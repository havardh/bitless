#include "DMADriver.h"

//#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define SAMPLE_RATE     44100

#define DMA_AUDIO_IN       0
#define DMA_AUDIO_OUT      1
#define DMA_FPGA_IN_LEFT   2
#define DMA_FPGA_IN_RIGHT  3
#define DMA_FPGA_OUT_LEFT  4
#define DMA_FPGA_OUT_RIGHT 5

static void init( void );

static void setupADCBasic( void );
static void setupADCPingPong( void );

static void setupDACBasic( void );
static void setupDACPingPong( void );

static void setupFPGAIn( void );
static void setupFPGAOut( void );

static DMA_CB_TypeDef cbInData;
static DMA_CB_TypeDef cbOutData;
static DMA_CB_TypeDef cbFpgaInLeft;
static DMA_CB_TypeDef cbFpgaInRight;
static DMA_CB_TypeDef cbFpgaOutLeft;
static DMA_CB_TypeDef cbFpgaOutRight;

// Address of DAC and ADC
static void *dacAddress = (void *)((uint32_t) &(DAC0->COMBDATA));
static void *adcAddress = (void *)((uint32_t) &(ADC0->SCANDATA));

// Addresses of Audio buffer in RAM
static void *audioInBuffer;
static void *audioOutBuffer;

// Addresses of FPGA Pipeline edge buffers
static void *fpgaLeftInBuffer;
static void *fpgaRightInBuffer;
static void *fpgaLeftOutBuffer;
static void *fpgaRightOutBuffer;

static int bufferSize;

static int called[8];

static void adcCbBasic(unsigned int channel, bool primary, void *user)
{
  (void) user;
	DMA_ActivateBasic(DMA_AUDIO_IN, true, false, audioInBuffer, adcAddress, bufferSize - 1);
	FPGADriver_NotifyDMACycleComplete();
	called[channel]++;
}

static void dacCbPingPong(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_RefreshPingPong(channel, primary, false, NULL, NULL, (bufferSize / 2) - 1, false);
	called[channel]++;
}

static void dmaCbBasic(unsigned int channel, bool primary, void *user)
{
  (void) user;
	DMA_ActivateBasic(DMA_AUDIO_OUT, true, false, dacAddress, audioOutBuffer, (bufferSize / 2) - 1);
	called[channel]++;
}

static void adcCbPingPong(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_RefreshPingPong(channel, primary, false, NULL, NULL, bufferSize - 1, false);

	called[channel]++;
	FPGADriver_NotifyDMACycleComplete();
	MEM_SetBufferPrimary( primary );
	SCB->ICSR = SCB_ICSR_PENDSVSET_Msk;
}

static void fpgaInLeftCb(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_ActivateBasic(DMA_FPGA_IN_LEFT, true, false, FPGADriver_GetInBuffer(0), audioInBuffer, (bufferSize / 2) - 1);
	called[channel]++;
}

static void fpgaInRightCb(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_ActivateBasic(DMA_FPGA_IN_RIGHT, true, false, FPGADriver_GetInBuffer(1), (((uint16_t*)audioInBuffer)+1), (bufferSize / 2) - 1);
	called[channel]++;
}

static void fpgaOutLeftCb(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_ActivateBasic(DMA_FPGA_OUT_LEFT, true, false, audioOutBuffer, FPGADriver_GetInBuffer(0), (bufferSize / 2) - 1);
	called[channel]++;
}

static void fpgaOutRightCb(unsigned int channel, bool primary, void *user)
{
	(void) user;
	DMA_ActivateBasic(DMA_FPGA_OUT_RIGHT, true, false, (((uint16_t*)audioOutBuffer)+1), FPGADriver_GetInBuffer(1), (bufferSize / 2) - 1);	
	called[channel]++;
}

