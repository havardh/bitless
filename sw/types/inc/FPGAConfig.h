#ifndef _FPGACONFIG_H_
#define _FPGACONFIG_H_

typedef struct {

	void *baseAddress;

	int numPipelines;
	int numCores;
	int bufferSize;
	int instructionSize;

} FPGAConfig;

#endif /* _FPGACONFIG_H_ */
