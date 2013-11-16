#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <limits.h>

#include "bsp.h"
#include "bsp_trace.h"
#include "em_device.h"
#include "em_common.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_adc.h"
#include "em_dac.h"
#include "em_prs.h"
#include "em_timer.h"
#include "em_dma.h"
#include "em_usart.h"
#include "dmactrl.h"

#include "SDConfig.h"
#include "DACConfig.h"
#include "ADCConfig.h"
#include "DMAConfig.h"
#include "FPGAConfig.h"
#include "SDDriver.h"
#include "DACDriver.h"
#include "ADCDriver.h"

#include "FPGADriver.h"
#include "MEMDriver.h"
#include "PRSDriver.h"

#include "INTDriver.h"
#include "Delay.h"
#include "sample_conversion.h"
#include "Blink.h"

#include "ff.h"
#include "microsd.h"
#include "diskio.h"
#include "bsp.h"

#define WAV_FILENAME "sweet1.wav"

#define BUFFER_SIZE 512

#define FPGA_BASE ((uint16_t*) 0x21000000)

static void* GetInBuffer( void )
{
	void* buffer = (void*)MEM_GetAudioInBuffer( true );
	
	return buffer;
}

static void* GetOutBuffer( void )
{
	void *buffer (void*)MEM_GetAudioOutBuffer( true );

	return buffer;
}

static void setupSD(void)
{
	SDConfig config = {
		.mode            = IN,
		.inFile          = "sweet1.wav",
		.GetInputBuffer  = &GetInBuffer,
		.bufferSize      = BUFFER_SIZE
	};
	SDDriver_Init( &config );
	SDDriver_Read();
}

static void setupBSP(void)
{
	BSP_Init( BSP_INIT_DEFAULT );
	BSP_TraceProfilerSetup();

	

	BSP_PeripheralAccess( BSP_MICROSD, true );
  BSP_PeripheralAccess( BSP_AUDIO_OUT, false );
}

static void setupDAC(void)
{
	DACConfig config;
	DACDriver_Init( &config );
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

static void setupDMA(void)
{
	DMAConfig config = DMA_CONFIG_DEFAULT;
	config.mode = SD_TO_DAC;
	config.dacEnabled = true;
	config.adcEnabled = true;
	config.fpgaInEnabled = true;
	config.fpgaOutEnabled = true;
	DMADriver_Init( &config );
}

static void setupMEM( void )
{
	MEM_Init();
}
/*
void read_samples(void)
{
	bool eof = SDDriver_Read();

  if (eof) {
		DMADriver_StopDAC();
		SDDriver_Finalize();

	} else {

		uint16_t* buffer = MEM_GetAudioInBuffer( true );
		int size = MEM_GetAudioInBufferSize();
		uint16_t tmp;
		for (int i=0; i < 2*size; i++) {
			tmp = buffer[i] + 0x8000;
			tmp >>= 4;
			buffer[i] = tmp;
		}

	}
}*/
/*
void write_samples(void) 
{
	uint16_t* buffer = MEM_GetAudioOutBuffer( true );
	int size = MEM_GetAudioOutBufferSize();
	uint16_t tmp;
	for (int i=0; i < 2*size; i++) {
		tmp = buffer[i] - 0x8000;
		tmp <<= 4;
		buffer[i] = tmp;
	}


	SDDriver_Write();
}*/

void sdToDACCallback( void ) {
	DMA_ActivateAuto(DMA_MEM_CPY, true, MEM_GetAudioOutBuffer(true), MEM_GetAudioInBuffer(true), MEM_GetAudioInBufferSize()-1);

	/*read_samples();

	
	int bufferSize               = MEM_GetAudioInBufferSize();
	uint16_t *audioInBuffer      = MEM_GetAudioInBuffer(true);
	uint16_t *audioOutBuffer     = MEM_GetAudioOutBuffer(true);
	volatile uint16_t *fpgaLeftInBuffer   = FPGADriver_GetInBuffer(0);
	volatile uint16_t *fpgaRightInBuffer  = FPGADriver_GetInBuffer(1);
	volatile uint16_t *fpgaLeftOutBuffer  = FPGADriver_GetOutBuffer(0);
	volatile uint16_t *fpgaRightOutBuffer = FPGADriver_GetOutBuffer(1);

	for (int i=0, j; i<2*bufferSize; i+=2, j++) {

		audioOutBuffer[i] = fpgaLeftInBuffer[j];
		audioOutBuffer[i+1] = fpgaRightInBuffer[j];
		//audioOutBuffer[i] = fpgaLeftOutBuffer[j];
		//audioOutBuffer[i+1] = fpgaRightOutBuffer[j];
		fpgaLeftInBuffer[j] = audioInBuffer[i];
		fpgaRightInBuffer[j] = audioInBuffer[i+1];
		
		}*/
}

void setupDma(void)
{
  DMA_Init_TypeDef        dmaInit;
  DMA_CfgChannel_TypeDef  chnlCfg;
  DMA_CfgDescr_TypeDef    descrCfg;
  
  /* Initializing the DMA */
  dmaInit.hprot        = 0;
  dmaInit.controlBlock = dmaControlBlock;
  DMA_Init(&dmaInit);

  /* Setting call-back function */  
  cb.cbFunc  = basicTransferComplete; //transferComplete;
  cb.userPtr = NULL;

  /* Setting up channel */
  chnlCfg.highPri   = false;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_DAC0_CH0;
 // 0
  chnlCfg.cb        = &(cb);
  DMA_CfgChannel(DMA_MEM_CPY, &chnlCfg);

  /* Setting up channel descriptor */
  descrCfg.dstInc  = dmaDataInc4;
  descrCfg.srcInc  = dmaDataInc4;
  descrCfg.size    = dmaDataSize4;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(DMA_MEM_CPY, true, &descrCfg);
	

	DMA_ActivateBasic(DMA_MEM_CPY, true, false, MEM_GetAudioOutBuffer(true), MEM_GetAudioInBuffer(true), MEM_GetAudioInBufferSize()-1);
}


void setupINT( void )
{
	INTDriver_Init();
	INTDriver_RegisterCallback(0, &sdToDACCallback);
}

void setupFPGA( void )
{
  FPGAConfig config;
  config.baseAddress = FPGA_BASE;
  config.numPipelines = 2;
  config.bufferSize = BUFFER_SIZE;
  FPGADriver_Init( &config );
}

void setupTIMER(uint32_t rate) 
{
	TIMER_Init_TypeDef init = TIMER_INIT_DEFAULT;
	init.mode = timerModeUpDown;
	TIMER_TopSet( TIMER0, CMU_ClockFreqGet(cmuClock_TIMER0) / rate );
	TIMER_Init( TIMER0, &init );
}

void main( void ) {

  CMU_ClockSelectSet(cmuClock_HF, cmuSelect_HFXO);
	
	setupBSP();
	
	setupMEM();
	setupFPGA();
	setupINT();
	setupSD();

	setupCMU();
	
	setupPRS();

	setupDAC();
	setupDMA();
	
	// Localy defined, should be moved
	setupDma();

	setupTIMER(8000);

	Delay_Init();

	while(1)
 {
	 BSP_LedsSet(0x2);
	 Delay(1000);
	 BSP_LedsSet(0);
	 Delay(500);
	}

}
