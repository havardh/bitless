#include "MEMDriver.h"

static int bufferSize;

static uint16_t *audioInBuffer;
static uint16_t *audioOutBuffer;

void MEM_Init( void ) 
{
  bufferSize = 64;
  
  audioInBuffer    = (uint16_t*)malloc((sizeof(uint16_t) * bufferSize));
  audioOutBuffer   = (uint16_t*)malloc((sizeof(uint16_t) * bufferSize));

}

uint16_t* MEM_GetAudioInBuffer( void ) 
{ 
  return audioInBuffer;
}

int MEM_GetAudioInBufferSize( void ) 
{
  return bufferSize;
}

uint16_t* MEM_GetAudioOutBuffer( void ) 
{ 
  return audioOutBuffer;
}

int MEM_GetAudioOutBufferSize( void ) 
{ 
  return bufferSize;
}

/*
void PendSV_Handler(void)
{
	
	uint16_t *inBuf  = MEM_GetAudioInBuffer( bufferPrimary );
	uint32_t *outBuf = MEM_GetAudioOutBuffer( bufferPrimary );

	for (int i=0; i<bufferSize; i++) 
		{
			int32_t right = (int32_t) *inBuf++;
			int32_t left = (int32_t) *inBuf++;
			
			*(outBuf++) = ((uint32_t) left << 16) | (uint32_t) right;
		}
	
}
*/
