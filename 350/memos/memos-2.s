    .globl _start
    .code16

_start:
    movw $0x9000, %ax
    movw %ax, %ss       # ss:sp == stack segment : offset
    xorw %sp, %sp
	movb '$, %al
	movb $0x0E, %ah
	int $0x10

    movw $0x0, %ax
    movw %ax, %es
    leaw msg, %di

    xorl %ebx, %ebx
    movl $0x534D4150, %edx
    movl $0xE820, %eax
    movl $0x18, %ecx
    int $0x15
    jc end

    movw $0x0, %dx
    movw %dx, %ds
    leaw msg, %si

1: 
    lodsb               # Load a byte from DS:SI to AL & increment SI
    movb $0x0E, %ah     # Write character to the screen
    int $0x10           # Make BIOS interrupt call to vector 0x10
    loop 1b             # Decrement CX, check for zero

    jmp end

print:	pushw %dx
	movb %al, %dl
	shrb $4, %al
	cmpb $10, %al
	jge 1f
	addb $0x30, %al		# Add ASCII '0' offset
	jmp 2f
1:	addb $55, %al		# Add ASCII 'A'-10 offset
2:	movb $0x0E, %ah
	int $0x10                   # BIOS interrupt with AH=0x0E for teletype output of char in %ax with 
                                # light gray color (%bx = 0x7)
	movb %dl, %al
	andb $0x0f, %al
	cmpb $10, %al
	jge 1f
	addb $0x30, %al
	jmp 2f
1:	addb $55, %al		
2:	movb $0x0E, %ah
	int $0x10
	popw %dx
	ret

msg: .asciz "                         "
msg_len: .word . - msg

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