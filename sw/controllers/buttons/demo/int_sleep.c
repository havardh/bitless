#include "efm32.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_gpio.h"

/* Defines for Push Button 0 */
#define PB_PORT    gpioPortB
#define PB0_PIN     9
#define PB1_PIN     10

/* Defines for the LED */
#define LED_PORT    gpioPortE
#define LED0_PIN    2
#define LED1_PIN    3


bool enableLed = 0;

/**************************************************************************//**
* @brief GPIO Handler
* Interrupt Service Routine 
*****************************************************************************/

void GPIO_IRQHandler(void) {
    /* Clear flag for Push Button 0  interrupt. The interrupt is called as
    * long as the interrupt flag is not cleared, so failing to do so here would
    * lock the program at the first interrupt.
    *
    * All the ports share a total of 16 interrupts - one per pin number - i.e.
    * pin 9 of port A and D share one interrupt, so to clear interrupts produced by
    * either one of them we have to clear bit 9 
    */

    uint32_t flags = GPIO_IntGet();

    GPIO_IntClear(flags);

    /* Toggle value */
    enableLed = !enableLed;

    if (enableLed) {
        /* Turn off LED */
        GPIO_PinOutSet(LED_PORT, LED0_PIN);
        GPIO_PinOutSet(LED_PORT, LED1_PIN);
    }
    else {
        /* Turn off LED )*/
        GPIO_PinOutClear(LED_PORT, LED0_PIN);
        GPIO_PinOutClear(LED_PORT, LED1_PIN);
    }
}

/**************************************************************************//**
* @brief GPIO_ODD Handler
* Interrupt Service Routine for odd GPIO pins
*****************************************************************************/
void GPIO_ODD_IRQHandler(void) {
    GPIO_IRQHandler();
}

void Init_GPIO(void) {
    /* Configure push button 1 as an input,
     * so that we can read its value. */
    GPIO_PinModeSet(PB_PORT, PB0_PIN, gpioModeInput, 1);
    GPIO_PinModeSet(PB_PORT, PB1_PIN, gpioModeInput, 1);

    /* Configure LED as a push pull, so that we can
     * set its value - 1 to turn on, 0 to turn off */
    GPIO_PinModeSet(LED_PORT, LED0_PIN, gpioModePushPull, 0);
    GPIO_PinModeSet(LED_PORT, LED1_PIN, gpioModePushPull, 0);
}

void enableGPIOInterrupts(void) {
    uint32_t enabledFlags = 0;

    GPIO_IntEnable(enabledFlags);

    NVIC_EnableIRQ(GPIO_ODD_IRQn);

    GPIO_IntConfig(PB_PORT, PB0_PIN, true, true, true);
    GPIO_IntConfig(PB_PORT, PB1_PIN, true, true, true);
}

int main(void) {
    /* Initialize chip */
    CHIP_Init();

    /* Enable clock for GPIO module, we need this because
     *  the button and the LED are connected to GPIO pins. */
    CMU_ClockEnable(cmuClock_GPIO, true);

    /* Init GPIO pins */
    Init_GPIO();

    enableGPIOInterrupts();

    /* Enable GPIO_ODD interrupt vector in NVIC. We want Push Button 1 to
     * send an interrupt when pressed. GPIO interrupts are handled by either
     * GPIO_ODD or GPIO_EVEN, depending on wheter the pin number is odd or even,
     * PB1 is therefore handled by GPIO_EVEN for Tiny Gecko (D8) and by GPIO_ODD for 
     * Giant Gecko (B9). */

    // NVIC_EnableIRQ(GPIO_ODD_IRQn);
    // NVIC_EnableIRQ(GPIO_EVEN_IRQn);

    /* Configure PD8 (Push Button 1) interrupt on falling edge, i.e. when it is
     * pressed, and rising edge, i.e. when it is released. */

    while (1) {
        /* Go to EM3 */
        EMU_EnterEM3(true);
    }
}
