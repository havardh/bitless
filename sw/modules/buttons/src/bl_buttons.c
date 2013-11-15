#include "bl_buttons.h"
static void Bitless_GpioSetup(void);

static void (*buttonCallbacks[5])(void);

static uint8_t lastPin = -1;

static BTN_t BTNS[NUM_BUTTONS] = BUTTONS_ARRAY_INIT;

void buttonCallback(uint8_t pin) {
	lastPin = pin;
}

/*
*   Setup callbacks for the different buttons specified in 'buttons', 
*   with the corresponding callback functions referenced in 'callbackPtrs'.
*/
/*void Buttons_RegisterCallbacks(void *(*callbacks)(void))
{
    for (int i = 0; i < NUM_BUTTONS; i++) {
			buttonCallbacks[i] = callbacks[i];
    }
}*/

/*
*   Register callbacks using the emlib gpiointerrupt library
*/
void Buttons_SetCallback(uint8_t button, void (*callback)(void)) 
{
	switch(button) {
	case BTN0: buttonCallbacks[0] = callback;
	case BTN1: buttonCallbacks[1] = callback;
	case BTN2: buttonCallbacks[2] = callback;
	case BTN3: buttonCallbacks[3] = callback;
	case BTN4: buttonCallbacks[4] = callback;
	}
}

void Buttons_Init(void) {
    /* Enable GPIO in CMU */
    CMU_ClockEnable(cmuClock_GPIO, true);

    /* Initialize ODD and EVEN GPIO interrupts dispatcher */
    GPIOINT_Init();

		GPIOINT_CallbackRegister(BTN0, buttonCallback);
		GPIOINT_CallbackRegister(BTN1, buttonCallback);
		GPIOINT_CallbackRegister(BTN2, buttonCallback);
		GPIOINT_CallbackRegister(BTN3, buttonCallback);
		GPIOINT_CallbackRegister(BTN4, buttonCallback);

		Bitless_GpioSetup();
}

void Buttons_Dispatch(void) 
{
	switch (lastPin) {
	case BTN0: (*buttonCallbacks[0])(); break;
	case BTN1: (*buttonCallbacks[1])(); break;
	case BTN2: (*buttonCallbacks[2])(); break;
	case BTN3: (*buttonCallbacks[3])(); break;
	case BTN4: (*buttonCallbacks[4])(); break;
	 
	}
	lastPin = -1;
}

static void Bitless_GpioSetup(void) {
    for (int i = 0; i < NUM_BUTTONS; i++) {
        /* Configure the five as input */
        GPIO_PinModeSet(BTNS[i].port, BTNS[i].pin, gpioModeInput, 0);
        /* Set falling edge interrupt for both ports */
        GPIO_IntConfig(BTNS[i].port, BTNS[i].pin, false, true, true);
    }
}
