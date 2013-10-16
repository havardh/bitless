#include "DMADriver.h"

//#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define SAMPLE_RATE     44100

#define DMA_AUDIO_IN       0
#define DMA_AUDIO_OUT      1
#define DMA_FPGA_IN_LEFT   2
#define DMA_FPGA_IN_RIGHT  3
#define DMA_FPGA_OUT_LEFT  4
#define DMA_FPGA_OUT_RIGHT 5

#define PRS_CHANNEL     0

void Delay(uint32_t dlyTicks);

static void init( void );
static void setupADC( void );
static void setupDAC( void );

static void setupFPGAIn( void );
static void setupFPGAOut( void );
void setupFPGALeftIn( void );
void setupFPGARightIn( void );

static uint16_t *bufferOne;
static uint16_t *bufferTwo;

static DMA_CB_TypeDef cbInData;
static DMA_CB_TypeDef cbOutData;

static DMA_CB_TypeDef cbFpgaInLeft;
static DMA_CB_TypeDef cbFpgaInRight;
static DMA_CB_TypeDef cbFpgaOutLeft;
static DMA_CB_TypeDef cbFpgaOutRight;

static int called[8];

static void adcCb(unsigned int channel, bool primary, void *user)
{
  (void) user;

	int bufferSize = MEM_GetAudioInBufferSize() - 1;
  DMA_RefreshPingPong(channel,primary,false,NULL,NULL,bufferSize,false);

	MEM_SetBufferPrimary( primary );

  SCB->ICSR = SCB_ICSR_PENDSVSET_Msk;
	called[channel]++;
}

static void dmaCb(unsigned int channel, bool primary, void *user)
{
  (void) user;
	int bufferSize = (MEM_GetAudioOutBufferSize() / 2) - 1;
  DMA_RefreshPingPong(channel,primary,false,NULL,NULL,bufferSize,false);
	called[channel]++;
}

static void fpgaCb(unsigned int channel, bool primary, void *user)
{
	(void) user;
	int bufferSize = MEM_GetAudioInBufferSize() / 2;
	DMA_RefreshPingPong(channel,primary,false,NULL,NULL,bufferSize,false);

	called[channel]++;
}

void DMADriver_Init(DMAConfig *config) 
{
	init();

	if (config->dacEnabled)
		setupDAC();

	if (config->adcEnabled) 		
		setupADC();

	bufferOne = malloc(sizeof(uint16_t) * 64);
	bufferTwo = malloc(sizeof(uint16_t) * 64);

	if (config->fpgaInEnabled)
		setupFPGAIn();

	if (config->fpgaOutEnabled)
		setupFPGAOut();

}

static void init( void ) 
{
	DMA_Init_TypeDef dmaInit;
	dmaInit.hprot = 0;
	dmaInit.controlBlock = dmaControlBlock;
  DMA_Init(&dmaInit);
}

void setupADC( void ) 
{
	cbInData.cbFunc  = adcCb;
  cbInData.userPtr = NULL;

  DMA_CfgChannel_TypeDef chnlCfg;
  chnlCfg.highPri   = true;
  chnlCfg.enableInt = true;
  chnlCfg.select    = DMAREQ_ADC0_SCAN;
  chnlCfg.cb        = &cbInData;
  DMA_CfgChannel(DMA_AUDIO_IN, &chnlCfg);

  DMA_CfgDescr_TypeDef   descrCfg;
  descrCfg.dstInc  = dmaDataInc2;
  descrCfg.srcInc  = dmaDataIncNone;
  descrCfg.size    = dmaDataSize2;
  descrCfg.arbRate = dmaArbitrate1;
  descrCfg.hprot   = 0;
  DMA_CfgDescr(DMA_AUDIO_IN, true, &descrCfg);
  DMA_CfgDescr(DMA_AUDIO_IN, false, &descrCfg);

	void     *ADCScanData = (void *)((uint32_t) &(ADC0->SCANDATA));
	uint16_t *priBuffer   = MEM_GetPrimaryAudioInBuffer();
	uint16_t *secBuffer   = MEM_GetSecondaryAudioInBuffer();
	int       bufferSize  = MEM_GetAudioInBufferSize() - 1;
  DMA_ActivatePingPong(DMA_AUDIO_IN,false,
											 priBuffer, ADCScanData, bufferSize,
											 secBuffer, ADCScanData, bufferSize);
	
	MEM_SetBufferPrimary( true );

}

void setupDAC( void )
{
	cbOutData.cbFunc = dmaCb;
	cbOutData.userPtr = NULL;

	DMA_CfgChannel_TypeDef chnlCfg;
	chnlCfg.highPri = true;
	chnlCfg.enableInt = true;
	chnlCfg.select = DMAREQ_DAC0_CH0;
	chnlCfg.cb = &cbOutData;
	DMA_CfgChannel(DMA_AUDIO_OUT, &chnlCfg);

	DMA_CfgDescr_TypeDef descrCfg;
	descrCfg.dstInc = dmaDataIncNone;
	descrCfg.srcInc = dmaDataInc4;
	descrCfg.size = dmaDataSize4;
	descrCfg.hprot = 0;
	DMA_CfgDescr(DMA_AUDIO_OUT, true, &descrCfg);
	DMA_CfgDescr(DMA_AUDIO_OUT, false, &descrCfg);

	void     *DACCombData = (void *)((uint32_t) &(DAC0->COMBDATA));
	uint16_t *priBuffer   = MEM_GetPrimaryAudioOutBuffer();
	uint16_t *secBuffer   = MEM_GetSecondaryAudioOutBuffer();
	int       bufferSize  = (MEM_GetAudioOutBufferSize() / 2) - 1;
	DMA_ActivatePingPong(DMA_AUDIO_OUT, false,
											 DACCombData, priBuffer, bufferSize,
											 DACCombData, secBuffer, bufferSize);

}

