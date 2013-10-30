#include <stdint.h>
#include <stdbool.h>
#include "em_cmu.h"
#include "em_chip.h"
#include "em_device.h"
#include "em_emu.h"
#include "em_gpio.h"
#include "em_letimer.h"
#include "em_pcnt.h"
#include "bsp.h"
#include "bsp_trace.h"

void PCNT0_IRQHandler(void) {
    /* Clear PCNT1 overflow interrupt flag */
    PCNT_IntClear(PCNT0, PCNT_IntGet(PCNT0));
    /*reset counter top to 10 */
    PCNT_CounterTopSet(PCNT0, 0, 10);
    BSP_LedToggle(0);
}

int main(void) {
    /* Chip errata */
    CHIP_Init();

    /* Select ULFRCO as clock source for LFA so the PCNT can work in EM3 */
    CMU_ClockSelectSet(cmuClock_LFA, cmuSelect_ULFRCO);

    /* Enabling all necessary clocks */
    CMU_ClockEnable(cmuClock_CORELE, true);
    /* Enable CORELE clock */
    CMU_ClockEnable(cmuClock_GPIO, true);
    /* Enable clock for GPIO module */
    CMU_ClockEnable(cmuClock_PCNT0, true);
    /* Enable clock for PCNT module */
    CMU_ClockEnable(cmuClock_PRS, true);

    /* Initialize LED driver */
    BSP_LedsInit();

    /* Configure PB9 as input */
    GPIO_PinModeSet(gpioPortB, 9, gpioModeInput, 0);

    /*make port b signal 9 to be prs GPIO signal 9 and 10*/
    GPIO->EXTIPSELH = GPIO_EXTIPSELH_EXTIPSEL9_PORTB;

    PRS->CH[2].CTRL = PRS_CH_CTRL_ASYNC | PRS_CH_CTRL_SOURCESEL_GPIOH | PRS_CH_CTRL_SIGSEL_GPIOPIN9;
    PRS->ROUTE = PRS_ROUTE_CH2PEN | PRS_ROUTE_LOCATION_LOC0;
    GPIO_PinModeSet(gpioPortC, 0, gpioModePushPull, 1); /* PRS CH2 */


    /* Set configuration for pulse counter */
    static const PCNT_Init_TypeDef initPCNT = {
        .mode = pcntModeOvsSingle, /* Oversampling, single mode. */
        .counter = 0U, /* Counter value has been initialized to 0. */
        .top = 10, /* Counter top value. */
        .negEdge = false, /* Use positive edge. */
        .countDown = false, /* Up-counting. */
        .filter = false, /* Filter disabled. */
        .hyst = false, /* Hysteresis disabled. */
        .s1CntDir = false, /* Counter direction is given by CNTDIR. */
        .cntEvent = pcntCntEventUp, /* Regular counter counts up on upcount events. */
        .auxCntEvent = pcntCntEventNone, /* Auxiliary counter doesn't respond to events. */
        .s0PRS = pcntPRSCh2, /* PRS channel 2 selected as S0IN. */
        .s1PRS = pcntPRSCh2 /* PRS channel 2 selected as S1IN. */
    };

    /* Initialize Pulse Counter */
    PCNT_Init(PCNT0, &initPCNT);
    PCNT_PRSInputEnable(PCNT0, pcntPRSInputS0, true);
    /* Enable the PCNT peripheral. */
    PCNT_Enable(PCNT0, pcntModeOvsSingle);

    /* Enable PCNT overflow interrupt */
    PCNT_IntEnable(PCNT0, PCNT_IEN_OF);
    /* Enable PCNT1 interrupt vector in NVIC */
    NVIC_EnableIRQ(PCNT0_IRQn);
    /* Infinite blink loop */
    while (1) {
        EMU_EnterEM3(false);
    }
}
