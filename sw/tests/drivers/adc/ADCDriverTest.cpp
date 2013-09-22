#include "CppUTest/CommandLineTestRunner.h"
#include "ADCDriver.h"
#include "em_adc_spy.h"

static ADCConfig C;

TEST_GROUP(ADCDriver) {
	void setup() {}
	void teardown() {}
};

TEST(ADCDriver, shouldHaveInitFunction) {
	ADCDriver_Init( &C );
}

TEST(ADCDriver, shouldUseADC_PrescaleCalc) {

	C.rate = 44100;

	ADCDriver_Init( &C );

	CHECK_EQUAL( 44100, ADC_PrescaleCalc_GetadcFreq() );

}

TEST(ADCDriver, shouldUseADC_TimebaseCalc) {

	ADCDriver_Init( &C );

	CHECK_EQUAL( 0, ADC_TimebaseCalc_GethfperFreq() );

}

TEST(ADCDriver, shouldCallInitOnADC) {
	
	ADCDriver_Init( &C );

	CHECK( ADC_Init_Called() );	
}

TEST(ADCDriver, shouldUseADC0) {

	ADC0.CTRL = 100;

	ADCDriver_Init( &C );

	ADC_TypeDef adc = ADC_Init_Getadc();
	CHECK_EQUAL( 100, adc.CTRL );

}

TEST(ADCDriver, shouldPassConfigToADC) {

	ADC_PrescaleCalc_SetReturn(10);
	ADC_TimebaseCalc_SetReturn(10);

	ADCDriver_Init( &C );

	const ADC_Init_TypeDef *init = ADC_Init_Getinit();
	CHECK_EQUAL(10, init->timebase);
	CHECK_EQUAL(10, init->prescale);
	
}

TEST(ADCDriver, shouldSupportSingleConvertion) {

	C.mode = ADCMode_SingleConvertion;
	
	ADCDriver_Init( &C );

	CHECK( ADC_InitSingle_Called() );

}

TEST(ADCDriver, shouldSetResolution) {
	
	C.mode = ADCMode_SingleConvertion;
	C.resolution = 8;
	
	ADCDriver_Init( &C );

	const ADC_InitSingle_TypeDef *init = ADC_InitSingle_Getinit();
	CHECK_EQUAL( adcRes8Bit, init->resolution );
}

static const ADC_InitSingle_TypeDef *initSpy;

TEST_GROUP(ADCDriver_InitSingle_Defaults) {
	void setup() {
		ADCDriver_Init( &C );
		initSpy = ADC_InitSingle_Getinit();
	}
	void teardown() {}
};

TEST(ADCDriver_InitSingle_Defaults, referenceShouldDefaultTo1V25) {
 
	CHECK_EQUAL( adcRef1V25, initSpy->reference );
	
}

TEST(ADCDriver_InitSingle_Defaults, inputShouldDefaultToVDDDiv3) {
 
	CHECK_EQUAL( adcSingleInpVDDDiv3, initSpy->input );
	
}

TEST(ADCDriver_InitSingle_Defaults, acqTimeShouldDefaultTo32) {
 
	CHECK_EQUAL( adcAcqTime32, initSpy->acqTime );
	
}

#include "ADCDriver.c"
