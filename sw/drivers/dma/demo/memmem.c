#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_adc.h"
#include "em_dma.h"
#include "em_prs.h"
#include "em_timer.h"
#include "em_int.h"
#include "bsp.h"
#include "bsp_trace.h"
#include "dmactrl.h"

#define N 4

DMA_CB_TypeDef cbInLeft;
DMA_CB_TypeDef cbInRight;
DMA_CB_TypeDef cbOutLeft;
DMA_CB_TypeDef cbOutRight;

#define DMA_CHANNEL_IN_LEFT   0 
#define DMA_CHANNEL_IN_RIGHT  1 
#define DMA_CHANNEL_OUT_LEFT  2
#define DMA_CHANNEL_OUT_RIGHT 3 

volatile uint16_t source[2*N] = { 1, 2, 3, 4, 5, 6, 7, 8 };

volatile uint16_t left[N] = { 0, 0, 0, 0 };
volatile uint16_t right[N] = { 0, 0, 0, 0 };

volatile uint16_t destination[2*N] = { 0, 0, 0, 0, 0, 0, 0, 0 };

volatile uint32_t msTicks; /* counts 1ms timeTicks */

volatile bool transferInLeftActive;
volatile bool transferInRightActive;
volatile bool transferOutLeftActive;
volatile bool transferOutRightActive;

void Delay(uint32_t dlyTicks);

void SysTick_Handler(void)
{
  msTicks++;	   /* increment counter necessary in Delay()*/
}

void Delay(uint32_t dlyTicks)
{
  uint32_t curTicks;

  curTicks = msTicks;
  while ((msTicks - curTicks) < dlyTicks) ;
}

void transferInLeftComplete(unsigned int channel, bool primary, void *user)
{
	(void) channel;
	(void) primary;
	(void) user;

  transferInLeftActive = false;
}

void transferInRightComplete(unsigned int channel, bool primary, void *user)
{
	(void) channel;
	(void) primary;
	(void) user;

  transferInRightActive = false;
}

void transferOutLeftComplete(unsigned int channel, bool primary, void *user)
{
	(void) channel;
	(void) primary;
	(void) user;

  transferOutLeftActive = false;
}

void transferOutRightComplete(unsigned int channel, bool primary, void *user)
{
	(void) channel;
	(void) primary;
	(void) user;

  transferOutRightActive = false;
}

void setupCMU( void ) 
{
	CMU_ClockEnable(cmuClock_DMA, true);
}

/*
 * Sets up the DMA to copy from src to dst0 and dst1 with the pattern:
 *
 * src:  | 1, 2, 3, 4, ... |
 * dst0: | 1, 3, ...  |
 * dst1: | 2, 4, ...  |
 */
void setupDMASplit(void)
{
	DMA_Init_TypeDef dmaInit;
	dmaInit.hprot = 0;
	dmaInit.controlBlock = dmaControlBlock;
	DMA_Init(&dmaInit);

	cbInLeft.cbFunc = transferInLeftComplete;
	cbInLeft.userPtr = NULL;

	cbInRight.cbFunc = transferInRightComplete;
	cbInRight.userPtr = NULL;

	DMA_CfgChannel_TypeDef chnlCfgLeft;
	chnlCfgLeft.highPri   = false;
	chnlCfgLeft.enableInt = true;
	chnlCfgLeft.select    = 0;
	chnlCfgLeft.cb        = &cbInLeft;
	DMA_CfgChannel(DMA_CHANNEL_IN_LEFT, &chnlCfgLeft);

	DMA_CfgChannel_TypeDef chnlCfgRight;
	chnlCfgRight.highPri   = false;
	chnlCfgRight.enableInt = true;
	chnlCfgRight.select    = 0;
	chnlCfgRight.cb        = &cbInRight;
	DMA_CfgChannel(DMA_CHANNEL_IN_RIGHT, &chnlCfgRight);

	DMA_CfgDescr_TypeDef descrCfg;
	descrCfg.dstInc  = dmaDataInc2;
	descrCfg.srcInc  = dmaDataInc4;
	descrCfg.size    = dmaDataSize2;
	descrCfg.arbRate = dmaArbitrate1;
	descrCfg.hprot   = 0;
	DMA_CfgDescr(DMA_CHANNEL_IN_LEFT, true, &descrCfg);
	DMA_CfgDescr(DMA_CHANNEL_IN_RIGHT, false, &descrCfg);

	transferInLeftActive = true;
	transferInRightActive = true;

	DMA_ActivateAuto(DMA_CHANNEL_IN_LEFT, true, left, source, N - 1);
	DMA_ActivateAuto(DMA_CHANNEL_IN_RIGHT, false, right, (char*)source+sizeof(uint16_t), N - 1);
}

