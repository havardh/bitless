#ifndef _FPGACONTROLLER_H_
#define _FPGACONTROLLER_H_

#include <stdint.h>
#include <stdlib.h>
#include "FPGAConfig.h"

typedef struct {
    uint32_t pos;
    uint32_t bufferSize;
    uint16_t *inputBuffer;
    uint16_t *outputBuffer;
    uint32_t imemSize;
    uint16_t *imem;
    uint32_t ctrlSize;
    uint16_t *ctrlmem;
} FPGA_Core;

typedef struct {
    uint32_t pos;
    uint32_t numCores;
    uint16_t *address;
    FPGA_Core *cores;
} FPGA_Pipeline;

typedef struct {
    uint32_t numPipelines;
    uint16_t *baseAddress;
    FPGA_Pipeline *pipelines;
} FPGA_Processor;

/* FPGA Processor methods */
FPGA_Pipeline* FPGA_GetPipeline(uint32_t pipeline);
FPGA_Core* FPGA_GetCore(uint32_t pipeline, uint32_t core);
uint16_t* FPGA_GetBaseAddress();

/* FPGA Pipeline methods */
uint16_t* FPGAPipeline_GetInputBuffer(FPGA_Pipeline *pipeline);
uint16_t* FPGAPipeline_GetOutputBuffer(FPGA_Pipeline *pipeline);
FPGA_Core* FPGAPipeline_GetCore(FPGA_Pipeline *pipeline, uint32_t core);

/* FPGA Core methods */
void FPGACore_GetProgram(FPGA_Core *core, uint16_t *program);
void FPGACore_SetProgram(FPGA_Core *core, uint16_t *program, uint32_t programSize);
void FPGACore_GetControls(FPGA_Core *core, uint16_t *controls);
void FPGACore_SetControls(FPGA_Core *core, uint16_t *controls, uint32_t controlSize);

/* Setup and teardown */
void FPGA_Init(FPGAConfig *config);
void FPGA_Destroy(void);
void FPGA_Pipeline_New(FPGA_Pipeline *pipeline, uint32_t pipelinePos, FPGAConfig *config);
void FPGA_Core_New(FPGA_Core *core, uint32_t corePos, uint32_t pipelinePos, FPGAConfig *config);

#endif /* _FPGACONTROLLER_H_ */
