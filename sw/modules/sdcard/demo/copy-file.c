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

#include "MEMConfig.h"
#include "FPGAConfig.h"

#include "SDDriver.h"
#include "spi.h"

#include "ff.h"
#include "microsd.h"
#include "diskio.h"

/*
 * This demo reads and writes samples from the SDCard with a FAT file system.
 * The source file is allways called sweet1.wav and destination is sweet2.wav.
 *
 * The demo uses CPU to read and write the SDCard, but also to deinterleave
 * and interleave the samples to and from the FPGA buffers. 
 */

#define FPGA_BASE ((uint16_t*) 0x21000000)

bool bytesLeft = true;

int bufferSize = 64;

bool done = false;

void setupSWO(void);

void* GetInBuffer(void) {
	return (void*)MEM_GetAudioInBuffer(true);
}

void* GetOutBuffer(void) {
	return (void*)MEM_GetAudioOutBuffer(true);
}

void setupSD() 
{
	SDConfig config;
	config.mode = INOUT;
	config.inFile = "sweet1.wav";
	config.outFile = "sweet2.wav";
	config.GetInputBuffer = GetInBuffer;
	config.GetOutputBuffer = GetOutBuffer;
	config.bufferSize = bufferSize;
	SDDriver_Init( &config );
}


void deinterleave( void ) 
{
	int16_t *audioInBuffer = (int16_t*)MEM_GetAudioInBuffer(true);
	int16_t *audioOutBuffer = (int16_t*)MEM_GetAudioOutBuffer(true);
	volatile uint16_t *fpgaLeftInBuffer   = (volatile uint16_t*)FPGADriver_GetInBuffer(0);
	volatile uint16_t *fpgaRightInBuffer  = (volatile uint16_t*)FPGADriver_GetInBuffer(1);

	uint16_t tmp;
	for (int i=0, j=0; i<bufferSize*2; i+=2, j++) {

		fpgaLeftInBuffer[j]  = (audioInBuffer[i  ] + 0x8000);
		fpgaRightInBuffer[j] = (audioInBuffer[i+1] + 0x8000);

	}

}

void interleave( void ) 
{
	int16_t *audioInBuffer = (int16_t*)MEM_GetAudioInBuffer(true);
	int16_t *audioOutBuffer = (int16_t*)MEM_GetAudioOutBuffer(true);

	// When FPGA core is implemented the OutputBuffers should be utilized
	volatile uint16_t *fpgaLeftInBuffer   = (volatile uint16_t*)FPGADriver_GetInBuffer(0);
	volatile uint16_t *fpgaRightInBuffer  = (volatile uint16_t*)FPGADriver_GetInBuffer(1);
	//volatile uint16_t *fpgaLeftOutBuffer  = (volatile uint16_t*)FPGADriver_GetOutBuffer(0);
	//volatile uint16_t *fpgaRightOutBuffer = (volatile uint16_t*)FPGADriver_GetOutBuffer(1);
	
	for (int i=0, j=0; i<bufferSize*2; i+=2, j++) {
		audioOutBuffer[i  ] = (fpgaLeftInBuffer[j]  - 0x8000); // << 4;
		audioOutBuffer[i+1] = (fpgaRightInBuffer[j] - 0x8000); // << 4;
	}
	
}

bool copySamples( void ) 
{
	if (!SDDriver_Read()) {
		
		deinterleave();
		interleave();

		SDDriver_Write();

	} else {
		done = true;
	}

}

void setupTimer( void  ) 
{
	CMU_ClockEnable( cmuClock_HFPER, true );
  CMU_ClockEnable( cmuClock_TIMER0, true);

	TIMER_Init_TypeDef init = {
		.enable = true,
		.debugRun = true,
		.prescale = timerPrescale1,
		.clkSel = timerClkSelHFPerClk,
		.fallAction = timerInputActionNone,
		.riseAction = timerInputActionNone,
		.mode = timerModeUp,
		.dmaClrAct = false,
		.quadModeX4 = false,
		.oneShot = false,
		.sync = false
	};

	TIMER_IntEnable( TIMER0, TIMER_IF_OF );
	NVIC_EnableIRQ( TIMER0_IRQn );
	TIMER_TopBufSet( TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / 8000 );
	TIMER_Init( TIMER0, &init );	
}

void TIMER0_IRQHandler( void ) 
{

	TIMER_IntClear( TIMER0, TIMER_IF_OF );

	copySamples();
}

void setupMEM( void ) 
{
	MEMConfig config = {
		.bufferSize = bufferSize
	};
	MEM_Init( &config );
}

void setupFPGA( void )
{
	FPGAConfig config = {
		.baseAddress = FPGA_BASE,
		.numPipelines = 2,
		.bufferSize = bufferSize
	};
	FPGADriver_Init( &config );
	
}

int main( void ) 
{
	CHIP_Init();

  /* Enable clock for USART2 */
  CMU_ClockEnable(cmuClock_USART2, true);
  CMU_ClockEnable(cmuClock_GPIO, true);
  
	SPI_setup(2, 0, true);

	setupMEM();
	setupFPGA();

	setupSD();

	setupTimer();

	while(1) {
		
		if (done)
			break;

	}
	
	SDDriver_Finalize();

	while(1);
	return 0;

}
