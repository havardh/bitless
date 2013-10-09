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
#include "ButtonsController.h"
#include "ButtonsConfig.h"

uint16_t led = 1;

void toggleLED(uint8_t pin) {
    BSP_LedToggle(led);
}

void switchLed(uint8_t pin) {
    led = !led;
}

void setupCallbacks(void) {
    uint8_t btns[2] = {9, 10};
    GPIOINT_IrqCallbackPtr_t ptrs[2] = {toggleLED, switchLed};
    RegisterCallbacks(btns, ptrs, 2);
}

int main(void) {
    /* Chip errata */
    CHIP_Init();

    /* If first word of user data page is non-zero, enable eA Profiler trace */
    BSP_TraceProfilerSetup();

    /* Initialize gpio with buttonscontroller */
    ButtonsConfig config;
    config.numButtons = 2;
    config.board = GG_STK3700;
    config.pins = (uint8_t*) malloc(sizeof(uint8_t) * 2);
    config.pins[0] = 9;
    config.pins[0] = 10;

    // config.board = GG_DK3750;
    
    ButtonsController_Init(&config);

    setupCallbacks();

    /* Initialize LED driver */
    BSP_LedsInit();

    /* Infinite loop */
    while (1) {
        EMU_EnterEM3(true);
    }
}
