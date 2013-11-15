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

#define DATA_LENGTH     2
#define BIT_HIGH(var,pos) ((var) & (1<<(pos)))

void read(volatile uint16_t *addr, uint32_t length, volatile uint16_t *data) {

	for (uint32_t i = 0; i < length; i++) {
		data[i] = *(addr);
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

	volatile uint16_t *fpga_address = (uint16_t*) 0x80000000;
	// uint32_t addr0 = 0x4000;
	// uint32_t addr1 = 0x40000;
	// uint32_t toplevel_address = 0x400000;

	volatile uint16_t fpga_res[DATA_LENGTH];
	
	for (int i=0; i<DATA_LENGTH; i++) {
		fpga_res[i] = 0;
	}
	
	while (1) {
		// write_data(fpga_address, 1, 0);
		read((fpga_address), 1, fpga_res);
		// read((fpga_address + number), 1, fpga_res);
		// read((fpga_address + addr1), 1, fpga_res);
		// read((fpga_address + toplevel_address), 1, fpga_res);
	}
}
