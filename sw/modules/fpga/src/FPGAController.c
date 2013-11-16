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
    ctrlReg.pipelines = 0xf & reg; // Value of lower four bits

    return ctrlReg;
}

void FPGA_SetControlRegister(FPGA_ControlRegister reg) {
    uint32_t regVal = 0x0;

    if (reg.reset)
        regVal |= CTRL_RESET_ADDR;

    fpga.controlRegister[0] = (uint16_t) regVal;
}

void FPGA_Reset(void) {
    FPGA_ControlRegister ctrlReg = FPGA_CTRL_REG_DEFAULT;
    ctrlReg.reset = true;

    FPGA_SetControlRegister(ctrlReg);
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
    return pipeline->inputBuffer;
}

uint16_t* FPGAPipeline_GetOutputBuffer(FPGA_Pipeline *pipeline) {
    return pipeline->outputBuffer;   
}

FPGA_PipelineControlRegister FPGAPipeline_GetControlRegister(FPGA_Pipeline *pipeline) {
    uint16_t regVal = *(pipeline->address);

    FPGA_PipelineControlRegister pReg;
    pReg.firstCore  = 0x000f & (regVal >> 12);
    pReg.secondCore = 0x000f & (regVal >> 8);
    pReg.stopMode   = BIT_HIGH(regVal, 7);
    pReg.reset      = BIT_HIGH(regVal, 6);
    pReg.numCores   = 0x000f & regVal;

    return pReg;
}

void FPGAPipeline_SetControlRegister(FPGA_Pipeline *pipeline, FPGA_PipelineControlRegister reg) {
    uint32_t regVal = 0x0000;

    regVal |= 0xf000 & (reg.firstCore << 12);
    regVal |= 0x0f00 & (reg.secondCore << 8);
    
    if (reg.stopMode)
        regVal |= 0x0080;

    if (reg.reset)
        regVal |= 0x0040;
    
    regVal |= 0x000f & reg.numCores;

    *(pipeline->address) = (uint16_t)regVal;
}

void FPGAPipeline_WriteInputBuffer(FPGA_Pipeline *pipeline, uint16_t *data, uint32_t length) {
    for (uint32_t i = 0; i < length; i++) {
        pipeline->inputBuffer[i] = data[i];
    }
}

void FPGAPipeline_ReadOutputBuffer(FPGA_Pipeline *pipeline, uint16_t *dest, uint32_t length) {
    for (uint32_t i = 0; i < length; i++) {
        dest[i] = pipeline->outputBuffer[i];
    }
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
    // if (programSize < core->imemSize) {
    //     for (uint32_t i = programSize; i < core->imemSize; i++) {
    //         core->imem[i] = 0;
    //     }
    // }
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

FPGA_CoreControlRegister FPGACore_GetControlRegister(FPGA_Core *core) {
    uint16_t regVal = *(core->address);

    FPGA_CoreControlRegister reg;
    reg.imemSize = regVal & 0xf800;
    reg.finished = BIT_HIGH(regVal, 2);
    reg.stopMode = BIT_HIGH(regVal, 1);
    reg.reset    = BIT_HIGH(regVal, 0);

    return reg;
}

void FPGACore_SetControlRegister(FPGA_Core *core, FPGA_CoreControlRegister reg) {
    uint32_t regVal = 0x0000;

    regVal = 0xf800 & (reg.imemSize << 11);

    if (reg.stopMode)
        regVal |= 0x2;

    if (reg.reset)
        regVal |= 0x1;

    *(core->address) = (uint16_t) regVal;
}

void FPGACore_Enable(FPGA_Core *core) {
    FPGA_CoreControlRegister reg = CORE_CTRL_REG_DEFAULT;
    reg.stopMode = false;

    FPGACore_SetControlRegister(core, reg);
}

void FPGACore_Disable(FPGA_Core *core) {
    FPGA_CoreControlRegister reg = CORE_CTRL_REG_DEFAULT;
    reg.stopMode = true;

    FPGACore_SetControlRegister(core, reg);
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
    pipeline->inputBuffer = (pipeline->address + P_INPUT_ADDR);
    pipeline->outputBuffer = (pipeline->address + P_OUTPUT_ADDR);
    pipeline->bufferSize = config->coreAddressSize;

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
    
    core->address = coreAddress;
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

/*******************************************
* FPGA Control                             *
*******************************************/

void FPGA_Enable(void) {
    // Set the FPGA Sample Clock low
    GPIO_PinOutClear(GPIO_PinOutClearPortF, 12);

    for (uint32_t i = 0; i < fpga.numPipelines; i++) {
        FPGA_Pipeline *p = &fpga.pipelines[i];

        for (uint32_t j = 0; j < p->numCores; i++) {
            FPGA_Core *c = &p->cores[i];

            FPGACore_Enable(c);
        }
    }
}

void FPGA_Disable(void) {
    for (uint32_t i = 0; i < fpga.numPipelines; i++) {
        FPGA_Pipeline *p = &fpga.pipelines[i];

        for (uint32_t j = 0; j < p->numCores; i++) {
            FPGA_Core *c = &p->cores[i];

            FPGACore_Disable(c);
        }
    }
}

void FPGA_ToggleClock(void) {
    // Toggle the FPGA Sample Clock
    GPIO_PinOutToggle(gpioPortF, 12);
}
