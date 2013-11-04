#include "bsp.h"
#include "bsp_trace.h"
#include "em_dma.h"
#include "em_prs.h"
#include "em_cmu.h"
#include "em_timer.h"
#include "dmactrl.h"

#define N 30

#define DMA0 0
#define DMA1 1
#define DMA2 2
#define DMA3 3
#define DMA4 4
#define DMA5 5
#define DMA6 6
#define DMA7 7

#define M 4

static int in[N];
static int out[N];

static DMA_CB_TypeDef dmaCbs[M];

static int called[M];

static void cb(unsigned int channel, bool primary, void *user)
{
	(void) user;
	(void) primary;
	DMA_ActivateBasic(channel, true, false, in, out, N-1);

	called[channel]++;	
}


void createDMA(int dmaChannel, void *from, void *to) 
{
	dmaCbs[dmaChannel].cbFunc = cb;
	dmaCbs[dmaChannel].userPtr = NULL;
	
	DMA_CfgChannel_TypeDef ch = {
		.highPri = false,
		.enableInt = true,
		.select = DMAREQ_TIMER0_UFOF,
		.cb = &dmaCbs[dmaChannel]
	};
	DMA_CfgChannel( dmaChannel, &ch );
	
	DMA_CfgDescr_TypeDef desc = {
		.dstInc = dmaDataInc4,
		.srcInc = dmaDataInc4,
		.size = dmaDataSize4,
		.arbRate = dmaArbitrate1024,
		.hprot = 0
	};
	DMA_CfgDescr( dmaChannel, true, &desc );
	
	DMA_ActivateBasic(dmaChannel, true, false, to, from, N-1);

}

int main1( void ) 
{
	DMA_Init_TypeDef dmaInit = {
		.hprot = 0,
		.controlBlock = dmaControlBlock
	};
	DMA_Init( &dmaInit );

	for (int i=0; i<M; i++) {
		createDMA(i, in, out);
	}

	CMU_ClockEnable( cmuClock_DMA, true );
	CMU_ClockEnable( cmuClock_TIMER0, true );
  
	TIMER_Init_TypeDef timer = TIMER_INIT_DEFAULT;
	TIMER_TopSet( TIMER0, CMU_ClockFreqGet(cmuClock_HFPER) / 88200);
	TIMER_Init( TIMER0, &timer );

	while(1) ;

}
