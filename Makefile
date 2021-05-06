#
# Makefile for building helloc.c using clang + musl-libc (requires GNU make)
#

LLVM = ${HOME}/LLVM
MUSL = ${HOME}/musl

CFLAGS = -std=c11 \
	 -target x86_64-pc-linux-gnu-repo \
	 -nostdinc \
	 -nodefaultlibs \
	 --sysroot $(MUSL) \
	 -isystem $(MUSL)/include

CXXFLAGS = -std=c++11 \
	   -target x86_64-pc-linux-gnu-repo \
	   -nostdinc++ \
	   -nostdinc \
	   -nodefaultlibs \
	   -fno-exceptions \
	   -fno-rtti \
	   --sysroot $(MUSL) \
	   -isystem $(LLVM)/include/c++/v1 \
	   -isystem $(MUSL)/include

LDFLAGS = -nostdlib \
	  -nodefaultlibs \
	  -static \
	  --sysroot $(MUSL) \
	  -L $(MUSL)/lib \
	  $(MUSL)/lib/crt1_asm.t.o \
	  $(MUSL)/lib/crt1.t.o \
	  -lc_elf

CXX_LDFLAGS = -stdlib=libc++ \
	      -L $(LLVM)/lib \
	      -L $(LLVM)/lib/linux \
	      -stdlib=libc++ \
	      $(LLVM)/lib/linux/clang_rt.crtbegin-x86_64.o.elf \
	      $(LLVM)/lib/linux/clang_rt.crtend-x86_64.o.elf \
	      -lc++ \
	      -lc++abi \
	      -lunwind \
	      -lclang_rt.builtins-x86_64 \
	      $(LDFLAGS)

.PHONY: all
all : helloc hellocpp

.PHONY: clean
clean:
	-rm -f helloc.o helloc.elf helloc hellocpp.o hellocpp.elf hellocpp

.PHONY: distclean
distclean: clean
	-rm -f clang.db

helloc.o: helloc.c
	$(CC) $(CFLAGS) -c -o $@ $^

hellocpp.o: hellocpp.cpp
	$(CC) $(CXXFLAGS) -c -o $@ $^

REPO2OBJ_CMD = repo2obj -o $@ $<
%.elf : %.o
	$(REPO2OBJ_CMD)

helloc : helloc.elf
	$(CC) -o $@ $< $(LDFLAGS)

hellocpp: hellocpp.elf
	$(CC) -o $@ hellocpp.elf $(CXX_LDFLAGS)
