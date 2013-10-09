#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_gpio.h"
#include "ButtonsController.h"
#include "ButtonsDriver.h"

/*
*   Setup callbacks for the different buttons specified in 'buttons', 
*   with the corresponding callback functions referenced in 'callbackPtrs'.
*/
void RegisterCallbacks(uint8_t buttons[], GPIOINT_IrqCallbackPtr_t *callbackPtrs, 
    uint8_t numButtons) 
{
    int i = 0;
    for (; i < numButtons; i++) {
        SetCallback(buttons[i], callbackPtrs[i]);
    }
}

/*
*   Register callbacks using the emlib gpiointerrupt library
*/
void SetCallback(uint8_t button, GPIOINT_IrqCallbackPtr_t callbackPtr) 
{
    GPIOINT_CallbackRegister(button, callbackPtr);
}

void ButtonsController_Init(ButtonsConfig *config) 
{
    ButtonsDriver_Init(config);
}
