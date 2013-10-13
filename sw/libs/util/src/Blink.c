#include "Blink.h"

void BlinkLeds(int leds, int millis) 
{
	BSP_LedsSet(0);
	Delay(millis);
	BSP_LedsSet(leds);
	Delay(millis);
	BSP_LedsSet(0);
}
