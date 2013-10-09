#include "bsp.h"
#include "bsp_trace.h"
#include "em_emu.h"
#include "em_cmu.h"
#include "em_adc.h"
#include "em_dac.h"
#include "em_prs.h"
#include "em_timer.h"
#include "em_dma.h"
#include "dmactrl.h"
#include "rtcdrv.h"
#include "ADCDriver.h"
#include "DACDriver.h"
#include "DMADriver.h"
#include "PRSDriver.h"
#include "MEMDriver.h"


#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */

// Start address of SRAM on DK3750 
#define EXT_SRAM_BASE_ADDRESS ((volatile uint16_t*) 0x88000000)

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

static void setupDMA( void ) 
{
	DMADriver_Init( );
}

static void setupPRS( ) 
{	
	PRSDriver_Init();
}

void setupBSP( void ) 
{
	BSP_Init( BSP_INIT_DEFAULT );
	BSP_TraceProfilerSetup();

	BSP_PeripheralAccess( BSP_AUDIO_IN, true );
	BSP_PeripheralAccess( BSP_AUDIO_OUT, true );
}

void setupClocks( void )
{
	CMU_ClockEnable( cmuClock_HFPER, true );
	CMU_ClockEnable( cmuClock_ADC0, true );
	CMU_ClockEnable( cmuClock_DAC0, true );
	CMU_ClockEnable( cmuClock_PRS, true );
	CMU_ClockEnable( cmuClock_DMA, true );
	CMU_ClockEnable( cmuClock_TIMER0, true );
}

void setupFPGA( void ) 
{
	FPGAConfig config;

	config.baseAddress = EXT_SRAM_BASE_ADDRESS;
	config.bufferSize  = BUFFER_SIZE;

	FPGA_Init( &config );
}

int main(void)
{
  TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;

	setupBSP();

	// Wait a little
  RTCDRV_Trigger(1000, NULL); EMU_EnterEM2(true);

	setupClocks();
  
  MEM_Init();

  NVIC_SetPriority(DMA_IRQn, 0);
  NVIC_SetPriority(PendSV_IRQn, (1 << __NVIC_PRIO_BITS) - 1);

	setupPRS();
	setupDMA(); setupDAC(); setupADC();

  TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / SAMPLE_RATE);
  TIMER_Init(TIMER0, &timerInit);

  while (1)
		{
			EMU_EnterEM1();
		}
}
