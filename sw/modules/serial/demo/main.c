#include "serial.h"
#include "bsp.h"

/* Declare some strings */
const char     welcomeString[]  = "Energy Micro RS-232 - Please press a key\n";
const char     overflowString[] = "\n---RX OVERFLOW---\n";
const uint32_t welLen           = sizeof(welcomeString) - 1;
const uint32_t ofsLen           = sizeof(overflowString) - 1;

int main(void) {
    CHIP_Init();

    /* Initialize clocks and oscillators */
    cmuSetup();


    circularBuffer rxBuf, txBuf = { {0}, 0, 0, 0, false };

    /* Initialize UART peripheral */
    uartSetup(&rxBuf, &txBuf);

    /* Initialize Development Kit in EBI mode */
    // BSP_Init(BSP_INIT_DEFAULT);

    /* Enable RS-232 transceiver on Development Kit */
    // BSP_PeripheralAccess(BSP_RS232_UART, true);

    /* When DVK is configured, and no more DVK access is needed, the interface can safely be disabled to save current */
    // BSP_Disable();


    /* Write welcome message to UART */
    uartPutData((uint8_t*) welcomeString, welLen);

    /*  Eternal while loop
    *  CPU will sleep during Rx and Tx. When a byte is transmitted, an interrupt
    *  wakes the CPU which copies the next byte in the txBuf queue to the
    *  UART TXDATA register.
    *
    *  When the predefined termiation character is received, the all pending
    *  data in rxBuf is copied to txBuf and echoed back on the UART */
    while (1) {
        /* Wait in EM1 while UART transmits */
        EMU_EnterEM1();

        /* Check if RX buffer has overflowed */
        if (rxBuf.overflow) {
            rxBuf.overflow = false;
            uartPutData((uint8_t*) overflowString, ofsLen);
        }

        /* Check if termination character is received */
        if (rxBuf.data[(rxBuf.wrI - 1) % BUFFERSIZE] == TERMINATION_CHAR) {
            /* Copy received data to UART transmit queue */
            uint8_t tmpBuf[BUFFERSIZE];
            int     len = uartGetData(tmpBuf, 0);
            uartPutData(tmpBuf, len);
        }
    }
}
