#include "MEMDriver.h"

static int bufferSize;
static bool bufferPrimary;

static uint16_t *audioInBuffer;
static uint16_t *audioOutBuffer;


void MEM_Init( MEMConfig *config ) 
{
  bufferSize = config->bufferSize;

  audioInBuffer    = (uint16_t*)malloc((sizeof(uint16_t) * bufferSize*2));
  audioOutBuffer   = (uint16_t*)malloc((sizeof(uint16_t) * bufferSize*2));

	memset(audioInBuffer, 0, 2*bufferSize*sizeof(uint16_t));
	memset(audioOutBuffer, 0, 2*bufferSize*sizeof(uint16_t));

  /*uint16_t *InBufferSecondary    = (uint16_t*)malloc((sizeof(uint16_t) * bufferSize));
  uint16_t *OutBufferSecondary   = (uint16_t*)malloc((sizeof(uint16_t) * bufferSize));

	memset(audioInBufferSecondary, 0, 64*2);
	memset(audioOutBufferSecondary, 0, 64*2);*/


}

uint16_t* MEM_GetAudioInBuffer( bool primary ) 
{ 
	if (primary) {
		return audioInBuffer;
	} else {
		return 0; //audioInBufferSecondary;
	}
}

int MEM_GetAudioInBufferSize( void ) 
{
  return bufferSize;
}

uint16_t* MEM_GetAudioOutBuffer( bool primary ) 
{ 
	if (primary) {
		return audioOutBuffer;
	} else {
		return 0; //audioOutBufferSecondary;
	}
}

uint16_t* MEM_GetCurrentOutBuffer( void ) {
	return MEM_GetAudioOutBuffer(bufferPrimary);
}

int MEM_GetAudioOutBufferSize( void ) 
{ 
  return bufferSize;
}

void MEM_SetBufferPrimary( bool primary )
{
	bufferPrimary = primary;
}

void cpucpy() 
{
	uint16_t *inBuf  = MEM_GetAudioInBuffer( bufferPrimary );
	uint16_t *outBuf = MEM_GetAudioOutBuffer( bufferPrimary );
	
	for (int i=0; i<bufferSize; i++) 
	{
		outBuf[i] = inBuf[i];
	}

}

