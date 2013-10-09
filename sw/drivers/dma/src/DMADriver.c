#include "DMADriver.h"

//#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define SAMPLE_RATE     44100
#define DMA_AUDIO_IN    0
#define DMA_AUDIO_OUT   1
#define PRS_CHANNEL     0

static void init( void );
static void setupADC( void );
static void setupDAC( void );

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

	setupADC();
	setupDAC();
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
