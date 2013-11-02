#include "Delay.h"

static volatile uint32_t msTicks; /* counts 1ms timeTicks */

void Delay_Init( void ) {
  if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000)) while (1) ;
} 

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
