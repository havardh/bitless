#include "Buttons.h"

static BTN_t BTNS[NUM_BUTTONS] = BUTTONS_ARRAY_INIT;

/*
*   Setup callbacks for the different buttons specified in 'buttons', 
*   with the corresponding callback functions referenced in 'callbackPtrs'.
*/
void Buttons_RegisterCallbacks(uint8_t buttons[],
	GPIOINT_IrqCallbackPtr_t *callbackPtrs, uint8_t numButtons)
{
    for (int i = 0; i < numButtons; i++) {
        Buttons_SetCallback(buttons[i], callbackPtrs[i]);
    }
}

/*
*   Register callbacks using the emlib gpiointerrupt library
*/
void Buttons_SetCallback(uint8_t button, GPIOINT_IrqCallbackPtr_t callbackPtr) 
{
    GPIOINT_CallbackRegister(button, callbackPtr);
}

void Buttons_Init(Board_t board) {
    /* Enable GPIO in CMU */
    CMU_ClockEnable(cmuClock_GPIO, true);

    /* Initialize ODD and EVEN GPIO interrupts dispatcher */
    GPIOINT_Init();

    if (board == GG_STK3700) {
        STK3700_GpioSetup();
    } else if (board == BITLESS) {
        Bitless_GpioSetup();
    }
}

void STK3700_GpioSetup(void) {
    /* Configure PB9 and PB10 as input */
    GPIO_PinModeSet(gpioPortB,  9, gpioModeInput, 0);
    GPIO_PinModeSet(gpioPortB, 10, gpioModeInput, 0);
    /* Set falling edge interrupt for both ports */
    GPIO_IntConfig(gpioPortB,  9, false, true, true);
    GPIO_IntConfig(gpioPortB, 10, false, true, true);
}

void Bitless_GpioSetup(void) {
    for (int i = 0; i < NUM_BUTTONS; i++) {
        /* Configure the five as input */
        GPIO_PinModeSet(BTNS[i].port, BTNS[i].pin, gpioModeInput, 0);
        /* Set falling edge interrupt for both ports */
        GPIO_IntConfig(BTNS[i].port, BTNS[i].pin, false, true, true);
    }
}
