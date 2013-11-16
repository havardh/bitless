#include "bl_ebi.h"

void EBIDriver_Init(void) {
    EBI_Init_TypeDef ebiConfig = EBI_INIT_DEFAULT;

    /* Enable clocks */
    CMU_ClockEnable(cmuClock_EBI, true);
    CMU_ClockEnable(cmuClock_GPIO, true);

    /* Configure GPIO pins as push pull */
    /* Address / Data */
    GPIO_PinModeSet(gpioPortE,  8, gpioModePushPull, 0); /* EBI AD00  */
    GPIO_PinModeSet(gpioPortE,  9, gpioModePushPull, 0); /* EBI AD01  */
    GPIO_PinModeSet(gpioPortE, 10, gpioModePushPull, 0); /* EBI AD02  */
    GPIO_PinModeSet(gpioPortE, 11, gpioModePushPull, 0); /* EBI AD03  */
    GPIO_PinModeSet(gpioPortE, 12, gpioModePushPull, 0); /* EBI AD04  */
    GPIO_PinModeSet(gpioPortE, 13, gpioModePushPull, 0); /* EBI AD05  */
    GPIO_PinModeSet(gpioPortE, 14, gpioModePushPull, 0); /* EBI AD06  */
    GPIO_PinModeSet(gpioPortE, 15, gpioModePushPull, 0); /* EBI AD07  */

    GPIO_PinModeSet(gpioPortA, 15, gpioModePushPull, 0); /* EBI AD08  */
    GPIO_PinModeSet(gpioPortA,  0, gpioModePushPull, 0); /* EBI AD09  */
    GPIO_PinModeSet(gpioPortA,  1, gpioModePushPull, 0); /* EBI AD10  */
    GPIO_PinModeSet(gpioPortA,  2, gpioModePushPull, 0); /* EBI AD11  */
    GPIO_PinModeSet(gpioPortA,  3, gpioModePushPull, 0); /* EBI AD12  */
    GPIO_PinModeSet(gpioPortA,  4, gpioModePushPull, 0); /* EBI AD13  */
    GPIO_PinModeSet(gpioPortA,  5, gpioModePushPull, 0); /* EBI AD14  */
    GPIO_PinModeSet(gpioPortA,  6, gpioModePushPull, 0); /* EBI AD15  */

    /* Address */
    GPIO_PinModeSet(gpioPortA, 12, gpioModePushPull, 0); /* EBI A00  */
    GPIO_PinModeSet(gpioPortA, 13, gpioModePushPull, 0); /* EBI A01  */
    GPIO_PinModeSet(gpioPortA, 14, gpioModePushPull, 0); /* EBI A02  */
    GPIO_PinModeSet(gpioPortB,  9, gpioModePushPull, 0); /* EBI A03  */
    GPIO_PinModeSet(gpioPortB, 10, gpioModePushPull, 0); /* EBI A04  */
    GPIO_PinModeSet(gpioPortC,  6, gpioModePushPull, 0); /* EBI A05  */
    GPIO_PinModeSet(gpioPortC,  7, gpioModePushPull, 0); /* EBI A06  */
    GPIO_PinModeSet(gpioPortE,  0, gpioModePushPull, 0); /* EBI A07  */

    GPIO_PinModeSet(gpioPortE,  1, gpioModePushPull, 0); /* EBI A08  */
    GPIO_PinModeSet(gpioPortC,  9, gpioModePushPull, 0); /* EBI A09  */
    GPIO_PinModeSet(gpioPortC, 10, gpioModePushPull, 0); /* EBI A10  */
    GPIO_PinModeSet(gpioPortE,  4, gpioModePushPull, 0); /* EBI A11  */
    GPIO_PinModeSet(gpioPortE,  5, gpioModePushPull, 0); /* EBI A12  */
    GPIO_PinModeSet(gpioPortE,  6, gpioModePushPull, 0); /* EBI A13  */
    GPIO_PinModeSet(gpioPortE,  7, gpioModePushPull, 0); /* EBI A14  */
    GPIO_PinModeSet(gpioPortC,  8, gpioModePushPull, 0); /* EBI A15  */

    GPIO_PinModeSet(gpioPortB,  0, gpioModePushPull, 0); /* EBI A16  */
    GPIO_PinModeSet(gpioPortB,  1, gpioModePushPull, 0); /* EBI A17  */
    GPIO_PinModeSet(gpioPortB,  2, gpioModePushPull, 0); /* EBI A18  */
    GPIO_PinModeSet(gpioPortB,  3, gpioModePushPull, 0); /* EBI A19  */
    GPIO_PinModeSet(gpioPortB,  4, gpioModePushPull, 0); /* EBI A20  */
    GPIO_PinModeSet(gpioPortB,  5, gpioModePushPull, 0); /* EBI A21  */
    GPIO_PinModeSet(gpioPortB,  6, gpioModePushPull, 0); /* EBI A22  */
    GPIO_PinModeSet(gpioPortC,  0, gpioModePushPull, 0); /* EBI A23  */
    GPIO_PinModeSet(gpioPortC,  1, gpioModePushPull, 0); /* EBI A24  */

    /* Chip Select */
    GPIO_PinModeSet(gpioPortD,  9, gpioModePushPull, 1); /* EBI CS0  */
    GPIO_PinModeSet(gpioPortD, 10, gpioModePushPull, 1); /* EBI CS1  */

    /* Read / Write */
    GPIO_PinModeSet(gpioPortF,  8, gpioModePushPull, 1); /* EBI Wen, active low  */
    GPIO_PinModeSet(gpioPortF,  9, gpioModePushPull, 1); /* EBI Ren, active low  */

    /* ---------------------------------------------------- */
    /* External 4MB SRAM, Bank 1, Base Address 0x84000000   */
    /* CY7C1061AV33                                         */
    /* ---------------------------------------------------- */
    ebiConfig.mode         = ebiModeD16;
    ebiConfig.banks        = EBI_BANK1;
    ebiConfig.csLines      = EBI_CS1;

    ebiConfig.csPolarity   = ebiActiveHigh;

    // ebiConfig.noIdle       = true;  /* Flag to enable or disable idle state insertion between transfers */
    // ebiConfig.readPrefetch = true;
    ebiConfig.aLow         = ebiALowA0;
    ebiConfig.aHigh        = ebiAHighA19;
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

    /* Configure EBI bank 1 - external SRAM */
    EBI_Init(&ebiConfig);

    /* --------------------------------------------------------- */
    /* Board FPGA registers, Bank 0, Base Address 0x84000000     */
    /* --------------------------------------------------------- */
    ebiConfig.mode         = ebiModeD16;
    ebiConfig.banks        = EBI_BANK0;
    ebiConfig.csLines      = EBI_CS0;

    ebiConfig.csPolarity   = ebiActiveLow;

    ebiConfig.aLow         = ebiALowA0;
    ebiConfig.aHigh        = ebiAHighA22;
    ebiConfig.location     = ebiLocation1;

    /* Address Setup and hold time */
    ebiConfig.addrHoldCycles  = 3;
    ebiConfig.addrSetupCycles = 3;

    /* Read cycle times */
    ebiConfig.readStrobeCycles = 7;
    ebiConfig.readHoldCycles   = 3;
    ebiConfig.readSetupCycles  = 3;

    /* Write cycle times */
    ebiConfig.writeStrobeCycles = 7;
    ebiConfig.writeHoldCycles   = 3;
    ebiConfig.writeSetupCycles  = 3;

    /* Configure EBI bank 0, FPGA */
    EBI_Init(&ebiConfig);
}

