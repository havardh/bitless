/******************************************************************************
 * @section License
 * <b>(C) Copyright 2012 Energy Micro AS, http://www.energymicro.com</b>
 *******************************************************************************
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 * 4. The source and compiled code may only be used on Energy Micro "EFM32"
 *    microcontrollers and "EFR4" radios.
 *
 * DISCLAIMER OF WARRANTY/LIMITATION OF REMEDIES: Energy Micro AS has no
 * obligation to support this Software. Energy Micro AS is providing the
 * Software "AS IS", with no express or implied warranties of any kind,
 * including, but not limited to, any implied warranties of merchantability
 * or fitness for any particular purpose or warranties against infringement
 * of any proprietary rights of a third party.
 *
 * Energy Micro AS will not be liable for any consequential, incidental, or
 * special damages, or any other relief, or for any claim by any third party,
 * arising from your use of this Software.
 *
 *****************************************************************************/
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
#include "bl_adc.h"
#include "bl_dac.h"
#include "bl_dma.h"
#include "bl_prs.h"
#include "bl_mem.h"
#include "FPGADriver.h"
#include "Delay.h"

#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */

// Start address of SRAM on DK3750 
#define EXT_SRAM_BASE_ADDRESS ((volatile uint16_t*) 0x88000000)

static void setupADC( void ) 
{
	ADCConfig config;
	config.rate = 4000000;
	config.mode = ScanConversion;
	ADCDriver_Init( &config );
}


static void setupDAC( void ) 
{
	DACConfig config;
	DACDriver_Init( &config );
}

static void setupDMA( void ) 
{
	DMADriver_Init( );
}

static void setupPRS( ) 
{	
	PRSDriver_Init();
}

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

void setupFPGA( void ) 
{
	FPGAConfig config;

	config.baseAddress = EXT_SRAM_BASE_ADDRESS;
  config.numPipelines = 2;
	config.bufferSize  = BUFFER_SIZE;

  FPGADriver_Init( &config );
}

// --------------------------------------tst

#define PREAMP_AUDIO_BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */

/** (Approximate) sample rate used for processing audio data. */
#define PREAMP_AUDIO_SAMPLE_RATE     44100

/** Number of times to sample volume (potentiometer) per second. */
#define PREAMP_VOLUME_SAMPLE_RATE    20

/** DMA channel used for audio in scan sequence (both right and left channel) */
#define PREAMP_DMA_AUDIO_IN          0

/** DMA channel used for audio out channels */
#define PREAMP_DMA_AUDIO_OUT         1

/** PRS channel used by TIMER to trigger ADC/DAC activity. */
#define PREAMP_PRS_CHANNEL           0

/** Variable indicate if primary or alternate audio buffer shall be processed */
static volatile bool preampProcessPrimary;

/** Primary audio in buffer, holding both left and right channel (interleaved) */
static uint16_t preampAudioInBuffer1[PREAMP_AUDIO_BUFFER_SIZE * 2];
/** Alternate audio in buffer, holding both left and right channel (interleaved) */
static uint16_t preampAudioInBuffer2[PREAMP_AUDIO_BUFFER_SIZE * 2];

/** Primary audio out buffer, combined right/left channel in one uint32_t. */
static uint32_t preampAudioOutBuffer1[PREAMP_AUDIO_BUFFER_SIZE];
/** Alternate audio out buffer, combined right/left channel in one uint32_t. */
static uint32_t preampAudioOutBuffer2[PREAMP_AUDIO_BUFFER_SIZE];

/** Callback config for audio-in DMA handling, must remain 'live' */
static DMA_CB_TypeDef cbInData;
/** Callback config for audio-out DMA handling, must remain 'live' */
static DMA_CB_TypeDef cbOutData;


/** Count number of interrupts on input buffer filled. */
static uint32_t preampMonInCount;
/** Count number of interrupts on output buffer sent. */
static uint32_t preampMonOutCount;
/** Count number of times buffer has been processed. */
static uint32_t preampMonProcessCount;


