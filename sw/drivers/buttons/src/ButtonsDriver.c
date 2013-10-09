#include "ButtonsDriver.h"
#include "em_device.h"
#include "em_emu.h"
#include "em_dbg.h"
#include "em_gpio.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "gpiointerrupt.h"
#include "bsp.h"
#include "bsp_trace.h"
#include "bsp_dk_bcreg_3201.h"

void STK3700_GpioSetup(uint8_t *pins, uint32_t numPins)
{
    uint32_t i = 0;
    for (; i < numPins; i++) {
        /* Configure PB9 and PB10 as input */
        GPIO_PinModeSet(gpioPortB, pins[i], gpioModeInput, 0);
        /* Set falling edge interrupt for both ports */
        GPIO_IntConfig(gpioPortB, pins[i], false, true, true);
    }
}

void DK3750_GpioSetup()
{
    // /* Init BSP */
    // BSP_Init(BSP_INIT_DEFAULT);

    // /* Clear and init interrupts for PushButtons */
    // BSP_InterruptDisable(0xffff);
    // BSP_InterruptFlagsClear (0xffff);
    // BSP_InterruptEnable(BC_INTEN_PB);

    // /* Configure interrupt pin as input - PushButtons-pin: 0*/
    // GPIO_PinModeSet(gpioPortE, 0, gpioModeInputPull, 1);
    // /* Set falling edge interrupt for both ports */
    // GPIO_IntConfig(gpioPortE, 0, false, true, true);
}

void ButtonsDriver_Init(ButtonsConfig *config)
{
    /* Enable GPIO in CMU */
    CMU_ClockEnable(cmuClock_GPIO, true);

    /* Initialize ODD and EVEN GPIO interrupts dispatcher */
    GPIOINT_Init();

    if (config->board == GG_STK3700) {
        STK3700_GpioSetup(config->pins, config->numButtons);
    } else if (config->board == GG_DK3750) {
        DK3750_GpioSetup(); 
    }
}
