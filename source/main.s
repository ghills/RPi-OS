.section .init
.globl _start
_start:

@ gpio register address
ldr r0,=0x20200000

@ set pin 16 to output
mov r1,#1
lsl r1,#18
str r1,[r0,#4]

@ set pin 16 off (off means led on)
mov r1,#1
lsl r1,#16
str r1,[r0,#40]

@ loop forever!!
loop$:
b loop$



