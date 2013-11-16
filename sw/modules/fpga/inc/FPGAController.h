#ifndef _FPGACONTROLLER_H_
#define _FPGACONTROLLER_H_

#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include "FPGAConfig.h"
// #include "em_gpio.h"

typedef struct {
    uint32_t pos;
    uint32_t bufferSize;
    uint16_t *address;
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
    uint16_t *inputBuffer;
    uint16_t *outputBuffer;
    uint32_t bufferSize;
    FPGA_Core *cores;
} FPGA_Pipeline;

typedef struct {
    uint32_t numPipelines;
    uint16_t *baseAddress;
    uint16_t *controlRegister;
    FPGA_Pipeline *pipelines;
} FPGA_Processor;

#define CTRL_RESET_ADDR     0x8000 // 1000 0000 0000 0000
#define CTRL_BLINK_ADDR     0x2000 // 0010 0000 0000 0000
#define CTRL_LED0_ADDR      0x1000 // 0001 0000 0000 0000
#define CTRL_LED1_ADDR      0x0800 // 0000 1000 0000 0000
#define P_INPUT_ADDR        0x20000
#define P_OUTPUT_ADDR       0x30000

typedef struct {
    bool reset;
    uint32_t pipelines;
} FPGA_ControlRegister;

typedef struct {
    uint16_t firstCore;  /* First core with access to constant memory */
    uint16_t secondCore; /* Second core with access to constant memory */
    uint16_t numCores;
    bool stopMode;
    bool reset;
} FPGA_PipelineControlRegister;

typedef struct {
    uint32_t imemSize;
    bool finished;
    bool stopMode;
    bool reset;
} FPGA_CoreControlRegister;

#define PIPELINE_CTRL_REG_DEFAULT                   \
{   0, /* firstCore */                              \
    0, /* secondCore */                             \
    0, /* numCores */                               \
    false, /* stopMode */                           \
    false, /* reset */                              \
}

#define FPGA_CTRL_REG_DEFAULT                       \
{   false,  /* Reset, write only */                 \
    0,      /* Number of pipelines, read only */    \
}

/* FPGA Processor methods */
FPGA_Pipeline* FPGA_GetPipeline(uint32_t pipeline);
FPGA_Core* FPGA_GetCore(uint32_t pipeline, uint32_t core);
uint16_t* FPGA_GetBaseAddress(void);
FPGA_ControlRegister FPGA_GetControlRegister(void);
void FPGA_SetControlRegister(FPGA_ControlRegister controlRegister);
void FPGA_Reset(void);

/* FPGA Pipeline methods */
uint16_t* FPGAPipeline_GetInputBuffer(FPGA_Pipeline *pipeline);
uint16_t* FPGAPipeline_GetOutputBuffer(FPGA_Pipeline *pipeline);
void FPGAPipeline_WriteInputBuffer(FPGA_Pipeline *pipeline, uint16_t *data, uint32_t length);
void FPGAPipeline_ReadOutputBuffer(FPGA_Pipeline *pipeline, uint16_t *dest, uint32_t length);
FPGA_Core* FPGAPipeline_GetCore(FPGA_Pipeline *pipeline, uint32_t core);
FPGA_PipelineControlRegister FPGAPipeline_GetControlRegister(FPGA_Pipeline *pipeline);
void FPGAPipeline_SetControlRegister(FPGA_Pipeline *pipeline, FPGA_PipelineControlRegister reg);

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

/* FPGA Control */
void FPGA_Enable(void);
void FPGA_Disable(void);
void FPGA_ToggleClock(void);

#endif /* _FPGACONTROLLER_H_ */
