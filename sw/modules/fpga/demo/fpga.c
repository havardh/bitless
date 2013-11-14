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
#include "INTDriver.h"
#include "Delay.h"
#include "Blink.h"
#include <string.h>

/*
 * Implementation overview. Inspired by the preamp demo by Energy Micro
 *
 *
 *                                | Audio in
 *                                V
 *  +------+     +-----+       +------+       +-----+         +--------+
 *  |TIMER0|---->| PRS |--+--->| ADC0 |------>| DMA |-------->| Buffer |
 *  +------+     +-----+  |    +------+       +-----+         +--------+
 *                        |       .                              / \
 *                        |       .                             /   \
 *                        |       .                            V     V
 *                        |       .                      +-----+     +-----+
 *                        |       +........irq..........>| DMA |....>| DMA |
 *                        |                              +-----+     +-----+
 *                        |                                 |           |
 *                        |                                 V           V
 *                        |                             +------+    +-------+
 *                        |                             | FPGA |    | FPGA  |
 *                        |                             | Left |    | Right |
 *                        |                             +------+    +-------+
 *                        |                                 |           |
 *                        |                                 V           V
 *                        |                              +-----+     +-----+
 *                        |       +........irq..........>| DMA |....>| DMA |
 *                        |       .                      +-----+     +-----+
 *                        |       .                            \     /
 *                        |       .                             \   /
 *                        |       .                               V
 *                        |    +------+       +-----+         +--------+
 *                        +--->| DAC0 |<------| DMA |<--------| Buffer |
 *                             +------+       +-----+         +--------+
 *                                |
 *                                V Audio out
 *
 *
 */

#define BUFFER_SIZE 64
#define FPGA_BASE ((uint16_t*) 0x21000000)

static uint16_t *in;
static uint16_t *out;
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

	config.mode = ADC_TO_DAC;

	config.dacEnabled = true;
	config.adcEnabled = true;

	config.fpgaInEnabled = true;
	config.fpgaOutEnabled = true;

	DMADriver_Init( &config );
}

void setupCMU( void ) 
{
	CMU_ClockEnable( cmuClock_HFPER, true );
	CMU_ClockEnable( cmuClock_DMA, true );
	CMU_ClockEnable( cmuClock_ADC0, true );
	CMU_ClockEnable( cmuClock_DAC0, true );
	CMU_ClockEnable( cmuClock_PRS, true);
	CMU_ClockEnable( cmuClock_TIMER0, true );
}

static void setupADC( void ) 
{
	ADCConfig config;
	config.rate = 7000000;
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

	init.mode = timerModeUpDown;

	TIMER_TopSet( TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / 22050 );
	TIMER_Init( TIMER0, &init );

}

static void setupPRS( ) 
{	
	PRSDriver_Init();
}

static void setupBSP()
{
	BSP_Init( BSP_INIT_DEFAULT );
	BSP_TraceProfilerSetup();

	BSP_PeripheralAccess( BSP_AUDIO_IN, true );
	BSP_PeripheralAccess( BSP_AUDIO_OUT, true );
}

static void setupINT()
{
	INTDriver_Init();
}

int main( void ) 
{
	setupBSP();

	Delay_Init();
 
	setupMEM();
	setupFPGA();
	setupINT();

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

		//test_and_display();
		BSP_LedToggle(0);
		Delay(1000);
		BSP_LedsSet(0);
		Delay(500);

	}
	
}
