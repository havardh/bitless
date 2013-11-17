#include "CppUTest/CommandLineTestRunner.h"
#include "sample_conversion.h"

TEST_GROUP(sample_conversion) {
	void setup() {}
	void teardown() {}
};

TEST(sample_conversion, shouldUnsignify) {
	
	int16_t samples[3] = { INT16_MIN, 0, INT16_MAX };
	uint16_t *result = (uint16_t*)samples;

	signedToUnsigned(samples, 3);

	CHECK_EQUAL(0, result[0]);
	CHECK_EQUAL(0x8000, result[1]);
	CHECK_EQUAL(UINT16_MAX, result[2]);
	
}


TEST(sample_conversion, shouldSignify) {
	
	uint16_t samples[3] = { 0, 0x8000, UINT16_MAX };
	int16_t *result = (int16_t*)samples;

	unsignedToSigned(samples, 3);
		
	CHECK_EQUAL(INT16_MIN, result[0]);
	CHECK_EQUAL(0, result[1]);
	CHECK_EQUAL(INT16_MAX, result[2]);
	
}

TEST(sample_conversion, shouldDownScale) {

	uint16_t samples[3] = { 0, UINT16_MAX/2, UINT16_MAX };

	downScale(samples, 3);

	CHECK_EQUAL(0, samples[0]);
	CHECK_EQUAL(UINT8_MAX/2, samples[1]);
	CHECK_EQUAL(UINT8_MAX, samples[2]);

}

TEST(sample_conversion, shouldUpScale) {

	uint16_t samples[3] = { 0, UINT8_MAX/2, UINT8_MAX };

	upScale(samples, 3);

	CHECK_EQUAL(0, samples[0]);
	CHECK_EQUAL( (UINT8_MAX/2) << 8, samples[1]);
	CHECK_EQUAL( (UINT8_MAX) << 8, samples[2]);

}


#include "sample_conversion.c"
