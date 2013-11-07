#include "bl_uart.h"

/* Setup UART0 in async mode for RS232*/
static USART_TypeDef           * uart   = UART0;
static USART_InitAsync_TypeDef uartInit = USART_INITASYNC_DEFAULT;

circularBuffer *rxBuf, *txBuf;

/******************************************************************************
* @brief  uartSetup function
*
******************************************************************************/
void UART_Init(circularBuffer *rx, circularBuffer *tx) {
    /* Enable clock for HF peripherals */
    CMU_ClockEnable(cmuClock_HFPER, true);
    /* Enable clock for USART module */
    CMU_ClockEnable(cmuClock_UART0, true);
    /* Enable clock for GPIO module (required for pin configuration) */
    CMU_ClockEnable(cmuClock_GPIO, true);
    /* Configure GPIO pins, uart location 0 */
    GPIO_PinModeSet(gpioPortF, 6, gpioModePushPull, 1); // TX
    GPIO_PinModeSet(gpioPortF, 7, gpioModeInput, 0);    // RX

    rxBuf = rx;
    txBuf = tx;

    /* Prepare struct for initializing UART in asynchronous mode*/
    uartInit.enable       = usartDisable;   /* Don't enable UART upon intialization */
    uartInit.refFreq      = 0;              /* Provide information on reference frequency. When set to 0, the reference frequency is */
    uartInit.baudrate     = 115200;         /* Baud rate */
    uartInit.oversampling = usartOVS16;     /* Oversampling. Range is 4x, 6x, 8x or 16x */
    uartInit.databits     = usartDatabits8; /* Number of data bits. Range is 4 to 10 */
    uartInit.parity       = usartNoParity;  /* Parity mode */
    uartInit.stopbits     = usartStopbits1; /* Number of stop bits. Range is 0 to 2 */
    uartInit.mvdis        = false;          /* Disable majority voting */
    uartInit.prsRxEnable  = false;          /* Enable USART Rx via Peripheral Reflex System */
    uartInit.prsRxCh      = usartPrsRxCh0;  /* Select PRS channel if enabled */

    /* Initialize USART with uartInit struct */
    USART_InitAsync(uart, &uartInit);

    /* Prepare UART Rx and Tx interrupts */
    USART_IntClear(uart, _UART_IF_MASK);
    USART_IntEnable(uart, UART_IF_RXDATAV);
    NVIC_ClearPendingIRQ(UART0_RX_IRQn);
    NVIC_ClearPendingIRQ(UART0_TX_IRQn);
    NVIC_EnableIRQ(UART0_RX_IRQn);
    NVIC_EnableIRQ(UART0_TX_IRQn);

    /* Enable I/O pins at UART0 location #0 */
    uart->ROUTE = UART_ROUTE_RXPEN | UART_ROUTE_TXPEN | UART_ROUTE_LOCATION_LOC0;

    /* Enable UART */
    USART_Enable(uart, usartEnable);
}



/******************************************************************************
 * @brief  uartGetChar function
 *  Note that if there are no pending characters in the receive buffer, this
 *  function will hang until a character is received.
 *****************************************************************************/
uint8_t UART_GetChar(void) {
    uint8_t ch;

    /* Check if there is a byte that is ready to be fetched. If no byte is ready, wait for incoming data */
    if (rxBuf->pendingBytes < 1) {
        while (rxBuf->pendingBytes < 1) ;
    }

    /* Copy data from buffer */
    ch        = rxBuf->data[rxBuf->rdI];
    rxBuf->rdI = (rxBuf->rdI + 1) % BUFFERSIZE;

    /* Decrement pending byte counter */
    rxBuf->pendingBytes--;

    return ch;
}

/******************************************************************************
 * @brief  uartPutChar function
 *
 *****************************************************************************/
