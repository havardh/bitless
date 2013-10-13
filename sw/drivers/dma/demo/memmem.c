#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_adc.h"
#include "em_dac.h"
#include "em_dma.h"
#include "em_prs.h"
#include "em_timer.h"
#include "em_int.h"
#include "bsp.h"
#include "bsp_trace.h"
#include "dmactrl.h"
#include "rtcdrv.h"

#define N 32
#define SAMPLE_RATE 44100

#define DMA_CHANNEL_IN_LEFT   0 
#define DMA_CHANNEL_IN_RIGHT  1 
#define DMA_CHANNEL_OUT_LEFT  2
#define DMA_CHANNEL_OUT_RIGHT 3 

#define DMA_CHANNEL_ADC 4
#define DMA_CHANNEL_DAC 5

#define PRS_CHANNEL_ADC 0

DMA_CB_TypeDef cbADC;
DMA_CB_TypeDef cbDAC;

volatile uint16_t source[2*N];

volatile uint16_t sourceP[N];
volatile uint16_t sourceS[N];

volatile uint16_t left[N];
volatile uint16_t right[N];

volatile uint16_t destination[2*N];

volatile uint32_t msTicks; /* counts 1ms timeTicks */

volatile bool bufferPrimary;

void Delay(uint32_t dlyTicks);

void SysTick_Handler(void)
{
  msTicks++;	   /* increment counter necessary in Delay()*/
}

void Delay(uint32_t dlyTicks)
{
  uint32_t curTicks;

  curTicks = msTicks;
  while ((msTicks - curTicks) < dlyTicks) ;
}

static void adcCb(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_RefreshPingPong(channel, primary, false, NULL, NULL, N-1, false);
	bufferPrimary = primary;
}

static void dacCb(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_RefreshPingPong(channel, primary, false, NULL, NULL, N-1, false);
}

void transferInLeftComplete(unsigned int channel, bool primary, void *user)
{
	(void) channel;
	(void) primary;
	(void) user;

  transferInLeftActive = false;
}

void transferInRightComplete(unsigned int channel, bool primary, void *user)
{
	(void) channel;
	(void) primary;
	(void) user;

  transferInRightActive = false;
}

void transferOutLeftComplete(unsigned int channel, bool primary, void *user)
{
	(void) channel;
	(void) primary;
	(void) user;

  transferOutLeftActive = false;
}

void transferOutRightComplete(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_RefreshPingPong(channel, primary, false, NULL, NULL, N-1, false);
}

void setupCMU( void ) 
{
  CMU_ClockEnable(cmuClock_HFPER, true);
  CMU_ClockEnable(cmuClock_ADC0, true);
  CMU_ClockEnable(cmuClock_DAC0, true);
  CMU_ClockEnable(cmuClock_PRS, true);
	CMU_ClockEnable(cmuClock_DMA, true);
	CMU_ClockEnable(cmuClock_TIMER0, true);
}

void setupPRS( void )
{
  PRS_LevelSet(0, 1 << (PRS_CHANNEL_ADC + _PRS_SWLEVEL_CH0LEVEL_SHIFT));
  PRS_SourceSignalSet(PRS_CHANNEL_ADC,
                      PRS_CH_CTRL_SOURCESEL_TIMER0,
                      PRS_CH_CTRL_SIGSEL_TIMER0OF,
                      prsEdgePos);
}

void setupADC( void ) 
{
	ADC_Init_TypeDef adcInit = ADC_INIT_DEFAULT;
	adcInit.timebase = ADC_TimebaseCalc(0);
	adcInit.prescale = ADC_PrescaleCalc(4000000, 0);
  adcInit.warmUpMode = adcWarmupKeepADCWarm;
	adcInit.tailgate = true;
	ADC_Init(ADC0, &adcInit);

	ADC_InitScan_TypeDef adcInitScan = ADC_INITSCAN_DEFAULT;
	adcInitScan.prsSel    = adcPRSSELCh0;
	adcInitScan.prsEnable = true;
	adcInitScan.reference = adcRefVDD;
	adcInitScan.input     = ADC_SCANCTRL_INPUTMASK_CH6 | ADC_SCANCTRL_INPUTMASK_CH7;
	ADC_InitScan(ADC0, &adcInitScan);
}

