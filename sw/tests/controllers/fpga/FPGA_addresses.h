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
#define CORE_DEVICE_SIZE 		0x10000
#define CORE_ADDRESS_SIZE       0x4000

// conf is defined in the tests
#define PIPELINE0_START         (conf.baseAddress + 0x400000) // 1 00 0000 00 00000000000000
#define CORE0_CONTROL           (conf.baseAddress + 0x420000) // 1 00 0010 00 00000000000000
#define CORE0_IMEM              (conf.baseAddress + 0x424000) // 1 00 0010 01 00000000000000
#define CORE0_INPUT             (conf.baseAddress + 0x428000) // 1 00 0010 10 00000000000000 
#define CORE0_OUTPUT            (conf.baseAddress + 0x42C000) // 1 00 0010 11 00000000000000
#define CORE1_CONTROL           (conf.baseAddress + 0x430000) // 1 00 0011 00 00000000000000
#define CORE1_IMEM              (conf.baseAddress + 0x434000) // 1 00 0011 01 00000000000000
#define CORE1_INPUT             (conf.baseAddress + 0x438000) // 1 00 0011 10 00000000000000
#define CORE1_OUTPUT            (conf.baseAddress + 0x43C000) // 1 00 0011 11 00000000000000

#define PIPELINE1_START         (conf.baseAddress + 0x500000) // 1 01 0000 00 00000000000000
#define CORE4_CONTROL           (conf.baseAddress + 0x520000) // 1 01 0010 00 00000000000000
#define CORE4_IMEM              (conf.baseAddress + 0x524000) // 1 01 0010 01 00000000000000
#define CORE4_INPUT             (conf.baseAddress + 0x528000) // 1 01 0010 10 00000000000000
#define CORE4_OUTPUT            (conf.baseAddress + 0x52C000) // 1 01 0010 11 00000000000000
#define CORE7_CONTROL           (conf.baseAddress + 0x550000) // 1 01 0101 00 00000000000000
#define CORE7_IMEM              (conf.baseAddress + 0x554000) // 1 01 0101 01 00000000000000
#define CORE7_INPUT             (conf.baseAddress + 0x558000) // 1 01 0101 10 00000000000000
#define CORE7_OUTPUT            (conf.baseAddress + 0x55C000) // 1 01 0101 11 00000000000000

#endif /* _FPGA_ADDRESSES_H_ */
