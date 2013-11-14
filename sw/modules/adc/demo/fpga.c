#include "fpga.h"

static bool bufferPrimary;

int bufferSize;

uint16_t *primaryAudioInBuffer;
uint16_t *secondaryAudioInBuffer;
uint32_t *primaryAudioOutBuffer;
uint32_t *secondaryAudioOutBuffer;

void FPGA_Init( FPGAConfig *config ) 
{
	bufferSize = config->bufferSize;

	// Allocate Space in SRAM
  primaryAudioInBuffer    = config->baseAddress + ((sizeof(uint32_t) * bufferSize) * 0);
	secondaryAudioInBuffer  = config->baseAddress + ((sizeof(uint32_t) * bufferSize) * 1);
  primaryAudioOutBuffer   = config->baseAddress + ((sizeof(uint32_t) * bufferSize) * 2);
  secondaryAudioOutBuffer = config->baseAddress + ((sizeof(uint32_t) * bufferSize) * 3);
}

uint16_t* FPGA_GetAudioInBuffer( bool primary ) 
{
	if (primary) 
	{
		return FPGA_GetPrimaryAudioInBuffer();
	} else {
		return FPGA_GetSecondaryAudioInBuffer();
	}
}

uint16_t* FPGA_GetPrimaryAudioInBuffer( void ) 
{
	return primaryAudioInBuffer;
}

uint16_t* FPGA_GetSecondaryAudioInBuffer( void )
{
	return secondaryAudioInBuffer;
}

int FPGA_GetAudioInBufferSize( void ) 
{
	return bufferSize * 2;
}

uint16_t* FPGA_GetAudioOutBuffer( bool primary ) 
{
	if (primary) 
	{
		return FPGA_GetPrimaryAudioOutBuffer();
	} else {
		return FPGA_GetSecondaryAudioOutBuffer();
	}
}

uint32_t* FPGA_GetPrimaryAudioOutBuffer( void )
{
	return primaryAudioOutBuffer;
}

uint32_t* FPGA_GetSecondaryAudioOutBuffer( void ) 
{
	return secondaryAudioOutBuffer;
}

int FPGA_GetAudioOutBufferSize( void ) 
{
	return bufferSize;
}

void FPGA_SetBufferPrimary( bool primary ) 
{
	bufferPrimary = primary;
}

/*void PendSV_Handler(void)
{

	uint16_t *inBuf;
  uint32_t *outBuf;
  int32_t right;
  int32_t left;

	inBuf = FPGA_GetAudioInBuffer( bufferPrimary );
	outBuf = FPGA_GetAudioOutBuffer( bufferPrimary );

	int i=0; 
	for (; i<bufferSize; i++) 
		{
			right = (int32_t) *inBuf++;
			left = (int32_t) *inBuf++;
			
			*(outBuf++) = ((uint32_t) left << 16) | (uint32_t) right;
		}

    }*/
