#ifndef _FPGA_ADDRESSES_H_
#define _FPGA_ADDRESSES_H_

#define NUM_PIPELINES           2
#define NUM_CORES               4
#define CORE_BUFFER_SIZE        4096
#define CORE_IMEM_SIZE          4096
#define CORE_CONTROL_SIZE       4096

#define FPGA_ADDRESS_SIZE       0x800000
#define TOPLEVEL_ADDRESS        0x400000
#define PIPELINE_ADDRESS_SIZE   0x100000
#define CORE_DEVICE_ADDRESS     0x20000
#define CORE_ADDRESS_SIZE       0x4000

// conf is defined in the tests
#define PIPELINE0_START         (conf.baseAddress + 0x400000) // 1 00 0000 00 00000000000000
#define CORE0_INPUT             (conf.baseAddress + 0x420000) // 1 00 0010 00 00000000000000
#define CORE0_IMEM              (conf.baseAddress + 0x421000) // 1 00 0010 00 01000000000000
#define CORE0_CONTROL           (conf.baseAddress + 0x422000) // 1 00 0010 00 10000000000000
#define CORE0_OUTPUT            (conf.baseAddress + 0x423000) // 1 00 0010 00 11000000000000
#define CORE1_INPUT             (conf.baseAddress + 0x424000) // 1 00 0010 01 00000000000000
#define CORE1_IMEM              (conf.baseAddress + 0x425000) // 1 00 0010 01 01000000000000
#define CORE1_CONTROL           (conf.baseAddress + 0x426000) // 1 00 0010 01 10000000000000
#define CORE1_OUTPUT            (conf.baseAddress + 0x427000) // 1 00 0010 01 11000000000000

#define PIPELINE1_START         (conf.baseAddress + 0x500000) // 1 01 0000 00 00000000000000
#define CORE4_INPUT             (conf.baseAddress + 0x520000) // 1 01 0010 00 00000000000000
#define CORE4_IMEM              (conf.baseAddress + 0x521000) // 1 01 0010 00 01000000000000
#define CORE4_CONTROL           (conf.baseAddress + 0x522000) // 1 01 0010 00 10000000000000
#define CORE4_OUTPUT            (conf.baseAddress + 0x523000) // 1 01 0010 00 11000000000000
#define CORE7_INPUT             (conf.baseAddress + 0x52C000) // 1 01 0010 11 00000000000000
#define CORE7_IMEM              (conf.baseAddress + 0x52D000) // 1 01 0010 11 01000000000000
#define CORE7_CONTROL           (conf.baseAddress + 0x52E000) // 1 01 0010 11 10000000000000
#define CORE7_OUTPUT            (conf.baseAddress + 0x52F000) // 1 01 0010 11 11000000000000

#endif /* _FPGA_ADDRESSES_H_ */