static void ADCConfig(void)
{
  DMA_CfgDescr_TypeDef   descrCfg;
  DMA_CfgChannel_TypeDef chnlCfg;
  ADC_Init_TypeDef       init     = ADC_INIT_DEFAULT;
  ADC_InitScan_TypeDef   scanInit = ADC_INITSCAN_DEFAULT;

  /* Configure DMA usage by ADC */

  cbInData.cbFunc  = adcCb;
  cbInData.userPtr = NULL;

  chnlCfg.highPri   = true;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_ADC0_SCAN;
  chnlCfg.cb        = &cbInData;
  DMA_CfgChannel(DMA_CHANNEL_ADC, &chnlCfg);

  descrCfg.dstInc  = dmaDataInc2;
  descrCfg.srcInc  = dmaDataIncNone;
  descrCfg.size    = dmaDataSize2;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(DMA_CHANNEL_ADC, true, &descrCfg);
  DMA_CfgDescr(DMA_CHANNEL_ADC, false, &descrCfg);

  DMA_ActivatePingPong(DMA_CHANNEL_ADC,
                       false,
                       sourceP,
                       (void *)((uint32_t) &(ADC0->SCANDATA)),
                       N - 1,
                       sourceS,
                       (void *)((uint32_t) &(ADC0->SCANDATA)),
                       N - 1);

  /* Indicate starting with primary in-buffer (according to above DMA setup) */
  bufferPrimary = true;

  /* Configure ADC */

  /* Keep warm due to "high" frequency sampling */
  init.warmUpMode = adcWarmupKeepADCWarm;
  /* Init common issues for both single conversion and scan mode */
  init.timebase = ADC_TimebaseCalc(0);
  init.prescale = ADC_PrescaleCalc(4000000, 0);
  /* Sample potentiometer by tailgating in order to not disturb fixed rate */
  /* audio sampling. */
  init.tailgate = true;
  ADC_Init(ADC0, &init);

  /* Init for scan sequence use (audio in right/left channels). */
  scanInit.prsSel    = adcPRSSELCh0;
  scanInit.prsEnable = true;
  scanInit.reference = adcRefVDD;
  scanInit.input     = ADC_SCANCTRL_INPUTMASK_CH6 | ADC_SCANCTRL_INPUTMASK_CH7;
  ADC_InitScan(ADC0, &scanInit);
}

static void DACConfig(void)
{
  DMA_CfgDescr_TypeDef    descrCfg;
  DMA_CfgChannel_TypeDef  chnlCfg;
  DAC_Init_TypeDef        dacInit   = DAC_INIT_DEFAULT;
  DAC_InitChannel_TypeDef dacChInit = DAC_INITCHANNEL_DEFAULT;

  /* Notice: Audio out buffers are by default filled with 0, since */
  /* uninitialized data; no need to clear explicitly. */

  /* Configure DAC */

  /* Init common DAC issues */
  dacInit.reference = dacRefVDD;
  DAC_Init(DAC0, &dacInit);

  /* Start with "no" signal out */
  DAC0->COMBDATA = 0x0;

  /* Init channels, equal config for both channels. */
  dacChInit.enable    = true;
  dacChInit.prsSel    = dacPRSSELCh0;
  dacChInit.prsEnable = true;
  DAC_InitChannel(DAC0, &dacChInit, 0); /* Right channel */
  DAC_InitChannel(DAC0, &dacChInit, 1); /* Left channel */

  /* Configure DMA usage by DAC */

  cbOutData.cbFunc  = dacCb;
  cbOutData.userPtr = NULL;

  chnlCfg.highPri   = true;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_DAC0_CH0;
  chnlCfg.cb        = &cbOutData;
  DMA_CfgChannel(DMA_CHANNEL_DAC, &chnlCfg);

  descrCfg.dstInc  = dmaDataIncNone;
  descrCfg.srcInc  = dmaDataInc4;
  descrCfg.size    = dmaDataSize4;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(DMA_CHANNEL_DAC, true, &descrCfg);
  DMA_CfgDescr(DMA_CHANNEL_DAC, false, &descrCfg);

  DMA_ActivatePingPong(DMA_CHANNEL_DAC,
                       false,
                       (void *)((uint32_t) &(DAC0->COMBDATA)),
                       sourceP,
                       N - 1,
                       (void *)((uint32_t) &(DAC0->COMBDATA)),
                       sourceS,
                       N - 1);
}



