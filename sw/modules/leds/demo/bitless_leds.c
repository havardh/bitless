#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "leds.h"

volatile uint32_t msTicks;

void Delay(uint32_t dlyTicks);

void SysTick_Handler(void)
{
  msTicks++;
}

void Delay(uint32_t dlyTicks) {
    uint32_t curTicks;

    curTicks = msTicks;
    while ((msTicks - curTicks) < dlyTicks) ;
}

int main() {
    CHIP_Init();

    if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000)) while (1) ;

    LEDController_Init();

    bool clear = false;
    int i = 0;
    while (1) {
        if (clear)
            LEDController_SetLed(i++);
        else
            LEDController_ClearLed(i++);

        if (i == NUM_LEDS) {
            i = 0;
            clear = !clear;
        }
        Delay(500);
    }
}
