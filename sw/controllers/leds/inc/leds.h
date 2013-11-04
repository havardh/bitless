#ifndef _LEDSCONTROLLER_H_
#define _LEDSCONTROLLER_H_

#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_gpio.h"

#define NUM_LEDS        5
#define LED0            7
#define LED1            8
#define LED2            9
#define LED3           10
#define LED4           11

#define LEDS_ARRAY_INIT {\
    {gpioPortA, (LED0)}, \
    {gpioPortA, (LED1)}, \
    {gpioPortA, (LED2)}, \
    {gpioPortA, (LED3)}, \
    {gpioPortA, (LED4)}, \
}

typedef struct {
  GPIO_Port_TypeDef   port;
  unsigned int        pin;
} LED_t;

void SysTick_Handler(void);
void LEDController_ClearLed(uint32_t led);
void LEDController_SetLed(uint32_t led);
void LEDController_SetLeds(uint32_t leds);
void LEDController_Init(void);

#endif // _LEDSCONTROLLER_H_
