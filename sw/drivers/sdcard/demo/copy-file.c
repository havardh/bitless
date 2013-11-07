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
//#include "bsp.h"

#define WAV_FILENAME             "sweet1.wav"

#define FPGA_BASE ((uint16_t*) 0x21000000)


bool bytesLeft = true;

int bufferSize = 64;
//void *inBuffer;
//void *outBuffer;

bool done = false;

void setupSWO(void);

void* GetInBuffer(void) {
	return (void*)MEM_GetAudioInBuffer(true);
}

void* GetOutBuffer(void) {
	return (void*)MEM_GetAudioOutBuffer(true);
}


static FATFS Fatfs;
static FIL WAVfile;
/*
void testOpen() 
{
	FRESULT res;

	CMU_ClockSelectSet(cmuClock_HF, cmuSelect_HFXO);

	BSP_Init(BSP_INIT_DEFAULT);
	BSP_PeripheralAccess(BSP_MICROSD, true);
	
	BSP_Init(BSP_INIT_DEFAULT);
	BSP_LedsSet(0xff);
	BSP_PeripheralAccess(BSP_I2S, true);
	BSP_PeripheralAccess(BSP_MICROSD, true);
	MICROSD_Init();

	res = f_mount(0, &Fatfs);
	while(res != FR_OK);

	res = f_open(&WAVfile, WAV_FILENAME, FA_READ);
	while(res != FR_OK);

	BSP_LedsSet(0xff00);
	while(1); 

}
*/
void setupBSP(void)
{
  //BSP_Init(BSP_INIT_DEFAULT);
  //BSP_PeripheralAccess(BSP_MICROSD, true);
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
		
		int16_t *audioInBuffer = (int16_t*)MEM_GetAudioInBuffer(true);
		int16_t *audioOutBuffer = (int16_t*)MEM_GetAudioOutBuffer(true);
		volatile uint16_t *fpgaLeftInBuffer   = (volatile uint16_t*)FPGADriver_GetInBuffer(0);
		volatile uint16_t *fpgaRightInBuffer  = (volatile uint16_t*)FPGADriver_GetInBuffer(1);
		volatile uint16_t *fpgaLeftOutBuffer  = (volatile uint16_t*)FPGADriver_GetOutBuffer(0);
		volatile uint16_t *fpgaRightOutBuffer = (volatile uint16_t*)FPGADriver_GetOutBuffer(1);

		deinterleave();
		interleave();

		/*
		for (int i=0, j=0; i<bufferSize*2; i+=2, j++) {
			fpgaLeftInBuffer[j]  = audioInBuffer[i  ];
			fpgaRightInBuffer[j] = audioInBuffer[i+1];

			audioOutBuffer[i  ] = fpgaLeftInBuffer[j];
			audioOutBuffer[i+1] = fpgaRightInBuffer[j];
			}*/

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

void USART2_setup(void)
{
  USART_InitSync_TypeDef init = USART_INITSYNC_DEFAULT;

  init.baudrate     = 115200;
  init.databits     = usartDatabits8;
  init.msbf         = 0;
  init.master       = 1;
  init.clockMode    = usartClockMode0;
  init.prsRxEnable  = 0;
  init.autoTx       = 0;

  USART_InitSync(USART2, &init);
}

int main( void ) 
{
	CHIP_Init();

  /* Enable clock for USART2 */
  CMU_ClockEnable(cmuClock_USART2, true);
  CMU_ClockEnable(cmuClock_GPIO, true);
  /* Custom initialization for USART2 */
  //USART2_setup();
  /* Enable signals TX, RX, CLK, CS */
  //USART2->ROUTE |= USART_ROUTE_TXPEN | USART_ROUTE_RXPEN | USART_ROUTE_CLKPEN | USART_ROUTE_CSPEN;
  
	SPI_setup(2, 0, true);

	
	//setupBSP();
	//setupSWO();
	setupMEM();
	setupFPGA();

	//BSP_LedsSet(0x0);

	//printf("Main\n");
	setupSD();

	setupTimer();

	while(1) {
		
		/*if (done) 
			BSP_LedsSet(0xff);*/

		if (done)
			break;

	}
	
	SDDriver_Finalize();

	while(1);
	return 0;

}