void UART_PutChar(uint8_t ch) {
    /* Check if Tx queue has room for new data */
    if ((txBuf->pendingBytes + 1) > BUFFERSIZE) {
        /* Wait until there is room in queue */
        while ((txBuf->pendingBytes + 1) > BUFFERSIZE) ;
    }

    /* Copy ch into txBuffer */
    txBuf->data[txBuf->wrI] = ch;
    txBuf->wrI             = (txBuf->wrI + 1) % BUFFERSIZE;

    /* Increment pending byte counter */
    txBuf->pendingBytes++;

    /* Enable interrupt on USART TX Buffer*/
    USART_IntEnable(uart, UART_IF_TXBL);
}

/******************************************************************************
 * @brief  uartPutData function
 *
 *****************************************************************************/
void UART_PutData(uint8_t *dataPtr, uint32_t dataLen) {
    uint32_t i = 0;

    /* Check if buffer is large enough for data */
    if (dataLen > BUFFERSIZE) {
        /* Buffer can never fit the requested amount of data */
        return;
    }

    /* Check if buffer has room for new data */
    if ((txBuf->pendingBytes + dataLen) > BUFFERSIZE) {
        /* Wait until room */
        while ((txBuf->pendingBytes + dataLen) > BUFFERSIZE) ;
    }

    /* Fill dataPtr[0:dataLen-1] into txBuffer */
    while (i < dataLen) {
        txBuf->data[txBuf->wrI] = *(dataPtr + i);
        txBuf->wrI             = (txBuf->wrI + 1) % BUFFERSIZE;
        i++;
    }

    /* Increment pending byte counter */
    txBuf->pendingBytes += dataLen;

    /* Enable interrupt on USART TX Buffer*/
    USART_IntEnable(uart, UART_IF_TXBL);
}

/******************************************************************************
 * @brief  uartGetData function
 *
 *****************************************************************************/
uint32_t UART_GetData(uint8_t * dataPtr, uint32_t dataLen) {
    uint32_t i = 0;

    /* Wait until the requested number of bytes are available */
    if (rxBuf->pendingBytes < dataLen) {
        while (rxBuf->pendingBytes < dataLen) ;
    }

    if (dataLen == 0) {
        dataLen = rxBuf->pendingBytes;
    }

    /* Copy data from Rx buffer to dataPtr */
    while (i < dataLen) {
        *(dataPtr + i) = rxBuf->data[rxBuf->rdI];
        rxBuf->rdI      = (rxBuf->rdI + 1) % BUFFERSIZE;
        i++;
    }

    /* Decrement pending byte counter */
    rxBuf->pendingBytes -= dataLen;

    return i;
}


/**************************************************************************//**
 * @brief UART0 RX IRQ Handler
 *
 * Set up the interrupt prior to use
 *
 * Note that this function handles overflows in a very simple way.
 *
 *****************************************************************************/
void UART0_RX_IRQHandler(void) {
    /* Check for RX data valid interrupt */
    if (uart->STATUS & UART_STATUS_RXDATAV) {
        /* Copy data into RX Buffer */
        uint8_t rxData = USART_Rx(uart);
        rxBuf->data[rxBuf->wrI] = rxData;
        rxBuf->wrI             = (rxBuf->wrI + 1) % BUFFERSIZE;
        rxBuf->pendingBytes++;

        /* Flag Rx overflow */
        if (rxBuf->pendingBytes > BUFFERSIZE) {
            rxBuf->overflow = true;
        }

        /* Clear RXDATAV interrupt */
        USART_IntClear(UART0, UART_IF_RXDATAV);
    }
}

/**************************************************************************//**
 * @brief UART0 TX IRQ Handler
 *
 * Set up the interrupt prior to use
 *
 *****************************************************************************/
void UART0_TX_IRQHandler(void) {
    /* Check TX buffer level status */
    if (uart->STATUS & UART_STATUS_TXBL) {
        if (txBuf->pendingBytes > 0) {
            /* Transmit pending character */
            USART_Tx(uart, txBuf->data[txBuf->rdI]);
            txBuf->rdI = (txBuf->rdI + 1) % BUFFERSIZE;
            txBuf->pendingBytes--;
        }

        /* Disable Tx interrupt if no more bytes in queue */
        if (txBuf->pendingBytes == 0) {
            USART_IntDisable(uart, UART_IF_TXBL);
        }
    }
}
