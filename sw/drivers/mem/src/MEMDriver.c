#include "MEMDriver.h"

static bool bufferPrimary;
static int bufferSize;

static uint16_t *primaryAudioInBuffer;
static uint16_t *secondaryAudioInBuffer;
static uint16_t *primaryAudioOutBuffer;
static uint16_t *secondaryAudioOutBuffer;

void MEM_Init( void ) 
{
  bufferSize = 64;
  
  primaryAudioInBuffer    = malloc((sizeof(uint16_t) * bufferSize));
	secondaryAudioInBuffer  = malloc((sizeof(uint16_t) * bufferSize));
  primaryAudioOutBuffer   = malloc((sizeof(uint16_t) * bufferSize));
  secondaryAudioOutBuffer = malloc((sizeof(uint16_t) * bufferSize));

}

uint16_t* MEM_GetAudioInBuffer( bool primary ) 
{
	if (primary) 
	{
		return MEM_GetPrimaryAudioInBuffer();
	} else {
		return MEM_GetSecondaryAudioInBuffer();
	}
}

uint16_t* MEM_GetPrimaryAudioInBuffer( void ) 
{ 
  return primaryAudioInBuffer;
}

uint16_t* MEM_GetSecondaryAudioInBuffer( void ) 
{ 
  return secondaryAudioInBuffer;
}

int MEM_GetAudioInBufferSize( void ) 
{
  return bufferSize;
}

uint16_t* MEM_GetAudioOutBuffer( bool primary ) 
{ 
	if (primary) 
	{
		return MEM_GetPrimaryAudioOutBuffer();
	} else {
		return MEM_GetSecondaryAudioOutBuffer();
	}
}


uint16_t* MEM_GetPrimaryAudioOutBuffer( void ) 
{ 
  return primaryAudioOutBuffer;
}

uint16_t* MEM_GetSecondaryAudioOutBuffer( void ) 
{ 
  return secondaryAudioOutBuffer;
}

int MEM_GetAudioOutBufferSize( void ) 
{ 
  return bufferSize;
}

void MEM_SetBufferPrimary( bool primary ) 
{ 
  bufferPrimary = primary;
}

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
