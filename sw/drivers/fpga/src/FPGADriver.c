#include "FPGADriver.h"

static int numPipelines;
static int bufferSize;

//static uint16_t** inBuffers;
//static uint16_t** outBuffers;

static CircularBuffer *inBuffers;
static CircularBuffer *outBuffers;

// This emulates the FPGA in memory, a later version should map up the correct addresses on the EBI bus
void FPGADriver_Init( FPGAConfig *config ) 
{
  numPipelines = config->numPipelines;
  bufferSize   = config->bufferSize;

  inBuffers  = malloc(sizeof(CircularBuffer) * numPipelines);
  outBuffers = malloc(sizeof(CircularBuffer) * numPipelines);
  
  for (int i=0; i<numPipelines; i++) 
  {
    inBuffers[i]  = CircularBuffer_New(malloc(sizeof(uint16_t) * 64*4), 64*4, 4);
    outBuffers[i] = CircularBuffer_New(malloc(sizeof(uint16_t) * 64*4), 64*4, 4);
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

void FPGADriver_NotifyDMACycleComplete( void ) 
{
	for (int i=0; i<numPipelines; i++) {
		CircularBuffer_MoveToNext(inBuffers[i]);
		CircularBuffer_MoveToNext(outBuffers[i]);
	}
}

uint16_t* FPGADriver_GetInBuffer( int pipeline ) 
{
  return CircularBuffer_GetBuffer( inBuffers[pipeline] );
}

uint16_t* FPGADriver_GetOutBuffer( int pipeline ) 
{
  return CircularBuffer_GetBuffer( outBuffers[pipeline] );
}

void FPGADriver_CopyData( void )
{
	for (int i=0; i<numPipelines; i++) 
	{
		memcpy(outBuffers[i], inBuffers[i], bufferSize*2);
	}
}
