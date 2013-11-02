#include "em_cmu.h"
#include "em_ebi.h"
#include "em_gpio.h"
#include "EBI_test.h"

void EBITest_Init(void) {

    EBI_Init_TypeDef ebiConfig = EBI_INIT_DEFAULT;

    /* Enable clocks */
    CMU_ClockEnable(cmuClock_EBI, true);
    CMU_ClockEnable(cmuClock_GPIO, true);

    /* Configure GPIO pins as push pull */
    /* Address */
    GPIO_PinModeSet(gpioPortA, 12, gpioModePushPull, 0); /* EBI  A0  */
    GPIO_PinModeSet(gpioPortA, 13, gpioModePushPull, 0); /* EBI  A1  */
    GPIO_PinModeSet(gpioPortA, 14, gpioModePushPull, 0); /* EBI  A2  */

    GPIO_PinModeSet(gpioPortB,  9, gpioModePushPull, 0); /* EBI  A3  */
    GPIO_PinModeSet(gpioPortB, 10, gpioModePushPull, 0); /* EBI  A4  */
    GPIO_PinModeSet(gpioPortB,  0, gpioModePushPull, 0); /* EBI A16  */
    GPIO_PinModeSet(gpioPortB,  1, gpioModePushPull, 0); /* EBI A17  */
    GPIO_PinModeSet(gpioPortB,  2, gpioModePushPull, 0); /* EBI A18  */
    GPIO_PinModeSet(gpioPortB,  3, gpioModePushPull, 0); /* EBI A19  */
    GPIO_PinModeSet(gpioPortB,  4, gpioModePushPull, 0); /* EBI A20  */
    // GPIO_PinModeSet(gpioPortB,  5, gpioModePushPull, 0); /* EBI A21  */
    // GPIO_PinModeSet(gpioPortB,  6, gpioModePushPull, 0); /* EBI A22  */

    GPIO_PinModeSet(gpioPortC,  6, gpioModePushPull, 0); /* EBI  A5  */
    GPIO_PinModeSet(gpioPortC,  7, gpioModePushPull, 0); /* EBI  A6  */
    GPIO_PinModeSet(gpioPortC,  8, gpioModePushPull, 0); /* EBI A15  */
    GPIO_PinModeSet(gpioPortC,  9, gpioModePushPull, 0); /* EBI  A9  */
    GPIO_PinModeSet(gpioPortC, 10, gpioModePushPull, 0); /* EBI A10  */

    GPIO_PinModeSet(gpioPortE,  0, gpioModePushPull, 0); /* EBI  A7  */
    GPIO_PinModeSet(gpioPortE,  1, gpioModePushPull, 0); /* EBI  A8  */
    GPIO_PinModeSet(gpioPortE,  4, gpioModePushPull, 0); /* EBI A11  */
    GPIO_PinModeSet(gpioPortE,  5, gpioModePushPull, 0); /* EBI A12  */
    GPIO_PinModeSet(gpioPortE,  6, gpioModePushPull, 0); /* EBI A13  */
    GPIO_PinModeSet(gpioPortE,  7, gpioModePushPull, 0); /* EBI A14  */

    /* EBI Data */
    GPIO_PinModeSet(gpioPortE,  8, gpioModePushPull, 0); /* EBI  AD0 */
    GPIO_PinModeSet(gpioPortE,  9, gpioModePushPull, 0); /* EBI  AD1 */
    GPIO_PinModeSet(gpioPortE, 10, gpioModePushPull, 0); /* EBI  AD2 */
    GPIO_PinModeSet(gpioPortE, 11, gpioModePushPull, 0); /* EBI  AD3 */
    GPIO_PinModeSet(gpioPortE, 12, gpioModePushPull, 0); /* EBI  AD4 */
    GPIO_PinModeSet(gpioPortE, 13, gpioModePushPull, 0); /* EBI  AD5 */    
    GPIO_PinModeSet(gpioPortE, 14, gpioModePushPull, 0); /* EBI  AD6 */
    GPIO_PinModeSet(gpioPortE, 15, gpioModePushPull, 0); /* EBI  AD7 */

    /* Chip Select */
    GPIO_PinModeSet(gpioPortF,  8, gpioModePushPull, 1); /* EBI Wen  */
    GPIO_PinModeSet(gpioPortF,  9, gpioModePushPull, 1); /* EBI Ren  */

    /* ---------------------------------------------------- */
    /* External 4MB PSRAM, Bank 2, Base Address 0x88000000  */
    /* Micron MT45W2MW16PGA-70 IT, 32Mb Cellular RAM        */
    /* ---------------------------------------------------- */
    ebiConfig.banks        = EBI_BANK2;
    ebiConfig.csLines      = EBI_CS2;
    ebiConfig.mode         = ebiModeD16A16ALE;
    ebiConfig.alePolarity  = ebiActiveHigh;
    ebiConfig.blEnable     = true;
    ebiConfig.noIdle       = true;
    ebiConfig.ardyEnable   = false;
    ebiConfig.addrHalfALE  = true;
    ebiConfig.readPrefetch = true;
    ebiConfig.aLow         = ebiALowA0;
    ebiConfig.aHigh        = ebiAHighA20;
    ebiConfig.location     = ebiLocation1;

    /* Address Setup and hold time */
    ebiConfig.addrHoldCycles  = 0;
    ebiConfig.addrSetupCycles = 0;

    /* Read cycle times */
    ebiConfig.readStrobeCycles = 4;
    ebiConfig.readHoldCycles   = 0;
    ebiConfig.readSetupCycles  = 0;

    /* Write cycle times */
    ebiConfig.writeStrobeCycles = 2;
    ebiConfig.writeHoldCycles   = 0;
    ebiConfig.writeSetupCycles  = 0;

    /* Configure EBI bank 2 - external PSRAM */
    EBI_Init(&ebiConfig);
}
