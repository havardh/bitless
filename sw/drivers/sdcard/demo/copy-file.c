#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <limits.h>

#include "em_device.h"
#include "em_common.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_dac.h"
#include "em_prs.h"
#include "em_timer.h"
#include "em_dma.h"
#include "em_usart.h"
#include "dmactrl.h"

#include "SDDriver.h"

#include "ff.h"
#include "microsd.h"
#include "diskio.h"
#include "bsp.h"

#define WAV_FILENAME             "sweet1.wav"

bool bytesLeft = true;

int bufferSize = 512;
void *buffer;

void* GetBuffer(void) {
	return buffer;
}

static FATFS Fatfs;
static FIL WAVfile;

void testOpen() 
{
	FRESULT res;

	CMU_ClockSelectSet(cmuClock_HF, cmuSelect_HFXO);

        BSP_Init(BSP_INIT_DEFAULT);
	BSP_PeripheralAccess(BSP_MICROSD, true);
	
	BSP_Init(BSP_INIT_DEFAULT);
	BSP_LedsSet(0xff);
	BSP_PeripheralAccess(BSP_I2S, true);
	BSP_PeripheralAccess(BSP_MICROSD, true);
	MICROSD_Init();

	res = f_mount(0, &Fatfs);
	while(res != FR_OK);

	res = f_open(&WAVfile, WAV_FILENAME, FA_READ);
	while(res != FR_OK);

	BSP_LedsSet(0xff00);
	while(1); 

}

void setupBSP(void)
{
  BSP_Init(BSP_INIT_DEFAULT);
  BSP_PeripheralAccess(BSP_MICROSD, true);
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
	//printf("Main\n");
	buffer = (void*)malloc(sizeof(uint16_t)*bufferSize);
	setupSD();
	//printf("setupSD: Done\n");

	//SDDriver_PrintWAVS();

	setupBSP();
	//testOpen();

	while(1) {
		if (!SDDriver_Read()) {

			SDDriver_Write();

		} else {

			break;

		}
	}
	
	SDDriver_Finalize();

	while(1);
	return 0;

}
