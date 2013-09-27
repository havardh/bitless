#include "CppUTest/CommandLineTestRunner.h"
#include "ADCDriver.h"
#include "em_adc_spy.h"

static ADCConfig C;


TEST_GROUP(ADCDriver) {
	void setup() {}
	void teardown() {
		ADC_Init_Freeinit();
		ADC_InitSingle_Freeinit();
	}
};

TEST(ADCDriver, shouldHaveInitFunction) {
	ADCDriver_Init( &C );
}

TEST(ADCDriver, shouldUseADC_PrescaleCalc) {

	C.rate = 44100;

	ADCDriver_Init( &C );

	CHECK_EQUAL( 4000000, ADC_PrescaleCalc_GetadcFreq() );
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

	ADC_PrescaleCalc_SetReturnValue(10);
	ADC_TimebaseCalc_SetReturnValue(10);

	ADCDriver_Init( &C );

	const ADC_Init_TypeDef *init = ADC_Init_Getinit();
	CHECK_EQUAL(10, init->timebase);
	CHECK_EQUAL(10, init->prescale);
}

TEST(ADCDriver, shouldSetDefaultParameters) {

	ADCDriver_Init( &C );

	const ADC_Init_TypeDef *init = ADC_Init_Getinit();
	CHECK_EQUAL( adcWarmupKeepADCWarm, init->warmUpMode );
	CHECK_EQUAL( true, init->tailgate );
}

TEST(ADCDriver, shouldSupportSingleConversion) {

	C.mode = SingleConversion;
	
	ADCDriver_Init( &C );

	CHECK( ADC_InitSingle_Called() );
}

TEST(ADCDriver, shouldSetResolution) {
	
	C.mode = SingleConversion;
	C.resolution = 8;
	
	ADCDriver_Init( &C );

	const ADC_InitSingle_TypeDef *init = ADC_InitSingle_Getinit();
	CHECK_EQUAL( adcRes8Bit, init->resolution );
}


TEST(ADCDriver, shouldSetChannel) {
	
	C.mode = SingleConversion;
	C.channel = CH5;
	
	ADCDriver_Init( &C );

	const ADC_InitSingle_TypeDef *init = ADC_InitSingle_Getinit();
	CHECK_EQUAL( adcSingleInpCh5, init->input );
}



static const ADC_InitSingle_TypeDef *initSpy;

TEST_GROUP(ADCDriver_InitSingle_Defaults) {
	void setup() {
		C.mode = SingleConversion;
		C.channel = VDDDiv3;
		ADCDriver_Init( &C );
		initSpy = ADC_InitSingle_Getinit();
	}
	void teardown() {
		
		ADC_Init_Freeinit();
		ADC_InitSingle_Freeinit();
	}
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

TEST_GROUP(ADCDriver_InitScan) {
	void setup() {
		C.mode = ScanConversion;
	}
	void teardown() {
		ADC_Init_Freeinit();
		ADC_InitScan_Freeinit();
	}
};

TEST(ADCDriver_InitScan, shouldSupportScanConversion) {

	ADCDriver_Init( &C );

	CHECK( ADC_InitScan_Called() );

}

TEST(ADCDriver_InitScan, shouldSetDefaultParameters) {
	
	ADCDriver_Init( &C );

	const ADC_InitScan_TypeDef *init = ADC_InitScan_Getinit();
	CHECK_EQUAL( adcPRSSELCh0, init->prsSel );
	CHECK_EQUAL( true, init->prsEnable );
	CHECK_EQUAL( adcRefVDD, init->reference );
	
}

TEST(ADCDriver_InitScan, shouldSetResolution) {
	
	C.resolution = 12;

	ADCDriver_Init( &C );
	
	const ADC_InitScan_TypeDef *init = ADC_InitScan_Getinit();
	CHECK_EQUAL( adcRes12Bit, init->resolution );
	
}



#include "ADCDriver.c"
