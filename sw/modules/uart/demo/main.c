#include "bl_uart.h"

/* Declare some strings */
const char     welcomeString[]  = "Energy Micro RS-232 - Please press a key\n";
const char     overflowString[] = "\n---RX OVERFLOW---\n";
const char     resetCursor0[]    = "\033[1;1H";
const char     resetCursor1[]    = "\033[2;1H";
const char     resetCursor2[]    = "\033[3;1H";
const uint32_t welLen           = sizeof(welcomeString) - 1;
const uint32_t ofsLen           = sizeof(overflowString) - 1;
const uint32_t resetLen         = sizeof(resetCursor0) - 1;

int main(void) {
    CHIP_Init();

    /* Initialize UART peripheral */
    UART_Init();

    /* Write welcome message to UART */
    UART_ClearScreen();
    UART_PutData((uint8_t*) resetCursor0, resetLen);
    UART_PutData((uint8_t*) welcomeString, welLen);
    UART_PutData((uint8_t*) resetCursor1, resetLen);
    UART_PutData((uint8_t*) welcomeString, welLen);
    UART_PutData((uint8_t*) resetCursor2, resetLen);
    UART_PutData((uint8_t*) welcomeString, welLen);
    
    while (1) ;
}
