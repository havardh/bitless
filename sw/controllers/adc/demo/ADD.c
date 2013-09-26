#include "bsp.h"
#include "bsp_trace.h"
#include "em_emu.h"
#include "em_cmu.h"
#include "em_adc.h"
#include "em_dac.h"
#include "em_prs.h"
#include "em_timer.h"
#include "em_dma.h"
#include "dmactrl.h"
#include "rtcdrv.h"
#include "ADCDriver.h"

#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define SAMPLE_RATE     44100
#define DMA_AUDIO_IN    0
#define DMA_AUDIO_OUT   1
#define PRS_CHANNEL     0

static volatile bool preampProcessPrimary;

static uint16_t preampAudioInBuffer1[BUFFER_SIZE * 2];
static uint16_t preampAudioInBuffer2[BUFFER_SIZE * 2];

static uint32_t preampAudioOutBuffer1[BUFFER_SIZE];
static uint32_t preampAudioOutBuffer2[BUFFER_SIZE];

static DMA_CB_TypeDef cbInData;
static DMA_CB_TypeDef cbOutData;

static void preampDMAInCb(unsigned int channel, bool primary, void *user)
{
  (void) user;
  DMA_RefreshPingPong(channel,primary,false,NULL,NULL,(BUFFER_SIZE * 2) - 1,false);
  preampProcessPrimary = primary;
  SCB->ICSR = SCB_ICSR_PENDSVSET_Msk;
}

static void preampDMAOutCb(unsigned int channel, bool primary, void *user)
{
  (void) user;
  DMA_RefreshPingPong(channel,primary,false,NULL,NULL,BUFFER_SIZE - 1,false);
}

void PendSV_Handler(void)
{

	uint16_t *inBuf;
  uint32_t *outBuf;
  int32_t right;
  int32_t left;

	if (preampProcessPrimary)
		{
			inBuf  = preampAudioInBuffer1;
			outBuf = preampAudioOutBuffer1;
		}
  else
		{
			inBuf  = preampAudioInBuffer2;
			outBuf = preampAudioOutBuffer2;
		}

	int i=0; 
	for (; i<BUFFER_SIZE; i++) 
		{
			right = (int32_t) *inBuf++;
			left = (int32_t) *inBuf++;
			
			*(outBuf++) = ((uint32_t) left << 16) | (uint32_t) right;
		}

}

static void setupADC( void ) 
{
	ADCConfig config;
	config.rate = 4000000;
	config.mode = ScanConversion;
	ADCDriver_Init( &config );
}


static void setupDAC( void ) 
{
	DAC_Init_TypeDef dacInit = DAC_INIT_DEFAULT;
	dacInit.reference = dacRefVDD;
	DAC_Init(DAC0, &dacInit);

	DAC0->COMBDATA = 0x0;

	DAC_InitChannel_TypeDef dacChInit = DAC_INITCHANNEL_DEFAULT;
	dacChInit.enable = true;
	dacChInit.prsSel = dacPRSSELCh0;
	dacChInit.prsEnable = true;
	DAC_InitChannel(DAC0, &dacChInit, 0);
	DAC_InitChannel(DAC0, &dacChInit, 1);
	
}

static void setupDMA_ADC( void ) 
{
	cbInData.cbFunc  = preampDMAInCb;
  cbInData.userPtr = NULL;

  DMA_CfgChannel_TypeDef chnlCfg;
  chnlCfg.highPri   = true;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_ADC0_SCAN;
  chnlCfg.cb        = &cbInData;
  DMA_CfgChannel(DMA_AUDIO_IN, &chnlCfg);

  DMA_CfgDescr_TypeDef   descrCfg;
  descrCfg.dstInc  = dmaDataInc2;
  descrCfg.srcInc  = dmaDataIncNone;
  descrCfg.size    = dmaDataSize2;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(DMA_AUDIO_IN, true, &descrCfg);
  DMA_CfgDescr(DMA_AUDIO_IN, false, &descrCfg);

  DMA_ActivatePingPong(DMA_AUDIO_IN,
                       false,
                       preampAudioInBuffer1,
                       (void *)((uint32_t) &(ADC0->SCANDATA)),
                       (BUFFER_SIZE * 2) - 1,
                       preampAudioInBuffer2,
                       (void *)((uint32_t) &(ADC0->SCANDATA)),
                       (BUFFER_SIZE * 2) - 1);
	
  preampProcessPrimary = true;

}

