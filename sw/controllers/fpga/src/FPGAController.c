#include "FPGAController.h"
#include <assert.h>
#include <stdio.h>

static FPGA_Processor proc;

void FPGA_Init(FPGAConfig *config) {
    proc.baseAddress = config->baseAddress;

    proc.numPipelines = config->numPipelines;

    proc.pipelines = (FPGA_Pipeline *) malloc(sizeof(FPGA_Pipeline) * config->numPipelines);

    for (uint32_t i = 0; i < proc.numPipelines; i++) {
        FPGA_Pipeline_New(&proc.pipelines[i], i, config);
    }
}

void FPGA_Pipeline_New(FPGA_Pipeline *pipeline, uint32_t pipelinePos, FPGAConfig *config) {
    pipeline->pos = pipelinePos;

    pipeline->numCores = config->numCores;
    pipeline->cores = (FPGA_Core *) malloc(sizeof(FPGA_Core) * pipeline->numCores);
    for (uint32_t i = 0; i < pipeline->numCores; i++) {
        FPGA_Core_New(&pipeline->cores[i], i, pipelinePos, config);
    }
}

void FPGA_Core_New(FPGA_Core *core, uint32_t corePos, uint32_t pipelinePos, FPGAConfig *config) {
    core->pos = corePos;
    core->bufferSize = config->bufferSize;
    core->imemSize = config->imemSize;

    uint32_t coreNum = corePos + pipelinePos * config->numCores;
    uint16_t *core_base_address = (config->baseAddress + coreNum * 
        (core->bufferSize + core->imemSize) + pipelinePos * core->bufferSize);
    
    core->inputBuffer =  core_base_address;
    core->outputBuffer = (core_base_address + core->bufferSize + core->imemSize);
    core->imem = (core_base_address + core->bufferSize);
}

FPGA_Pipeline* FPGA_GetPipeline(uint32_t pipeline) {
    if (pipeline < proc.numPipelines) {
        return &proc.pipelines[pipeline];
    }
    return NULL;
}

FPGA_Core* FPGAPipline_GetCore(FPGA_Pipeline *pipeline, uint32_t core) {
    if (pipeline != NULL && core < pipeline->numCores) {
        return &pipeline->cores[core];
    }
    return NULL;
}

FPGA_Core* FPGA_GetCore(uint32_t pipeline, uint32_t core) {
    FPGA_Pipeline *p = FPGA_GetPipeline(pipeline);
    return FPGAPipline_GetCore(p, core);
}

uint16_t* FPGA_GetBaseAddress() {
    return proc.baseAddress;
}

uint16_t* FPGAPipeline_GetInputBuffer(FPGA_Pipeline *pipeline) {
    FPGA_Core *core = FPGA_GetCore(pipeline->pos, 0);
    return core->inputBuffer;
}

uint16_t* FPGAPipeline_GetOutputBuffer(FPGA_Pipeline *pipeline) {
    FPGA_Core *core = FPGA_GetCore(pipeline->pos, pipeline->numCores - 1);
    return core->outputBuffer;   
}

void FPGACore_GetProgram(FPGA_Core *core, uint16_t *program) {
    for (uint32_t i = 0; i < core->imemSize; i++) {
        program[i] = *(core->imem + i);
    }
}

void FPGACore_SetProgram(FPGA_Core *core, uint16_t *program, uint32_t programSize) {
    assert(programSize <= core->imemSize);

    for (uint32_t i = 0; i < programSize; i++) {
        core->imem[i] = program[i];
    }

    /* Set all remaining instruction memory to 0 */
    if (programSize < core->imemSize) {
        for (uint32_t i = programSize; i < core->imemSize; i++) {
            core->imem[i] = 0;
        }
    }
}

void FPGA_Destroy() {
    for (uint32_t i = 0; i < proc.numPipelines; i++) {
        FPGA_Pipeline *p = FPGA_GetPipeline(i);
        free(p->cores);
    }
    free(proc.pipelines);
    free(proc.baseAddress);
}
