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

obj-m += ioctl_module.o

all: ioctl_module ioctl_test install

ioctl_module: ioctl_module.c
	make -C /lib/modules/`uname -r`/build SUBDIRS=/root/350/primer modules

ioctl_test: ioctl_test.c
	gcc -o ioctl_test ioctl_test.c
	
install: ioctl_module
	insmod ioctl_module.ko
	./ioctl_test

clean:
	pkill "./ioctl_test" || true
	rm -f ioctl_module.o ioctl_module.ko ioctl_module.mod.c ioctl_module.mod.o Module.symvers modules.order ioctl_test
	rmmod ioctl_module.ko	
