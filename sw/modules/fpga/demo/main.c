#include "FPGAController.h"
#include "FPGAConfig.h"

void initMemory() {
    uint16_t *program = (uint16_t *) malloc(sizeof(uint16_t) * DEFAULT_CORE_ADDRESS_SIZE);
    uint16_t *inputBuffer;
    uint16_t *outputBuffer;

    for (int p = 0; p < DEFAULT_NUM_PIPELINES; p++) {
        for (int i = 0; i < DEFAULT_NUM_CORES; i++) {
            FPGACore_SetProgram(FPGA_GetCore(p, i), program, DEFAULT_CORE_ADDRESS_SIZE);
        }
    }
    free(program);
}

int main() {

    uint16_t *a = (uint16_t *) malloc(sizeof(uint16_t) * 0x800000);
    FPGAConfig conf = FPGA_CONFIG_DEFAULT(a);

    FPGA_Init(&conf);

    initMemory();

    FPGA_Destroy();
    
    return 0;
}
