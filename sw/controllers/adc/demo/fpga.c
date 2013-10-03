#include "fpga.h"

static bool bufferPrimary;

uint16_t *primaryAudioInBuffer;
uint16_t *secondaryAudioInBuffer;
uint32_t *primaryAudioOutBuffer;
uint32_t *secondaryAudioOutBuffer;

void FPGA_Init( void ) 
{
	// Allocate Space in SRAM
  primaryAudioInBuffer    = EXT_SRAM_BASE_ADDRESS + ((sizeof(uint32_t) * BUFFER_SIZE) * 0);
	secondaryAudioInBuffer  = EXT_SRAM_BASE_ADDRESS + ((sizeof(uint32_t) * BUFFER_SIZE) * 1);
  primaryAudioOutBuffer   = EXT_SRAM_BASE_ADDRESS + ((sizeof(uint32_t) * BUFFER_SIZE) * 2);
  secondaryAudioOutBuffer = EXT_SRAM_BASE_ADDRESS + ((sizeof(uint32_t) * BUFFER_SIZE) * 3);
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
	return BUFFER_SIZE * 2;
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
	return BUFFER_SIZE;
}

void FPGA_SetBufferPrimary( bool primary ) 
{
	bufferPrimary = primary;
}

void PendSV_Handler(void)
{

	uint16_t *inBuf;
  uint32_t *outBuf;
  int32_t right;
  int32_t left;

	if (bufferPrimary)
		{
			inBuf  = primaryAudioInBuffer;
			outBuf = primaryAudioOutBuffer;
		}
  else
		{
			inBuf  = secondaryAudioInBuffer;
			outBuf = secondaryAudioOutBuffer;
		}

	int i=0; 
	for (; i<BUFFER_SIZE; i++) 
		{
			right = (int32_t) *inBuf++;
			left = (int32_t) *inBuf++;
			
			*(outBuf++) = ((uint32_t) left << 16) | (uint32_t) right;
		}

}
