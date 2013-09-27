#define H_SPY_Called(functionName)							\
	int functionName##_Called();																					

#define H_SPY_Set(functionName, type, arg)			\
	void functionName##_Set##arg(type arg);				\

#define H_SPY_GetSet(functionName, type, arg)		\
	H_SPY_Set(functionName,type,arg)							\
	type functionName##_Get##arg();								\

#define H_SPY_Free(functionName, arg)						\
	void functionName##_##Free##arg();

#define SPY_Set(functionName, type, arg)																				\
void functionName##_Set##arg(type arg) { functionName##_##arg = arg; }	

#define SPY_GetSet(functionName, type, arg)											\
	SPY_Set(functionName, type, arg)															\
type functionName##_Get##arg() { return functionName##_##arg; }

#define SPY_Called(functionName)																				\
	int functionName##_Called() { return functionName##CallCount > 0; } 

#define SPY_Type(functionName, type, arg)				\
	static type functionName##_##arg;

#define SPY_Count(functionName)									\
	static int functionName##CallCount = 0;

#define SPY_IncrCall(functionName)							\
	functionName##CallCount++;

#define SPY_SaveParam(functionName, arg)				\
	functionName##_##arg = arg;

#define SPY_MallocParam(functionName, type, arg)	\
	functionName##_##arg = (type *)malloc(sizeof(type));

#define SPY_Free(functionName, arg)							\
	void functionName##_##Free##arg() {						\
	free(functionName##_##arg);										\
	}

