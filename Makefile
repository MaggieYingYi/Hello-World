#
# Makefile for building helloc.c using clang + musl-libc (requires GNU make)
#

PATHTOMUSL = ${HOME}/musl-prepo

CFLAGS = -std=c11 -target x86_64-pc-linux-gnu-repo -nostdinc -nodefaultlibs -I$(PATHTOMUSL)/obj/include --sysroot $(PATHTOMUSL) -isystem $(PATHTOMUSL)/include

%.elf: %.o
	repo2obj --repo=helloc.db -o $@ $<

.PHONY: all
all :
	make helloc.db
	make helloc

TICKETS = helloc.o ctr1_asm.o memcpy.o memset.o set_thread_area.o
ELFS = $(TICKETS:%.o=%.elf)

.PHONY: clean
clean:
	rm $(TICKETS) $(ELFS) helloc

.PHONY: distclean
distclean: clean
	rm -f helloc.db

helloc.db: helloc.json
	-rm -f $@
	pstore-import $@ $<

helloc.o: helloc.db helloc.c
	REPOFILE=$*.db	clang $(CFLAGS) -c -o $@ $*.c

ctr1_asm.o: helloc.db
	repo-create-ticket --output=./$@ --repo=$< 0d89c794f89f75747df70d0f6b2832ed
memcpy.o: helloc.db
	repo-create-ticket --output=./$@ --repo=$< 4c9f1d7ecaca97ea2d3ff025d2ac3f23
memset.o: helloc.db
	repo-create-ticket --output=./$@ --repo=$< e0adc5a2801f47044a03f962ec0634e8
set_thread_area.o: helloc.db
	repo-create-ticket --output=./$@ --repo=$< 61823da085f534c947264e1497f73741

MUSL_OBJECTS = \
	$(PATHTOMUSL)/obj/src/stdio/printf.o.elf \
	$(PATHTOMUSL)/obj/src/env/__libc_start_main.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/stdout.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/vfprintf.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/ofl.o.elf \
	$(PATHTOMUSL)/obj/src/errno/strerror.o.elf \
	$(PATHTOMUSL)/obj/src/env/__environ.o.elf \
	$(PATHTOMUSL)/obj/src/env/__init_tls.o.elf \
	$(PATHTOMUSL)/obj/src/exit/exit.o.elf \
	$(PATHTOMUSL)/obj/src/exit/_Exit.o.elf \
	$(PATHTOMUSL)/obj/src/internal/defsysinfo.o.elf \
	$(PATHTOMUSL)/obj/src/internal/libc.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/__stdio_close.o.elf \
	$(PATHTOMUSL)/obj/src/internal/syscall_ret.o.elf \
	$(PATHTOMUSL)/obj/src/errno/__errno_location.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/__stdio_seek.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/__stdout_write.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/__stdio_write.o.elf \
	$(PATHTOMUSL)/obj/src/math/__fpclassifyl.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/fwrite.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/__lockfile.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/__towrite.o.elf \
	$(PATHTOMUSL)/obj/src/stdio/__stdio_exit.o.elf \
	$(PATHTOMUSL)/obj/src/math/__signbitl.o.elf \
	$(PATHTOMUSL)/obj/src/math/frexpl.o.elf \
	$(PATHTOMUSL)/obj/src/locale/__lctrans.o.elf \
	$(PATHTOMUSL)/obj/src/multibyte/wctomb.o.elf \
	$(PATHTOMUSL)/obj/src/multibyte/wcrtomb.o.elf \
	$(PATHTOMUSL)/obj/src/string/strnlen.o.elf \
	$(PATHTOMUSL)/obj/src/string/memchr.o.elf \
	$(PATHTOMUSL)/obj/src/thread/__lock.o.elf \
	$(PATHTOMUSL)/obj/src/thread/default_attr.o.elf \
	$(PATHTOMUSL)/obj/src/unistd/lseek.o.elf \
	$(PATHTOMUSL)/obj/crt/crt1.o.elf \

helloc : $(ELFS)
	ld -o $@ -nostdlib -static --sysroot $(PATHTOMUSL) -L $(PATHTOMUSL)/lib $(MUSL_OBJECTS) $(ELFS)
