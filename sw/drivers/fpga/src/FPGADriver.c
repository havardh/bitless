#include "FPGADriver.h"

static int numPipelines;
static int bufferSize;

static uint16_t** inBuffers;
static uint16_t** outBuffers;


// This emulates the FPGA in memory, a later version should map up the correct addresses on the EBI bus
void FPGADriver_Init( FPGAConfig *config ) 
{
  numPipelines = config->numPipelines;
  bufferSize   = config->bufferSize;

  inBuffers  = malloc(sizeof(uint16_t*) * numPipelines);
  outBuffers = malloc(sizeof(uint16_t*) * numPipelines);
  
  for (int i=0; i<numPipelines; i++) 
  {
    inBuffers[i]  = malloc(sizeof(uint16_t) * bufferSize);
    outBuffers[i] = malloc(sizeof(uint16_t) * bufferSize);
  }
  
}

void FPGADriver_Destroy( void ) 
{
  for (int i=0; i<numPipelines; i++) 
  {
    free( inBuffers[i] );
    free( outBuffers[i] );
  }
  free( inBuffers );
  free( outBuffers );
}

uint16_t* FPGADriver_GetInBuffer( int pipeline ) 
{
  return inBuffers[pipeline];
}

uint16_t* FPGADriver_GetOutBuffer( int pipeline ) 
{
  return outBuffers[pipeline];
}

void FPGADriver_CopyData( void )
{
	for (int i=0; i<numPipelines; i++) 
	{
		memcpy(outBuffers[i], inBuffers[i], bufferSize*2);
	}
}