void setupDAC( void )
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

void setupDMA( void ) 
{
	DMA_Init_TypeDef dmaInit;
	dmaInit.hprot = 0;
	dmaInit.controlBlock = dmaControlBlock;
	DMA_Init(&dmaInit);
}

void setupDMAInput( void ) 
{
  cbADC.cbFunc = adcCb;
  cbADC.userPtr = NULL;

  DMA_CfgChannel_TypeDef chnlCfg;
  chnlCfg.highPri = true;
  chnlCfg.enableInt = true;
  chnlCfg.select = DMAREQ_ADC0_SCAN;
  chnlCfg.cb = &cbADC;
  DMA_CfgChannel(DMA_CHANNEL_ADC, &chnlCfg);

  DMA_CfgDescr_TypeDef descrCfg;
  descrCfg.dstInc = dmaDataInc2;
  descrCfg.srcInc = dmaDataIncNone;
  descrCfg.size   = dmaDataSize2;
  descrCfg.hprot  = 0;
  DMA_CfgDescr(DMA_CHANNEL_ADC, true, &descrCfg);
  DMA_CfgDescr(DMA_CHANNEL_ADC, false, &descrCfg);

  DMA_ActivatePingPong(DMA_CHANNEL_ADC,
                       false,
                       sourceP,
                       (void*)((uint32_t) &(ADC0->SCANDATA)),
                       N - 1,
                       sourceS,
                       (void*)((uint32_t) &(ADC0->SCANDATA)),
                       N - 1);

  bufferPrimary = true;
	
}

void setupDMAOutput( void ) 
{
	cbDAC.cbFunc = dacCb;
  cbDAC.userPtr = NULL;

  DMA_CfgChannel_TypeDef chnlCfg = {
    .highPri = true,
    .enableInt = true,
    .select = DMAREQ_DAC0_CH0,
    .cb = &cbDAC
  };
  DMA_CfgChannel(DMA_CHANNEL_DAC, &chnlCfg);
  
  DMA_CfgDescr_TypeDef descrCfg = {
    .dstInc = dmaDataIncNone,
    .srcInc = dmaDataInc4,
    .size = dmaDataSize4,
    .hprot = 0
  };
  DMA_CfgDescr(DMA_CHANNEL_DAC, true, &descrCfg);
  DMA_CfgDescr(DMA_CHANNEL_DAC, false, &descrCfg);
  
  DMA_ActivatePingPong(DMA_CHANNEL_DAC, false,
                       (void*)((uint32_t) &DAC0->COMBDATA), sourceP, N - 1,
                       (void*)((uint32_t) &DAC0->COMBDATA), sourceS, N - 1);

}

/*
 * Sets up the DMA to copy from src to dst0 and dst1 with the pattern:
 *
 * src:  | 1, 2, 3, 4, ... |
 * dst0: | 1, 3, ...  |
 * dst1: | 2, 4, ...  |
 */
void setupDMASplit(void)
{
	DMA_Init_TypeDef dmaInit;
	dmaInit.hprot = 0;
	dmaInit.controlBlock = dmaControlBlock;
	DMA_Init(&dmaInit);

	DMA_CfgChannel_TypeDef chnlCfgLeft;
	chnlCfgLeft.highPri   = false;
	chnlCfgLeft.enableInt = true;
	chnlCfgLeft.select    = 0;
	chnlCfgLeft.cb        = NULL; //&cbInLeft;
	DMA_CfgChannel(DMA_CHANNEL_IN_LEFT, &chnlCfgLeft);

	DMA_CfgChannel_TypeDef chnlCfgRight;
	chnlCfgRight.highPri   = false;
	chnlCfgRight.enableInt = true;
	chnlCfgRight.select    = 0;
	chnlCfgRight.cb        = NULL; //&cbInRight;
	DMA_CfgChannel(DMA_CHANNEL_IN_RIGHT, &chnlCfgRight);

	DMA_CfgDescr_TypeDef descrCfg;
	descrCfg.dstInc  = dmaDataInc2;
	descrCfg.srcInc  = dmaDataInc4;
	descrCfg.size    = dmaDataSize2;
	descrCfg.arbRate = dmaArbitrate1;
	descrCfg.hprot   = 0;
	DMA_CfgDescr(DMA_CHANNEL_IN_LEFT, true, &descrCfg);
	DMA_CfgDescr(DMA_CHANNEL_IN_RIGHT, false, &descrCfg);

	DMA_ActivateAuto(DMA_CHANNEL_IN_LEFT, true, left, source, N - 1);
	DMA_ActivateAuto(DMA_CHANNEL_IN_RIGHT, false, right, (char*)source+sizeof(uint16_t), N - 1);
}

