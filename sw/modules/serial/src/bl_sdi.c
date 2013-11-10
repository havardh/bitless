#include "bl_sdi.h"

void write_instruction(uint8_t command[]);
void write_data(uint8_t command[]);
void read_data(uint8_t command[]);

typedef struct {
	uint16_t *in, *out, *inst;
} Core;

typedef struct {
	Core *cores;
} Pipeline;

static Pipeline *pipelines;

static uint8_t nums[32] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };

void SDI_Init(void) 
{
	pipelines = (Pipeline*)malloc(sizeof(Pipeline)*1);
	for (int i=0; i<1; i++) {
		pipelines[i].cores = (Core*)malloc(sizeof(Core)*1);

		for (int j=0; j<1; j++) {
			pipelines[i].cores[j].in = (uint16_t*)malloc(sizeof(uint16_t)*16);
			//pipelines[i].cores[j].out = nums;
			//pipelines[i].cores[j].inst = nums;

			for(int k=0; k<16; k++) {
				pipelines[i].cores[j].in[k] = nums[k];
			}
		}
	}
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
	uint8_t core = command[3];

	uint16_t *inst = pipelines[pipeline].cores[core].inst;

	UART_GetData((uint8_t*)inst, 16*2);
}

void write_data(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t memory = command[3];

	uint16_t *mem = pipelines[pipeline].cores[memory].in;
	
	UART_GetData((uint8_t*)nums, 32);
}

void read_data(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t memory = command[3];

	uint16_t *mem = pipelines[pipeline].cores[memory].in;

	UART_PutData((uint8_t*)nums, 32);
}