#define SPY_SaveParamPtr(functionName, type, arg)								\
	memcpy((void*)functionName##_##arg, (void*)arg, sizeof(type));

#define SPY1_Function(returnType, functionName, type, arg)	\
	returnType functionName(type arg) {												\
		SPY_IncrCall(functionName)															\
			SPY_SaveParam(functionName, arg)											\
			return functionName##_##ReturnValue; }

#define SPY2_Function(returnType, functionName, type1, arg1, type2, arg2)	\
	returnType functionName(type1 arg1, type2 arg2) {											\
		SPY_IncrCall(functionName)																					\
			SPY_SaveParam(functionName, arg1)																	\
			SPY_SaveParam(functionName, arg2)																	\
			return functionName##_##ReturnValue; }

#define SPY1_Function_V(functionName, type, arg)	\
	void functionName(type arg) {										\
		SPY_IncrCall(functionName)										\
			SPY_SaveParam(functionName, arg)						\
			}							

#define SPY2_Function_V(functionName, type1, arg1, type2, arg2)					\
	void functionName(type1 arg1, type2 arg2) {														\
		SPY_IncrCall(functionName)																					\
			SPY_SaveParam(functionName, arg1)																	\
			SPY_SaveParam(functionName, arg2)																	\
			}

#define SPY1_Function_P(returnType, functionName, type, arg)	\
	returnType functionName(type * arg) {												\
		SPY_IncrCall(functionName)															\
			SPY_SaveParamPtr(functionName, arg)											\
			return functionName##_##ReturnValue; }

#define SPY2_Function_VP(functionName, type1, arg1, type2, arg2)	\
	void functionName(type1 arg1, type2 * arg2) {											\
		SPY_IncrCall(functionName)																		\
			SPY_SaveParam(functionName, arg1)														\
			SPY_MallocParam(functionName, type2, arg2)									\
			SPY_SaveParamPtr(functionName, type2, arg2)									\
			 }

#define H_SPY1_V(functionName, type, arg)				\
	H_SPY_GetSet(functionName, type, arg)					\
	H_SPY_Called(functionName)										\
	void functionName(type arg);

#define SPY1_V(functionName, type, arg)								\
	SPY_Type(functionName, type, arg)										\
	SPY_Count(functionName)															\
	SPY_GetSet(functionName, type, arg)									\
	SPY_Called(functionName)														\
	SPY1_Function_V(functionName, type, arg)

#define H_SPY1(returnType, functionName, type, arg)	\
	H_SPY_GetSet(functionName, type, arg)							\
	H_SPY_Set(functionName, returnType, ReturnValue)	\
	H_SPY_Called(functionName)												\
	returnType functionName(type arg);

#define SPY1(returnType, functionName, type, arg)			\
	SPY_Type(functionName, type, arg)										\
	SPY_Type(functionName, returnType, ReturnValue)			\
	SPY_Count(functionName)															\
	SPY_GetSet(functionName, type, arg)									\
	SPY_Set(functionName, returnType, ReturnValue)		\
	SPY_Called(functionName)														\
	SPY1_Function(returnType, functionName, type, arg)

#define H_SPY2(returnType, functionName, type1, arg1, type2, arg2)	\
	H_SPY_GetSet(functionName, type1, arg1)														\
	H_SPY_GetSet(functionName, type2, arg2)														\
	H_SPY_Set(functionName, returnType, ReturnValue)									\
	H_SPY_Called(functionName)																				\
	returnType functionName(type1 arg1, type2 arg2);

#define SPY2(returnType, functionName, type1, arg1, type2, arg2)		\
	SPY_Type(functionName, type1, arg1)																\
	SPY_Type(functionName, type2, arg2)																\
	SPY_Type(functionName, returnType, ReturnValue)										\
	SPY_Count(functionName)																						\
	SPY_GetSet(functionName, type1, arg1)																	\
	SPY_GetSet(functionName, type2, arg2)																	\
	SPY_Set(functionName, returnType, ReturnValue)											\
	SPY_Called(functionName)																							\
	SPY2_Function(returnType, functionName, type1, arg1, type2, arg2)

#define H_SPY2_V(functionName, type1, arg1, type2, arg2)	\
	H_SPY_GetSet(functionName, type1, arg1)									\
	H_SPY_GetSet(functionName, type2, arg2)									\
	H_SPY_Called(functionName)															\
	void functionName(type1 arg1, type2 arg2);

#define SPY2_V(functionName, type1, arg1, type2, arg2)									\
	SPY_Type(functionName, type1, arg1)																		\
	SPY_Type(functionName, type2, arg2)																		\
	SPY_Count(functionName)																								\
	SPY_GetSet(functionName, type1, arg1)																	\
	SPY_GetSet(functionName, type2, arg2)																	\
	SPY_Called(functionName)																							\
		SPY2_Function_V(functionName, type1, arg1, type2, arg2)

#define H_SPY1_P(returnValue, functionName, type, arg)								\
	H_SPY_GetSet(functionName, type *, arg)															\
	H_SPY_Called(functionName)																					\
	void functionName(type * arg);

#define SPY1_P(returnValue, functionName, type, arg)								\
	SPY_Type(functionName, type, arg)																	\
	SPY_Count(functionName)																						\
	SPY_Type(functionName, returnType, ReturnValue)										\
	SPY_GetSet(functionName, type, arg)																\
	SPY1_Function_P(returnValue, functionName, type, arg)

#define H_SPY2_VP(functionName, type1, arg1, type2, arg2)								\
	H_SPY_GetSet(functionName, type1, arg1)																\
	H_SPY_GetSet(functionName, type2 *, arg2)															\
	H_SPY_Called(functionName)																					\
	H_SPY_Free(functionName, arg2)																				\
	void functionName(type1 arg1, type2 * arg2);

#define SPY2_VP(functionName, type1, arg1, type2, arg2)								\
	SPY_Type(functionName, type1, arg1)																		\
	SPY_Type(functionName, type2 *, arg2)																		\
	SPY_Count(functionName)																								\
	SPY_GetSet(functionName, type1, arg1)																	\
	SPY_GetSet(functionName, type2 *, arg2)																	\
	SPY_Free(functionName, arg2)																					\
	SPY_Called(functionName)																							\
	SPY2_Function_VP(functionName, type1, arg1, type2, arg2)
