#include "FPGADebug.h"

void FPGADebug_GetCoreInputBuffer(FPGA_Core *core, uint16_t *inputBuffer) {
    for (uint32_t i = 0; i < core->bufferSize; i++) {
        inputBuffer[i] = core->inputBuffer[i];
    }
}

void FPGADebug_SetCoreInputBuffer(FPGA_Core *core, uint16_t *inputBuffer) {
    for (uint32_t i = 0; i < core->bufferSize; i++) {
        core->inputBuffer[i] = inputBuffer[i];
    }
}

void FPGADebug_GetCoreOutputBuffer(FPGA_Core *core, uint16_t *outputBuffer) {
    for (uint32_t i = 0; i < core->bufferSize; i++) {
        outputBuffer[i] = core->outputBuffer[i];
    }
}

void FPGADebug_SetCoreOutputBuffer(FPGA_Core *core, uint16_t *outputBuffer) {
    for (uint32_t i = 0; i < core->bufferSize; i++) {
        core->outputBuffer[i] = outputBuffer[i];
    }
}
