#include "FPGAController.h"
#include "FPGAConfig.h"
#include "bl_sdi.h"

#define INST_SIZE 512
#define DATA_SIZE 256

#define FPGA_ADDR_BASE       0x80000000
#define FPGA_ADDR_IMEM_CORE0 0x44000
#define FPGA_ADDR_INM_CORE0  0x20000
#define FPGA_ADDR_OUM_CORE0  0x30000
#define FPGA_ADDR_CTRL_PIPE0 0x40000
#define FPGA_ADDR_CTRL_PIPE1 0x50000
#define FPGA_CTRL_START      0x0000
#define FPGA_CTRL_STOP       0x0002

void write_instruction(uint8_t command[]);
void write_data(uint8_t command[]);
void read_data(uint8_t command[]);
void execute(uint8_t command[]);

void SDI_Init(void) 
{
	FPGAConfig conf = FPGA_CONFIG_DEFAULT(0x80000000);
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
		} else if ( command[0] == 'e') {
			execute(command);
		}
	}
}

void write_instruction(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t coreIndex = command[3];

	FPGA_Core *core = FPGA_GetCore(pipeline, coreIndex);

	UART_GetData((uint8_t*)FPGA_ADDR_IMEM_CORE0, INST_SIZE*2);
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

	UART_GetData((uint8_t*)FPGA_ADDR_INM_CORE0, DATA_SIZE*2);
}

void read_data(uint8_t command[])
{
	uint8_t pipeline = command[2];
	uint8_t memory = command[3];

	uint16_t *mem = getBuffer(pipeline, memory);

	UART_PutData((uint8_t*)FPGA_ADDR_OUM_CORE0, DATA_SIZE*2);
}
/*
static int parseIterations(uint8_t command[]) 
{
	int iterations = (int)command[3];
	iterations += (int)command[2]*10;
	iterations += (int)command[3]*100;

	return iterations;
}
*/
void execute(uint8_t command[])
{
	*(uint16_t*)(FPGA_ADDR_BASE + FPGA_ADDR_CTRL_PIPE0) = FPGA_CTRL_START;
	*(uint16_t*)(FPGA_ADDR_BASE + FPGA_ADDR_CTRL_PIPE1) = FPGA_CTRL_START;

	// Wait some should toogle the clock eventually
	for(int i=0; i<100000; i++) ;
	
	*(uint16_t*)(FPGA_ADDR_BASE + FPGA_ADDR_CTRL_PIPE0) = FPGA_CTRL_STOP;
	*(uint16_t*)(FPGA_ADDR_BASE + FPGA_ADDR_CTRL_PIPE1) = FPGA_CTRL_STOP;

	/*
	FPGA_Enable();
	
	int iterations = parseIterations(command);

	for (int i=0; i<iterations; i++) {
		FPGA_ToggleClock();
	}

	FPGA_Disable();
	*/
}
