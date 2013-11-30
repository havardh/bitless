/******************************************************************************
 * @section License
 * <b>(C) Copyright 2012 Energy Micro AS, http://www.energymicro.com</b>
 *******************************************************************************
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 * 4. The source and compiled code may only be used on Energy Micro "EFM32"
 *    microcontrollers and "EFR4" radios.
 *
 * DISCLAIMER OF WARRANTY/LIMITATION OF REMEDIES: Energy Micro AS has no
 * obligation to support this Software. Energy Micro AS is providing the
 * Software "AS IS", with no express or implied warranties of any kind,
 * including, but not limited to, any implied warranties of merchantability
 * or fitness for any particular purpose or warranties against infringement
 * of any proprietary rights of a third party.
 *
 * Energy Micro AS will not be liable for any consequential, incidental, or
 * special damages, or any other relief, or for any claim by any third party,
 * arising from your use of this Software.
 *
 *****************************************************************************/
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

int main(void) {
    /* Chip errata */
    CHIP_Init();

    /* Select LFRCO as clock source for LFA */
    CMU_ClockSelectSet(cmuClock_LFA, cmuSelect_ULFRCO);

    /* Enabling all necessary clocks */
    CMU_ClockEnable(cmuClock_CORELE, true); /* Enable CORELE clock */
    CMU_ClockEnable(cmuClock_GPIO, true); /* Enable clock for GPIO module */
    CMU_ClockEnable(cmuClock_LETIMER0, true);

    /* Set configurations for LETIMER 0 */
    const LETIMER_Init_TypeDef letimerInit = {
        .enable = true, /* Start counting when init completed*/
        .debugRun = false, /* Counter shall not keep running during debug halt. */
        .rtcComp0Enable = false, /* Start counting on RTC COMP0 match. */
        .rtcComp1Enable = false, /* Don't start counting on RTC COMP1 match. */
        .comp0Top = true, /* Load COMP0 register into CNT when counter underflows. COMP is used as TOP */
        .bufTop = false, /* Don't load COMP1 into COMP0 when REP0 reaches 0. */
        .out0Pol = 0, /* Idle value for output 0. */
        .out1Pol = 0, /* Idle value for output 1. */
        .ufoa0 = letimerUFOAPwm, /* PwM output on output 0 */
        .ufoa1 = letimerUFOANone, /* No output on output 1*/
        .repMode = letimerRepeatFree /* Count while REP != 0 */
    };
    /* enable GPIO C pin 4 as output */
    GPIO_PinModeSet(gpioPortE, 3, gpioModePushPull, 0);
    LETIMER0->ROUTE = LETIMER_ROUTE_OUT0PEN | LETIMER_ROUTE_LOCATION_LOC3;
    /*Set repeat count to 1*/
    LETIMER_RepeatSet(LETIMER0, 0, 1);
    LETIMER_RepeatSet(LETIMER0, 0, 1);

    /*LETIMER clock is 1.000 Hz*/
    /*COMP0 contains that "period" and
    COMP1 contains the "active period */
    LETIMER_CompareSet(LETIMER0, 0, 1000);
    LETIMER_CompareSet(LETIMER0, 1, 100);

    /* Initialize LETIMER */
    LETIMER_Init(LETIMER0, &letimerInit);

    GPIO_PinOutSet(gpioPortE, 3);
    /* Infinite blink loop */
    while (1) {
       EMU_EnterEM3(false);
    }
}
