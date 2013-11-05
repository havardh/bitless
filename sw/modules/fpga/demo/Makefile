DIR=../../..

CC = gcc
INCLUDE= -I. \
-I../inc \
-I$(DIR)/types/inc

CFLAGS = -std=c99 -g -Wall 

SRC= \
../src/FPGAController.c \
main.c

all: main

main: $(SRC)
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ $(SRC)

memcheck: main
	valgrind ./main

clean:
	-rm -f main