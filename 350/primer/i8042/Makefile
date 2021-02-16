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

obj-m += i8042.o

all: i8042 install

i8042: i8042.c
	make -C /lib/modules/`uname -r`/build SUBDIRS=$(PWD) modules
	modprobe i8042.ko
	
clean:
	rm -f i8042.o i8042.ko i8042.mod.c i8042.mod.o Module.symvers modules.order
	rmmod i8042.ko	
