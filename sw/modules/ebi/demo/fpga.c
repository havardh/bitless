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

void read(volatile uint16_t *addr, volatile uint16_t *data) {

	*data = *addr;
	
}

void write_data(volatile uint16_t *addr, volatile uint16_t data) {
	*addr = data;
}

void load_store(void) 
{
	write_data(fpga_address + 0x44000, 0x0000);
	write_data(fpga_address + 0x44001, 0x7080);
	write_data(fpga_address + 0x44002, 0x0000);
	write_data(fpga_address + 0x44003, 0x0000);
	write_data(fpga_address + 0x44004, 0x0000);
	write_data(fpga_address + 0x44005, 0x0000);
	write_data(fpga_address + 0x44006, 0x7c80);
	write_data(fpga_address + 0x44007, 0x0000);
	write_data(fpga_address + 0x44008, 0x0000);
	write_data(fpga_address + 0x44009, 0x0000);
	write_data(fpga_address + 0x4400a, 0x3000);
	write_data(fpga_address + 0x20000, 0x7fff);
	write_data(fpga_address + 0x40000, 0x0000);
	
	write_data(fpga_address + 0x40000, 0x0002);
	
	uint16_t res;
	read(fpga_address + 0x30000, &res);
	
	write_data(fpga_address + 0x40000, 0x0002);

}

void add1(void) 
{
	write_data(fpga_address + 0x44000, 0x0000);
	write_data(fpga_address + 0x44001, 0x7080);
	write_data(fpga_address + 0x44002, 0x0000);
	write_data(fpga_address + 0x44003, 0x0000);
	write_data(fpga_address + 0x44004, 0x0000);
	write_data(fpga_address + 0x44005, 0x0000);
	write_data(fpga_address + 0x44006, 0x7c80);
	write_data(fpga_address + 0x44007, 0x0000);
	write_data(fpga_address + 0x44008, 0x0000);
	write_data(fpga_address + 0x44009, 0x0000);
	write_data(fpga_address + 0x4400a, 0x3000);
	write_data(fpga_address + 0x20000, 0x7fff);
	write_data(fpga_address + 0x40000, 0x0000);
	
	write_data(fpga_address + 0x40000, 0x0002);
	
	uint16_t res;
	read(fpga_address + 0x30000, &res);
	
	write_data(fpga_address + 0x40000, 0x0002);

}



int main(void) {
	CHIP_Init();
	EBIDriver_Init();

	volatile uint16_t *fpga_address = (uint16_t*) 0x80000000;
	// uint32_t addr0 = 0x4000;
	// uint32_t addr1 = 0x40000;
	// uint32_t toplevel_address = 0x400000;

	volatile uint16_t fpga_res[DATA_LENGTH];
	
	
	while (1) {
		// write_data(fpga_address, 1, 0);
		//read((fpga_address), 1, fpga_res);
		// read((fpga_address + number), 1, fpga_res);
		// read((fpga_address + addr1), 1, fpga_res);
		// read((fpga_address + toplevel_address), 1, fpga_res);
	}
}
