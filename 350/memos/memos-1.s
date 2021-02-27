    .globl _start
    .code16

_start:
    movw $0x9000, %ax
    movw %ax, %ss       # ss:sp == stack segment : offset
    xorw %sp, %sp
	movb $0x65, %al
	movb $0x0E, %ah
	int $0x10

    movw $0x0, %ax
    movw %ax, %es
    leaw msg, %di
    movb $0x65, %al
	movb $0x0E, %ah
	int $0x10

    xorl %ebx, %ebx
    # movl $0x534D4150, %edx
    movl $0xE820, %eax
    movl $0x18, %ecx
    int $0x15
    movl %eax, %edx
    # movb $0x65, %al
    movl $8, %ecx 
3:
	movb $0x0E, %ah
    movb %dl, %al
    andb $0x0F, %al
    cmp $0x9, %al 
    jl 4
    add $0x30, %al
    jmp 5
4:
    add $0x37, %al
5:
    int $0x10
    shr $4, %dl
    loop 3b
    # jc end

    movw $0x0, %dx
    movw %dx, %ds
    leaw msg, %si
    movb $0x65, %al
	movb $0x0E, %ah
	int $0x10

1: 
    lodsb               # Load a byte from DS:SI to AL & increment SI
    movb $0x0E, %ah     # Write character to the screen
    int $0x10           # Make BIOS interrupt call to vector 0x10
    loop 1b             # Decrement CX, check for zero

    jmp end

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