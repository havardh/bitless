#include "ButtonsConfig.h"

#define B4 		5
#define B5 		11
#define B6 		0
#define B7 		1
#define B8 		2

void ButtonsDriver_Init(ButtonsConfig *);

void STK3700_GpioSetup(uint8_t *pins, uint32_t numPins);

void DK3750_GpioSetup();
