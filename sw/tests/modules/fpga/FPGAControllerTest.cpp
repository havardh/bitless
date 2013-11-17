#include "CppUTest/CommandLineTestRunner.h"
#include "CppUTestExt/MockSupport.h"
#include "FPGAController.h"
#include "FPGA_addresses.h"
#include <stdio.h>

// #define malloc cpputest_malloc

static FPGAConfig conf;
static uint16_t *input_program;

TEST_GROUP(FPGAController) {
    void setup() {
        conf.numPipelines = NUM_PIPELINES;
        conf.numCores = NUM_CORES;
        conf.baseAddress = (uint16_t *) malloc(sizeof(uint16_t) * FPGA_ADDRESS_SIZE);
        conf.toplevelAddress = TOPLEVEL_REGISTER;
        conf.pipelineAddressSize = PIPELINE_ADDRESS_SIZE;
        conf.coreDeviceAddress = CORE_DEVICE_ADDRESS;
        conf.coreDeviceSize = CORE_DEVICE_SIZE;
        conf.coreAddressSize = CORE_ADDRESS_SIZE;

        FPGA_Init(&conf);
        
        input_program = (uint16_t *) malloc(sizeof(uint16_t) * CORE_ADDRESS_SIZE);
    }
    void teardown() {
        FPGA_Destroy();
        free(input_program);
        free(conf.baseAddress);
    }
};

TEST(FPGAController, should_have_2_pipelines) {
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);
    FPGA_Pipeline *p1 = FPGA_GetPipeline(1);
    FPGA_Pipeline *p2 = FPGA_GetPipeline(2);

    CHECK(p0);
    CHECK(p1);
    CHECK(p0 < p1);
    POINTERS_EQUAL(p2, NULL);
}

TEST(FPGAController, pipeline_has_address) {
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);

    CHECK(p0->address);
    POINTERS_EQUAL(PIPELINE0_START, p0->address);
}

TEST(FPGAController, pipeline_has_four_cores) {
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);

    FPGA_Core *c0 = FPGAPipeline_GetCore(p0, 0);
    FPGA_Core *c1 = FPGAPipeline_GetCore(p0, 1);
    FPGA_Core *c2 = FPGAPipeline_GetCore(p0, 2);
    FPGA_Core *c3 = FPGAPipeline_GetCore(p0, 3);
    FPGA_Core *c4 = FPGAPipeline_GetCore(p0, 4);

    CHECK(c0);
    CHECK(c1);
    CHECK(c2);
    CHECK(c3);
    POINTERS_EQUAL(NULL, c4);
}

TEST(FPGAController, pipeline1_has_right_address) {
    FPGA_Pipeline *p1 = FPGA_GetPipeline(1);

    CHECK(p1->address);
    POINTERS_EQUAL(PIPELINE1_START, p1->address);
}

TEST(FPGAController, core0_memory_addresses_is_right) {
    FPGA_Core *c0 = FPGA_GetCore(0, 0);

    POINTERS_EQUAL(CORE0_INPUT, c0->inputBuffer);
    POINTERS_EQUAL(CORE0_IMEM, c0->imem);
    POINTERS_EQUAL(CORE0_CONTROL, c0->ctrlmem);
    POINTERS_EQUAL(CORE0_OUTPUT, c0->outputBuffer);
}

TEST(FPGAController, core1_inputBuffer_is_right) {
    FPGA_Core *c1 = FPGA_GetCore(0, 1);

    POINTERS_EQUAL(CORE1_INPUT, c1->inputBuffer);
}

TEST(FPGAController, core0_outputBuffer_should_be_smaller_than_core1_inputBuffer) {
    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_Core *c1 = FPGA_GetCore(0, 1);

    CHECK(c0->inputBuffer < c1->inputBuffer);
}

TEST(FPGAController, core1_outputbuffer_is_right) {
    FPGA_Core *c1 = FPGA_GetCore(0, 1);

    POINTERS_EQUAL(CORE1_OUTPUT, c1->outputBuffer);
}

