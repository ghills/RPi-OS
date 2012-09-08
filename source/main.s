.section .init
.globl _start
_start:

b main

.section .text
main:
mov sp,#0x8000

@ set pin 16 to output
pinNum .req r0
pinFunc .req r1
mov pinNum,#16
mov pinFunc,#1
bl SetGpioFunction
.unreq pinNum
.unreq pinFunc

loop$:

@ set pin 16 off (off means led on)
pinNum .req r0
pinVal .req r1
mov pinNum,#16
mov pinVal,#0
bl SetGpio
.unreq pinNum
.unreq pinVal

@ wait a while
mov r2,#0x3F0000
wait1$:
sub r2,#1
cmp r2,#0
bne wait1$

@ set pin 16 to on
pinNum .req r0
pinVal .req r1
mov pinNum,#16
mov pinVal,#1
bl SetGpio
.unreq pinNum
.unreq pinVal

@ wait a while
mov r2,#0x3F0000
wait2$:
sub r2,#1
cmp r2,#0
bne wait2$

@ loop forever!!
b loop$



