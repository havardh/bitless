#include "CppUTest/CommandLineTestRunner.h"
#include "FPGAController.h"

#define NUM_PIPELINES           2
#define NUM_CORES               4
#define CORE_BUFFER_SIZE        100
#define CORE_IMEM_SIZE          200
#define CORE_OFFSET             (CORE_BUFFER_SIZE + CORE_IMEM_SIZE)
#define PIPELINE_MEMORY         (NUM_CORES * CORE_OFFSET + CORE_BUFFER_SIZE)
#define FPGA_MEMORY             (PIPELINE_MEMORY * NUM_PIPELINES)


FPGAConfig conf;
uint16_t *input_program;

TEST_GROUP(FPGAController) {
    void setup() {
        conf.numPipelines = NUM_PIPELINES;
        conf.numCores = NUM_CORES;
        conf.bufferSize = CORE_BUFFER_SIZE;
        conf.imemSize = CORE_IMEM_SIZE;
        conf.baseAddress = (uint16_t *) malloc(sizeof(uint16_t) * FPGA_MEMORY);

        FPGA_Init(&conf);

        input_program = (uint16_t *) malloc(sizeof(uint16_t) * CORE_IMEM_SIZE);
    }
    void teardown() {
        FPGA_Destroy();
        free(input_program);
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

TEST(FPGAController, core0_inputBuffer_equals_baseAddress) {
    FPGA_Core *c0 = FPGA_GetCore(0, 0);

    POINTERS_EQUAL(c0->inputBuffer, conf.baseAddress);
}

TEST(FPGAController, core0_outputBuffer_should_be_core1_inputBuffer) {
    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_Core *c1 = FPGA_GetCore(0, 1);

    POINTERS_EQUAL(c0->outputBuffer, c1->inputBuffer);
}

TEST(FPGAController, core0_inputBuffer_should_be_smaller_than_core3_inputBuffer) {
    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_Core *c1 = FPGA_GetCore(1, 0);

    CHECK(c0->inputBuffer != c1->inputBuffer);
    CHECK(c0->inputBuffer < c1->inputBuffer);
}

TEST(FPGAController, core1_outputBuffer_should_be_core2_inputBuffer) {
    FPGA_Core *c0 = FPGA_GetCore(0, 1);
    FPGA_Core *c1 = FPGA_GetCore(0, 2);

    POINTERS_EQUAL(c0->outputBuffer, c1->inputBuffer);
}

TEST(FPGAController, core2_has_valid_pointers) {
    FPGA_Core *c1 = FPGA_GetCore(0, 1);
    FPGA_Core *c2 = FPGA_GetCore(0, 2);
    FPGA_Core *c3 = FPGA_GetCore(0, 3);

    POINTERS_EQUAL(c1->outputBuffer, c2->inputBuffer);
    POINTERS_EQUAL(c2->outputBuffer, c3->inputBuffer);
    POINTERS_EQUAL(c2->imem, c2->inputBuffer + CORE_BUFFER_SIZE);
    POINTERS_EQUAL(c2->outputBuffer, c2->inputBuffer + CORE_OFFSET);
    POINTERS_EQUAL(c1->outputBuffer + CORE_OFFSET, c3->inputBuffer);
}

TEST(FPGAController, core3_outputBuffer_should_not_be_core4_inputBuffer) {
    FPGA_Core *c3 = FPGA_GetCore(0, 3);
    FPGA_Core *c4 = FPGA_GetCore(1, 0);

    CHECK(c3->outputBuffer != c4->inputBuffer);
    CHECK(c3->outputBuffer < c4->inputBuffer);
    POINTERS_EQUAL(c3->outputBuffer + CORE_BUFFER_SIZE, c4->inputBuffer);
}

TEST(FPGAController, pipeline0_inputbuffer_should_belong_to_core0) {
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);
    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    uint16_t *inputBuffer = FPGAPipeline_GetInputBuffer(p0);

    POINTERS_EQUAL(inputBuffer, c0->inputBuffer);
}

TEST(FPGAController, pipeline0_outputBuffer_should_belong_to_core3) {
    FPGA_Core *c3 = FPGA_GetCore(0, 3);
    FPGA_Pipeline *p0 = FPGA_GetPipeline(0);
    uint16_t *outputBuffer = FPGAPipeline_GetOutputBuffer(p0);

    POINTERS_EQUAL(outputBuffer, c3->outputBuffer);
}

TEST(FPGAController, pipeline1_inputbuffer_should_belong_to_core4) {
    FPGA_Pipeline *p1 = FPGA_GetPipeline(1);
    FPGA_Core *c0 = FPGA_GetCore(1, 0);
    uint16_t *inputBuffer = FPGAPipeline_GetInputBuffer(p1);

    POINTERS_EQUAL(inputBuffer, c0->inputBuffer);
}

TEST(FPGAController, pipeline0_memory_equals_first_half_of_fpga_memory) {
    uint16_t *pipline0_end = (conf.baseAddress + PIPELINE_MEMORY - 1);
    FPGA_Core *c3 = FPGA_GetCore(0, 3);

    POINTERS_EQUAL(c3->outputBuffer + CORE_BUFFER_SIZE - 1, pipline0_end);
}

TEST(FPGAController, pipeline1_outputBuffer_should_belong_to_core7) {
    FPGA_Core *c7 = FPGA_GetCore(1, 3);
    FPGA_Pipeline *p1 = FPGA_GetPipeline(1);
    uint16_t *outputBuffer = FPGAPipeline_GetOutputBuffer(p1);

    POINTERS_EQUAL(outputBuffer, c7->outputBuffer);
    POINTERS_EQUAL(c7->outputBuffer + CORE_BUFFER_SIZE - 1, conf.baseAddress + FPGA_MEMORY - 1);
}

TEST(FPGAController, set_and_get_core_programs) {
    for (uint16_t i = 0; i < CORE_IMEM_SIZE; i++) {
        input_program[i] = i;
    }

    FPGA_Core *c0 = FPGA_GetCore(0, 0);
    FPGA_Core *c7 = FPGA_GetCore(1, 3);

    FPGACore_SetProgram(c0, input_program, CORE_IMEM_SIZE);
    FPGACore_SetProgram(c7, input_program, CORE_IMEM_SIZE / 2);

    uint16_t *prog = (uint16_t *) malloc(sizeof(uint16_t) * CORE_IMEM_SIZE);
    
    FPGACore_GetProgram(c0, prog);
    CHECK_EQUAL(prog[0], 0);
    CHECK_EQUAL(prog[CORE_IMEM_SIZE-1], CORE_IMEM_SIZE-1);
    CHECK_EQUAL(prog[CORE_IMEM_SIZE-1], input_program[CORE_IMEM_SIZE-1]);

    FPGACore_GetProgram(c7, prog);
    CHECK_EQUAL(prog[0], 0);
    CHECK_EQUAL(prog[CORE_IMEM_SIZE / 2 - 1], CORE_IMEM_SIZE / 2 - 1);
    CHECK_EQUAL(prog[CORE_IMEM_SIZE-1], 0);

    free(prog);
}


#include "FPGAController.c"
