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

#include "bl_mem.h"
#include "FPGAConfig.h"

#include "bl_sd.h"

#include "ff.h"
#include "microsd.h"
#include "diskio.h"

#include "StoredFilter.h"

// How many samples to read for each interrupt
static int bufferSize = 64;

// Is the reading done
static bool done = false;

static void setupSD(void);
static void setupTimer(void);
static void setupMEM(void);

void StoredFilter_Start(void) 
{
	Leds_SetLeds(0x8);	

  CHIP_Init();

  /* Enable clock for USART2 */
  CMU_ClockEnable(cmuClock_USART2, true);
  CMU_ClockEnable(cmuClock_GPIO, true);

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

//------------//
// Setup code //
//------------//

// Callback for getting InBuffer
void* GetInBuffer(void) 
{
  return (void*) MEM_GetAudioInBuffer(true);
}

void* GetOutBuffer(void)
{
  return (void*) MEM_GetAudioOutBuffer(true);
}



void TIMER0_IRQHandler( void ) 
{

	TIMER_IntClear( TIMER0, TIMER_IF_OF );

	copySamples();
}

void setupSD(void)
{
  SDConfig config = {
    .mode = INOUT,
		inFile = "sweet1.wav",
		.outFile = "sweet2.wav",
		.GetInputBuffer = GetInBuffer,
		.GetOutputBuffer = GetOutBuffer,
		.bufferSize = bufferSize
  };
	SDDriver_Init( &config );
}

void setupMEM( void ) 
{
	MEMConfig config = {
		.bufferSize = bufferSize
	};
	MEM_Init( &config );
}

// 
//
//

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
