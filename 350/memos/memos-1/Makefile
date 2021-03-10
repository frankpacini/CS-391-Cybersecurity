

build:
	as --32 memos-1.s -o memos-1.o
	ld -T memos-1.ld memos-1.o -o memos-1
	sync
	# qemu-system-i386 -hda memos-1
	# /root/vnc/opt/TigerVNC/bin/vncviewer localhost:5900 

clean:
	rm -f memos-1.o memos-1