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
waitTime .req r0
ldr waitTime,=2000000
bl Wait
.unreq waitTime

@ set pin 16 to on
pinNum .req r0
pinVal .req r1
mov pinNum,#16
mov pinVal,#1
bl SetGpio
.unreq pinNum
.unreq pinVal

@ wait a while
waitTime .req r0
ldr waitTime,=2000000
bl Wait
.unreq waitTime

@ loop forever!!
b loop$



