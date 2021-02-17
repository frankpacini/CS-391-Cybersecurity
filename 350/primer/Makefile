# A few tips about this Makefile:
#
# make -C [dir] changes the current working directory to [dir]
# before executing the make command
#
# Linux's kernel makefile is located under /lib/modules/`uname -r`/build
# 
# obj-m is a variable in Linux's Makefile that specifies object files
# which are built as loadable kernel modules.
#

obj-m += keyboard_module.o

all: keyboard_module keyboard_test install

keyboard_module: keyboard_module.c
	make -C /lib/modules/`uname -r`/build SUBDIRS=/root/350/primer modules

keyboard_test: keyboard_test.c
	gcc -o keyboard_test keyboard_test.c
	
install: keyboard_module
	insmod keyboard_module.ko
	./keyboard_test

clean:
	pkill "./keyboard_test" || true
	rm -f keyboard_module.o keyboard_module.ko keyboard_module.mod.c keyboard_module.mod.o Module.symvers modules.order keyboard_test
	rmmod keyboard_module.ko	
