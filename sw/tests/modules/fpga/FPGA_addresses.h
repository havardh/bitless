#ifndef _FPGA_ADDRESSES_H_
#define _FPGA_ADDRESSES_H_

#define NUM_PIPELINES           2
#define NUM_CORES               4

#define FPGA_ADDRESS_SIZE       0x800000
#define TOPLEVEL_REGISTER       0x400000
#define PIPELINE_ADDRESS_SIZE   0x100000
#define CORE_DEVICE_ADDRESS     0x20000
#define CORE_DEVICE_SIZE 		0x10000
#define CORE_ADDRESS_SIZE       0x4000

// conf is defined in the tests                                  T PP DDDD CC AAAAAAAAAAAAAA
#define PIPELINE0_START         (conf.baseAddress + 0x000000) // 0 00 0000 00 00000000000000
#define CORE0_CONTROL           (conf.baseAddress + 0x020000) // 0 00 0010 00 00000000000000
#define CORE0_IMEM              (conf.baseAddress + 0x024000) // 0 00 0010 01 00000000000000
#define CORE0_INPUT             (conf.baseAddress + 0x028000) // 0 00 0010 10 00000000000000 
#define CORE0_OUTPUT            (conf.baseAddress + 0x02C000) // 0 00 0010 11 00000000000000
#define CORE1_CONTROL           (conf.baseAddress + 0x030000) // 0 00 0011 00 00000000000000
#define CORE1_IMEM              (conf.baseAddress + 0x034000) // 0 00 0011 01 00000000000000
#define CORE1_INPUT             (conf.baseAddress + 0x038000) // 0 00 0011 10 00000000000000
#define CORE1_OUTPUT            (conf.baseAddress + 0x03C000) // 0 00 0011 11 00000000000000

#define PIPELINE1_START         (conf.baseAddress + 0x100000) // 0 01 0000 00 00000000000000
#define CORE4_CONTROL           (conf.baseAddress + 0x120000) // 0 01 0010 00 00000000000000
#define CORE4_IMEM              (conf.baseAddress + 0x124000) // 0 01 0010 01 00000000000000
#define CORE4_INPUT             (conf.baseAddress + 0x128000) // 0 01 0010 10 00000000000000
#define CORE4_OUTPUT            (conf.baseAddress + 0x12C000) // 0 01 0010 11 00000000000000
#define CORE7_CONTROL           (conf.baseAddress + 0x150000) // 0 01 0101 00 00000000000000
#define CORE7_IMEM              (conf.baseAddress + 0x154000) // 0 01 0101 01 00000000000000
#define CORE7_INPUT             (conf.baseAddress + 0x158000) // 0 01 0101 10 00000000000000
#define CORE7_OUTPUT            (conf.baseAddress + 0x15C000) // 0 01 0101 11 00000000000000

#endif /* _FPGA_ADDRESSES_H_ */
