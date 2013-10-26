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

#include "INTDriver.h"

#include "ff.h"
#include "microsd.h"
#include "diskio.h"
#include "bsp.h"

#define WAV_FILENAME "sweet1.wav"

#define SAMPLE_RATE 11025
#define FPGA_BASE ((uint16_t*) 0x21000000)

static void* GetBuffer( void )
{
	void* buffer = (void*)MEM_GetAudioOutBuffer( true );

	//printf("GetBuffer Called: %p\n", buffer);
	
	return buffer;
}

static void setupSD(void)
{
	SDConfig config = {
		.mode            = IN,
		.inFile          = "sweet1.wav",
		.GetInputBuffer = &GetBuffer,
		.bufferSize      = 64
	};
	SDDriver_Init( &config );
		//printf("Reading first samples\n");
	SDDriver_Read();
		//printf("Done Reading first samples\n");
}

static void setupBSP(void)
{
	BSP_Init( BSP_INIT_DEFAULT );
	BSP_TraceProfilerSetup();

	BSP_PeripheralAccess( BSP_MICROSD, true );
	BSP_PeripheralAccess( BSP_AUDIO_OUT, true );
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

static void setupClocks(void)
{
	CMU_ClockEnable( cmuClock_HFPER, true );
	CMU_ClockEnable( cmuClock_DAC0, true );
	CMU_ClockEnable( cmuClock_ADC0, true );
	CMU_ClockEnable( cmuClock_PRS, true );
	CMU_ClockEnable( cmuClock_DMA, true );
	CMU_ClockEnable( cmuClock_TIMER0, true );
}

void setupADC( void )
{
  ADCConfig config;
  config.rate = 7000000;
  config.mode = ScanConversion;
  ADCDriver_Init( &config );
}

static void setupDMA(void)
{
	DMAConfig config = DMA_CONFIG_DEFAULT;
	config.mode = SD_TO_DAC;
	DMADriver_Init( &config );
}

static void setupMEM( void )
{
	MEM_Init();
}

void read_samples(void)
{
  if (SDDriver_Read()) {
		DMADriver_StopDAC();
	}

} 

void setupINT( void )
{
	INTDriver_Init();
	INTDriver_RegisterCallback(0, &read_samples);
}

void setupFPGA( void )
{
  FPGAConfig config;
  config.baseAddress = FPGA_BASE;
  config.numPipelines = 2;
  config.bufferSize = 64;
  FPGADriver_Init( &config );
}

int main(void) 
{
	TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;
		
	setupBSP();
	
	setupClocks();
	//printf("Initialization\n");
	setupFPGA();
	setupINT();
	setupMEM();
	setupPRS();
	setupDAC();
	//setupADC();
	setupDMA();
	//printf("SD init\n");
	setupSD();
	//printf("Init done\n");

	TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / SAMPLE_RATE);
	TIMER_Init( TIMER0, &timerInit );

	while(1)
		EMU_EnterEM1();
}
