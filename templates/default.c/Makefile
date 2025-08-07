CC = gcc
CFLAGS = -I. -Wall -Wextra -O0 -fPIC
LDFLAGS = -lm -lz

all: PROJECTNAME.exe

PROJECTNAME.exe: PROJECTNAME.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

PROJECTNAME.o: PROJECTNAME.c PROJECTNAME.h
	$(CC) $(CFLAGS) -c $<

clean:
	del *.o *.exe

.PHONY: all clean