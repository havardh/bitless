#ifndef _LEDSCONTROLLER_H_
#define _LEDSCONTROLLER_H_

#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_gpio.h"
#include "leds_config.h"

typedef struct {
  GPIO_Port_TypeDef   port;
  unsigned int        pin;
} LED_t;

void LEDController_Init(void);
uint32_t LEDController_GetLeds(void);
void LEDController_SetLed(uint32_t led);
void LEDController_SetLeds(uint32_t leds);
void LEDController_ClearLed(uint32_t led);

#endif // _LEDSCONTROLLER_H_