/*
 * Sets up the DMA to copy from src0 and src1 to dst with the pattern:
 *
 * src0: | 1, 3, ...  |
 * src1: | 2, 4, ...  |
 * dst:  | 1, 2, 3, 4, ... |
 */
void setupDMAMerge(void)
{

	DMA_CfgChannel_TypeDef chnlCfgLeft;
	chnlCfgLeft.highPri   = false;
	chnlCfgLeft.enableInt = true;
	chnlCfgLeft.select    = 0;
	chnlCfgLeft.cb        = NULL; //&cbOutLeft;
	DMA_CfgChannel(DMA_CHANNEL_OUT_LEFT, &chnlCfgLeft);

	DMA_CfgChannel_TypeDef chnlCfgRight;
	chnlCfgRight.highPri   = false;
	chnlCfgRight.enableInt = true;
	chnlCfgRight.select    = 0;
	chnlCfgRight.cb        = NULL; //&cbOutRight;
	DMA_CfgChannel(DMA_CHANNEL_OUT_RIGHT, &chnlCfgRight);

	DMA_CfgDescr_TypeDef descrCfg;
	descrCfg.dstInc  = dmaDataInc4;
	descrCfg.srcInc  = dmaDataInc2;
	descrCfg.size    = dmaDataSize2;
	descrCfg.arbRate = dmaArbitrate1;
	descrCfg.hprot   = 0;
	DMA_CfgDescr(DMA_CHANNEL_OUT_LEFT, true, &descrCfg);
	DMA_CfgDescr(DMA_CHANNEL_OUT_RIGHT, false, &descrCfg);

	DMA_ActivateAuto(DMA_CHANNEL_OUT_LEFT, true, destination, left, N - 1);
	DMA_ActivateAuto(DMA_CHANNEL_OUT_RIGHT, false, (char*)destination+sizeof(uint16_t), right, N - 1);
}

bool test(void) 
{
	for (int i=0; i<N; i++) {
		if (left[i] != (2*i+1) || right[i] != (2*i+2)) {
			return false;
		}
	}

	for (int i=0; i<2*N; i++) {
		if (destination[i] != i+1) {
			return false;
		}
	}

	return true;
}

void initSource( void ) 
{
  for (int i=0; i<2*N; i++) {
    source[i] = i+1;
  }
}

int main(void) 
{
	
	CHIP_Init();

	if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000)) while (1) ;

  BSP_Init(BSP_INIT_DEFAULT);
	BSP_LedsSet(0);

  BSP_PeripheralAccess(BSP_AUDIO_IN, true);
  BSP_PeripheralAccess(BSP_AUDIO_OUT, true);

  RTCDRV_Trigger(1000, NULL);
  EMU_EnterEM2(true);

  initSource();

	setupCMU();
  setupDMA();
  
  //setupADC();
  //setupDAC();

  //setupDMAInput();
  //setupDMAOutput();

	//setupDMASplit();
	//setupDMAMerge();

  ADCConfig();
  DACConfig();

  TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;
  TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / SAMPLE_RATE);
  TIMER_Init(TIMER0, &timerInit);

	Delay(100);
	BSP_LedsSet(3);
	Delay(500);
	BSP_LedsSet(0);
	Delay(100);

	while(1) {
		volatile bool result = test();
		if (result) {
			BSP_LedsSet(0x00FF);
		} else {
			BSP_LedsSet(0xFF00);			
		}
		Delay(1000);
    BSP_LedsSet(0x0);    
    Delay(1000);
	}

}