static void preampDMAInCb(unsigned int channel, bool primary, void *user)
{
  (void) user; /* Unused parameter */

  /* Refresh DMA for using this buffer. DMA ping-pong will */
  /* halt if buffer not refreshed in time. */
  DMA_RefreshPingPong(channel,
                      primary,
                      false,
                      NULL,
                      NULL,
                      (PREAMP_AUDIO_BUFFER_SIZE * 2) - 1,
                      false);

  preampMonInCount++;

  /* Indicate buffer to be processed next */
  preampProcessPrimary = primary;

  /* Trigger lower priority interrupt which will process data */
  SCB->ICSR = SCB_ICSR_PENDSVSET_Msk;
}


static void preampDMAOutCb(unsigned int channel, bool primary, void *user)
{
  (void) user; /* Unused parameter */

  /* Refresh DMA for using this buffer. DMA ping-pong will */
  /* halt if buffer not refreshed in time. */
  DMA_RefreshPingPong(channel,
                      primary,
                      false,
                      NULL,
                      NULL,
                      PREAMP_AUDIO_BUFFER_SIZE - 1,
                      false);

  preampMonOutCount++;
}


static void preampADCConfig(void)
{
  DMA_CfgDescr_TypeDef   descrCfg;
  DMA_CfgChannel_TypeDef chnlCfg;
  ADC_Init_TypeDef       init     = ADC_INIT_DEFAULT;
  ADC_InitScan_TypeDef   scanInit = ADC_INITSCAN_DEFAULT;

  /* Configure DMA usage by ADC */

  cbInData.cbFunc  = preampDMAInCb;
  cbInData.userPtr = NULL;

  chnlCfg.highPri   = true;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_ADC0_SCAN;
  chnlCfg.cb        = &cbInData;
  DMA_CfgChannel(PREAMP_DMA_AUDIO_IN, &chnlCfg);

  descrCfg.dstInc  = dmaDataInc2;
  descrCfg.srcInc  = dmaDataIncNone;
  descrCfg.size    = dmaDataSize2;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(PREAMP_DMA_AUDIO_IN, true, &descrCfg);
  DMA_CfgDescr(PREAMP_DMA_AUDIO_IN, false, &descrCfg);

  DMA_ActivatePingPong(PREAMP_DMA_AUDIO_IN,
                       false,
                       preampAudioInBuffer1,
                       (void *)((uint32_t) &(ADC0->SCANDATA)),
                       (PREAMP_AUDIO_BUFFER_SIZE * 2) - 1,
                       preampAudioInBuffer2,
                       (void *)((uint32_t) &(ADC0->SCANDATA)),
                       (PREAMP_AUDIO_BUFFER_SIZE * 2) - 1);

  /* Indicate starting with primary in-buffer (according to above DMA setup) */
  preampProcessPrimary = true;

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


static void preampDACConfig(void)
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

  cbOutData.cbFunc  = preampDMAOutCb;
  cbOutData.userPtr = NULL;

  chnlCfg.highPri   = true;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_DAC0_CH0;
  chnlCfg.cb        = &cbOutData;
  DMA_CfgChannel(PREAMP_DMA_AUDIO_OUT, &chnlCfg);

  descrCfg.dstInc  = dmaDataIncNone;
  descrCfg.srcInc  = dmaDataInc4;
  descrCfg.size    = dmaDataSize4;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(PREAMP_DMA_AUDIO_OUT, true, &descrCfg);
  DMA_CfgDescr(PREAMP_DMA_AUDIO_OUT, false, &descrCfg);

  DMA_ActivatePingPong(PREAMP_DMA_AUDIO_OUT,
                       false,
                       (void *)((uint32_t) &(DAC0->COMBDATA)),
                       preampAudioOutBuffer1,
                       PREAMP_AUDIO_BUFFER_SIZE - 1,
                       (void *)((uint32_t) &(DAC0->COMBDATA)),
                       preampAudioOutBuffer2,
                       PREAMP_AUDIO_BUFFER_SIZE - 1);
}


