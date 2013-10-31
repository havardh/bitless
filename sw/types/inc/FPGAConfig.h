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
    /* Size of the input and output buffers on the FPGA */
    uint32_t ctrlSize;
    /* ********************************************
    * FPGA base address, with a 23 bit address space
    * T   (1 bit): Always 1 when addressing the cores
    * P  (2 bits): Pipeline number
    * D  (4 bits): Device in pipeline
    * C  (2 bits): Core in pipeline
    * A (14 bits): Address space in the core,
    *              contains all the buffers, the imem and ctrl
    * ---------------------------------------------------------
    * | T | P P | D D D D | C C | A A A A A A A A A A A A A A |
    * ---------------------------------------------------------
    **********************************************/
    uint16_t *baseAddress;
} FPGAConfig;

#endif /* _FPGACONFIG_H_ */