TEST(FPGAController, core0_inputBuffer_should_be_smaller_than_core3_inputBuffer) {
    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_Core *c1 = FPGA_GetCore(1, 0);

    CHECK(c0->inputBuffer != c1->inputBuffer);
    CHECK(c0->inputBuffer < c1->inputBuffer);
}

TEST(FPGAController, pipeline0_inputbuffer_should_be_right) {
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);
    uint16_t *inputBuffer = FPGAPipeline_GetInputBuffer(p0);

    POINTERS_EQUAL(inputBuffer, PIPELINE0_INPUT);
}

TEST(FPGAController, pipeline0_outputBuffer_should_be_right) {
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);
    uint16_t *outputBuffer = FPGAPipeline_GetOutputBuffer(p0);

    POINTERS_EQUAL(PIPELINE0_OUTPUT, outputBuffer);
}

TEST(FPGAController, pipeline1_inputbuffer_should_be_right) {
    FPGA_Pipeline *p1 = FPGA_GetPipeline(1);
    uint16_t *inputBuffer = FPGAPipeline_GetInputBuffer(p1);

    POINTERS_EQUAL(inputBuffer, PIPELINE1_INPUT);
}

TEST(FPGAController, core4_memory_addresses_is_right) {
    FPGA_Core *c4 = FPGA_GetCore(1, 0);

    POINTERS_EQUAL(CORE4_INPUT, c4->inputBuffer);
    POINTERS_EQUAL(CORE4_IMEM, c4->imem);
    POINTERS_EQUAL(CORE4_CONTROL, c4->ctrlmem);
    POINTERS_EQUAL(CORE4_OUTPUT, c4->outputBuffer);
}

TEST(FPGAController, pipeline1_outputBuffer_should_be_right) {
    FPGA_Pipeline *p1 = FPGA_GetPipeline(1);
    uint16_t *outputBuffer = FPGAPipeline_GetOutputBuffer(p1);

    POINTERS_EQUAL(PIPELINE1_OUTPUT, outputBuffer);
}

TEST(FPGAController, core7_memory_addresses_is_right) {
    FPGA_Core *c7 = FPGA_GetCore(1, 3);

    POINTERS_EQUAL(CORE7_INPUT, c7->inputBuffer);
    POINTERS_EQUAL(CORE7_IMEM, c7->imem);
    POINTERS_EQUAL(CORE7_CONTROL, c7->ctrlmem);
    POINTERS_EQUAL(CORE7_OUTPUT, c7->outputBuffer);
}

TEST(FPGAController, should_set_and_get_core_programs) {
    for (uint16_t i = 0; i < CORE_ADDRESS_SIZE; i++) {
        input_program[i] = i;
    }

    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_Core *c7 = FPGA_GetCore(1, 3);

    FPGACore_SetProgram(c0, input_program, CORE_ADDRESS_SIZE);
    FPGACore_SetProgram(c7, input_program, CORE_ADDRESS_SIZE / 2);

    uint16_t *prog = (uint16_t *) malloc(sizeof(uint16_t)    * CORE_ADDRESS_SIZE);
    
    FPGACore_GetProgram(c0, prog);
    CHECK_EQUAL(prog[0], 0);
    CHECK_EQUAL(prog[CORE_ADDRESS_SIZE-1], CORE_ADDRESS_SIZE-1);
    CHECK_EQUAL(prog[CORE_ADDRESS_SIZE-1], input_program[CORE_ADDRESS_SIZE-1]);

    FPGACore_GetProgram(c7, prog);
    CHECK_EQUAL(prog[0], 0);
    CHECK_EQUAL(prog[CORE_ADDRESS_SIZE / 2 - 1], CORE_ADDRESS_SIZE / 2 - 1);
    // CHECK_EQUAL(prog[CORE_ADDRESS_SIZE-1], 0);

    free(prog);
}

