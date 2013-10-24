#include "CppUTest/CommandLineTestRunner.h"
#include "CircularBuffer.h"

TEST_GROUP(CircularBuffer) {
	void setup() {}
	void teardown() {}
};

TEST(CircularBuffer, shouldInitializePointerStart) {
	

	uint16_t *buf = (uint16_t*)malloc(sizeof(uint16_t));
	CircularBuffer cb = CircularBuffer_New(buf, 1, 1);

	void *ptr = CircularBuffer_GetBuffer( cb );

	POINTERS_EQUAL( ptr, buf );

	free( buf );
	free( cb );	
}

TEST(CircularBuffer, shouldMovePointerWhenRequested) {

	uint16_t *buf = (uint16_t*) malloc(sizeof(uint16_t)*2);
	CircularBuffer cb = CircularBuffer_New(buf, 4, 2);
	
	CircularBuffer_MoveToNext( cb );
	uint16_t *ptr = CircularBuffer_GetBuffer( cb );

	POINTERS_EQUAL( buf+2, ptr );

	free( buf );
	free( cb );
}

TEST(CircularBuffer, shouldWrapAround) {
	
	uint16_t *buf = (uint16_t*) malloc(sizeof(uint16_t)*4);
	CircularBuffer cb = CircularBuffer_New( buf, 4, 2);
	
	CircularBuffer_MoveToNext( cb );
	CircularBuffer_MoveToNext( cb );
	uint16_t *ptr = CircularBuffer_GetBuffer( cb );

	POINTERS_EQUAL( ptr, buf );

	free( buf );
	free( cb );	
	
}

TEST(CircularBuffer, shouldHaveGetAndIncrementFunction) {
	
	uint16_t *buf = (uint16_t*) malloc(sizeof(uint16_t)*4);
	CircularBuffer cb = CircularBuffer_New(buf, 4, 2);
 
	POINTERS_EQUAL( CircularBuffer_GetNextBuffer( cb ), buf );
	POINTERS_EQUAL( CircularBuffer_GetNextBuffer( cb ), buf+2 );
	free( buf );
	free( cb );
	
}


TEST(CircularBuffer, shouldSupportLargeSplit) {
	
	uint16_t *buf = (uint16_t*) malloc(sizeof(uint16_t)*16);
	CircularBuffer cb = CircularBuffer_New( buf, 16, 4);
	
	POINTERS_EQUAL( CircularBuffer_GetNextBuffer( cb ), buf );
	POINTERS_EQUAL( CircularBuffer_GetNextBuffer( cb ), buf+4 );
	POINTERS_EQUAL( CircularBuffer_GetNextBuffer( cb ), buf+8 );
	POINTERS_EQUAL( CircularBuffer_GetNextBuffer( cb ), buf+12 );
	POINTERS_EQUAL( CircularBuffer_GetNextBuffer( cb ), buf );

	free( buf );
	free( cb );	
}


#include "CircularBuffer.c"
