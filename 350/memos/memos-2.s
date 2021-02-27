    .globl _start
    .code16

_start:
    movw $0x9000, %ax
    movw %ax, %ss       # ss:sp == stack segment : offset
    xorw %sp, %sp
    movw $3, %ax
    int $0x10
	movb $65, %al
	movb $0x0E, %ah
	movw $0x07, %bx
	int $0x10

end:
    hlt


# This is going to be in our MBR for Bochs, so we need a valid signature
	.org 0x1FE

	.byte 0x55
	.byte 0xAA

# To test:	
# as --32 vga16.s -o vga16.o
# ld -T vga.ld vga16.o -o vga16
# dd bs=1 if=vga16 of=vga16_test skip=4096 count=512
# bochs -qf bochsrc-vga