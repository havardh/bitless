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
#include "dmactrl.h"

#include "SDDriver.h"

#include "ff.h"
#include "microsd.h"
#include "diskio.h"
#include "bsp.h"

#define WAV_FILENAME "sweet1.wav"

#define SAMPLE_RATE 44100

void GetBuffer( void )
{
	return MEM_GetAudioOutBuffer( true );
}

void setupSD(void)
{
	SDConfig config = {
		.mode            = IN,
		.inFile          = "sweet1.wav",
		.GetOutputBuffer = GetBuffer,
		.bufferSize      = 64
	};
	SDDriver_Init( &config );
	SDDriver_Read();
}

void setupBSP(void)
{
	BSP_Init( BSP_INIT_DEFAULT );
	BSP_TraceProfilerSetup();

	BSP_PeripheralAccess( BSP_MICROSD, true );
	BSP_PeripheralAccess( BSP_AUDIO_OUT, true );
}

void setupDAC(void)
{
	DACConfig config;
	DACDriver_Init( &config );
}

void setupPRS(void)
{
	PRSDriver_Init();
}

void setupClocks(void)
{
	CMU_ClockEnable( cmuClock_HFPER, true );
	CMU_ClockEnable( cmuClock_DAC0, true );
	CMU_ClockEnable( cmuClock_PRS, true );
	CMU_ClockEnable( cmuClock_DMA, true );
	CMU_ClockEnable( cmuClock_TIMER0, true );
}

void setupDMA(void)
{
	DMAConfig config = DMA_CONFIG_DEFAULT;
	config.dacEnabled     = true;
	config.fpgaInEnabled  = true;
	config.fpgaOutEnabled = true;
	DMADriver_Init( &config );
}

void setupMEM( void )
{
	MEM_Init();
}

int main(void) 
{
	TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;

	setupBSP();

	RTCDRV_Trigger( 1000, NULL ); EMU_EnterEM2( true );
	
	setupClocks();

	setupMEM();
	setupPRS();
	setupDAC();
	setupDMA();
	setupSD();

	SWInt_RegisterCallback(1, SDDriver_Read);

	TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / SAMPLE_RATE);
	TIMER_Init( TIMER0, &timerInit );

	while(1)
		EMU_EnterEM1();
}
