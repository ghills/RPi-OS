.globl GetGpioAddress
GetGpioAddress:
ldr r0,=0x20200000
mov pc,lr

.globl SetGpioFunction
SetGpioFunction:
cmp r0,#53 @ check pin number, 0-53
cmpls r1,#7 @ check pin function, 0-7
movhi pc,lr @ return early if either one

push {lr}
mov r2,r0
bl GetGpioAddress

@ repeated subtraction to find right group of 10 pins
functionLoop$:
	cmp r2,#9
	subhi r2,#10
	addhi r0,#4 @ if still >= 10, move 4 bytes further to next group
	bhi functionLoop$

add r2, r2,lsl #1 @ trick to multiple r2 by 3. 2*r2 + r2
lsl r1,r2
str r1,[r0]

@ return to lr stored on the stack
pop {pc}


.globl SetGpio
SetGpio:
pinNum .req r0
pinVal .req r1

cmp pinNum,#53 @ check pin number <= 53
movhi pc,lr

push {lr}
mov r2,pinNum
.unreq pinNum
pinNum .req r2
bl GetGpioAddress
gpioAddr .req r0

pinBank .req r3
lsr pinBank,pinNum,#5 @ determine if first 4 bytes or second
lsl pinBank,#2 @ 4 bytes out, so multiply by 4
add gpioAddr,pinBank
.unreq pinBank

and pinNum,#31
setBit .req r3
mov setBit,#1
lsl setBit,pinNum
.unreq pinNum

teq pinVal,#0
.unreq pinVal
streq setBit,[gpioAddr,#40]
strne setBit,[gpioAddr,#28]
.unreq setBit
.unreq gpioAddr

pop {pc}
