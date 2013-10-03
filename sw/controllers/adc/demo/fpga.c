#include "fpga.h"

extern volatile bool preampProcessPrimary;

uint16_t preampAudioInBuffer1[BUFFER_SIZE * 2];
uint16_t preampAudioInBuffer2[BUFFER_SIZE * 2];
uint32_t preampAudioOutBuffer1[BUFFER_SIZE];
uint32_t preampAudioOutBuffer2[BUFFER_SIZE];

void PendSV_Handler(void)
{

	uint16_t *inBuf;
  uint32_t *outBuf;
  int32_t right;
  int32_t left;

	if (preampProcessPrimary)
		{
			inBuf  = preampAudioInBuffer1;
			outBuf = preampAudioOutBuffer1;
		}
  else
		{
			inBuf  = preampAudioInBuffer2;
			outBuf = preampAudioOutBuffer2;
		}

	int i=0; 
	for (; i<BUFFER_SIZE; i++) 
		{
			right = (int32_t) *inBuf++;
			left = (int32_t) *inBuf++;
			
			*(outBuf++) = ((uint32_t) left << 16) | (uint32_t) right;
		}

}
