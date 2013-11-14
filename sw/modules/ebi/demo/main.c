#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_gpio.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "bl_leds.h"
#include "bl_ebi.h"
#include "bl_uart.h"

#define DATA_LENGTH     10

static uint16_t sram_data[DATA_LENGTH] = {
    0xff, 1, 2, 3, 4, 5, 6, 7, 8, 9
};

static uint16_t sram_data1[DATA_LENGTH] = {
    10, 11, 12, 13, 14, 15, 16, 17, 18, 9
};

void write(uint16_t *data, uint32_t length, uint16_t *addr) {
    for (uint32_t i = 0; i < length; i++) {
        *(addr + i) = data[i];
    }
}

void read(uint16_t *data, uint16_t length, uint16_t *addr) {
    char str[20];

    for (uint32_t i = 0; i < length; i++) {
        data[i] = *(addr + i);
        sprintf(str, "data: %d\n\r", (int)data[i]);
        UART_PutData((uint8_t*)str, strlen(str));
    }
}

bool compare(uint16_t *data, uint16_t *res, uint32_t length) {
    bool equal = true;

    for (uint32_t i = 0; i < length; i++) {
        if (data[i] != res[i])
            equal = false;
    }

    return equal;
}

int main(void) {
    CHIP_Init();
    EBIDriver_Init();
    Leds_Init();

    uint16_t *sram_addr = (uint16_t*) 0x84000000;
    uint16_t sram_res[DATA_LENGTH];

    UART_Init();
    char str[20];
    sprintf(str, "Test\n\r");
    UART_PutData((uint8_t*)str, strlen(str));

    // sprintf(str, "data:\n\r");
    // UART_PutData((uint8_t*)str, strlen(str));
    // Leds_SetLed(3);

    write(sram_data, DATA_LENGTH, sram_addr);
    read(sram_res, DATA_LENGTH, sram_addr);
    bool equal = compare(sram_data, sram_res, DATA_LENGTH);

    while (1) {
        read(sram_res, 1, sram_addr);
        if (equal) {
            Leds_SetLed(0);
            Leds_SetLed(1);
            Leds_SetLed(2);
            Leds_SetLed(3);
        } else {
            Leds_SetLed(4);
        }
    }
}
