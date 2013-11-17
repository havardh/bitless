#include "CppUTest/CommandLineTestRunner.h"
#include "FPGAController.h"
#include "FPGADebug.h"
#include "FPGA_addresses.h"

static FPGAConfig conf;
static uint16_t *input_program;
static uint16_t *core_input_buffer;
static uint16_t *core_output_buffer;

TEST_GROUP(FPGADebug) {
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
        core_input_buffer = (uint16_t *) malloc(sizeof(uint16_t) * CORE_ADDRESS_SIZE);
        core_output_buffer = (uint16_t *) malloc(sizeof(uint16_t) * CORE_ADDRESS_SIZE);
    }
    void teardown() {
        FPGA_Destroy();
        free(conf.baseAddress);
        free(input_program);
        free(core_input_buffer);
        free(core_output_buffer);
    }
};

TEST(FPGADebug, should_set_and_get_core_inputBuffer) {
    for (uint16_t i = 0; i < CORE_ADDRESS_SIZE; i++) {
        core_input_buffer[i] = i;
    }

    uint16_t *c4_inputBuffer = (uint16_t *) malloc(sizeof(uint16_t) * CORE_ADDRESS_SIZE);

    FPGA_Core *c4 = FPGA_GetCore(1, 0);
    FPGADebug_SetCoreInputBuffer(c4, core_input_buffer);
    FPGADebug_GetCoreInputBuffer(c4, c4_inputBuffer);

    CHECK_EQUAL(core_input_buffer[50], c4_inputBuffer[50]);
    CHECK_EQUAL(core_input_buffer[1], 1);

    free(c4_inputBuffer);
}

TEST(FPGADebug, should_set_and_get_core_outputBuffer) {
    for (uint16_t i = 0; i < CORE_ADDRESS_SIZE; i++) {
        core_output_buffer[i] = i;
    }

    uint16_t *c4_outputBuffer = (uint16_t *) malloc(sizeof(uint16_t) * CORE_ADDRESS_SIZE);

    FPGA_Core *c4 = FPGA_GetCore(1, 0);
    FPGADebug_SetCoreOutputBuffer(c4, core_output_buffer);
    FPGADebug_GetCoreOutputBuffer(c4, c4_outputBuffer);

    CHECK_EQUAL(core_output_buffer[50], c4_outputBuffer[50]);
    CHECK_EQUAL(core_output_buffer[1], 1);

    free(c4_outputBuffer);
}

#include "FPGADebug.c"
