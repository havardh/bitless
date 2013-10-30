#include <stdint.h>
#include "gpiointerrupt.h"
#include "ButtonsConfig.h"

void ButtonsController_RegisterCallbacks(uint8_t buttons[], GPIOINT_IrqCallbackPtr_t *callbackPtrs, uint8_t numButtons);

void ButtonsController_SetCallback(uint8_t button, GPIOINT_IrqCallbackPtr_t callbackPtr);

void ButtonsController_Init(ButtonsConfig *config);
