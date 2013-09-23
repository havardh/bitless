#---------
#
# CppUTest Examples Makefile
#
#----------

#Set this to @ to keep the makefile quiet
ifndef SILENCE
	SILENCE = @
endif

#--- Inputs ----#
COMPONENT_NAME = all
CPPUTEST_HOME = ../libs/cpputest

CPPUTEST_USE_EXTENSIONS = Y
CPP_PLATFORM = GCC
CPPUTEST_CPPFLAGS = -x c++ 
CFLAGS += --std=c99

SRC_DIRS = \
  .\
  ../libs/math/src\
	./test-doubles/drivers/**\
	./test-doubles/libs/**\
  src\


TEST_SRC_DIRS = \
	./**/**\

INCLUDE_DIRS =\
	./test-doubles/**/**\
  ../**/**/inc\
	../**/**/src\
  ../**/inc\
	../libs/mocks/inc\
  $(CPPUTEST_HOME)/include\

include $(CPPUTEST_HOME)/build/MakefileWorker.mk
