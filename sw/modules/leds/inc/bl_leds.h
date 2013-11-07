#ifndef _LEDS_H_
#define _LEDS_H_

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

/* Comment in lines below to run on STK_3700 */
// #define NUM_LEDS        2
// #define LEDS_ARRAY_INIT {{gpioPortE,2},{gpioPortE,3}}

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
