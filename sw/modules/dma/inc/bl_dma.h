#ifndef _DMADRIVER_H_
#define _DMADRIVER_H_

#include <stdint.h>
#include "em_device.h"
#include "em_dma.h"
#include "dmactrl.h"
#include "bl_mem.h"
#include "FPGADriver.h"
#include "INTDriver.h"
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

//#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define SAMPLE_RATE     44100
#define DMA_AUDIO_IN    0
#define DMA_AUDIO_OUT   1
#define PRS_CHANNEL     0

void DMADriver_Init( DMAConfig *config );
void DMADriver_StopDAC( void );

#endif /* _DMADRIVER_H_ */
