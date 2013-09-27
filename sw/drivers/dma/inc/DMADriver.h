#ifndef _DMADRIVER_H_
#define _DMADRIVER_H_

#include "em_device.h"
#include "em_dma.h"
#include "dmactrl.h"
#include "DMAConfig.h"

#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define SAMPLE_RATE     44100
#define DMA_AUDIO_IN    0
#define DMA_AUDIO_OUT   1
#define PRS_CHANNEL     0
/*
extern volatile bool preampProcessPrimary;

extern uint16_t preampAudioInBuffer1[BUFFER_SIZE * 2];
extern uint16_t preampAudioInBuffer2[BUFFER_SIZE * 2];

extern uint32_t preampAudioOutBuffer1[BUFFER_SIZE];
extern uint32_t preampAudioOutBuffer2[BUFFER_SIZE];
*/
void DMADriver_Init();

#endif /* _DMADRIVER_H_ */
