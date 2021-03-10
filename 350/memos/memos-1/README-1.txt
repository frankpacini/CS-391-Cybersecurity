Once the virtual disk image (memos-1.img)has been created as instructed and the binary for our 
boot sector (memos-1) is generated, we can place it at the beginning of the disk image using:

    dd if=memos-1 of=memos-1.img conv=notrunc

which writes the binary to the beginning of our disk image  (since no seek value has been provided) 
with the conv=notrunc argument to prevent dd from truncating the image to the size of our binary when converting.

Then the disk image can be executed using:

    qemu-system-i386 memos-1.img