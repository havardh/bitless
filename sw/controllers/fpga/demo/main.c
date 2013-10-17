#include "FPGAController.h"
#include "FPGAConfig.h"

#define NUM_PIPELINES           2
#define NUM_CORES               4
#define CORE_BUFFER_SIZE        100
#define CORE_IMEM_SIZE          100
#define CORE_OFFSET             (CORE_BUFFER_SIZE + CORE_IMEM_SIZE)
#define FPGA_MEMORY             (NUM_CORES * (CORE_OFFSET + 1 + CORE_BUFFER_SIZE) * NUM_PIPELINES)

void initMemory() {
    uint16_t *program = (uint16_t *) malloc(sizeof(uint16_t) * CORE_IMEM_SIZE);
    uint16_t *inputBuffer;
    uint16_t *outputBuffer;

    for (int p = 0; p < NUM_PIPELINES; p++) {
        for (int i = 0; i < NUM_CORES; i++) {
            inputBuffer = (FPGA_GetBaseAddress() + i * CORE_OFFSET);
            outputBuffer = (FPGA_GetBaseAddress() + (i + 1) * CORE_OFFSET);

            for (int j = 0; j < CORE_BUFFER_SIZE; j++) {
                inputBuffer[j] = 1000 + i;
                outputBuffer[j] = 3000 + i;
            }
            for (int j = 0; j < CORE_IMEM_SIZE; j++) {
                program[j] = 2000 + i;
            }
            FPGACore_SetProgram(FPGA_GetCore(p, i), program, CORE_IMEM_SIZE);
        }
    }
    free(program);
}

int main() {

    FPGAConfig conf;
    conf.numPipelines = NUM_PIPELINES;
    conf.numCores = NUM_CORES;
    conf.bufferSize = CORE_BUFFER_SIZE;
    conf.imemSize = CORE_IMEM_SIZE;
    conf.baseAddress = (uint16_t *) malloc(sizeof(uint16_t) * FPGA_MEMORY);

    FPGA_Init(&conf);

    initMemory();

    FPGA_Destroy();
    
    return 0;
}
