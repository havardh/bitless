#include "wavp_arch.c"

#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "bsp.h"
#include "bsp_trace.h"

#include "Delay.h"


int main(void) 
{

	CHIP_Init();
  BSP_Init(BSP_INIT_DEFAULT);
  BSP_TraceProfilerSetup();

  if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000)) { while (1); }

	BSP_LedsSet(0x000);



	init();
}
