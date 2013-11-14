#include "bl_prs.h"

void PRSDriver_Init( void ) 
{
	unsigned int channel = 0;

	//PRS_LevelSet(0, 1 << (channel + _PRS_SWLEVEL_CH0LEVEL_SHIFT ));

	PRS_SourceSignalSet(channel,
											PRS_CH_CTRL_SOURCESEL_TIMER0,
											PRS_CH_CTRL_SIGSEL_TIMER0OF,
											prsEdgePos);
}
