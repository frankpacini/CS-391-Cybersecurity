# ** Copyright Rich West, Boston University **
#	
# Test vga settings using real mode
# This dumps various register values used for setting up a video
# mode such as 16 color 640x480.
#	
# Originally developed as a bootup routine to reverse-engineer a VGA-based
# video driver for the Quest OS, to support Pacman.
# If it can't play Pacman it's not a proper OS!	
 
	.globl _start
	
	.code16

_start:
	movw $0x9000, %ax
	movw %ax, %ss       # Move 0x9000 into the stack segment
	xorw %sp, %sp

# set video mode	
	movw $0x0003, %ax   # Use VESA VBE mode 3
	int $0x10           # BIOS interrupt with AH==00h, AL==03 to set video mode to 3

# sequencer	            # For 5 iterations updates 0x3C4 with the character it is on (index byte),
                        # reads a character from VGA 0x3C5 (data byte), and prints it followed by a newline 
	movw $0x3c4, %dx
	xorb %al, %al
	movw $5, %cx
1:	
	outb %al, %dx       # Write al (incremented from 0 to 4) to VGA port 0x3C4
	incw %dx
	pushw %ax           
	inb %dx, %al        # Read byte from VGA port 0x3C5 to al
	decw %dx

	call print
	
	popw %ax
	incb %al
	loop 1b             # decrement %cx, jump if it does not equal 0 (so 5 iterations) 

	movw $0x0e0d, %ax   
	movw $0x07, %bx
	int $0x10           
	movw $0x0e0a, %ax
	movw $0x07, %bx
	int $0x10           # BIOS interrupts for teletype output of newline (carriage return + line feed)

# attribute controller	    # Same as sequencer but with ports 0x3c0 and 0x3c1 and using indices 
                            # 0x10 - 0x13 and 0x34
	movw $0x3c0, %dx
	movb $0x10, %al
	movw $4, %cx
1:	
	outb %al, %dx
	incw %dx
	pushw %ax
	inb %dx, %al
	decw %dx
	
	call print
	
	popw %ax
	incb %al
	loop 1b

	movb $0x34, %al
	outb %al, %dx
	incw %dx
	inb %dx, %al

	call print

	movw $0x0e0d, %ax
	movw $0x07, %bx
	int $0x10
	movw $0x0e0a, %ax
	movw $0x07, %bx
	int $0x10

# graphics register         # Same as previous but with ports 0x3ce, 0x3cf and indices
                            # 0 through 9
	movw $0x3ce, %dx
	xorb %al, %al
	movw $9, %cx
1:	
	outb %al, %dx
	incw %dx
	pushw %ax
	inb %dx, %al
	decw %dx

	call print
	
	popw %ax
	incb %al
	loop 1b

	movw $0x0e0d, %ax
	movw $0x07, %bx
	int $0x10
	movw $0x0e0a, %ax
	movw $0x07, %bx
	int $0x10

# crt controller	            # ports 0x3D4, 0x3D5, indices 0-24
	movw $0x3d4, %dx
	xorb %al, %al
	movw $25, %cx
1:	
	outb %al, %dx
	incw %dx
	pushw %ax
	inb %dx, %al
	decw %dx

	call print
	
	popw %ax
	incb %al
	loop 1b

	movw $0x0e0d, %ax
	movw $0x07, %bx
	int $0x10
	movw $0x0e0a, %ax
	movw $0x07, %bx
	int $0x10

# misc o/p register
	movw $0x3cc, %dx
	inb %dx, %al

	call print

1:	jmp 1b
	
print:	pushw %dx
	movb %al, %dl
	shrb $4, %al
	cmpb $10, %al
	jge 1f
	addb $0x30, %al		# Add ASCII '0' offset
	jmp 2f
1:	addb $55, %al		# Add ASCII 'A'-10 offset
2:	movb $0x0E, %ah
	movw $0x07, %bx
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
	movw $0x07, %bx
	int $0x10
	popw %dx
	ret

# This is going to be in our MBR for Bochs, so we need a valid signature
	.org 0x1FE

	.byte 0x55
	.byte 0xAA

# To test:	
# as --32 vga16.s -o vga16.o
# ld -T vga.ld vga16.o -o vga16
# dd bs=1 if=vga16 of=vga16_test skip=4096 count=512
# bochs -qf bochsrc-vga
	