#include "bl_leds.h"

static LED_t LEDS[NUM_LEDS] = LEDS_ARRAY_INIT;

uint32_t Leds_GetLeds(void) {
    uint32_t ledsVal = 0;
    for (uint32_t i = 0, mask = 0x1; i < NUM_LEDS; i++, mask <<= 1) {
        if (GPIO_PinOutGet(LEDS[i].port, LEDS[i].pin))
            ledsVal |= mask;
    }

    return ledsVal;
}

void Leds_SetLed(uint32_t led) {
    if (led < NUM_LEDS) {
        GPIO_PinOutSet(LEDS[led].port, LEDS[led].pin);
    }
}

void Leds_ClearLed(uint32_t led) {
    if (led < NUM_LEDS) {
        GPIO_PinOutClear(LEDS[led].port, LEDS[led].pin);
    }   
}

void Leds_SetLeds(uint32_t leds) {
    for (uint32_t i = 0, mask = 0x1; i < NUM_LEDS; i++, mask <<= 1 ) {
        if (leds & mask) {
            GPIO_PinOutSet(LEDS[i].port, LEDS[i].pin);
        } else {
            GPIO_PinOutClear(LEDS[i].port, LEDS[i].pin);
        }
    }
}

void Leds_Init(void) {
    /* Enable clocks */
    CMU_ClockEnable(cmuClock_HFPER, true); /* High frequency peripheral clock */
    CMU_ClockEnable(cmuClock_GPIO, true);  /* General purpose input/output clock. */

    /* Setup GPIO Pins for leds */
    for (int i = 0; i < NUM_LEDS; i++) {
        GPIO_PinModeSet(LEDS[i].port, LEDS[i].pin, gpioModePushPull, 0);
    }
}
