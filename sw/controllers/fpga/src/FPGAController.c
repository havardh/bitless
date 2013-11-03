#include "FPGAController.h"
#include <assert.h>
#include <stdio.h>

static FPGA_Processor fpga;

/*******************************************
* FPGA Processor methods                   *
*******************************************/

uint16_t* FPGA_GetBaseAddress(void) {
    return fpga.baseAddress;
}

FPGA_Pipeline* FPGA_GetPipeline(uint32_t pipeline) {
    if (pipeline < fpga.numPipelines) {
        return &fpga.pipelines[pipeline];
    }
    return NULL;
}

FPGA_Core* FPGA_GetCore(uint32_t pipeline, uint32_t core) {
    FPGA_Pipeline *p = FPGA_GetPipeline(pipeline);
    return FPGAPipeline_GetCore(p, core);
}

/*******************************************
* FPGA Pipeline methods                    *
*******************************************/

FPGA_Core* FPGAPipeline_GetCore(FPGA_Pipeline *pipeline, uint32_t core) {
    if (pipeline != NULL && core < pipeline->numCores) {
        return &pipeline->cores[core];
    }
    return NULL;
}

uint16_t* FPGAPipeline_GetInputBuffer(FPGA_Pipeline *pipeline) {
    FPGA_Core *core = FPGA_GetCore(pipeline->pos, 0);
    return core->inputBuffer;
}

uint16_t* FPGAPipeline_GetOutputBuffer(FPGA_Pipeline *pipeline) {
    FPGA_Core *core = FPGAPipeline_GetCore(pipeline, pipeline->numCores - 1);
    return core->outputBuffer;   
}

/*******************************************
* FPGA Core methods                        *
*******************************************/

void FPGACore_GetProgram(FPGA_Core *core, uint16_t *program) {
    for (uint32_t i = 0; i < core->imemSize; i++) {
        program[i] = core->imem[i];
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

void FPGACore_GetControls(FPGA_Core *core, uint16_t *controls) {
    for (uint32_t i = 0; i < core->ctrlSize; i++) {
        controls[i] = core->ctrlmem[i];
    }
}

void FPGACore_SetControls(FPGA_Core *core, uint16_t *controls, uint32_t controlSize) {
    assert(controlSize <= core->ctrlSize);

    for (uint32_t i = 0; i < controlSize; i++) {
        core->ctrlmem[i] = controls[i];
    }
    /* Set all remaining controls to 0 */
    if (controlSize < core->ctrlSize) {
        for (uint32_t i = controlSize; i < core->ctrlSize; i++) {
            core->ctrlmem[i] = 0;
        }
    }
}


/*******************************************
* FPGA Setup and teardown                  *
*******************************************/

void FPGA_Init(FPGAConfig *config) {
    fpga.baseAddress = config->baseAddress;

    fpga.numPipelines = config->numPipelines;
    fpga.pipelines = (FPGA_Pipeline *) malloc(sizeof(FPGA_Pipeline) * config->numPipelines);
    for (uint32_t i = 0; i < fpga.numPipelines; i++) {
        FPGA_Pipeline_New(&fpga.pipelines[i], i, config);
    }
}

void FPGA_Pipeline_New(FPGA_Pipeline *pipeline, uint32_t pipelinePos, FPGAConfig *config) {
    pipeline->pos = pipelinePos;
    pipeline->address = fpga.baseAddress + config->toplevelAddress + pipelinePos * config->pipelineAddressSize;

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
    core->ctrlSize = config->ctrlSize;

    uint16_t *pipelineAddress = FPGA_GetPipeline(pipelinePos)->address;
    uint16_t *coreAddress = (pipelineAddress + config->coreDeviceAddress + corePos * config->coreDeviceSize);
    
    core->ctrlmem = coreAddress;
    core->imem = (core->ctrlmem + config->coreAddressSize);
    core->inputBuffer = (core->imem + config->coreAddressSize);
    core->outputBuffer = (core->inputBuffer + config->coreAddressSize);
}

void FPGA_Destroy(void) {
    for (uint32_t i = 0; i < fpga.numPipelines; i++) {
        FPGA_Pipeline *p = FPGA_GetPipeline(i);
        free(p->cores);
    }
    free(fpga.pipelines);
    free(fpga.baseAddress);
}
