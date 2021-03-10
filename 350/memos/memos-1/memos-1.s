
    .globl _start
    .code16

_start:
    movw $0x9000, %ax
    movw %ax, %ss       # ss:sp == stack segment : offset
    xorw %sp, %sp
	

	movw $0x7C0, %dx
    movw %dx, %ds
	leaw msg, %si       # NB: We need to relocate from our linker script
    movw msg_len, %cx   # again relocation is required
1:
    lodsb               # Load a byte from DS:SI to AL & increment SI
	movb $0x0E, %ah     # Write character to the screen
	int $0x10           # Make BIOS interrupt call to vector 0x10
	loop 1b             # Decrement CX, check for zero
	
	movl $0x0, %eax
	movw %ax, %es
	movw $0x500, %bx
	movl %eax, (%bx)
	movw $0x504, %di
	movl %eax, (%di)
	xorl %ebx, %ebx
2:
	movl $0x534D4150, %edx
	movl $0x18, %ecx
	movl $0xE820, %eax
	int $0x15
	jc error
	
	
 	movw $0x0, %ax
 	movw %ax, %ds
    movw $0x500, %si
	xorl %edx, %edx
	pushl %ebx
	movl $11, %ebx
	movb 16(%di), %dl
	
    cmp $0x01, %dl
	jne 4f
3:
	shl $8, %eax
	movb (%bx, %di, 1), %al
	decw %bx
    cmp $7, %bx
	jne 3b
	
	movl (%si), %edx
	addl %eax, %edx
	movl %edx, (%si)
4:
	addw %cx, %di
	popl %ebx
	cmp $0, %ebx
	jne 2b

	movw $0x0, %dx
    movw %dx, %ds
    movw $3, %bx
5: 
	leaw 0x500(%bx), %si
	lodsb
	call print
	shl $8, %eax
	cmp $0, %bx
	je 6f
	decw %bx
	jmp 5b
	
6:
	movw $0x7C0, %dx
    movw %dx, %ds
	leaw msg2, %si
    movw msg2_len, %cx
7:
    lodsb
	movb $0x0E, %ah
	int $0x10
	loop 7b

	movw $0x0, %dx
    movw %dx, %ds
	movw $0x500, %si
	movl (%si), %edx
	shr $20, %edx
	movl %edx, (%si)
    movw $1, %bx
8:
	leaw 0x500(%bx), %si
	lodsb
	call print
	cmp $0, %bx
	je 9f
	decw %bx
	jmp 8b
9:
	movb $0x20, %al
	movb $0x0E, %ah
	int $0x10
	movb $'M, %al
	movb $0x0E, %ah
	int $0x10
	movb $'B, %al
	movb $0x0E, %ah
	int $0x10
	
end:
	cli
    hlt

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

error:
    movw $0x0, %dx
    movw %dx, %ds
    leaw error_msg, %si       # NB: We need to relocate from our linker script
    movw error_msg_len, %cx   # again relocation is required
1: 
    lodsb               # Load a byte from DS:SI to AL & increment SI
    movb $0x0E, %ah     # Write character to the screen
    int $0x10           # Make BIOS interrupt call to vector 0x10
    loop 1b             # Decrement CX, check for zero

	jmp end
	
msg: .ascii "MemOS: Welcome *** System Memory is: 0x"
msg_len: .word . - msg

msg2: .ascii " bytes = 0x"
msg2_len: .word . - msg2

error_msg: .asciz "ERROR"
error_msg_len: .word . - error_msg


# This is going to be in our MBR for Bochs, so we need a valid signature
	.org 0x1FE

	.byte 0x55
	.byte 0xAA

# To test:	
# as --32 vga16.s -o vga16.o
# ld -T vga.ld vga16.o -o vga16
# dd bs=1 if=vga16 of=vga16_test skip=4096 count=512
# bochs -qf bochsrc-vga