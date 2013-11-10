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

void SDI_Init(void) 
{
	pipelines = (Pipeline*)malloc(sizeof(Pipeline)*2);
	for (int i=0; i<2; i++) {
		pipelines[i].cores = (Core*)malloc(sizeof(Core)*2);

		for (int j=0; j<2; j++) {
			pipelines[i].cores[j].in = malloc(sizeof(uint16_t)*MEM_SIZE);
			pipelines[i].cores[j].out = malloc(sizeof(uint16_t)*MEM_SIZE);
			pipelines[i].cores[j].inst = malloc(sizeof(uint16_t)*MEM_SIZE);
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

	UART_GetData(inst, 16*2);
}

void write_data(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t memory = command[3];

	uint16_t *mem = pipelines[pipeline].cores[memory].in;
	
	UART_GetData(mem, 16*2);
}

void read_data(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t memory = command[3];

	uint16_t *mem = pipelines[pipeline].cores[memory].in;

	UART_PutData(mem, 16*2);
}



