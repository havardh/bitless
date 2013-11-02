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
CPPFLAGS += -include $(CPPUTEST_HOME)/include/CppUTest/MemoryLeakDetectorNewMacros.h
CPPUTEST_CPPFLAGS = -x c++ -g
CFLAGS += --std=c99 -include $(CPPUTEST_HOME)/include/CppUTest/MemoryLeakDetectorMallocMacros.h

SRC_DIRS = \
  .\
	../controllers/main/src\
	./test-doubles/drivers/**\
	./test-doubles/libs/**\
  src\


TEST_SRC_DIRS = \
	./controllers/fpga\
	./libs/**\

INCLUDE_DIRS =\
	./test-doubles/**/**\
  ../**/**/inc\
	../**/**/src\
  ../**/inc\
	../libs/mocks/inc\
  $(CPPUTEST_HOME)/include\

include $(CPPUTEST_HOME)/build/MakefileWorker.mk
