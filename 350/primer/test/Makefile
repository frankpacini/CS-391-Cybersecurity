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

obj-m += test_module.o

all: test_module install

test_module: test_module.c
	make -C /lib/modules/`uname -r`/build SUBDIRS=$(PWD) modules
	
install: test_module
	insmod test_module.ko

clean:
	rm -f test_module.o test_module.ko test_module.mod.c test_module.mod.o Module.symvers modules.order
	rmmod test_module.ko	