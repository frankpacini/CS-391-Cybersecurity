OUTPUT_FORMAT("binary")
OUTPUT_ARCH(i386)
ENTRY(_start)
SECTIONS
{
  . = 0x0; /* Start associating symbol names with addresses at symbolic address 0x0 */ 
  .prog : { *(.text) } /* Declare section .prog in output which is link edit of all .text sections in input objects  */ 
}