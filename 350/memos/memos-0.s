    .globl _start
    .code16

_start:
    movw $0x9000, %ax
    movw %ax, %ss       # ss:sp == stack segment : offset
    xorw %sp, %sp

#   movw $0x7C0, %dx    # The BIOS loads the MBR at 0x7C00
    movw $0x0, %dx
    movw %dx, %ds

    leaw msg, %si       # NB: We need to relocate from our linker script
    movw msg_len, %cx   # again relocation is required

1: 
    lodsb               # Load a byte from DS:SI to AL & increment SI
    movb $0x0E, %ah     # Write character to the screen
    int $0x10           # Make BIOS interrupt call to vector 0x10
    loop 1b             # Decrement CX, check for zero


# Write "0x" to the screen
    movb $'0, %al       # '0 is ASCII(0)
    movb $0x0E, %ah
    int $0x10
    movb $'x, %al       # 'x is ASCII(x)
    movb $0x0E, %ah
    int $0x10

# Probe memory, try INT 0x15, AX = 0xE801
    movw $0xE801, %ax
    int $0x15

    # AX holds number of KBs between 1-16MB
    # BX holds number of 64KB pages above 16MB

    # Account for lower 1MB memory in system
    addw $0x400, %ax    # This is 1020 KBs

    movw %ax, %cx       # Make copies if the BIOS doesn't do this
    movw %bx, %dx


    # For now we just write a nasty looking HEX value for KBs
    # of memory below 16MB. A fancier solution would add all
    # memory regions, jumping over holes and print out free
    # memory in decimal.


    shr $8, %ax
    call print          # Writes what is in AL to screen in HEX
    movw %cx, %ax
    andb $0xFF, %ax
    call print

    # Here, then, finish with the memory units...KBs

    leaw munits, %si
    movw u_len, %cx
1:
    lodsb
    movb $0x0E, %ah
    int $0x10
    loop 1MB

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

msg: .asciz "MemOS: Welcome *** System Memory is: "
msg_len: .word . - msg

munits: .asciz "KB"
u_len: .word . - munits

end:
    htl


# This is going to be in our MBR for Bochs, so we need a valid signature
	.org 0x1FE

	.byte 0x55
	.byte 0xAA

# To test:	
# as --32 memos-0.s -o memos-0.o
# ld -T memos.ld memos-0.o -o memos-0
# dd bs=1 if=memos-0 of=memos-0_test skip=4096 count=512
# bochs -qf bochsrc-vga