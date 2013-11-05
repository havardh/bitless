#ifndef _DMACONFIG_H_
#define _DMACONFIG_H_

#include <stdbool.h>

typedef struct {

	bool adcEnabled;
	bool dacEnabled;

	bool fpgaInEnabled;
	bool fpgaOutEnabled;

} DMAConfig;

#define DMA_CONFIG_DEFAULT { 0, 0, 0, 0 };

#endif /* _DMACONFIG_H_ */
