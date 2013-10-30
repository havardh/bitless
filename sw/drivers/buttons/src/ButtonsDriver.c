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

void DK3750_GpioSetup(void)
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

void Bitless_GpioSetup(void) {
    /* Configure the five pushbuttons */
    GPIO_PinModeSet(gpioPortB, B4, gpioModeInput, 0); /* Button B4 , GPIO5*/
    GPIO_PinModeSet(gpioPortC, B5, gpioModeInput, 0); /* Button B5 , GPIO6*/
    GPIO_PinModeSet(gpioPortD, B6, gpioModeInput, 0); /* Button B6 , GPIO7*/
    GPIO_PinModeSet(gpioPortD, B7, gpioModeInput, 0); /* Button B7 , GPIO8*/
    GPIO_PinModeSet(gpioPortD, B8, gpioModeInput, 0); /* Button B8 , GPIO9*/

    GPIO_IntConfig(gpioPortB, B4, false, true, true);
    GPIO_IntConfig(gpioPortC, B5, false, true, true);
    GPIO_IntConfig(gpioPortD, B6, false, true, true);
    GPIO_IntConfig(gpioPortD, B7, false, true, true);
    GPIO_IntConfig(gpioPortD, B8, false, true, true);
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
    } else if (config->board == BITLESS) {
        Bitless_GpioSetup();
    }
}
