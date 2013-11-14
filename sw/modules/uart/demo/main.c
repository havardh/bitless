#include "bl_uart.h"

/* Declare some strings */
const char     welcomeString[]  = "Energy Micro RS-232 - Please press a key\n";
const char     overflowString[] = "\n---RX OVERFLOW---\n";
const uint32_t welLen           = sizeof(welcomeString) - 1;

int main(void) {
    CHIP_Init();

    /* Initialize UART peripheral */
    UART_Init();

    /* Write welcome message to UART */
    UART_ClearScreen();
    UART_SetCursor(1, 1);
    UART_PutData((uint8_t*) welcomeString, welLen);
    UART_SetCursor(2, 1);
    UART_PutData((uint8_t*) welcomeString, welLen);
    UART_SetCursor(5, 1);
    UART_PutData((uint8_t*) welcomeString, welLen);

    while (1) ;
}
