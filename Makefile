#
# Makefile for building helloc.c using clang + musl-libc (requires GNU make)
#

MUSL = ${HOME}/musl

CFLAGS = -std=c11 \
	-target x86_64-pc-linux-gnu-repo \
	-nostdinc \
	-nodefaultlibs \
	--sysroot $(MUSL) \
	-isystem $(MUSL)/include

.PHONY: all
all : helloc

.PHONY: clean
clean:
	-rm -f helloc.o helloc.elf helloc

.PHONY: distclean
distclean: clean
	-rm -f clang.db

helloc.o: helloc.c
	$(CC) $(CFLAGS) -c -o $@ $^

helloc.elf: helloc.o
	repo2obj -o $@ $<

helloc : helloc.elf
	ld -o $@ -nostdlib -static --sysroot $(MUSL) -L $(MUSL)/lib helloc.elf $(MUSL)/lib/crt1.o.elf $(MUSL)/lib/crt1_asm.o.elf -lc
