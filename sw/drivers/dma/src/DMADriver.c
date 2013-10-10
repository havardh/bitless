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

static uint16_t *bufferOne;
static uint16_t *bufferTwo;

static DMA_CB_TypeDef cbInData;
static DMA_CB_TypeDef cbOutData;

static void preampDMAInCb(unsigned int channel, bool primary, void *user)
{
  (void) user;

	int bufferSize = MEM_GetAudioInBufferSize() - 1;
  DMA_RefreshPingPong(channel,primary,false,NULL,NULL,bufferSize,false);

	MEM_SetBufferPrimary( primary );

  SCB->ICSR = SCB_ICSR_PENDSVSET_Msk;
}

static void preampDMAOutCb(unsigned int channel, bool primary, void *user)
{
  (void) user;
	int bufferSize = (MEM_GetAudioOutBufferSize() / 2) - 1;
  DMA_RefreshPingPong(channel,primary,false,NULL,NULL,bufferSize,false);
}


void DMADriver_Init() 
{
	init();

	bufferOne = malloc(sizeof(uint16_t) * 64);
	bufferTwo = malloc(sizeof(uint16_t) * 64);

	//setupADC();
	//setupDAC();

	printf("Start Copy 1\n");
  setupFPGAIn();
	Delay(1000);
	FPGADriver_CopyData();
	Delay(1000);
	printf("Start Copy 2\n");
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
	cbInData.cbFunc  = preampDMAInCb;
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
	cbOutData.cbFunc = preampDMAOutCb;
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

void setupFPGAIn( void ) 
{
  DMA_CfgChannel_TypeDef chnlCfg = {
    .highPri   = false,
    .enableInt = true,
    .select    = 0,
    .cb        = NULL
  };
  DMA_CfgChannel( DMA_FPGA_IN_LEFT,  &chnlCfg );
  DMA_CfgChannel( DMA_FPGA_IN_RIGHT, &chnlCfg );
  DMA_CfgChannel( DMA_FPGA_IN_LEFT+4,  &chnlCfg );
  DMA_CfgChannel( DMA_FPGA_IN_RIGHT+4, &chnlCfg );

  DMA_CfgDescr_TypeDef descrCfg = {
    .dstInc = dmaDataInc2,
    .srcInc = dmaDataInc4,
    .size = dmaDataSize2,
    .arbRate = dmaArbitrate1,
    .hprot = 0
  };
  DMA_CfgDescr( DMA_FPGA_IN_LEFT,  true, &descrCfg );
  DMA_CfgDescr( DMA_FPGA_IN_RIGHT, true, &descrCfg );
  DMA_CfgDescr( DMA_FPGA_IN_LEFT+4,  true, &descrCfg );
  DMA_CfgDescr( DMA_FPGA_IN_RIGHT+4, true, &descrCfg );

  void *dst, *src; int n;
  dst = FPGADriver_GetInBuffer(0);
  src = MEM_GetPrimaryAudioInBuffer();
  n = MEM_GetAudioInBufferSize() / 2;
  DMA_ActivateAuto( DMA_FPGA_IN_LEFT, true, dst, src, n - 1);

  dst = bufferOne; //FPGADriver_GetInBuffer(0);
  src = MEM_GetSecondaryAudioInBuffer();
  n = MEM_GetAudioInBufferSize() / 2;
  DMA_ActivateAuto( DMA_FPGA_IN_LEFT+4, true, dst, src, n - 1);

  dst = FPGADriver_GetInBuffer(1);
  src = MEM_GetPrimaryAudioInBuffer() + sizeof(uint8_t);
  n = MEM_GetAudioInBufferSize() / 2;
  DMA_ActivateAuto( DMA_FPGA_IN_RIGHT, true, dst, src, n - 1);

  dst = bufferTwo; //FPGADriver_GetInBuffer(1);
  src = MEM_GetSecondaryAudioInBuffer() + sizeof(uint8_t);
  n = MEM_GetAudioInBufferSize() / 2;
  DMA_ActivateAuto( DMA_FPGA_IN_RIGHT+4, true, dst, src, n - 1);
}

void setupFPGAOut( void ) 
{
	
  DMA_CfgChannel_TypeDef chnlCfg = {
    .highPri   = false,
    .enableInt = true,
    .select    = 0,
    .cb        = NULL
  };
  DMA_CfgChannel( DMA_FPGA_OUT_LEFT,  &chnlCfg );
  DMA_CfgChannel( DMA_FPGA_OUT_RIGHT, &chnlCfg );

  DMA_CfgChannel( DMA_FPGA_OUT_LEFT+4,  &chnlCfg );
  DMA_CfgChannel( DMA_FPGA_OUT_RIGHT+4, &chnlCfg );

  DMA_CfgDescr_TypeDef descrCfg = {
    .dstInc = dmaDataInc4,
    .srcInc = dmaDataInc2,
    .size = dmaDataSize2,
    .arbRate = dmaArbitrate1,
    .hprot = 0
  };
  DMA_CfgDescr( DMA_FPGA_OUT_LEFT,  true, &descrCfg );
  DMA_CfgDescr( DMA_FPGA_OUT_RIGHT, true, &descrCfg );

  DMA_CfgDescr( DMA_FPGA_OUT_LEFT+4,  true, &descrCfg );
  DMA_CfgDescr( DMA_FPGA_OUT_RIGHT+4, true, &descrCfg );

  void *dst, *src; int n;
  dst = MEM_GetPrimaryAudioOutBuffer();
  src = FPGADriver_GetOutBuffer(0);
  n = MEM_GetAudioOutBufferSize();
  DMA_ActivateAuto( DMA_FPGA_OUT_LEFT, true, dst, src, n - 1);

  dst = MEM_GetSecondaryAudioOutBuffer();
  src = bufferOne;
  n = MEM_GetAudioOutBufferSize();
  DMA_ActivateAuto( DMA_FPGA_OUT_LEFT+4, true, dst, src, n - 1);

  dst =  MEM_GetPrimaryAudioOutBuffer() + sizeof(uint8_t);
  src = FPGADriver_GetOutBuffer(1);
  n = MEM_GetAudioOutBufferSize();
  DMA_ActivateAuto( DMA_FPGA_OUT_RIGHT, true, dst, src, n - 1); 

  dst =  MEM_GetSecondaryAudioOutBuffer() + sizeof(uint8_t);
  src = bufferTwo;
  n = MEM_GetAudioOutBufferSize();
  DMA_ActivateAuto( DMA_FPGA_OUT_RIGHT+4, true, dst, src, n - 1); 

}
