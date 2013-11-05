#ifndef _DMACONFIG_H_
#define _DMACONFIG_H_

#include <stdbool.h>

typedef enum {

	ADC_TO_DAC,
	ADC_TO_SD,
	SD_TO_DAC,
	SD_TO_SD

} Dataflow;

typedef struct {

	Dataflow mode;

	bool fgpaEnabled;

	bool adcEnabled;
	bool dacEnabled;

	bool fpgaInEnabled;
	bool fpgaOutEnabled;

} DMAConfig;

#define DMA_CONFIG_DEFAULT { ADC_TO_DAC, 0, 1, 0, 0, 0 };

#endif /* _DMACONFIG_H_ */