void DMADriver_Init(DMAConfig *config) 
{
	init();

	bufferSize         = MEM_GetAudioInBufferSize();
	audioInBuffer      = MEM_GetAudioInBuffer(true);
	audioOutBuffer     = MEM_GetAudioOutBuffer(true);
	fpgaLeftInBuffer   = FPGADriver_GetInBuffer(0);
	fpgaRightInBuffer  = FPGADriver_GetInBuffer(1);
	fpgaLeftOutBuffer  = FPGADriver_GetOutBuffer(0);
	fpgaRightOutBuffer = FPGADriver_GetOutBuffer(1);

	if (config->dacEnabled)
		setupDACBasic();

	if (config->adcEnabled)
		setupADCBasic();

	
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

void setupADCBasic( void ) 
{
	cbInData.cbFunc  = adcCbBasic;
  cbInData.userPtr = NULL;

  DMA_CfgChannel_TypeDef chnlCfg = {
		.highPri   = true,
		.enableInt = true,
		.select    = DMAREQ_ADC0_SCAN,
		.cb        = &cbInData
	};
  DMA_CfgChannel(DMA_AUDIO_IN, &chnlCfg);

  DMA_CfgDescr_TypeDef descrCfg = {
		.dstInc  = dmaDataInc2,
		.srcInc  = dmaDataIncNone,
		.size    = dmaDataSize2,
		.arbRate = dmaArbitrate1,
		.hprot   = 0
	};
  DMA_CfgDescr(DMA_AUDIO_IN, true, &descrCfg);

	DMA_ActivateBasic(DMA_AUDIO_IN, true, false, audioInBuffer, adcAddress, bufferSize - 1);

}

void setupADCPingPong( void )
{
	cbInData.cbFunc  = adcCbPingPong;
  cbInData.userPtr = NULL;

	DMA_CfgChannel_TypeDef chnlCfg = {
		.highPri   = true,
		.enableInt = true,
		.select    = DMAREQ_ADC0_SCAN,
		.cb        = &cbInData
	};
	DMA_CfgChannel( DMA_AUDIO_IN, &chnlCfg );

	DMA_CfgDescr_TypeDef descrCfg = {
		.dstInc  = dmaDataInc2,
		.srcInc  = dmaDataIncNone,
		.size    = dmaDataSize2,
		.arbRate = dmaArbitrate1,
		.hprot   = 0
	};
	DMA_CfgDescr(DMA_AUDIO_IN, true, &descrCfg );
	DMA_CfgDescr(DMA_AUDIO_IN, false, &descrCfg );

	DMA_ActivatePingPong(DMA_AUDIO_IN, false,
											 MEM_GetAudioInBuffer(true), adcAddress, bufferSize - 1,
											 MEM_GetAudioInBuffer(false), adcAddress, bufferSize - 1);

}

void setupDACBasic( void )
{
	cbOutData.cbFunc  = dmaCbBasic;
	cbOutData.userPtr = NULL;

	DMA_CfgChannel_TypeDef chnlCfg = { 
		.highPri   = true,
		.enableInt = true,
		.select    = DMAREQ_DAC0_CH0,
		.cb        = &cbOutData
	};
	DMA_CfgChannel(DMA_AUDIO_OUT, &chnlCfg);

	DMA_CfgDescr_TypeDef descrCfg = {
		.dstInc = dmaDataIncNone,
		.srcInc = dmaDataInc4,
		.size   = dmaDataSize4,
		.hprot  = 0
	};
	DMA_CfgDescr(DMA_AUDIO_OUT, true, &descrCfg);

	DMA_ActivateBasic(DMA_AUDIO_OUT, true, false, dacAddress, audioOutBuffer, (bufferSize / 2) - 1);

}

void setupDACPingPong( void )
{
	cbOutData.cbFunc  = dacCbPingPong;
	cbOutData.userPtr = NULL;

	DMA_CfgChannel_TypeDef chnlCfg = {
		.highPri = true,
		.enableInt = true,
		.select = DMAREQ_DAC0_CH0,
		.cb = &cbOutData
	};
	DMA_CfgChannel( DMA_AUDIO_OUT, &chnlCfg );

	DMA_CfgDescr_TypeDef descrCfg = {
		.dstInc  = dmaDataInc2,
		.srcInc  = dmaDataIncNone,
		.size    = dmaDataSize2,
		.arbRate = dmaArbitrate1,
		.hprot   = 0
	};
	DMA_CfgDescr(DMA_AUDIO_OUT, true, &descrCfg );
	DMA_CfgDescr(DMA_AUDIO_OUT, false, &descrCfg );

	DMA_ActivatePingPong(DMA_AUDIO_OUT, false,
											 MEM_GetAudioOutBuffer(true), adcAddress, bufferSize - 1,
											 MEM_GetAudioOutBuffer(false), adcAddress, bufferSize - 1);
}

static void setupFPGAIn( void ) 
{
	cbFpgaInLeft.cbFunc   = fpgaInLeftCb;
	cbFpgaInLeft.userPtr  = NULL;
	cbFpgaInRight.cbFunc  = fpgaInRightCb;
	cbFpgaInRight.userPtr = NULL;

  DMA_CfgChannel_TypeDef chnlCfgLeft = {
    .highPri   = false,
    .enableInt = true,
    .select    = DMAREQ_ADC0_SCAN,
    .cb        = &cbFpgaInLeft
  };
  DMA_CfgChannel( DMA_FPGA_IN_LEFT,  &chnlCfgLeft );

	DMA_CfgChannel_TypeDef chnlCfgRight = {
    .highPri   = false,
    .enableInt = true,
    .select    = DMAREQ_ADC0_SCAN,
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
  DMA_CfgDescr( DMA_FPGA_IN_RIGHT, true,  &descrCfg );

	DMA_ActivateBasic(DMA_FPGA_IN_LEFT, true, false, FPGADriver_GetInBuffer(0), audioInBuffer, (bufferSize / 2) - 1);
	DMA_ActivateBasic(DMA_FPGA_IN_RIGHT, true, false, FPGADriver_GetInBuffer(1), (((uint16_t*)audioInBuffer)+1), (bufferSize / 2) - 1);	
}

void setupFPGAOut( void ) 
{
	cbFpgaOutLeft.cbFunc   = fpgaOutLeftCb;
	cbFpgaOutLeft.userPtr  = NULL;
	cbFpgaOutRight.cbFunc  = fpgaOutRightCb;
	cbFpgaOutRight.userPtr = NULL;	

  DMA_CfgChannel_TypeDef chnlCfgLeft = {
    .highPri   = false,
    .enableInt = true,
    .select    = DMAREQ_DAC0_CH0,
    .cb        = &cbFpgaOutLeft
  };
  DMA_CfgChannel( DMA_FPGA_OUT_LEFT,  &chnlCfgLeft );

  DMA_CfgChannel_TypeDef chnlCfgRight = {
    .highPri   = false,
    .enableInt = true,
    .select    = DMAREQ_DAC0_CH0,
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
  DMA_CfgDescr( DMA_FPGA_OUT_RIGHT, true,  &descrCfg );

	DMA_ActivateBasic(DMA_FPGA_OUT_LEFT, true, false, audioOutBuffer, FPGADriver_GetInBuffer(0), (bufferSize / 2) - 1);
	DMA_ActivateBasic(DMA_FPGA_OUT_RIGHT, true, false, (((uint16_t*)audioOutBuffer)+1), FPGADriver_GetInBuffer(1), (bufferSize / 2) - 1);	

}

