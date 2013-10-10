#include "bsp.h"
#include "bsp_trace.h"
#include "em_emu.h"
#include "em_cmu.h"
#include "em_prs.h"
#include "em_timer.h"
#include "em_dma.h"
#include "dmactrl.h"
#include "rtcdrv.h"
#include "MEMDriver.h"
#include "FPGADriver.h"
#include "DMADriver.h"
#include "retargetserial.h"

volatile uint32_t msTicks; /* counts 1ms timeTicks */
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

void setupFPGA( void )
{
  FPGAConfig config;

  config.numPipelines = 2;
  config.bufferSize = 64;

  FPGADriver_Init( &config );
}

void setupMEM( void )
{
  MEM_Init();
}

void setupDMA( void ) 
{
	DMADriver_Init();
}

void initialize( void ) 
{
	uint16_t *primIN  = MEM_GetPrimaryAudioInBuffer();
	uint16_t *primOUT = MEM_GetPrimaryAudioOutBuffer();
	uint16_t *secIN   = MEM_GetSecondaryAudioInBuffer();
	uint16_t *secOUT  = MEM_GetSecondaryAudioOutBuffer();

	for (int i=0; i<64; i++) 
	{	
		primIN[i] = i;
		secIN[i]  = i;

		primOUT[i] = 0;
		secOUT[i]  = 0;
	}

}

bool testSplit( void ) 
{
	uint16_t *left  = FPGADriver_GetInBuffer(0);
	uint16_t *right = FPGADriver_GetInBuffer(1);

	for (int i=0; i < (64 / 2); i++)
	{
		if (left[i] != 2*i || right[i] != 2*i+1) {
			return false;
		}
	}

	return true;
}

bool testMerge( void ) 
{

	uint16_t *primOUT = MEM_GetPrimaryAudioOutBuffer();
	uint16_t *secOUT = MEM_GetSecondaryAudioOutBuffer();

	for(int i=0; i<64; i++) 
	{
		if (primOUT[i] != i) {
			printf("primOUT[%d] was %d expected to be %d\n", i, primOUT[i], i);
			return false;
		}
	}

	for(int i=0; i<64; i++) 
	{
		if (secOUT[i] != i) {
			printf("secOUT[%d] was %d expected to be %d\n", i, secOUT[i], i);
			return false;
		}
	}

	return true;
}

bool test( void ) 
{
	return testSplit() && testMerge();
}

int main( void )
{

  if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000)) while (1) ;

  BSP_Init(BSP_INIT_DEFAULT);
	BSP_LedsSet(0);

  setupFPGA();
  setupMEM();

	initialize();

	setupDMA();

  while(1) 
  {
		bool result = test();
		
		if (result) {
			BSP_LedsSet(0x00FF);
		} else {
			BSP_LedsSet(0xFF00);
		}
    Delay(1000);
		BSP_LedsSet(0x0);
    Delay(1000);
  }
  
}
