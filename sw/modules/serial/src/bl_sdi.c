#include "FPGAController.h"
#include "FPGAConfig.h"
#include "bl_sdi.h"

#define INST_SIZE 512
#define DATA_SIZE 1024

void write_instruction(uint8_t command[]);
void write_data(uint8_t command[]);
void read_data(uint8_t command[]);

void SDI_Init(void) 
{
	FPGAConfig conf = FPGA_CONFIG_DEFAULT(0x20000000);
	FPGA_Init( &conf );
}

void SDI_Start(void)
{

	while(1) {
		uint8_t command[CMD_LEN];
		UART_GetData(command, CMD_LEN);
	
		if (command[0] == 'w' && command[1] == 'i') {
			write_instruction(command);
		} else if ( command[0] == 'w' && command[1] == 'd' ) {
			write_data(command);
		} else if ( command[0] == 'r' && command[1] == 'd' ) {
			read_data(command);
		}
	}
}

void write_instruction(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t coreIndex = command[3];

	FPGA_Core *core = FPGA_GetCore(pipeline, coreIndex);

	UART_GetData((uint8_t*)core->imem, INST_SIZE*2);
}

static uint16_t *getBuffer(uint8_t pipeline, uint8_t memory)
{
	uint16_t *mem;

	FPGA_Pipeline *p = FPGA_GetPipeline(pipeline);
	if (memory == 0) {
		mem = FPGAPipeline_GetInputBuffer(p);
	} else if (memory == 1) {
		mem = FPGAPipeline_GetOutputBuffer(p);
	}
	return mem;
}

void write_data(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t memory = command[3];

	uint16_t *mem = getBuffer(pipeline, memory);

	UART_GetData((uint8_t*)mem, DATA_SIZE*2);
}

void read_data(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t memory = command[3];

	uint16_t *mem = getBuffer(pipeline, memory);

	UART_PutData((uint8_t*)mem, DATA_SIZE*2);
}



