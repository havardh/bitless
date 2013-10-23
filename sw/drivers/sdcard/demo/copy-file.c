#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <limits.h>
#include <stdlib.h>

#include "SDDriver.h"

bool bytesLeft = true;

int bufferSize = 512;
void *buffer;

void* GetBuffer(void) {
	return buffer;
}

void setupSD() 
{
	SDConfig config;
	config.mode = INOUT;
	config.inFile = "sweet1.wav";
	config.outFile = "sweet2.wav";
	config.GetInputBuffer = GetBuffer;
	config.GetOutputBuffer = GetBuffer;
	config.bufferSize = bufferSize;
	SDDriver_Init( &config );
}

int main( void ) 
{
	printf("Main\n");
	buffer = (void*)malloc(sizeof(uint16_t)*bufferSize);
	setupSD();
	printf("setupSD: Done\n");

	SDDriver_PrintWAVS();

	while(1) {
		if (!SDDriver_Read()) {

			SDDriver_Write();

		} else {

			break;

		}
	}
	
	SDDriver_Finalize();

	return 0;

}
