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
fbInfoAddr .req r4
mov fbInfoAddr,r0

render$:
    fbAddr .req r3
    ldr fbAddr,[fbInfoAddr,#32]

    color .req r0
    y .req r1
    ldr y,=1080
    drawRow$:
        x .req r2
        ldr x,=1920
        drawPixel$:
            strh color,[fbAddr]
            add fbAddr,#2
            sub x,#1
            teq x,#0
            bne drawPixel$

        sub y,#1
        add color,#1
        teq y,#0
        bne drawRow$

    b render$

.unreq fbAddr
.unreq fbInfoAddr
