.section .text

/* ------------------------------------------------------------------ */

.globl InitializeFrameBuffer
InitializeFrameBuffer:
width .req r0
height .req r1
bitDepth .req r2
cmp width,#4096
cmpls height,#4096
cmpls bitDepth,#32
result .req r0
movhi result,#0
movhi pc,lr

fbInfoAddr .req r4
push {r4,lr}
ldr fbInfoAddr,=FrameBufferInfo
str width,[fbInfoAddr,#0]
str height,[fbInfoAddr,#4]
str width,[fbInfoAddr,#8]
str height,[fbInfoAddr,#12]
str bitDepth,[fbInfoAddr,#20]
.unreq width
.unreq height
.unreq bitDepth

mov r0,fbInfoAddr
mov r1,#1
bl MailBoxWrite

mov r0,#1
bl MailBoxRead

teq result,#0
movne result,#0
popne {r4,pc}

pointerWait$:
ldr result,[fbInfoAddr,#32]
teq result,#0
beq pointerWait$

mov result,fbInfoAddr
pop {r4,pc}
.unreq result
.unreq fbInfoAddr

/* ------------------------------------------------------------------ */

.section .data
.align 12
.globl FrameBufferInfo
FrameBufferInfo:
.int 1920   /* #0 Width             */
.int 1080   /* #4 Height            */
.int 1920   /* #8 vWidth            */
.int 1080   /* #12 vHeight          */
.int 0      /* #16 GPU - Pitch      */
.int 16     /* #20 Bit Depth        */
.int 0      /* #24 X                */
.int 0      /* #28 Y                */
.int 0      /* #32 GPU - Pointer    */
.int 0      /* #36 GPU - Size       */