static void preampPRSConfig(unsigned int prsChannel)
{
  PRS_LevelSet(0, 1 << (prsChannel + _PRS_SWLEVEL_CH0LEVEL_SHIFT));
  PRS_SourceSignalSet(prsChannel,
                      PRS_CH_CTRL_SOURCESEL_TIMER0,
                      PRS_CH_CTRL_SIGSEL_TIMER0OF,
                      prsEdgePos);
}


void test() {
  DMA_Init_TypeDef   dmaInit;
  TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;
  uint32_t           leds;
  static uint16_t    last_buttons = 0;
  uint16_t           buttons;

  /* Initialize DK board register access */
  BSP_Init(BSP_INIT_DEFAULT);

  /* If first word of user data page is non-zero, enable eA Profiler trace */
  BSP_TraceProfilerSetup();

  /* Connect audio in/out to ADC/DAC */
  BSP_PeripheralAccess(BSP_AUDIO_IN, true);
  BSP_PeripheralAccess(BSP_AUDIO_OUT, true);

  /* Wait a while in order to let signal from audio-in stabilize after */
  /* enabling audio-in peripheral. */
  RTCDRV_Trigger(1000, NULL);
  EMU_EnterEM2(true);

  /* Current example gets by at 14MHz core clock (also with low level of compiler */
  /* optimization). That may however change if modified, consider changing to */
  /* higher HFRCO band or HFXO. */
  /*
   * Use for instance one of below statements to increase core clock.
   * CMU_ClockSelectSet(cmuClock_HF, cmuSelect_HFXO);
   * CMU_HFRCOBandSet(cmuHFRCOBand_28MHz);
   */

  /* Enable clocks required */
  CMU_ClockEnable(cmuClock_HFPER, true);
  CMU_ClockEnable(cmuClock_ADC0, true);
  CMU_ClockEnable(cmuClock_DAC0, true);
  CMU_ClockEnable(cmuClock_PRS, true);
  CMU_ClockEnable(cmuClock_DMA, true);
  CMU_ClockEnable(cmuClock_TIMER0, true);

  /* Ensure DMA interrupt at higher priority than PendSV. */
  /* (PendSV used to process sampled audio). */
  NVIC_SetPriority(DMA_IRQn, 0);                              /* Highest priority */
  NVIC_SetPriority(PendSV_IRQn, (1 << __NVIC_PRIO_BITS) - 1); /* Lowest priority */

  /* Configure peripheral reflex system used by TIMER to trigger ADC/DAC */
  preampPRSConfig(PREAMP_PRS_CHANNEL);

  /* Configure general DMA issues */
  dmaInit.hprot        = 0;
  dmaInit.controlBlock = dmaControlBlock;
  DMA_Init(&dmaInit);

  /* Configure DAC used for audio-out */
  preampDACConfig();

  /* Configure ADC used for audio-in */
  preampADCConfig();

  /* Trigger sampling according to configured sample rate */
  TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / PREAMP_AUDIO_SAMPLE_RATE);
  TIMER_Init(TIMER0, &timerInit);
}

void PendSV_Handler(void)
{
	
	uint16_t *inBuf;
	uint32_t *outBuf;

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

	for (int i=0; i<BUFFER_SIZE; i++) 
		{
			int32_t right = (int32_t) *inBuf++;
			int32_t left = (int32_t) *inBuf++;
			
			*(outBuf++) = ((uint32_t) left << 16) | (uint32_t) right;
		}
	
}


// --------------------------------------tst


int main(void)
{
	test();

	Delay_Init();
	Delay(1000);

  TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;

	setupBSP();

	// Wait a little
  RTCDRV_Trigger(1000, NULL); EMU_EnterEM2(true);

	setupClocks();
  
  MEM_Init();
  setupFPGA();


  NVIC_SetPriority(DMA_IRQn, 0);
  NVIC_SetPriority(PendSV_IRQn, (1 << __NVIC_PRIO_BITS) - 1);

	setupPRS();

	setupDAC();
	setupDMA();
	setupADC();


 
  TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / SAMPLE_RATE);
  TIMER_Init(TIMER0, &timerInit);

  while (1)
		{
			EMU_EnterEM1();
		}
}
