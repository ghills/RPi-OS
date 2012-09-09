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

@ set up blinking pattern
ptrn .req r4
ldr ptrn,=pattern
ldr ptrn,[ptrn]
seq .req r5
mov seq,#0

loop$:

@ display the current state
pinNum .req r0
pinVal .req r1
mov pinNum,#16
mov pinVal,#1
lsl pinVal,seq
and pinVal,ptrn
bl SetGpio
.unreq pinNum
.unreq pinVal

@ wait a while
waitTime .req r0
ldr waitTime,=250000
bl Wait
.unreq waitTime

@ increment seq (or wrap around at 32)
add seq,#1
and seq,#0b11111

@ loop forever!!
b loop$

.section .data
.align 2
pattern:
.int 0b11111111101010100010001000101010
