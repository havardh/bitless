#include <stdint.h>
#include "gpiointerrupt.h"
#include "ButtonsConfig.h"

void RegisterCallbacks(uint8_t buttons[], GPIOINT_IrqCallbackPtr_t *callbackPtrs, uint8_t numButtons);

void SetCallback(uint8_t button, GPIOINT_IrqCallbackPtr_t callbackPtr);

void ButtonsController_Init(ButtonsConfig *config);
