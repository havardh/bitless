
#include "EBIDriver.h"

void EBIDriver_Init(void) {

    EBI_Init_TypeDef ebiConfig = EBI_INIT_DEFAULT;

    /* Enable clocks */
    CMU_ClockEnable(cmuClock_EBI, true);
    CMU_ClockEnable(cmuClock_GPIO, true);

    /* Configure GPIO pins as push pull */
    /* Data */
    GPIO_PinModeSet(gpioPortA, 0, gpioModePushPull, 0); /* EBI AD7  */
    GPIO_PinModeSet(gpioPortA, 1, gpioModePushPull, 0); /* EBI AD6  */
    GPIO_PinModeSet(gpioPortA, 2, gpioModePushPull, 0); /* EBI AD4  */
    GPIO_PinModeSet(gpioPortA, 3, gpioModePushPull, 0); /* EBI AD1  */

    GPIO_PinModeSet(gpioPortB, 0, gpioModePushPull, 0); /* EBI AD8  */
    GPIO_PinModeSet(gpioPortB, 1, gpioModePushPull, 0); /* EBI AD5  */
    GPIO_PinModeSet(gpioPortB, 2, gpioModePushPull, 0); /* EBI AD3  */
    GPIO_PinModeSet(gpioPortB, 3, gpioModePushPull, 0); /* EBI AD0  */

    GPIO_PinModeSet(gpioPortC, 0, gpioModePushPull, 0); /* EBI AD10 */
    GPIO_PinModeSet(gpioPortC, 1, gpioModePushPull, 0); /* EBI AD9  */
    GPIO_PinModeSet(gpioPortC, 2, gpioModePushPull, 0); /* EBI AD2  */

    GPIO_PinModeSet(gpioPortD, 0, gpioModePushPull, 0); /* EBI AD12 */
    GPIO_PinModeSet(gpioPortD, 1, gpioModePushPull, 0); /* EBI AD11 */

    GPIO_PinModeSet(gpioPortE, 0, gpioModePushPull, 0); /* EBI AD15 */
    GPIO_PinModeSet(gpioPortE, 1, gpioModePushPull, 0); /* EBI AD14 */
    GPIO_PinModeSet(gpioPortE, 2, gpioModePushPull, 0); /* EBI AD13 */

    /* Chip Select */
    GPIO_PinModeSet(gpioPortD, 7, gpioModePushPull, 1); /* EBI CS0  */
    GPIO_PinModeSet(gpioPortA, 6, gpioModePushPull, 1); /* EBI CS1  */

    GPIO_PinModeSet(gpioPortB, 7, gpioModePushPull, 1); /* EBI Wen  */
    GPIO_PinModeSet(gpioPortC, 7, gpioModePushPull, 1); /* EBI Ren  */

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
    ebiConfig.aLow         = ebiALowA16;
    ebiConfig.aHigh        = ebiAHighA23;
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

    /* --------------------------------------------------------- */
    /* Board FPGA registers, Bank 0, Base Address 0x80000000     */
    /* FPGA Xilinx Spartan XC6SLX16 CSG324                        */
    /* --------------------------------------------------------- */
    ebiConfig.banks       = EBI_BANK0;
    ebiConfig.csLines     = EBI_CS0;
    ebiConfig.mode        = ebiModeD16A16ALE;;
    ebiConfig.alePolarity = ebiActiveHigh;
    /* keep blEnable */
    ebiConfig.blEnable     = false;
    ebiConfig.addrHalfALE  = true;
    ebiConfig.readPrefetch = false;
    ebiConfig.noIdle       = true;

    /* keep alow/ahigh configuration */
    /* ebiConfig.aLow = ebiALowA0; - needs to be set for PSRAM */
    /* ebiConfig.aHigh = ebiAHighA0; - needs to be set for PSRAM */

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

    /* Configure EBI bank 0 */
    EBI_Init(&ebiConfig);
}

void EBIDriver_Disable(void) {
    /* Configure GPIO pins as disabled */
    /* Data */
    GPIO_PinModeSet(gpioPortA, 0, gpioModeDisabled, 0); /* EBI AD7  */
    GPIO_PinModeSet(gpioPortA, 1, gpioModeDisabled, 0); /* EBI AD6  */
    GPIO_PinModeSet(gpioPortA, 2, gpioModeDisabled, 0); /* EBI AD4  */
    GPIO_PinModeSet(gpioPortA, 3, gpioModeDisabled, 0); /* EBI AD1  */

    GPIO_PinModeSet(gpioPortB, 0, gpioModeDisabled, 0); /* EBI AD8  */
    GPIO_PinModeSet(gpioPortB, 1, gpioModeDisabled, 0); /* EBI AD5  */
    GPIO_PinModeSet(gpioPortB, 2, gpioModeDisabled, 0); /* EBI AD3  */
    GPIO_PinModeSet(gpioPortB, 3, gpioModeDisabled, 0); /* EBI AD0  */

    GPIO_PinModeSet(gpioPortC, 0, gpioModeDisabled, 0); /* EBI AD10 */
    GPIO_PinModeSet(gpioPortC, 1, gpioModeDisabled, 0); /* EBI AD9  */
    GPIO_PinModeSet(gpioPortC, 2, gpioModeDisabled, 0); /* EBI AD2  */

    GPIO_PinModeSet(gpioPortD, 0, gpioModeDisabled, 0); /* EBI AD12 */
    GPIO_PinModeSet(gpioPortD, 1, gpioModeDisabled, 0); /* EBI AD11 */

    GPIO_PinModeSet(gpioPortE, 0, gpioModeDisabled, 0); /* EBI AD15 */
    GPIO_PinModeSet(gpioPortE, 1, gpioModeDisabled, 0); /* EBI AD14 */
    GPIO_PinModeSet(gpioPortE, 2, gpioModeDisabled, 0); /* EBI AD13 */

    /* Chip Select */
    GPIO_PinModeSet(gpioPortD, 7, gpioModeDisabled, 0); /* EBI CS0  */
    GPIO_PinModeSet(gpioPortA, 6, gpioModeDisabled, 0); /* EBI CS1  */

    GPIO_PinModeSet(gpioPortB, 7, gpioModeDisabled, 0); /* EBI Wen  */
    GPIO_PinModeSet(gpioPortC, 7, gpioModeDisabled, 0); /* EBI Ren  */

    /* Reset EBI configuration */
    EBI_Disable();

    /* Turn off EBI clock */
    CMU_ClockEnable(cmuClock_EBI, false);
}
