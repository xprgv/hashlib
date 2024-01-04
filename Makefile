CC := gcc
CFLAGS := -Wall -g -z noexecstack
AS := nasm
ASFLAGS := -felf64

.PHONY: all clean obj bin

all: bin

obj: hash.s
	$(AS) $(ASFLAGS) $< -o hash.o

bin: obj
	$(CC) $(CFLAGS) examples/hashf.c hash.h hash.o -o hashf

# full:
# 	gcc -o main main.c hash.h hash.s

clean:
	rm *.o
	rm hashf