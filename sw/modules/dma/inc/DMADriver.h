#ifndef _DMADRIVER_H_
#define _DMADRIVER_H_

#include <stdint.h>
#include "em_device.h"
#include "em_dma.h"
#include "dmactrl.h"
#include "DMAConfig.h"
#include "MEMDriver.h"
#include "FPGADriver.h"


//#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define SAMPLE_RATE     44100
#define DMA_AUDIO_IN    0
#define DMA_AUDIO_OUT   1
#define PRS_CHANNEL     0

void DMADriver_Init();

#endif /* _DMADRIVER_H_ */
