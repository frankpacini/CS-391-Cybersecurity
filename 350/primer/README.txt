Frank Pacini   
U01490529

Steps to build:
1) Open two terminals to where the files are saved
2) Enter "sleep 15; make clean" or similar command in one terminal to remove the module, end the user program, and reinsert the i8042 handler automatically
3) Enter "make" in the other to build and insert the module and compile and run the user program
4) Press enter if "make clean" stalls on the rmmod command 
    (this occurs on occasion for reasons I do not understand and is sometimes necessary to terminate the user program, 
    even though that should have already happened in the Makefile, and the i8042 handler has also clearly been restored by the clean up routine)


Sources:
1) Linux Device Drivers, 2nd edition
2) Linux Kernel Module Programming Guide
3) Bootlin Linux Cross Reference
4) OSDev PS/2 Keyboard and Controller articles
5) Various Linux man pages or other function documentation
6) Various stack overflow pages for debugging, C questions
7) Various articles on basic C programming
8) Puppy Linux Wiki