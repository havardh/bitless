#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_dma.h"
#include "em_timer.h"
#include "dmactrl.h"
#include "Delay.h"
#include "Blink.h"

#define N 16

static DMA_CB_TypeDef cb;

static uint16_t FROM_PRI[N];
static uint16_t FROM_SEC[N];

static uint16_t MID_PRI[N];
static uint16_t MID_SEC[N];

static uint16_t TO_PRI[N];
static uint16_t TO_SEC[N];

void init( void )
{
	for (int i=0; i<N; i++) {
		FROM_PRI[i] = i;
		FROM_SEC[i] = i;
	}
}

void transfer ( void ) 
{
	DMA_Init_TypeDef dmaInit;
	dmaInit.hprot = 0;
	dmaInit.controlBlock = dmaControlBlock;
  DMA_Init(&dmaInit);

	DMA_CfgChannel_TypeDef chnlCfg1 = {
		.highPri = true,
		.enableInt = true,
		.select = DMAREQ_TIMER0_UFOF,
		.cb = &cb
	};
	DMA_CfgChannel(0, &chnlCfg1);

	DMA_CfgChannel_TypeDef chnlCfg2 = {
		.highPri = true,
		.enableInt = true,
		.select = DMAREQ_TIMER1_UFOF,
		.cb = &cb
	};
	DMA_CfgChannel(1, &chnlCfg2);

	DMA_CfgDescr_TypeDef descrCfg = {
		.dstInc  = dmaDataInc2,
		.srcInc  = dmaDataInc2,
		.size    = dmaDataSize2,
		.arbRate = dmaArbitrate1,
		.hprot   = 0
	};
	DMA_CfgDescr(0, true, &descrCfg);
	DMA_CfgDescr(0, false, &descrCfg);
	DMA_CfgDescr(1, true, &descrCfg);
	DMA_CfgDescr(1, false, &descrCfg);

	DMA_ActivatePingPong(0, false, 
											 &MID_PRI, &FROM_PRI, N-1,
											 &MID_SEC, &FROM_SEC, N-1);

	DMA_ActivatePingPong(1, false, 
											 &TO_PRI, &MID_PRI, N-1,
											 &TO_SEC, &MID_SEC, N-1);
}

void fake_transfer( void ) 
{
	for (int i=0; i<N; i++) {
		TO_PRI[i] = i;
		TO_SEC[i] = i;
	}
}

int test( void ) 
{
	int result = 0;
	for(int i=0; i<N; i++) {
		if (TO_PRI[i] != i) {
			result |= 0b1;
		}
		if (TO_SEC[i] != i) {
			result |= 0b10;
		}
	}

	return result;
 
}

void test_and_display( void ) 
{

		volatile int result = test();
		
		if (result & 0b1) {
			BSP_LedToggle(0);
		}
		if (result & 0b10) {
			BSP_LedToggle(1);
		}

}

void setupCMU( void ) 
{

	CMU_ClockEnable(cmuClock_HFPER, true);
	CMU_ClockEnable(cmuClock_DMA, true);
	CMU_ClockEnable(cmuClock_TIMER0, true);
	CMU_ClockEnable(cmuClock_TIMER1, true);

}

void setupTimer( void ) 
{

	TIMER_Init_TypeDef init1 = TIMER_INIT_DEFAULT;
	init1.enable     = true;
	init1.dmaClrAct  = true;
	TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / 44100);
	TIMER_Init(TIMER0, &init1); 

	TIMER_Init_TypeDef init2 = TIMER_INIT_DEFAULT;
	init2.enable     = true;
	init2.dmaClrAct  = true;
	TIMER_TopSet(TIMER1, CMU_ClockFreqGet(cmuClock_HFPER) / 44100);
	TIMER_Init(TIMER1, &init2); 
	
}


int main( void )
{
	init();

	setupCMU();
	setupTimer();

	transfer();
	//fake_transfer();

	BSP_LedsInit();

	Delay_Init();
	BlinkLeds(3, 200);

	while(1) {
		test_and_display();
		Delay(1000);
		BSP_LedsSet(0x0);
		Delay(500);
	}
}
