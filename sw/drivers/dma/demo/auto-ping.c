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
static uint16_t TO_PRI[N];
static uint16_t FROM_SEC[N];
static uint16_t TO_SEC[N];

static void callback(unsigned int channel, bool primary, void *user)
{
	(void) channel;
	(void) primary;
	(void) user;
}

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

	cb.cbFunc  = callback;
	cb.userPtr = NULL;

	DMA_CfgChannel_TypeDef chnlCfg = {
		.highPri = true,
		.enableInt = true,
		.select = DMAREQ_TIMER0_UFOF,
		.cb = &cb
	};
	DMA_CfgChannel(0, &chnlCfg);

	DMA_CfgDescr_TypeDef descrCfg = {
		.dstInc  = dmaDataInc2,
		.srcInc  = dmaDataInc2,
		.size    = dmaDataSize2,
		.arbRate = dmaArbitrate1,
		.hprot   = 0
	};
	DMA_CfgDescr(0, true, &descrCfg);
	DMA_CfgDescr(0, false, &descrCfg);

	DMA_ActivatePingPong(0, false, 
											 &TO_PRI, &FROM_PRI, N-1,
											 &TO_SEC, &FROM_SEC, N-1);
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

}

void setupTimer( void ) 
{
	TIMER_Init_TypeDef init = TIMER_INIT_DEFAULT;

	init.enable     = true;
	init.dmaClrAct  = true;

	TIMER_TopSet(TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / 44100);
	TIMER_Init(TIMER0, &init);
	
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
