#ifndef _SERIAL_H_
#define _SERIAL_H_

#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_emu.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "em_usart.h"

/* Define termination character */
#define TERMINATION_CHAR    '.'

/* Declare a circular buffer structure to use for Rx and Tx queues */
#define BUFFERSIZE          256

typedef volatile struct {
    uint8_t  data[BUFFERSIZE];  /* data buffer */
    uint32_t rdI;               /* read index */
    uint32_t wrI;               /* write index */
    uint32_t pendingBytes;      /* count of how many bytes are not yet handled */
    bool     overflow;          /* buffer overflow indicator */
} circularBuffer;

void USART_Init(void);

void uartSetup(circularBuffer *rx, circularBuffer *tx);
void cmuSetup(void);
void uartPutData(uint8_t * dataPtr, uint32_t dataLen);
uint32_t uartGetData(uint8_t * dataPtr, uint32_t dataLen);
void uartPutChar(uint8_t charPtr);
uint8_t uartGetChar(void);


#endif // _SERIAL_H_
