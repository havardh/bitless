#include "bsp.h"
#include "bsp_trace.h"
#include "em_adc.h"
#include "em_dac.h"
#include "em_emu.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "em_dma.h"
#include "em_prs.h"
#include "em_timer.h"
#include "dmactrl.h"
#include "FPGADriver.h"
#include "MEMDriver.h"
#include "DMADriver.h"
#include "PRSDriver.h"
#include "ADCDriver.h"
#include "DACDriver.h"
#include "Delay.h"
#include "Blink.h"
#include <string.h>

#define BUFFER_SIZE 64
#define FPGA_BASE ((uint16_t*) 0x21000000)

static uint16_t *inPrim;
static uint16_t *inSec;
static uint16_t *outPrim;
static uint16_t *outSec;
static uint16_t *fpgaZero;
static uint16_t *fpgaOne;

void setupMEM( void )
{
	MEM_Init();
}

void setupFPGA( void )
{
	FPGAConfig config;

	config.baseAddress = FPGA_BASE;
	config.numPipelines = 2;
	config.bufferSize = BUFFER_SIZE;

	FPGADriver_Init( &config );
}

void setupDMA( void ) 
{
	DMAConfig config = DMA_CONFIG_DEFAULT;

	config.dacEnabled = true;
	config.adcEnabled = true;

	config.fpgaInEnabled = true;
	config.fpgaOutEnabled = true;

	DMADriver_Init( &config );
}

void setupCMU( void ) 
{
	CMU_ClockEnable( cmuClock_DMA, true );
	CMU_ClockEnable( cmuClock_TIMER0, true );

}

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

void setupTIMER( void )
{
	TIMER_Init_TypeDef init = TIMER_INIT_DEFAULT;

	TIMER_TopSet( TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / 10 );
	TIMER_Init( TIMER0, &init );

}

static void setupPRS( ) 
{	
	PRSDriver_Init();
}

int test( void ) 
{

	int result = 0;
	for(int i=0; i<BUFFER_SIZE; i++) {

		if (outPrim[i] != i) {
			result |= 1;
		}
		if (outSec[i] != i) {
			result |= 2;
		}

		if (i < BUFFER_SIZE / 2) {

			if (fpgaZero[i] != i*2) {
				result |= 4;
			}

			if (fpgaOne[i] != (i*2)+1) {
				result |= 8;
			}
		}

	}

	return result;
}

void test_and_display( void ) 
{
		volatile int result = test();
		
		if (result & 1) {
			BSP_LedToggle(0);
		}
		if (result & 2) {
			BSP_LedToggle(1);
		}

		if (result & 4) {
			//BSP_LedToggle(0);
		}
		if (result & 8) {
			//BSP_LedToggle(1);
		}
}

void init( void ) 
{

	inPrim  = MEM_GetPrimaryAudioInBuffer();
	inSec   = MEM_GetSecondaryAudioInBuffer();
	outPrim = MEM_GetPrimaryAudioOutBuffer();
	outSec  = MEM_GetSecondaryAudioOutBuffer();
	memset(outPrim, 0, 64*2);
	memset(outSec, 0, 64*2);

	fpgaZero = FPGADriver_GetInBuffer(0);
	fpgaOne  = FPGADriver_GetInBuffer(1);
	memset(fpgaZero, 0, 64);
	memset(fpgaOne, 0, 64);

	for (int i=0; i<BUFFER_SIZE; i++) {
		inPrim[i] = i;
		inSec[i] = i;
		/*
		if (i < BUFFER_SIZE/2) {
			fpgaZero[i] = i;
			fpgaOne[i] = i;
			}*/
	}
}

int main1( void ) 
{
	setupMEM();
	setupFPGA();

	init();

	setupCMU();

	setupPRS();

	setupDAC();
	setupDMA();
	setupADC();

	setupTIMER();

	Delay_Init();

	BSP_LedsInit();
	BSP_LedsSet(0);

	while(1) {
		test_and_display();
		Delay(1000);
		BSP_LedsSet(0);
		Delay(500);

	}
	
}
