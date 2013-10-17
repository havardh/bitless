#ifndef _FPGACONFIG_H_
#define _FPGACONFIG_H_

typedef struct {
    /* Number of pipelines in the FPGA */
    uint32_t numPipelines;
    /* Number of cores in each pipeline */
    uint32_t numCores;
    /* Size of the input and output buffers on the FPGA */
    uint32_t bufferSize;
    /* Size of instruction memory for each core */
    uint32_t imemSize;
    /* ********************************************
    * FPGA base address, with the following memory layout:
    *    -------------------------------------------------------------------------------
    * P0:|C(0)_IN    |C(0)_IMEM    |C(0)_OUT    |.....|C(N/2)_IN|C(N/2)_IMEM|C(N/2)_OUT|
    *    -------------------------------------------------------------------------------
    * P1:|C(N/2+1)_IN|C(N/2+1)_IMEM|C(N/2+1)_OUT|.....|C(N)_IN  |C(N)_IMEM  |C(N)_OUT  |
    *    -------------------------------------------------------------------------------
    **********************************************/
    uint16_t *baseAddress;
} FPGAConfig;

#endif /* _FPGACONFIG_H_ */
