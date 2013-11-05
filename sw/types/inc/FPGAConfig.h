#ifndef _FPGACONFIG_H_
#define _FPGACONFIG_H_

typedef struct {
    /* Number of pipelines in the FPGA */
    uint32_t numPipelines;
    /* Number of cores in each pipeline */
    uint32_t numCores;
    /* Size of the input and output buffers on the FPGA */
    /* ********************************************
    * FPGA base address, a 23 bit address space will look like this
    * T   (1 bit): Always 0 when addressing the cores
    * P  (2 bits): Pipeline number
    * D  (4 bits): Device in pipeline, the cores starts at 2
    * C  (2 bits): Type of core memory (buffers, imem, control)
    * A (14 bits): Address space in the core
    * ---------------------------------------------------------
    * | T | P P | D D D D | C C | A A A A A A A A A A A A A A |
    * ---------------------------------------------------------
    **********************************************/
    uint16_t *baseAddress;
    /* Relative address, from 'baseAddress', to the first pipeline */
    uint32_t toplevelAddress;
    /* The address size of each pipeline */
    uint32_t pipelineAddressSize;
    /* The address for the first core device in the pipeline (when DDDD is 0010)*/
    uint32_t coreDeviceAddress;
    /* The size for one core */
    uint32_t coreDeviceSize;
    /* The address size for each of the core's different memories */
    uint32_t coreAddressSize;
} FPGAConfig;

#define DEFAULT_NUM_PIPELINES           2
#define DEFAULT_NUM_CORES               4
#define DEFAULT_TOPLEVEL_ADDRESS        0x400000
#define DEFAULT_PIPELINE_ADDRESS_SIZE   0x100000
#define DEFAULT_CORE_DEVICE_ADDRESS     0x20000
#define DEFAULT_CORE_DEVICE_SIZE        0x10000
#define DEFAULT_CORE_ADDRESS_SIZE       0x4000
#define DEFAULT_FPGA_ADDRESS_SIZE       0x800000
    
#endif /* _FPGACONFIG_H_ */
