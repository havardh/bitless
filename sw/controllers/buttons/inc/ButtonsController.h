#ifndef _BUTTONSCONTROLLER_H_
#define _BUTTONSCONTROLLER_H_

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
void ButtonsController_Init(Board_t board);
void STK3700_GpioSetup(void);
void Bitless_GpioSetup(void);

/* Register callback functions for buttons */
void ButtonsController_RegisterCallbacks(uint8_t buttons[], GPIOINT_IrqCallbackPtr_t *callbackPtrs, uint8_t numButtons);
void ButtonsController_SetCallback(uint8_t button, GPIOINT_IrqCallbackPtr_t callbackPtr);

#endif /* _BUTTONSCONTROLLER_H_ */