TEST(FPGAController, should_set_and_get_core_control) {
    for (uint16_t i = 0; i < CORE_ADDRESS_SIZE; i++) {
        input_program[i] = i;
    }

    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_Core *c7 = FPGA_GetCore(1, 3);

    FPGACore_SetControls(c0, input_program, CORE_ADDRESS_SIZE);
    FPGACore_SetControls(c7, input_program, CORE_ADDRESS_SIZE / 2);

    uint16_t *prog = (uint16_t *) malloc(sizeof(uint16_t) * CORE_ADDRESS_SIZE);
    
    FPGACore_GetControls(c0, prog);
    CHECK_EQUAL(prog[0], 0);
    CHECK_EQUAL(prog[CORE_ADDRESS_SIZE-1], CORE_ADDRESS_SIZE-1);
    CHECK_EQUAL(prog[CORE_ADDRESS_SIZE-1], input_program[CORE_ADDRESS_SIZE-1]);

    FPGACore_GetControls(c7, prog);
    CHECK_EQUAL(prog[0], 0);
    CHECK_EQUAL(prog[CORE_ADDRESS_SIZE / 2 - 1], CORE_ADDRESS_SIZE / 2 - 1);
    CHECK_EQUAL(prog[CORE_ADDRESS_SIZE-1], 0);

    free(prog);
}

TEST(FPGAController, set_core_ctrl_reg) {
    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_CoreControlRegister reg = CORE_CTRL_REG_DEFAULT;

    reg.finished = true;
    reg.stopMode = true;
    reg.reset = true;
    reg.imemSize = 10;

    FPGACore_SetControlRegister(c0, reg);
    CHECK_EQUAL(0x5003, *c0->address);

    reg.imemSize = 0;
    
    FPGACore_SetControlRegister(c0, reg);
    CHECK_EQUAL(0x3, *c0->address);

    reg.stopMode = false;
    FPGACore_SetControlRegister(c0, reg);
    CHECK_EQUAL(0x1, *c0->address);

    reg.finished = false;
    FPGACore_SetControlRegister(c0, reg);
    CHECK_EQUAL(0x1, *c0->address);

}

TEST(FPGAController, get_core_ctrl_reg) {
    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_CoreControlRegister reg = CORE_CTRL_REG_DEFAULT,
                             reg2;
    reg.finished = true;
    reg.stopMode = true;
    reg.reset = true;

    FPGACore_SetControlRegister(c0, reg);
    reg2 = FPGACore_GetControlRegister(c0);

    CHECK_EQUAL(false, reg2.finished);
    CHECK_EQUAL(reg.stopMode, reg2.stopMode);
    CHECK_EQUAL(reg.reset, reg2.reset);
}

TEST(FPGAController, set_pipieline_ctrl_reg) {
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);
    FPGA_PipelineControlRegister reg = PIPELINE_CTRL_REG_DEFAULT;

    reg.firstCore = 1;
    reg.secondCore = 2;
    reg.numCores = 4;
    reg.stopMode = true;
    reg.reset = true;

    FPGAPipeline_SetControlRegister(p0, reg);
    CHECK_EQUAL(0x12c4, *p0->address);
}

TEST(FPGAController, get_pipeline_ctrl_register) {
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);
    FPGA_PipelineControlRegister reg = PIPELINE_CTRL_REG_DEFAULT,
                                 reg2;
    reg.firstCore = 4;
    reg.secondCore = 9;
    reg.numCores = 11;
    reg.stopMode = true;
    reg.reset = true;
    FPGAPipeline_SetControlRegister(p0, reg);
    reg2 = FPGAPipeline_GetControlRegister(p0);

    CHECK_EQUAL(reg.firstCore, reg2.firstCore);
    CHECK_EQUAL(reg.secondCore, reg2.secondCore);
    CHECK_EQUAL(reg.numCores, reg2.numCores);
    CHECK_EQUAL(reg.stopMode, reg2.stopMode);
    CHECK_EQUAL(reg.reset, reg2.reset);
}

#include "FPGAController.c"