static void setupDMA_DAC( void )
{
	cbOutData.cbFunc = preampDMAOutCb; //DMAOutCallback;
	cbOutData.userPtr = NULL;

	DMA_CfgChannel_TypeDef chnlCfg;
	chnlCfg.highPri = true;
	chnlCfg.enableInt = true;
	chnlCfg.select = DMAREQ_DAC0_CH0;
	chnlCfg.cb = &cbOutData;
	DMA_CfgChannel(DMA_AUDIO_OUT, &chnlCfg);

	DMA_CfgDescr_TypeDef descrCfg;
	descrCfg.dstInc = dmaDataIncNone;
	descrCfg.srcInc = dmaDataInc4;
	descrCfg.size = dmaDataSize4;
	descrCfg.hprot = 0;
	DMA_CfgDescr(DMA_AUDIO_OUT, true, &descrCfg);
	DMA_CfgDescr(DMA_AUDIO_OUT, false, &descrCfg);

	DMA_ActivatePingPong(DMA_AUDIO_OUT,
											 false,
											 (void*)((uint32_t) &(DAC0->COMBDATA)),
											 preampAudioOutBuffer1,
											 BUFFER_SIZE - 1,
											 (void*)((uint32_t) &(DAC0->COMBDATA)),
											 preampAudioOutBuffer2,
											 BUFFER_SIZE - 1);

}

static void setupDMA( void ) 
{
	DMA_Init_TypeDef dmaInit;
	dmaInit.hprot = 0;
	dmaInit.controlBlock = dmaControlBlock;
  DMA_Init(&dmaInit);

	setupDMA_ADC();
	setupDMA_DAC();
}



/***************************************************************************//**
																																							* @brief
																																							*   Configure PRS usage for this application.
																																							*
																																							* @param[in] prsChannel
																																							*   PRS channel to use.
																																							*******************************************************************************/

static void setupPRS( unsigned int channel ) 
{
	PRS_LevelSet(0, 1 << (channel + _PRS_SWLEVEL_CH0LEVEL_SHIFT));

	PRS_SourceSignalSet(channel,
											PRS_CH_CTRL_SOURCESEL_TIMER0,
											PRS_CH_CTRL_SIGSEL_TIMER0OF,
											prsEdgePos);
}


/*******************************************************************************
 **************************   GLOBAL FUNCTIONS   *******************************
 ******************************************************************************/

void setupBSP( void ) 
{
	BSP_Init( BSP_INIT_DEFAULT );
	BSP_TraceProfilerSetup();

	BSP_PeripheralAccess( BSP_AUDIO_IN, true );
	BSP_PeripheralAccess( BSP_AUDIO_OUT, true );
}

void setupClocks( void )
{
	CMU_ClockEnable( cmuClock_HFPER, true );
	CMU_ClockEnable( cmuClock_ADC0, true );
	CMU_ClockEnable( cmuClock_DAC0, true );
	CMU_ClockEnable( cmuClock_PRS, true );
	CMU_ClockEnable( cmuClock_DMA, true );
	CMU_ClockEnable( cmuClock_TIMER0, true );
}


int main(void)
{
  TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;

	setupBSP();

	// Wait a little
  RTCDRV_Trigger(1000, NULL); EMU_EnterEM2(true);

	setupClocks();

  NVIC_SetPriority(DMA_IRQn, 0);
  NVIC_SetPriority(PendSV_IRQn, (1 << __NVIC_PRIO_BITS) - 1);

  setupPRS(PRS_CHANNEL);

	//
	setupDMA(); setupDAC(); setupADC();
	//

  TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / SAMPLE_RATE);
  TIMER_Init(TIMER0, &timerInit);

  while (1)
		{
			EMU_EnterEM1();
		}
}
