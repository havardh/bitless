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

void setupSWO(void)
{
  /* Enable GPIO Clock. */
  CMU->HFPERCLKEN0 |= CMU_HFPERCLKEN0_GPIO;
  /* Enable Serial wire output pin */
  GPIO->ROUTE |= GPIO_ROUTE_SWOPEN;
#if defined(_EFM32_GIANT_FAMILY) || defined(_EFM32_WONDER_FAMILY) || defined(_EFM32_LEOPARD_FAMILY)
  /* Set location 0 */
  GPIO->ROUTE = (GPIO->ROUTE & ~(_GPIO_ROUTE_SWLOCATION_MASK)) | GPIO_ROUTE_SWLOCATION_LOC0;

  /* Enable output on pin - GPIO Port F, Pin 2 */
  GPIO->P[5].MODEL &= ~(_GPIO_P_MODEL_MODE2_MASK);
  GPIO->P[5].MODEL |= GPIO_P_MODEL_MODE2_PUSHPULL;
#else
  /* Set location 1 */
  GPIO->ROUTE = (GPIO->ROUTE & ~(_GPIO_ROUTE_SWLOCATION_MASK)) | GPIO_ROUTE_SWLOCATION_LOC1;
  /* Enable output on pin */
  GPIO->P[2].MODEH &= ~(_GPIO_P_MODEH_MODE15_MASK);
  GPIO->P[2].MODEH |= GPIO_P_MODEH_MODE15_PUSHPULL;
#endif
  /* Enable debug clock AUXHFRCO */
  CMU->OSCENCMD = CMU_OSCENCMD_AUXHFRCOEN;

  while(!(CMU->STATUS & CMU_STATUS_AUXHFRCORDY));

  /* Enable trace in core debug */
  CoreDebug->DHCSR |= 1;
  CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;

  /* Enable PC and IRQ sampling output */
  DWT->CTRL = 0x400113FF;
  /* Set TPIU prescaler to 16. */
  TPI->ACPR = 0xf;
  /* Set protocol to NRZ */
  TPI->SPPR = 2;
  /* Disable continuous formatting */
  TPI->FFCR = 0x100;
  /* Unlock ITM and output data */
  ITM->LAR = 0xC5ACCE55;
  ITM->TCR = 0x10009;
}


int main1( void ) 
{

	setupBSP();
	setupSWO();

	printf("Main\n");

	buffer = (void*)malloc(sizeof(uint16_t)*bufferSize);
	setupSD();
	//printf("setupSD: Done\n");

	//SDDriver_PrintWAVS();


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
