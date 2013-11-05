#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <limits.h>
#include <stdint.h>

#include "DMAConfig.h"

#include "MEMConfig.h"

#include "MEMDriver.h"
#include "DMADriver.h"
#include "INTDriver.h"
#include "FPGADriver.h"

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
#include "ff.h"
#include "microsd.h"
#include "diskio.h"
#include "bsp.h"


#define DMA_MEM_CPY 0
#define FPGA_BASE ((uint16_t*) 0x21000000)

/** Filename to open from SD-card */
#define WAV_FILENAME             "sweet1.wav"

/** Ram buffers
 * BUFFERIZE should be between 512 and 1024, depending on available ram on efm32
 */
#define BUFFERSIZE               64

/** DMA callback structure */
static DMA_CB_TypeDef DMAcallBack;
static DMA_CB_TypeDef cb;

static DMA_CB_TypeDef cbIN;

static DMA_CB_TypeDef cbOUT;

/* Buffers for DMA transfer, 32 bits are transfered at a time with DMA.
 * The buffers are twice as large as BUFFERSIZE to hold both left and right
 * channel samples. */
//static int16_t ramBufferDacData0Stereo[2 * BUFFERSIZE];
//static int16_t ramBufferDacData1Stereo[2 * BUFFERSIZE];

/** Bytecounter, need to stop DMA when finished reading file */
static uint32_t ByteCounter;

/** File system specific */
static FATFS Fatfs;

/** File to read WAV audio data from */
static FIL WAVfile;

/** WAV header structure */
typedef struct
{
  uint8_t  id[4];                   /** should always contain "RIFF"      */
  uint32_t totallength;             /** total file length minus 8         */
  uint8_t  wavefmt[8];              /** should be "WAVEfmt "              */
  uint32_t format;                  /** Sample format. 16 for PCM format. */
  uint16_t pcm;                     /** 1 for PCM format                  */
  uint16_t channels;                /** Channels                          */
  uint32_t frequency;               /** sampling frequency                */
  uint32_t bytes_per_second;        /** Bytes per second                  */
  uint16_t bytes_per_capture;       /** Bytes per capture                 */
  uint16_t bits_per_sample;         /** Bits per sample                   */
  uint8_t  data[4];                 /** should always contain "data"      */
  uint32_t bytes_in_data;           /** No. bytes in data                 */
} WAV_Header_TypeDef;

/** Wav header. Global as it is used in callbacks. */
static WAV_Header_TypeDef wavHeader;

/*
 *   DK push buttons PB1 and PB2 are used to decrease/increase output volume.
 *   Push the AEM button on the kit until "EFM" shows in the upper right
 *   corner of the TFT display to activate PB1 and PB2 pushbuttons.
 */

int called[8];

int initFatFS(void)
{
  MICROSD_Init();
  if (f_mount(0, &Fatfs) != FR_OK)
    return -1;
  return 0;
}

DWORD get_fattime(void) { return (28 << 25) | (2 << 21) | (1 << 16); }

void SysTick_Handler(void){}

void transferComplete(unsigned int channel, bool primary, void *user)
{  
	(void) channel;  (void) primary;  (void) user; 
		
	called[channel]++;
}


void FillBufferFromSDcard(bool stereo, bool primary)
{
  UINT     bytes_read;
  int16_t  * 		buffer = MEM_GetAudioInBuffer(true);
  int      i, j;
  uint16_t tmp;


	f_read(&WAVfile, buffer, 4*MEM_GetAudioInBufferSize(), &bytes_read);
	ByteCounter += bytes_read;

	for (i = 0; i < 2*BUFFERSIZE; i++)
  {
		tmp = buffer[i] + 0x8000;
		tmp >>= 4;
		buffer[i] = tmp;
	}

}

void basicTransferComplete(unsigned int channel, bool primary, void *user) 
{}

