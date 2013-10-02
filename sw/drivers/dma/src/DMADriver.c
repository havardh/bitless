#include "DMADriver.h"

//#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define SAMPLE_RATE     44100
#define DMA_AUDIO_IN    0
#define DMA_AUDIO_OUT   1
#define PRS_CHANNEL     0

static void init( void );
static void setupADC( void );
static void setupDAC( void );

volatile bool preampProcessPrimary;

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


void DMADriver_Init() 
{
	init();

	setupADC();
	setupDAC();
}

static void init( void ) 
{
	DMA_Init_TypeDef dmaInit;
	dmaInit.hprot = 0;
	dmaInit.controlBlock = dmaControlBlock;
  DMA_Init(&dmaInit);
}


void setupADC( void ) 
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

void setupDAC( void )
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
