#ifndef _LEDS_H_
#define _LEDS_H_

#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_gpio.h"
#include "LedsConfig.h"

typedef struct {
  GPIO_Port_TypeDef   port;
  unsigned int        pin;
} LED_t;

void Leds_Init(void);
uint32_t Leds_GetLeds(void);
void Leds_SetLed(uint32_t led);
void Leds_SetLeds(uint32_t leds);
void Leds_ClearLed(uint32_t led);

#endif // _LEDS_H_
