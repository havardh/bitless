#include "FPGAController.h"

#define BIT_HIGH(var,pos) ((var) & (1<<(pos)))

static FPGA_Processor fpga;

/*******************************************
* FPGA Processor methods                   *
*******************************************/

uint16_t* FPGA_GetBaseAddress(void) {
    return fpga.baseAddress;
}

FPGA_ControlRegister FPGA_GetControlRegister(void) {
    uint16_t reg = *fpga.controlRegister;

    FPGA_ControlRegister ctrlReg = FPGA_CTRL_REG_DEFAULT;
    ctrlReg.blinkMode = BIT_HIGH(reg, 13);
    ctrlReg.LED0      = BIT_HIGH(reg, 12);
    ctrlReg.LED1      = BIT_HIGH(reg, 11);
    ctrlReg.BTN0      = BIT_HIGH(reg, 10);
    ctrlReg.BTN1      = BIT_HIGH(reg,  9);
    ctrlReg.pipelines = 0x7 & reg; // Value of lower three bits

    return ctrlReg;
}

void FPGA_SetControlRegister(FPGA_ControlRegister reg) {
    uint32_t regVal = 0x0;

    if (reg.reset)
        regVal += CTRL_RESET_ADDR;

    if (reg.blinkMode)
        regVal += CTRL_BLINK_ADDR;

    if (reg.LED0)
        regVal += CTRL_LED0_ADDR;

    if (reg.LED1)
        regVal += CTRL_LED1_ADDR;

    fpga.controlRegister[0] = (uint16_t) regVal;
}

void FPGA_Reset(void) {
    FPGA_ControlRegister ctrlReg = FPGA_CTRL_REG_DEFAULT;
    ctrlReg.reset = true;

    FPGA_SetControlRegister(ctrlReg);
}

void FPGA_SetLeds(bool led0, bool led1) {
    FPGA_ControlRegister ctrlReg = FPGA_CTRL_REG_DEFAULT;
    ctrlReg.LED0 = led0;
    ctrlReg.LED1 = led1;

    FPGA_SetControlRegister(ctrlReg);
}

void FPGA_SetBlinkMode(bool blinkMode) {
    FPGA_ControlRegister ctrlReg = FPGA_CTRL_REG_DEFAULT;
    ctrlReg.blinkMode = blinkMode;

    FPGA_SetControlRegister(ctrlReg);
}

uint32_t FPGA_GetButtonStatus(void) {
    FPGA_ControlRegister ctrlReg = FPGA_GetControlRegister();

    return (uint32_t) (0x1 & ctrlReg.BTN1) + (0x1 & ctrlReg.BTN0);
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
    fpga.controlRegister = config->baseAddress + config->toplevelAddress;
    FPGA_Reset();

    fpga.numPipelines = config->numPipelines;
    fpga.pipelines = (FPGA_Pipeline *) malloc(sizeof(FPGA_Pipeline) * config->numPipelines);
    for (uint32_t i = 0; i < fpga.numPipelines; i++) {
        FPGA_Pipeline_New(&fpga.pipelines[i], i, config);
    }
}

void FPGA_Pipeline_New(FPGA_Pipeline *pipeline, uint32_t pipelinePos, FPGAConfig *config) {
    pipeline->pos = pipelinePos;
    pipeline->address = fpga.baseAddress + pipelinePos * config->pipelineAddressSize;

    pipeline->numCores = config->numCores;
    pipeline->cores = (FPGA_Core *) malloc(sizeof(FPGA_Core) * pipeline->numCores);
    for (uint32_t i = 0; i < pipeline->numCores; i++) {
        FPGA_Core_New(&pipeline->cores[i], i, pipelinePos, config);
    }
}

void FPGA_Core_New(FPGA_Core *core, uint32_t corePos, uint32_t pipelinePos, FPGAConfig *config) {
    core->pos = corePos;
    core->bufferSize = config->coreAddressSize;
    core->imemSize = config->coreAddressSize;
    core->ctrlSize = config->coreAddressSize;

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
