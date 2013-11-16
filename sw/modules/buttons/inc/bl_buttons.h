#ifndef _BUTTONS_H_
#define _BUTTONS_H_

#include <stdint.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_gpio.h"
#include "gpiointerrupt.h"

#define NUM_BUTTONS         5
#define BTN0                15
#define BTN1                11
#define BTN2                0
#define BTN3                1
#define BTN4                2

#define BUTTONS_ARRAY_INIT {\
    {gpioPortB, (BTN0)},    \
    {gpioPortC, (BTN1)},    \
    {gpioPortD, (BTN2)},    \
    {gpioPortD, (BTN3)},    \
    {gpioPortD, (BTN4)},    \
}

typedef struct { GPIO_Port_TypeDef port;  uint32_t pin; } BTN_t;

/* Init and setup */
void Buttons_Init(void);
void Buttons_Dispatch(void);

/* Register callback functions for buttons */
//void Buttons_RegisterCallbacks(void *(*callbacks)(void));
void Buttons_SetCallback(uint8_t button, void (*callback)());

#endif /* _BUTTONS_H_ */
