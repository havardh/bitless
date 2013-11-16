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
#include "FPGAController.h"

#define DATA_LENGTH     2
#define BIT_HIGH(var,pos) ((var) & (1<<(pos)))

#define fpga_address 0x80000000

void read(volatile uint16_t *addr, volatile uint16_t *data) {

    *data = *addr;
    
}

void write_data(volatile uint16_t *addr, volatile uint16_t data) {
    *addr = data;
}

#define IMEM_LEN 11

uint16_t imem_data[IMEM_LEN] = {
    0x0000,0x7080,0x0000,0x0000,0x0000,0x0000,0x7c80,0x0000,0x0000,0x0000,0x3000
};

void load_store2cores(void) 
{
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);
    //Skriv program til kjerne 0:
    FPGA_Core *c0 = FPGAPipeline_GetCore(p0, 0);
    FPGACore_SetProgram(c0, imem_data, IMEM_LEN);

    //Skriv program til kjerne 1:
    FPGA_Core *c1 = FPGAPipeline_GetCore(p0, 1);
    FPGACore_SetProgram(c1, imem_data, IMEM_LEN);

    //Skriv data til input-buffer:
    uint16_t *in = FPGAPipeline_GetInputBuffer(p0);
    write_data(in, 0xbeef);

    //Start kjerne 0:
    write_data(c0->address, 0x0000);
    //Start kjerne 1:
    write_data(c1->address, 0x0000);

    // Vent litt), send én puls på sample_clk), vent litt til.
    GPIO_PinOutToggle(gpioPortF, 12);    

    //Stopp kjerne 0:
    write_data(c0->address, 0x0002);
    //Stopp kjerne 1:
    write_data(c1->address, 0x0002);

    uint16_t res;
    uint16_t *out = FPGAPipeline_GetOutputBuffer(p0);
    read(out, &res);

    write_data(c0->address, 0x0002);
}

int main(void) {
    CHIP_Init();
    EBIDriver_Init();

    FPGAConfig conf = FPGA_CONFIG_DEFAULT(fpga_address);
    FPGA_Init(&conf);

    CMU_ClockEnable(cmuClock_GPIO, true);

    GPIO_PinModeSet(gpioPortF,  12, gpioModePushPull, 0);
    GPIO_PinOutClear(gpioPortF, 12);
    // uint32_t addr0 = 0x4000;
    // uint32_t addr1 = 0x40000;
    // uint32_t toplevel_address = 0x400000;

    
    while (1) {
        load_store2cores();
        // write_data(fpga_address, 1, 0);
        //read((fpga_address), 1, fpga_res);
        // read((fpga_address + number), 1, fpga_res);
        // read((fpga_address + addr1), 1, fpga_res);
        // read((fpga_address + toplevel_address), 1, fpga_res);
    }
}
