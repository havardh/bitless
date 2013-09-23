#include "stdlib.h"

#define SPY1(returnType, functionName, type, arg)								\
	static type functionName##_##arg;															\
	static returnType functionName##ReturnValue;									\
	static int functionName##CallCount = 0;												\
	void functionName##_Set##arg(type arg)												\
  {																															\
  	functionName##_##arg = arg;																	\
	}																															\
	type functionName##_Get##arg()																\
	{																															\
		return functionName##_##arg;																\
	}																															\
	void functionName##_SetReturn(returnType returnValue)					\
	{																															\
		functionName##ReturnValue = returnValue;										\
	}																															\
	int functionName##_Called()																		\
	{																															\
		return functionName##CallCount > 0;													\
	}																															\
	returnType functionName(type arg)															\
	{																															\
		functionName##CallCount++;																	\
		functionName##_##arg = arg;																	\
		return functionName##ReturnValue;													  \
	}

#define H_SPY1(returnType, functionName, type, arg)							\
	void functionName##_Set##arg(type arg);												\
	type functionName##_Get##arg();																\
	void functionName##_SetReturn(returnType returnValue);				\
	int functionName##_Called();																	\
	returnType functionName(type arg);



#define SPY2(returnType, functionName, type1, arg1, type2, arg2)				\
	static type1 functionName##_##arg1;																		\
	static type2 functionName##_##arg2;																		\
	static int functionName##CallCount = 0;																\
	static returnType functionName##ReturnValue;													\
	void functionName##_Set##arg1(type1 arg1)															\
  {																																			\
  	functionName##_##arg1 = arg1;																				\
	}																																			\
	type1 functionName##_Get##arg1()																			\
	{																																			\
		return functionName##_##arg1;																				\
	}																																			\
	void functionName##_Set##arg2(type2 arg2)															\
  {																																			\
  	functionName##_##arg2 = arg2;																				\
	}																																			\
	type2 functionName##_Get##arg2()																			\
	{																																			\
		return functionName##_##arg2;																				\
	}																																			\
	void functionName##_SetReturn(returnType returnValue)									\
	{																																			\
		functionName##ReturnValue = returnValue;														\
	}																																			\
	int functionName##_Called()																						\
	{																																			\
	 return functionName##CallCount > 0;																	\
	 }																																		\
	returnType functionName(type1 arg1, type2 arg2)												\
	{																																			\
	 functionName##_##arg1 = arg1;																				\
	 functionName##_##arg2 = arg2;																				\
	 return functionName##ReturnValue;																		\
	 }

#define H_SPY2(returnType, functionName, type1, arg1, type2, arg2)			\
	void functionName##_Set##arg1(type1 arg1);														\
	type1 functionName##_Get##arg1();																			\
	void functionName##_Set##arg2(type2 arg2);														\
	type2 functionName##_Get##arg2();																			\
	void functionName##_SetReturn(returnType returnValue);								\
	int functionName##_Called();																					\
	returnType functionName(type1 arg1, type2 arg2);

#define SPY2_V(functionName, type1, arg1, type2, arg2)				\
	static type1 functionName##_##arg1;																		\
	static type2 functionName##_##arg2;																		\
	static int functionName##CallCount = 0;																\
	void functionName##_Set##arg1(type1 arg1)															\
  {																																			\
  	functionName##_##arg1 = arg1;																				\
	}																																			\
	type1 functionName##_Get##arg1()																			\
	{																																			\
		return functionName##_##arg1;																				\
	}																																			\
	void functionName##_Set##arg2(type2 arg2)															\
  {																																			\
  	functionName##_##arg2 = arg2;																				\
	}																																			\
	type2 functionName##_Get##arg2()																			\
	{																																			\
		return functionName##_##arg2;																				\
	}																																			\
	int functionName##_Called()																						\
	{																																			\
	 return functionName##CallCount > 0;																	\
	 }																																		\
		void functionName(type1 arg1, type2 arg2)														\
	{																																			\
		functionName##CallCount++;																					\
	 functionName##_##arg1 = arg1;																				\
	 functionName##_##arg2 =arg2;								\
	 }

#define H_SPY2_V(functionName, type1, arg1, type2, arg2)								\
	void functionName##_Set##arg1(type1 arg1);														\
	type1 functionName##_Get##arg1();																			\
	void functionName##_Set##arg2(type2 arg2);														\
	type2 functionName##_Get##arg2();																			\
	int functionName##_Called();																					\
	void functionName(type1 arg1, type2 arg2);

#define SPY1_V(functionName, type, arg)				\
	static type functionName##_##arg;																		\
	static int functionName##CallCount = 0;																\
	void functionName##_Set##arg(type arg)															\
  {																																			\
  	functionName##_##arg = arg;																				\
	}																																			\
	type functionName##_Get##arg()																			\
	{																																			\
		return functionName##_##arg;																				\
	}																																			\
	int functionName##_Called()																						\
	{																																			\
	 return functionName##CallCount > 0;																	\
	 }																																		\
		void functionName(type arg)														\
	{																																			\
		functionName##CallCount++;																					\
	 functionName##_##arg = arg;																				\
	 }

#define H_SPY1_V(functionName, type, arg)								\
	void functionName##_Set##arg(type arg);														\
	type functionName##_Get##arg();																			\
	int functionName##_Called();																					\
	void functionName(type arg);



//SPY1(uint8_t, ADC_PrescaleCalc, uint32_t, adcFreq)
