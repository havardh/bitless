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

#include "ff.h"
#include "microsd.h"
#include "diskio.h"
#include "bsp.h"

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

void setupBSP(void)
{
  BSP_Init(BSP_INIT_DEFAULT);
  BSP_PeripheralAccess(BSP_MICROSD, true);
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

bool copySamples( void ) 
{
	if (!SDDriver_Read()) {
		
		uint16_t *audioInBuffer = (uint16_t*)MEM_GetAudioInBuffer(true);
		uint16_t *audioOutBuffer = (uint16_t*)MEM_GetAudioOutBuffer(true);
		volatile uint16_t *fpgaLeftInBuffer   = (volatile uint16_t*)FPGADriver_GetInBuffer(0);
		volatile uint16_t *fpgaRightInBuffer  = (volatile uint16_t*)FPGADriver_GetInBuffer(1);
		volatile uint16_t *fpgaLeftOutBuffer  = (volatile uint16_t*)FPGADriver_GetOutBuffer(0);
		volatile uint16_t *fpgaRightOutBuffer = (volatile uint16_t*)FPGADriver_GetOutBuffer(1);

		for (int i=0, j=0; i<bufferSize*2; i+=2, j++) {
			fpgaLeftInBuffer[j] = audioInBuffer[i];
			fpgaRightInBuffer[j] = audioInBuffer[i+1];
			audioOutBuffer[i] = fpgaLeftInBuffer[j];
			audioOutBuffer[i+1] = fpgaRightInBuffer[j];
		}

		//memcpy(audioOutBuffer, audioInBuffer, bufferSize*2);

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
	setupBSP();
	setupSWO();
	setupMEM();
	setupFPGA();

	BSP_LedsSet(0x0);

	printf("Main\n");
	setupSD();

	setupTimer();

	while(1) {

		if (done) 
			BSP_LedsSet(0xff);

		if (done)
			break;

	}
	
	SDDriver_Finalize();

	while(1);
	return 0;

}


void setupSWO(void)
{
  /* Enable GPIO Clock. */
  CMU->HFPERCLKEN0 |= CMU_HFPERCLKEN0_GPIO;
  /* Enable Serial wire output pin */
  GPIO->ROUTE |= GPIO_ROUTE_SWOPEN;
#if defined(_EFM32_GIANT_FAMILY) || defined(_EFM32_WONDER_FAMILY) || defined(_EFM32_LEOPARD_FAMILY)
  /* Set location 0 */
  GPIO->ROUTE = (GPIO->ROUTE & ~(_GPIO_ROUTE_SWLOCATION_MASK)) | GPIO_ROUTE_SWLOCATION_LOC0;

  /* Enable output on pin - GPIO Port F, Pin 2 */
  GPIO->P[5].MODEL &= ~(_GPIO_P_MODEL_MODE2_MASK);
  GPIO->P[5].MODEL |= GPIO_P_MODEL_MODE2_PUSHPULL;
#else
  /* Set location 1 */
  GPIO->ROUTE = (GPIO->ROUTE & ~(_GPIO_ROUTE_SWLOCATION_MASK)) | GPIO_ROUTE_SWLOCATION_LOC1;
  /* Enable output on pin */
  GPIO->P[2].MODEH &= ~(_GPIO_P_MODEH_MODE15_MASK);
  GPIO->P[2].MODEH |= GPIO_P_MODEH_MODE15_PUSHPULL;
#endif
  /* Enable debug clock AUXHFRCO */
  CMU->OSCENCMD = CMU_OSCENCMD_AUXHFRCOEN;

  while(!(CMU->STATUS & CMU_STATUS_AUXHFRCORDY));

  /* Enable trace in core debug */
  CoreDebug->DHCSR |= 1;
  CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;

  /* Enable PC and IRQ sampling output */
  DWT->CTRL = 0x400113FF;
  /* Set TPIU prescaler to 16. */
  TPI->ACPR = 0xf;
  /* Set protocol to NRZ */
  TPI->SPPR = 2;
  /* Disable continuous formatting */
  TPI->FFCR = 0x100;
  /* Unlock ITM and output data */
  ITM->LAR = 0xC5ACCE55;
  ITM->TCR = 0x10009;
}

