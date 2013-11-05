#ifndef _BUTTONS_H_
#define _BUTTONS_H_

#include <stdint.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_gpio.h"
#include "gpiointerrupt.h"
#include "ButtonsConfig.h"

typedef struct {
    GPIO_Port_TypeDef port;
    uint32_t pin;
} BTN_t;

/* Init and setup */
void Buttons_Init(Board_t board);
void STK3700_GpioSetup(void);
void Bitless_GpioSetup(void);

/* Register callback functions for buttons */
void Buttons_RegisterCallbacks(uint8_t buttons[], GPIOINT_IrqCallbackPtr_t *callbackPtrs, uint8_t numButtons);
void Buttons_SetCallback(uint8_t button, GPIOINT_IrqCallbackPtr_t callbackPtr);

#endif /* _BUTTONS_H_ */
