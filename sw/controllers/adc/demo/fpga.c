#include "fpga.h"

extern volatile bool preampProcessPrimary;

uint16_t *preampAudioInBuffer1;
uint16_t *preampAudioInBuffer2;
uint32_t *preampAudioOutBuffer1;
uint32_t *preampAudioOutBuffer2;

void FPGA_Init( void ) 
{ /*
	preampAudioInBuffer1 = (uint16_t*)malloc(sizeof(uint16_t) * BUFFER_SIZE * 2);
	preampAudioInBuffer2 = (uint16_t*)malloc(sizeof(uint16_t) * BUFFER_SIZE * 2);
	preampAudioOutBuffer1 = (uint16_t*)malloc(sizeof(uint32_t) * BUFFER_SIZE);
	preampAudioOutBuffer2 = (uint16_t*)malloc(sizeof(uint32_t) * BUFFER_SIZE);
	*/
	preampAudioInBuffer1 = EXT_SRAM_BASE_ADDRESS + ((sizeof(uint32_t) * BUFFER_SIZE) * 0);
	preampAudioInBuffer2 = EXT_SRAM_BASE_ADDRESS + ((sizeof(uint32_t) * BUFFER_SIZE) * 1);
	preampAudioOutBuffer1 = EXT_SRAM_BASE_ADDRESS + ((sizeof(uint32_t) * BUFFER_SIZE)* 2);
	preampAudioOutBuffer2 = EXT_SRAM_BASE_ADDRESS + ((sizeof(uint32_t) * BUFFER_SIZE)* 3);

}

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
