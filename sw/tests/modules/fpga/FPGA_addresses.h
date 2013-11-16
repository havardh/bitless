#ifndef _FPGA_ADDRESSES_H_
#define _FPGA_ADDRESSES_H_

#define NUM_PIPELINES           2
#define NUM_CORES               4

#define FPGA_ADDRESS_SIZE       0x800000
#define TOPLEVEL_REGISTER       0x400000
#define PIPELINE_ADDRESS_SIZE   0x100000
#define CORE_DEVICE_ADDRESS     0x40000
#define CORE_DEVICE_SIZE        0x10000
#define CORE_ADDRESS_SIZE       0x4000

// conf is defined in the tests                                  0 00 0100 01 00000000000000 - Core 0 ins_mem
#define PIPELINE0_START         (conf.baseAddress + 0x000000) // 0 00 0000 00 00000000000000
#define PIPELINE0_INPUT         (conf.baseAddress + 0x020000) // 0 00 0010 00 00000000000000
#define PIPELINE0_OUTPUT        (conf.baseAddress + 0x030000) // 0 00 0011 00 00000000000000
#define CORE0_CONTROL           (conf.baseAddress + 0x040000) // 0 00 0100 00 00000000000000
#define CORE0_IMEM              (conf.baseAddress + 0x044000) // 0 00 0100 01 00000000000000
#define CORE0_INPUT             (conf.baseAddress + 0x048000) // 0 00 0100 10 00000000000000 
#define CORE0_OUTPUT            (conf.baseAddress + 0x04C000) // 0 00 0100 11 00000000000000
#define CORE1_CONTROL           (conf.baseAddress + 0x050000) // 0 00 0101 00 00000000000000
#define CORE1_IMEM              (conf.baseAddress + 0x054000) // 0 00 0101 01 00000000000000
#define CORE1_INPUT             (conf.baseAddress + 0x058000) // 0 00 0101 10 00000000000000
#define CORE1_OUTPUT            (conf.baseAddress + 0x05C000) // 0 00 0101 11 00000000000000

#define PIPELINE1_START         (conf.baseAddress + 0x100000) // 0 01 0000 00 00000000000000
#define PIPELINE1_INPUT         (conf.baseAddress + 0x120000) // 0 01 0010 00 00000000000000
#define PIPELINE1_OUTPUT        (conf.baseAddress + 0x130000) // 0 01 0011 00 00000000000000
#define CORE4_CONTROL           (conf.baseAddress + 0x140000) // 0 01 0100 00 00000000000000
#define CORE4_IMEM              (conf.baseAddress + 0x144000) // 0 01 0100 01 00000000000000
#define CORE4_INPUT             (conf.baseAddress + 0x148000) // 0 01 0100 10 00000000000000
#define CORE4_OUTPUT            (conf.baseAddress + 0x14C000) // 0 01 0100 11 00000000000000
#define CORE7_CONTROL           (conf.baseAddress + 0x170000) // 0 01 0111 00 00000000000000
#define CORE7_IMEM              (conf.baseAddress + 0x174000) // 0 01 0111 01 00000000000000
#define CORE7_INPUT             (conf.baseAddress + 0x178000) // 0 01 0111 10 00000000000000
#define CORE7_OUTPUT            (conf.baseAddress + 0x17C000) // 0 01 0111 11 00000000000000

#endif /* _FPGA_ADDRESSES_H_ */
