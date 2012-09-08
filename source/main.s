.section .init
.globl _start
_start:

@ gpio register address
ldr r0,=0x20200000

@ set pin 16 to output
mov r1,#1
lsl r1,#18
str r1,[r0,#4]

@ save pin 16 value in r1
mov r1,#1
lsl r1,#16

loop$:

@ set pin 16 off (off means led on)
str r1,[r0,#40]

@ wait a while
mov r2,#0x3F0000
wait1$:
sub r2,#1
cmp r2,#0
bne wait1$

@ set pin 16 to on
str r1,[r0,#28]

@ wait a while
mov r2,#0x3F0000
wait2$:
sub r2,#1
cmp r2,#0
bne wait2$

@ loop forever!!
b loop$



