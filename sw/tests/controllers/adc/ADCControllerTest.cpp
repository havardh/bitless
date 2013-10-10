#include "CppUTest/CommandLineTestRunner.h"
#include "ADCController.h"
#include "ADCDriverSpy.h"

TEST_GROUP(ADCController) {
    void setup() {}
    void teardown() {}
};

TEST(ADCController, shouldDefineConfigStruct) {
	ADCConfig config;
	
	//config.channel = 0;
	config.resolution = 8;

	//CHECK_EQUAL(config.channel, 0);
	CHECK_EQUAL(config.resolution, 8);
}

TEST(ADCController, shouldHaveInitFunction) {
	
	ADCConfig config;
	ADCController_Init(&config);
	
}

TEST(ADCController, shouldDelegateToDriver) {
	
	ADCConfig config = {
		/*.channel =*/ CH5,
		/*.resolution =*/ 12,
		/*.rate =*/ 44100, // 44.1 kHz
		/*.mode =*/ SingleConversion
	};

	ADCController_Init( &config );

	ADCConfig *configOut = ADCDriverSpy_Init_Getconfig();
	CHECK_EQUAL( 12, configOut->resolution );
	CHECK_EQUAL( 44100, configOut->rate );
}

#define ADCDriver_Init(x) ADCDriverSpy_Init(x)
#include "ADCController.c"
#undef ADCDriver_Init
