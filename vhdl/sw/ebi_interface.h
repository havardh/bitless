// External Bus Interface Defines for interfacing with the FPGA

#ifndef FPGA_EBI_INTERFACE_H
#define FPGA_EBI_INTERFACE_H

// Constructs an address for indexing a specific module in the FPGA.
#define FPGA_EBI_ADDRESS(pipeline, device, address)
	((pipeline & 3) << 22 | (device & 0x1f) << 18 | (address & 0x3ffff))

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

// Layout of the pipeline control register (not to scale):
// |EN|     --- ZERO ---   |NUM_CORES|
#define FPGA_PIPELINE_CONTROL_EN		15	// Bitnumber of the enable bit
#define FPGA_PIPELINE_CONTROL_NUM_CORES		 0	// Bitnumber of the start of the 

// This register may get a field for size of the instruction memory and size of the ringbuffers

#define FPGA_PIPELINE_CONTROL_NUM_CORES_MASK	0x1f

#endif
