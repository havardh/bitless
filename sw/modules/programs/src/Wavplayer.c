#include "Wavplayer.h"

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <limits.h>

#include "em_device.h"
#include "em_common.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_dac.h"
#include "em_prs.h"
#include "em_timer.h"
#include "em_dma.h"
#include "em_usart.h"
#include "em_chip.h"
#include "dmactrl.h"

#include "bl_dac.h"
#include "bl_mem.h"
#include "FPGAConfig.h"
#include "bl_dma.h"
#include "bl_uart.h"

#include "bl_sd.h"
#include "sample_conversion.h"

#include "ff.h"
#include "microsd.h"
#include "diskio.h"
#include <string.h>

/*
 * This demo reads samples from the SDCard with a FAT file system.
 * The source file is allways called sweet1.wav.
 *
 * The samples are consumed by the DAC through DMA
 */


#define PUT(x) { char * debug_string = x; UART_PutData((uint8_t*)debug_string, strlen(debug_string)); for (volatile int i=0; i<10000; i++);}

#define DMA_MEM_CPY 0
static DMA_CB_TypeDef cb;

static int bufferSize = 64;

static bool done = false;

static void* GetInBuffer(void) {
	return (void*)MEM_GetAudioInBuffer(true);
}

static void setupSD() 
{
	SDConfig config;
	config.mode = IN;
	config.inFile = "sweet1.wav";
	config.GetInputBuffer = GetInBuffer;
	config.bufferSize = bufferSize*4;
	SDDriver_Init( &config );
}

static void transferComplete(unsigned int channel, bool primary, void *user)
{  
	(void) channel;  (void) primary;  (void) user;

}

static void onDACRequest(void)
{

	DMA_ActivateAuto(DMA_MEM_CPY, true, (void*)MEM_GetAudioOutBuffer(true), (void*)MEM_GetAudioInBuffer(true), MEM_GetAudioInBufferSize()-1);

	uint16_t tmp;
	
	if (!SDDriver_Read()) {

		int16_t * buffer = MEM_GetAudioInBuffer(true);

		for (int i=0; i<2*MEM_GetAudioInBufferSize(); i++) {
			tmp = buffer[i] + 0x8000;
			tmp >>= 4;
			buffer[i] = tmp;
		}

	} else {
		done = true;
	}
}

static void setupTimer( uint32_t frequency ) 
{

	TIMER_Init_TypeDef init = TIMER_INIT_DEFAULT;
	TIMER_Init( TIMER0, &init );	

  	PRS_SourceSignalSet(0, PRS_CH_CTRL_SOURCESEL_TIMER0, PRS_CH_CTRL_SIGSEL_TIMER0OF, prsEdgePos);

	TIMER_TopBufSet( TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / frequency );
}

static void setupMEM( void ) 
{
	MEMConfig config = {
		.bufferSize = bufferSize
	};
	MEM_Init( &config );
}

static void setupPRS(void)
{
	PRSDriver_Init();
}

static void setupCMU(void)
{

	CMU_ClockEnable( cmuClock_HFPER, true );
	CMU_ClockEnable( cmuClock_DMA, true );
	CMU_ClockEnable( cmuClock_DAC0, true );
	CMU_ClockEnable( cmuClock_PRS, true );
	CMU_ClockEnable( cmuClock_TIMER0, true );
}

static void setupDma(void)
{
  DMA_Init_TypeDef        dmaInit;
  DMA_CfgChannel_TypeDef  chnlCfg;
  DMA_CfgDescr_TypeDef    descrCfg;
  
  /* Initializing the DMA */
  dmaInit.hprot        = 0;
  dmaInit.controlBlock = dmaControlBlock;
  DMA_Init(&dmaInit);

  /* Setting call-back function */  
  cb.cbFunc  = transferComplete;
  cb.userPtr = NULL;

  /* Setting up channel */
  chnlCfg.highPri   = false;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_DAC0_CH0;
  chnlCfg.cb        = &(cb);
  DMA_CfgChannel(DMA_MEM_CPY, &chnlCfg);

  /* Setting up channel descriptor */
  descrCfg.dstInc  = dmaDataInc4;
  descrCfg.srcInc  = dmaDataInc4;
  descrCfg.size    = dmaDataSize4;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(DMA_MEM_CPY, true, &descrCfg);
	

  DMA_ActivateBasic(DMA_MEM_CPY, true, false, (void*)MEM_GetAudioOutBuffer(true), (void*)MEM_GetAudioInBuffer(true), MEM_GetAudioInBufferSize()-1);
}

static void DAC_setup(void)
{
  DAC_Init_TypeDef        init        = DAC_INIT_DEFAULT;
  DAC_InitChannel_TypeDef initChannel = DAC_INITCHANNEL_DEFAULT;

  /* Calculate the DAC clock prescaler value that will result in a DAC clock
   * close to 1 MHz. Second parameter is zero, if the HFPERCLK value is 0, the
   * function will check what the HFPERCLK actually is. */
  init.prescale = DAC_PrescaleCalc(1000000, 0);

  /* Initialize the DAC. */
  DAC_Init(DAC0, &init);

  /* Enable prs to trigger samples at the right time with the timer */
  initChannel.prsEnable = true;
  initChannel.prsSel    = dacPRSSELCh0;

  /* Both channels can be configured the same
   * and be triggered by the same prs-signal. */
  DAC_InitChannel(DAC0, &initChannel, 0);
  DAC_InitChannel(DAC0, &initChannel, 1);

  DAC_Enable(DAC0, 0, true);
  DAC_Enable(DAC0, 1, true);
}

static void setupDAC(void)
{
	DACConfig config;
	DACDriver_Init( &config );
}

void Wavplayer_Start( void ) 
{
	Leds_SetLeds(0x8);

	setupCMU();
	setupPRS();
	setupSD();
	setupMEM();
	setupDma();
	DMAConfig config = { .mode = SD_TO_DAC };
	DMADriver_Init( &config );
	DAC_setup();
	INTDriver_Init();
	INTDriver_RegisterCallback(0, &onDACRequest);
	done = false;

	setupTimer(8000);

	while(1) {
		if (done)
			break;
	}

	DMADriver_StopDAC();
	SDDriver_Finalize();
	DMA_Reset();
	DAC_Reset(DAC0);
	MEM_Destroy();
	TIMER_Reset( TIMER0 );
}
