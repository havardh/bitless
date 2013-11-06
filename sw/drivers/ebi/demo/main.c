#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "EbiDriver.h"
#include "leds.h"

#define DATA_LENGTH     10

static uint16_t sram_data[DATA_LENGTH] = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9
};

void write(uint16_t *data, uint32_t length, uint16_t *addr) {
    for (uint32_t i = 0; i < length; i++) {
        *(addr + i) = data[i];
    }
}

void read(uint16_t *data, uint16_t length, uint16_t *addr) {
    for (uint32_t i = 0; i < length; i++) {
        data[i] = *(addr + i);
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
    LEDController_Init();
    EBIDriver_Init();   

    uint16_t *sram_addr = (uint16_t*) 0x84000000;
    uint16_t sram_res[DATA_LENGTH];


    write(sram_data, DATA_LENGTH, sram_addr);
    read(sram_res, DATA_LENGTH, sram_addr);
    bool equal = compare(sram_data, sram_res, DATA_LENGTH);

    while (1) {
        if (equal) {
            LEDController_SetLeds(0xF);
        } else {
            LEDController_SetLed(4);
        }
    }
}
