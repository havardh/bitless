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

volatile uint32_t msTicks;
void Delay(uint32_t dlyTicks);

void SysTick_Handler(void) {
  msTicks++;
}

void Delay(uint32_t dlyTicks) {
    uint32_t curTicks;

    curTicks = msTicks;
    while ((msTicks - curTicks) < dlyTicks) ;
}

#define DATA_LENGTH     2
#define BIT_HIGH(var,pos) ((var) & (1<<(pos)))

void read(volatile uint16_t *addr, uint32_t length, volatile uint16_t *data) {
    char str[20];

    for (uint32_t i = 0; i < length; i++) {
        data[i] = *(addr);

        sprintf(str, "FPGA[%d]: %d\n\r", (int)i, data[i]);
        UART_PutData((uint8_t*)str, strlen(str));
    }
}

void write_data(volatile uint16_t *addr, uint32_t length, uint16_t data) {
    for (uint32_t i = 0; i < length; i++) {
        *(addr + i) = data;
    }
}

int main(void) {
    CHIP_Init();
    EBIDriver_Init();
    Leds_Init();

    volatile uint16_t *fpga_address = (uint16_t*) 0x80000000;
        // uint32_t addr0 = 0x4000;
        // uint32_t addr1 = 0x40000;
        // uint32_t toplevel_address = 0x400000;

    volatile uint16_t fpga_res[DATA_LENGTH];
    fpga_res[0] = 0;
    fpga_res[1] = 0;


    /* Initialize UART peripheral */
    UART_Init();
    char str[20];
    sprintf(str, "Test\n\r");
    UART_PutData((uint8_t*)str, strlen(str));

    while (1) {
        // UART_GetData((uint8_t*)str, 7);
        // UART_PutData((uint8_t*)str, strlen(str));

        // uint32_t number = (uint32_t)strtol(str, NULL, 16);

        // write_data(fpga_address, 1, 0);
        read((fpga_address), 1, fpga_res);
        // read((fpga_address + number), 1, fpga_res);
        // read((fpga_address + addr1), 1, fpga_res);
        // read((fpga_address + toplevel_address), 1, fpga_res);

        if (fpga_res[0] > 0) {
            Leds_SetLed(0);
            Leds_SetLed(1);
            Leds_SetLed(2);
            Leds_SetLed(3);
        } else {
            Leds_SetLed(4);
        }
        Delay(5000);
    }
}
