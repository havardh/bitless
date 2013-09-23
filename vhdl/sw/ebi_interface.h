// External Bus Interface Defines for interfacing with the FPGA

#ifndef FPGA_EBI_INTERFACE_H
#define FPGA_EBI_INTERFACE_H

// Constructs an address for indexing a specific module in the FPGA.
#define FPGA_EBI_ADDRESS(pipeline, device, address)
	((pipeline & 3) << 26 | (device & 0x1f) << 21 | (address & 0xfffff))

// Device number for accessing the control register of a pipeline:
#define FPGA_PIPELINE_CONTROL	0
// Device number for accessing the input buffer of a pipeline:
#define FPGA_PIPELINE_INPUT	1
// Device number for accessing the output buffer of a pipeline:
#define FPGA_PIPELINE_OUTPUT	2
// Device number for accessing the constant register of a pipeline:
#define FPGA_PIPELINE_CONSTANT	3
// Device number for accessing a core in a pipeline (0 indexed):
#define FPGA_PIPELINE_CORE(x)	(x + 4)

#endif