void onDACInterrupt( void ) {
	//DMA_ActivateAuto(DMA_MEM_CPY, true, MEM_GetAudioOutBuffer(true), MEM_GetAudioInBuffer(true), MEM_GetAudioInBufferSize()-1);

	called[3]++;
	FillBufferFromSDcard((bool) wavHeader.channels, true);

	
	int bufferSize               = MEM_GetAudioInBufferSize();
	uint16_t *audioInBuffer      = MEM_GetAudioInBuffer(true);
	uint16_t *audioOutBuffer     = MEM_GetAudioOutBuffer(true);
	volatile uint16_t *fpgaLeftInBuffer   = FPGADriver_GetInBuffer(0);
	volatile uint16_t *fpgaRightInBuffer  = FPGADriver_GetInBuffer(1);
	volatile uint16_t *fpgaLeftOutBuffer  = FPGADriver_GetOutBuffer(0);
	volatile uint16_t *fpgaRightOutBuffer = FPGADriver_GetOutBuffer(1);

	for (int i=0, j; i<2*bufferSize; i+=2, j++) {

		audioOutBuffer[i] = fpgaLeftInBuffer[j];
		audioOutBuffer[i+1] = fpgaRightInBuffer[j];
		fpgaLeftInBuffer[j] = audioInBuffer[i];
		fpgaRightInBuffer[j] = audioInBuffer[i+1];
		
	}
}

void transferInComplete(unsigned int channel, bool primary, void *user) 
{
	(void) channel;  (void) primary;  (void) user;
  
	DMA_ActivateBasic(3, true, false, MEM_GetAudioInBuffer(true), FPGADriver_GetInBuffer(0), (MEM_GetAudioInBufferSize() / 2) - 1);
	//DMA_ActivateAuto(4, false, MEM_GetAudioInBuffer(true) + sizeof(uint16_t), FPGADriver_GetInBuffer(1), (MEM_GetAudioInBufferSize() / 2)-1);
	called[channel]++;
}



void transferOutComplete(unsigned int channel, bool primary, void *user) 
{
	(void) channel;  (void) primary;  (void) user;
  
	DMA_ActivateBasic(4, true, false, MEM_GetAudioInBuffer(true), FPGADriver_GetInBuffer(0), (MEM_GetAudioInBufferSize() / 2) - 1);
	//DMA_ActivateAuto(4, false, MEM_GetAudioInBuffer(true) + sizeof(uint16_t), FPGADriver_GetInBuffer(1), (MEM_GetAudioInBufferSize() / 2)-1);
	called[channel]++;
}

void DAC_setup(void)
{
  DAC_Init_TypeDef        init        = DAC_INIT_DEFAULT;
  DAC_InitChannel_TypeDef initChannel = DAC_INITCHANNEL_DEFAULT;

  /* Calculate the DAC clock prescaler value that will result in a DAC clock
   * close to 1 MHz. Second parameter is zero, if the HFPERCLK value is 0, the
   * function will check what the HFPERCLK actually is. */
  init.prescale = DAC_PrescaleCalc(1000000, 0);

  /* Initialize the DAC. */
  DAC_Init(DAC0, &init);

  /* Enable prs to trigger samples at the right time with the timer */
  initChannel.prsEnable = true;
  initChannel.prsSel    = dacPRSSELCh0;

  /* Both channels can be configured the same
   * and be triggered by the same prs-signal. */
  DAC_InitChannel(DAC0, &initChannel, 0);
  DAC_InitChannel(DAC0, &initChannel, 1);

  DAC_Enable(DAC0, 0, true);
  DAC_Enable(DAC0, 1, true);
}

void TIMER_setup(void)
{
  uint32_t timerTopValue;
  /* Use default timer configuration, overflow on counter top and start counting
   * from 0 again. */
  TIMER_Init_TypeDef timerInit = TIMER_INIT_DEFAULT;

  TIMER_Init(TIMER0, &timerInit);

  /* PRS setup */
  /* Select TIMER0 as source and TIMER0OF (Timer0 overflow) as signal (rising edge) */
  PRS_SourceSignalSet(0, PRS_CH_CTRL_SOURCESEL_TIMER0, PRS_CH_CTRL_SIGSEL_TIMER0OF, prsEdgePos);

  /* Calculate the proper overflow value */
  timerTopValue = CMU_ClockFreqGet(cmuClock_TIMER0) / wavHeader.frequency;

  /* Write new topValue */
  TIMER_TopBufSet(TIMER0, timerTopValue);
}

