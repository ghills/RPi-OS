.section .init
.globl _start
_start:

b main

.section .text
main:
mov sp,#0x8000

ldr r0,=1920 @ width
ldr r1,=1080 @ height
mov r2,#16   @ bit depth
bl InitializeFrameBuffer

/* check if framebuffer failed to initialize */
teq r0,#0
bne noError$

/* set up pin 16 (OK led) as output */
mov r0,#16
mov r1,#1
bl SetGpioFunction

/* turn on led to indicate failure */
mov r0,#16
mov r1,#0
bl SetGpioFunction

error$:
b error$

noError$:
bl SetGraphicsAddress
fbInfoAddr .req r4
mov fbInfoAddr,r0

rand .req r5
color .req r6
x .req r7
y .req r8
newx .req r9
newy .req r10

/* initialize to zero */
mov rand,#0
mov color,#0
mov x,#0
mov y,#0

render$:
    /* call random twice to get x and y */
    mov r0,rand
    bl Random
    mov newx,r0
    bl Random
    mov newy,r0
    mov rand,r0

    /* set color, increment, and reset if needed */
    mov r0,color
    add color,#1
    lsl color,#16
    lsr color,#16
    bl SetForeColor

    /* shift right to get appropriate range for x,y */
    lsr newx,#21
    lsr newy,#21

    ldr r0,[fbInfoAddr,#0]
    ldr r1,[fbInfoAddr,#4]
    width .req r0
    height .req r1

    /* check if onscreen */
    sub width,#1
    sub height,#1
    cmp newx,width
    cmpls newy,height
    bhi render$

    .unreq width
    .unreq height

    mov r0,x
    mov r1,y
    mov r2,newx
    mov r3,newy
    bl DrawLine

    mov x,newx
    mov y,newy

    b render$

.unreq fbInfoAddr