void EBIDriver_Disable(void) {
    /* Configure GPIO pins as disabled */
    /* Address / Data */
    GPIO_PinModeSet(gpioPortE,  8, gpioModeDisabled, 0); /* EBI AD00  */
    GPIO_PinModeSet(gpioPortE,  9, gpioModeDisabled, 0); /* EBI AD01  */
    GPIO_PinModeSet(gpioPortE, 10, gpioModeDisabled, 0); /* EBI AD02  */
    GPIO_PinModeSet(gpioPortE, 11, gpioModeDisabled, 0); /* EBI AD03  */
    GPIO_PinModeSet(gpioPortE, 12, gpioModeDisabled, 0); /* EBI AD04  */
    GPIO_PinModeSet(gpioPortE, 13, gpioModeDisabled, 0); /* EBI AD05  */
    GPIO_PinModeSet(gpioPortE, 14, gpioModeDisabled, 0); /* EBI AD06  */
    GPIO_PinModeSet(gpioPortE, 15, gpioModeDisabled, 0); /* EBI AD07  */

    GPIO_PinModeSet(gpioPortA, 15, gpioModeDisabled, 0); /* EBI AD08  */
    GPIO_PinModeSet(gpioPortA,  0, gpioModeDisabled, 0); /* EBI AD09  */
    GPIO_PinModeSet(gpioPortA,  1, gpioModeDisabled, 0); /* EBI AD10  */
    GPIO_PinModeSet(gpioPortA,  2, gpioModeDisabled, 0); /* EBI AD11  */
    GPIO_PinModeSet(gpioPortA,  3, gpioModeDisabled, 0); /* EBI AD12  */
    GPIO_PinModeSet(gpioPortA,  4, gpioModeDisabled, 0); /* EBI AD13  */
    GPIO_PinModeSet(gpioPortA,  5, gpioModeDisabled, 0); /* EBI AD14  */
    GPIO_PinModeSet(gpioPortA,  6, gpioModeDisabled, 0); /* EBI AD15  */

    /* Address */
    GPIO_PinModeSet(gpioPortA, 12, gpioModeDisabled, 0); /* EBI A00  */
    GPIO_PinModeSet(gpioPortA, 13, gpioModeDisabled, 0); /* EBI A01  */
    GPIO_PinModeSet(gpioPortA, 14, gpioModeDisabled, 0); /* EBI A02  */
    GPIO_PinModeSet(gpioPortB,  9, gpioModeDisabled, 0); /* EBI A03  */
    GPIO_PinModeSet(gpioPortB, 10, gpioModeDisabled, 0); /* EBI A04  */
    GPIO_PinModeSet(gpioPortC,  6, gpioModeDisabled, 0); /* EBI A05  */
    GPIO_PinModeSet(gpioPortC,  7, gpioModeDisabled, 0); /* EBI A06  */
    GPIO_PinModeSet(gpioPortE,  0, gpioModeDisabled, 0); /* EBI A07  */

    GPIO_PinModeSet(gpioPortE,  1, gpioModeDisabled, 0); /* EBI A08  */
    GPIO_PinModeSet(gpioPortC,  9, gpioModeDisabled, 0); /* EBI A09  */
    GPIO_PinModeSet(gpioPortC, 10, gpioModeDisabled, 0); /* EBI A10  */
    GPIO_PinModeSet(gpioPortE,  4, gpioModeDisabled, 0); /* EBI A11  */
    GPIO_PinModeSet(gpioPortE,  5, gpioModeDisabled, 0); /* EBI A12  */
    GPIO_PinModeSet(gpioPortE,  6, gpioModeDisabled, 0); /* EBI A13  */
    GPIO_PinModeSet(gpioPortE,  7, gpioModeDisabled, 0); /* EBI A14  */
    GPIO_PinModeSet(gpioPortC,  8, gpioModeDisabled, 0); /* EBI A15  */

    GPIO_PinModeSet(gpioPortB,  0, gpioModeDisabled, 0); /* EBI A16  */
    GPIO_PinModeSet(gpioPortB,  1, gpioModeDisabled, 0); /* EBI A17  */
    GPIO_PinModeSet(gpioPortB,  2, gpioModeDisabled, 0); /* EBI A18  */
    GPIO_PinModeSet(gpioPortB,  3, gpioModeDisabled, 0); /* EBI A19  */
    GPIO_PinModeSet(gpioPortB,  4, gpioModeDisabled, 0); /* EBI A20  */
    GPIO_PinModeSet(gpioPortB,  5, gpioModeDisabled, 0); /* EBI A21  */
    GPIO_PinModeSet(gpioPortB,  6, gpioModeDisabled, 0); /* EBI A22  */
    GPIO_PinModeSet(gpioPortC,  0, gpioModeDisabled, 0); /* EBI A23  */
    GPIO_PinModeSet(gpioPortC,  1, gpioModeDisabled, 0); /* EBI A24  */

    /* Chip Select */
    GPIO_PinModeSet(gpioPortD,  9, gpioModeDisabled, 1); /* EBI CS0  */
    GPIO_PinModeSet(gpioPortD, 10, gpioModeDisabled, 1); /* EBI CS1  */

    /* Read / Write */
    GPIO_PinModeSet(gpioPortF,  8, gpioModeDisabled, 1); /* EBI Wen  */
    GPIO_PinModeSet(gpioPortF,  9, gpioModeDisabled, 1); /* EBI Ren  */

    /* Reset EBI configuration */
    EBI_Disable();

    /* Turn off EBI clock */
    CMU_ClockEnable(cmuClock_EBI, false);
}