static void setupFPGAIn( void ) 
{
	cbFpgaInLeft.cbFunc = fpgaCb;
	cbFpgaInLeft.userPtr = NULL;

	cbFpgaInRight.cbFunc = fpgaCb;
	cbFpgaInRight.userPtr = NULL;

  DMA_CfgChannel_TypeDef chnlCfgLeft = {
    .highPri   = true,
    .enableInt = true,
    .select    = DMAREQ_TIMER0_UFOF,
    .cb        = &cbFpgaInLeft
  };
  DMA_CfgChannel( DMA_FPGA_IN_LEFT,  &chnlCfgLeft );

	DMA_CfgChannel_TypeDef chnlCfgRight = {
    .highPri   = true,
    .enableInt = true,
    .select    = DMAREQ_TIMER0_UFOF,
    .cb        = &cbFpgaInRight
  };
  DMA_CfgChannel( DMA_FPGA_IN_RIGHT, &chnlCfgRight );

  DMA_CfgDescr_TypeDef descrCfg = {
    .dstInc  = dmaDataInc2,
    .srcInc  = dmaDataInc4,
    .size    = dmaDataSize2,
    .arbRate = dmaArbitrate1,
    .hprot   = 0
  };
  DMA_CfgDescr( DMA_FPGA_IN_LEFT,  true,  &descrCfg );
  DMA_CfgDescr( DMA_FPGA_IN_LEFT,  false, &descrCfg );
  DMA_CfgDescr( DMA_FPGA_IN_RIGHT, true,  &descrCfg );
  DMA_CfgDescr( DMA_FPGA_IN_RIGHT, false, &descrCfg );

  int n = MEM_GetAudioInBufferSize() / 2;
  void *dstPri = FPGADriver_GetInBuffer(0);
  void *srcPri = MEM_GetPrimaryAudioInBuffer();
  void *dstSec = bufferOne; // This should be inside FPGA
  void *srcSec = MEM_GetSecondaryAudioInBuffer();
	DMA_ActivatePingPong(DMA_FPGA_IN_LEFT, false, dstPri, srcPri, n - 1, dstSec, srcSec, n - 1);

  n = MEM_GetAudioInBufferSize() / 2;	
	dstPri = FPGADriver_GetInBuffer(1);
  srcPri = MEM_GetPrimaryAudioInBuffer() + 1;
  dstSec = bufferTwo; // This should be inside FPGA
  srcSec = MEM_GetSecondaryAudioInBuffer() + 1;
	DMA_ActivatePingPong(DMA_FPGA_IN_RIGHT, false, dstPri, srcPri, n - 1, dstSec, srcSec, n - 1);
	
}

void setupFPGAOut( void ) 
{
	cbFpgaOutLeft.cbFunc = fpgaCb;
	cbFpgaOutLeft.userPtr = NULL;
	cbFpgaOutRight.cbFunc = fpgaCb;
	cbFpgaOutRight.userPtr = NULL;	

  DMA_CfgChannel_TypeDef chnlCfgLeft = {
    .highPri   = true,
    .enableInt = true,
    .select    = DMAREQ_TIMER0_UFOF,
    .cb        = &cbFpgaOutLeft
  };
  DMA_CfgChannel( DMA_FPGA_OUT_LEFT,  &chnlCfgLeft );

  DMA_CfgChannel_TypeDef chnlCfgRight = {
    .highPri   = true,
    .enableInt = true,
    .select    = DMAREQ_TIMER0_UFOF,
    .cb        = &cbFpgaOutRight
  };
  DMA_CfgChannel( DMA_FPGA_OUT_RIGHT, &chnlCfgRight );

  DMA_CfgDescr_TypeDef descrCfg = {
    .dstInc  = dmaDataInc4,
    .srcInc  = dmaDataInc2,
    .size    = dmaDataSize2,
    .arbRate = dmaArbitrate1,
    .hprot   = 0
  };
  DMA_CfgDescr( DMA_FPGA_OUT_LEFT,  true,  &descrCfg );
  DMA_CfgDescr( DMA_FPGA_OUT_LEFT,  false, &descrCfg );
  DMA_CfgDescr( DMA_FPGA_OUT_RIGHT, true,  &descrCfg );
  DMA_CfgDescr( DMA_FPGA_OUT_RIGHT, false, &descrCfg );

  void *dstPri, *srcPri, *dstSec, *srcSec;
  int n = MEM_GetAudioInBufferSize() / 2;

	// Setup copy from left channel
  dstPri = MEM_GetPrimaryAudioOutBuffer();
  srcPri = FPGADriver_GetInBuffer(0); // This should be OUT
	dstSec = MEM_GetSecondaryAudioOutBuffer();
	srcSec = bufferOne; // This should be inside FPGA
	DMA_ActivatePingPong(DMA_FPGA_OUT_LEFT, false, dstPri, srcPri, n - 1, dstSec, srcSec, n - 1);

	// Setup copy from right channel
  dstPri = MEM_GetPrimaryAudioOutBuffer() + 1;
  srcPri = FPGADriver_GetInBuffer(1); // This should be OUT
	dstSec = MEM_GetSecondaryAudioOutBuffer() + 1;
	srcSec = bufferTwo; // This should be inside FPGA
	DMA_ActivatePingPong(DMA_FPGA_OUT_RIGHT, false, dstPri, srcPri, n - 1, dstSec, srcSec, n - 1);

}

