#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_gpio.h"
#include "bsp.h"
#include "bsp_trace.h"
#include "gpiointerrupt.h"
#include "Leds.h"
#include "ButtonsConfig.h"
#include "Buttons.h"

void toggSTKleLED(uint8_t pin) {
    if (pin == 9) {
        BSP_LedToggle(1);
    } else if (pin == 10) {
        BSP_LedToggle(0);
    }
}

void setupSTKCallbacks(void) {
    uint8_t btns[2] = {9, 10};
    GPIOINT_IrqCallbackPtr_t ptrs[2] = {toggSTKleLED, toggSTKleLED};
    Buttons_RegisterCallbacks(btns, ptrs, 2);
}

void toggleBitlessLED(uint8_t pin) {
    Leds_SetLeds(pin);
}

void setupBitlessCallbacks(void) {
    uint8_t btns[5] = {BTN0, BTN1, BTN2, BTN3, BTN4};
    GPIOINT_IrqCallbackPtr_t ptrs[5] = {toggleBitlessLED, toggleBitlessLED, toggleBitlessLED, toggleBitlessLED, toggleBitlessLED};
    Buttons_RegisterCallbacks(btns, ptrs, 5);
}

int main(void) {
    /* Chip errata */
    CHIP_Init();

    Board_t type = GG_STK3700;

    /* Initialize gpio with buttons */
    Buttons_Init(type);

    /* Configure leds */
    if (type == GG_STK3700) {
        setupSTKCallbacks();
        BSP_LedsInit();
    } else {
        setupBitlessCallbacks();
    }

    /* Infinite loop */
    while (1) {
        EMU_EnterEM3(true);
    }
}