/*
 * Sets up the DMA to copy from src0 and src1 to dst with the pattern:
 *
 * src0: | 1, 3, ...  |
 * src1: | 2, 4, ...  |
 * dst:  | 1, 2, 3, 4, ... |
 */
void setupDMAMerge(void)
{
	DMA_Init_TypeDef dmaInit;
	dmaInit.hprot = 0;
	dmaInit.controlBlock = dmaControlBlock;
	DMA_Init(&dmaInit);

	cbOutLeft.cbFunc = transferOutLeftComplete;
	cbOutLeft.userPtr = NULL;

	cbOutRight.cbFunc = transferOutRightComplete;
	cbOutRight.userPtr = NULL;

	DMA_CfgChannel_TypeDef chnlCfgLeft;
	chnlCfgLeft.highPri   = false;
	chnlCfgLeft.enableInt = true;
	chnlCfgLeft.select    = 0;
	chnlCfgLeft.cb        = &cbOutLeft;
	DMA_CfgChannel(DMA_CHANNEL_OUT_LEFT, &chnlCfgLeft);

	DMA_CfgChannel_TypeDef chnlCfgRight;
	chnlCfgRight.highPri   = false;
	chnlCfgRight.enableInt = true;
	chnlCfgRight.select    = 0;
	chnlCfgRight.cb        = &cbOutRight;
	DMA_CfgChannel(DMA_CHANNEL_OUT_RIGHT, &chnlCfgRight);

	DMA_CfgDescr_TypeDef descrCfg;
	descrCfg.dstInc  = dmaDataInc4;
	descrCfg.srcInc  = dmaDataInc2;
	descrCfg.size    = dmaDataSize2;
	descrCfg.arbRate = dmaArbitrate1;
	descrCfg.hprot   = 0;
	DMA_CfgDescr(DMA_CHANNEL_OUT_LEFT, true, &descrCfg);
	DMA_CfgDescr(DMA_CHANNEL_OUT_RIGHT, false, &descrCfg);

	transferOutLeftActive = true;
	transferOutRightActive = true;

	DMA_ActivateAuto(DMA_CHANNEL_OUT_LEFT, true, destination, left, N - 1);
	DMA_ActivateAuto(DMA_CHANNEL_OUT_RIGHT, false, (char*)destination+sizeof(uint16_t), right, N - 1);
}

bool test(void) 
{
	for (int i=0; i<N; i++) {
		if (left[i] != (2*i+1) || right[i] != (2*i+2)) {
			//return false;
		}
	}

	for (int i=0; i<2*N; i++) {
		if (destination[i] != i+1) {
			return false;
		}
	}

	return true;
}

int main(void) 
{
	
	CHIP_Init();

	if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000)) while (1) ;

	BSP_LedsInit();
	BSP_LedsSet(0);

	setupCMU();

	setupDMASplit();
	setupDMAMerge();

	Delay(100);
	BSP_LedsSet(3);
	Delay(500);
	BSP_LedsSet(0);
	Delay(100);

	while(1) {
		volatile bool result = test();
		if (result) {
			BSP_LedToggle(0);
		} else {
			BSP_LedToggle(1);			
		}
		Delay(1000);
	}

	

}
