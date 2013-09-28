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

#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define PRS_CHANNEL     0

extern volatile bool preampProcessPrimary;

extern uint16_t preampAudioInBuffer1[BUFFER_SIZE * 2];
extern uint16_t preampAudioInBuffer2[BUFFER_SIZE * 2];
extern uint32_t preampAudioOutBuffer1[BUFFER_SIZE];
extern uint32_t preampAudioOutBuffer2[BUFFER_SIZE];

void PendSV_Handler(void)
{

	uint16_t *inBuf;
  uint32_t *outBuf;
  int32_t right;
  int32_t left;

	if (preampProcessPrimary)
		{
			inBuf  = preampAudioInBuffer1;
			outBuf = preampAudioOutBuffer1;
		}
  else
		{
			inBuf  = preampAudioInBuffer2;
			outBuf = preampAudioOutBuffer2;
		}

	int i=0; 
	for (; i<BUFFER_SIZE; i++) 
		{
			right = (int32_t) *inBuf++;
			left = (int32_t) *inBuf++;
			
			*(outBuf++) = ((uint32_t) left << 16) | (uint32_t) right;
		}

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

static void setupDMA( void ) 
{
	DMADriver_Init( );
}

static void setupPRS( unsigned int channel ) 
{
	PRS_LevelSet(0, 1 << (channel + _PRS_SWLEVEL_CH0LEVEL_SHIFT));

	PRS_SourceSignalSet(channel,
											PRS_CH_CTRL_SOURCESEL_TIMER0,
											PRS_CH_CTRL_SIGSEL_TIMER0OF,
											prsEdgePos);
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


int main(void)
{
  TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;

	setupBSP();

	// Wait a little
  RTCDRV_Trigger(1000, NULL); EMU_EnterEM2(true);

	setupClocks();

  NVIC_SetPriority(DMA_IRQn, 0);
  NVIC_SetPriority(PendSV_IRQn, (1 << __NVIC_PRIO_BITS) - 1);

  setupPRS(PRS_CHANNEL);

	setupDMA(); setupDAC(); setupADC();

  TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / SAMPLE_RATE);
  TIMER_Init(TIMER0, &timerInit);

  while (1)
		{
			EMU_EnterEM1();
		}
}