void setupDma(void)
{
  DMA_Init_TypeDef        dmaInit;
  DMA_CfgChannel_TypeDef  chnlCfg;
  DMA_CfgDescr_TypeDef    descrCfg;
  
  /* Initializing the DMA */
  dmaInit.hprot        = 0;
  dmaInit.controlBlock = dmaControlBlock;
  DMA_Init(&dmaInit);

  /* Setting call-back function */  
  cb.cbFunc  = basicTransferComplete; //transferComplete;
  cb.userPtr = NULL;

  /* Setting up channel */
  chnlCfg.highPri   = false;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_DAC0_CH0; // 0
  chnlCfg.cb        = &(cb);
  DMA_CfgChannel(DMA_MEM_CPY, &chnlCfg);

  /* Setting up channel descriptor */
  descrCfg.dstInc  = dmaDataInc4;
  descrCfg.srcInc  = dmaDataInc4;
  descrCfg.size    = dmaDataSize4;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(DMA_MEM_CPY, true, &descrCfg);	

	DMA_ActivateBasic(DMA_MEM_CPY, true, false, MEM_GetAudioOutBuffer(true), MEM_GetAudioInBuffer(true), MEM_GetAudioInBufferSize()-1);
}

int main(void)
{
  UINT    bytes_read;
  FRESULT res;

  ByteCounter = 0;

  /* Use 32MHZ HFXO as core clock frequency, need high speed for 44.1kHz stereo */
  CMU_ClockSelectSet(cmuClock_HF, cmuSelect_HFXO);

  /* Initialize DK board register access */
  BSP_Init(BSP_INIT_DEFAULT);


  /* Setup SysTick Timer for 10 msec interrupts  */
  if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 100))
		{
			while (1) ;
		}

  BSP_PeripheralAccess(BSP_AUDIO_OUT, true);

  /* Enable SPI access to MicroSD card */
  BSP_PeripheralAccess(BSP_MICROSD, true);

  /* Initialize filesystem */
  MICROSD_Init();
  res = f_mount(0, &Fatfs);
  if (res != FR_OK)
		{
			/* No micro-SD with FAT32 is present */
			while (1) ;
		}

  /* Open wav file from SD-card */
  if (f_open(&WAVfile, WAV_FILENAME, FA_READ) != FR_OK)
		{
			/* No micro-SD with FAT32, or no WAV_FILENAME found */
			while (1) ;
		}

  /* Read header and place in header struct */
  f_read(&WAVfile, &wavHeader, sizeof(wavHeader), &bytes_read);

	MEMConfig memConfig = { .bufferSize = BUFFERSIZE };
	MEM_Init( &memConfig );

  /* Start clocks */
  CMU_ClockEnable(cmuClock_DMA, true);
  CMU_ClockEnable(cmuClock_DAC0, true);
  CMU_ClockEnable(cmuClock_TIMER0, true);
  CMU_ClockEnable(cmuClock_PRS, true);

  /* Fill both primary and alternate RAM-buffer before start */
  FillBufferFromSDcard((bool) wavHeader.channels, true);

  /* Setup DMA and peripherals */
	setupDma();
	//setupDeinterleavedDMA();
	//setupInterleavedDMA();

	INTDriver_Init();
	INTDriver_RegisterCallback(0, &onDACInterrupt);

	FPGAConfig configFPGA;
  configFPGA.baseAddress = FPGA_BASE;
  configFPGA.numPipelines = 2;
  configFPGA.bufferSize = BUFFERSIZE;
  FPGADriver_Init( &configFPGA );

	DMAConfig config = { .mode = SD_TO_DAC };
	DMADriver_Init( &config );

  DAC_setup();

  /* Start timer which will trig DMA ... */
  TIMER_setup();

  while (1)
		{
			/* Enter EM1 while the DAC, Timer, PRS and DMA is working */
			EMU_EnterEM1();

			/* Check if time to check volume pushbuttons. */

		}
}
