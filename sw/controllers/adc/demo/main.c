#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "em_adc.h"
#include "bsp.h"
#include "bsp_trace.h"
#include "retargetserial.h"
//#include "ADCConfig.h"
//#include "ADCController.h"

volatile uint32_t msTicks;

void Delay( uint32_t ticks );

void SysTick_Handler( void ) 
{
    msTicks++;
}

void Delay( uint32_t ticks ) {

    uint32_t curTicks;

    curTicks = msTicks;
    while ((msTicks - curTicks) < ticks) ;

}

static void ADCConfig(void)
{
  ADC_Init_TypeDef init = ADC_INIT_DEFAULT;
  init.timebase = ADC_TimebaseCalc(0);
  init.prescale = ADC_PrescaleCalc(7000000, 0);
  ADC_Init(ADC0, &init);

	//BSP_PeripheralAccess ( BSP_AUDIO_IN, true );
	//uint16_t perfControl = BSP_RegisterRead(&BC_REGISTER->PERICON);;
	//perfControl |= (1 << BC_PERICON_AUDIO_IN_SHIFT);
	//BSP_RegisterWrite(&BC_REGISTER->PERICON, perfControl);*/
	

  ADC_InitSingle_TypeDef singleInit = ADC_INITSINGLE_DEFAULT;	
  singleInit.reference  = adcRef1V25;
  singleInit.input      = adcSingleInpCh6; // adcSingleInpCh6;
  singleInit.resolution = adcRes12Bit;
  singleInit.acqTime    = adcAcqTime32;
  ADC_InitSingle(ADC0, &singleInit);
}

/*void setupAdc( void ) 
{
	ADCConfig config;
	config.channel = CH5;
	config.resolution = 8;
	config.rate = 44100;
	ADCController_Init( &config );
	}*/

/*

	if (sample > 3565)
		BSP_LedSet(1);
	if (sample > 3566)
		BSP_LedSet(2);
	if (sample > 3567)
		BSP_LedSet(3);
	if (sample > 3568)
		BSP_LedSet(4);
	if (sample > 3569)
		BSP_LedSet(5);
	if (sample > 3570)
		BSP_LedSet(6);
	if (sample > 3571)
		BSP_LedSet(7);
	if (sample > 3572)
		BSP_LedSet(8);

 */

void setLeds(uint16_t sample) 
{
	uint16_t leds = 0;
	/*
	if (sample > 3565)
		BSP_LedSet(1);
	if (sample > 3566)
		BSP_LedSet(2);
	if (sample > 3567)
		BSP_LedSet(3);
	if (sample > 3568)
		BSP_LedSet(4);
	if (sample > 3569)
		BSP_LedSet(5);
	if (sample > 3570)
		BSP_LedSet(6);
	if (sample > 3571)
		BSP_LedSet(7);
	if (sample > 3572)
		BSP_LedSet(8);
	*/
		
	
	if (sample > 0)
		BSP_LedSet(1);
	if (sample > 400)
		BSP_LedSet(2);
	if (sample > 800)
		BSP_LedSet(3);
	if (sample > 1200)
		BSP_LedSet(4);
	if (sample > 1600)
		BSP_LedSet(5);
	if (sample > 2000)
		BSP_LedSet(6);
	if (sample > 2400)
		BSP_LedSet(7);
	if (sample > 2800)
		BSP_LedSet(8);
	if (sample > 3200)
		BSP_LedSet(9);
	if (sample > 3600)
		BSP_LedSet(10);
	if (sample > 3600)
		BSP_LedSet(11);
	if (sample > 3600)
		BSP_LedSet(12);
	if (sample > 3600)
		BSP_LedSet(13);
	if (sample > 4000)
		BSP_LedSet(14);
	if (sample > 5000)
		BSP_LedSet(15);
	
}

int main( void ) 
{

	uint16_t sample;

	CMU_ClockEnable(cmuClock_HFPER, true);
	CMU_ClockEnable(cmuClock_ADC0, true);

  if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000)) while (1) ;

	ADCConfig();

  BSP_Init(BSP_INIT_DK_SPI);

	while(1) {    
		BSP_LedsSet(0x0000); //Delay(50);		//BSP_LedsSet(0xffff); Delay(50);

		ADC_Start(ADC0, adcStartSingle);

		while(ADC0->STATUS & ADC_STATUS_SINGLEACT);

		sample = ADC_DataSingleGet(ADC0);

		setLeds(sample);
		Delay(10);

	}

	return 0;
}
