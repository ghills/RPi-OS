.section .data
.align 1
foreColor:
.hword 0xFFFF

.align 2
graphicsAddress:
.int 0

.section .text
.globl SetForeColor
SetForeColor:
cmp r0,#0x10000
movhs pc,lr
ldr r1,=foreColor
strh r0,[r1]
mov pc,lr

.globl SetGraphicsAddress
SetGraphicsAddress:
ldr r1,=graphicsAddress
str r0,[r1]
mov pc,lr

.globl DrawPixel
DrawPixel:
px .req r0
py .req r1
addr .req r2
ldr addr,=graphicsAddress
ldr addr,[addr]

/* check py against height of fb */
height .req r3
ldr height,[addr,#4]
sub height,#1
cmp py,height
movhi pc,lr
.unreq height

/* check px against width of fb */
width .req r3
ldr width,[addr,#0]
sub width,#1
cmp px,width
movhi pc,lr

/* figure out where in fb pixel is */
ldr addr,[addr,#32]
add width,#1

/* pixel = (py*width) + px */
mla px,py,width,px
.unreq width
.unreq py

/* move to the location in fb, 2 bytes per px */
add addr, px,lsl #1
.unreq px

/* get foreground color to use */
fore .req r3
ldr fore,=foreColor
ldrh fore,[fore]

strh fore,[addr]
.unreq fore
.unreq addr

mov pc,lr

.globl DrawLine
DrawLine:
push {r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
x0 .req r9
x1 .req r10
y0 .req r11
y1 .req r12

mov x0,r0
mov x1,r2
mov y0,r1
mov y1,r3

dx .req r4
dyn .req r5 /* only use negative of dy */
sx .req r6
sy .req r7
err .req r8

/* determine the delta-x and step */
cmp x0,x1
subgt dx,x0,x1
movgt sx,#-1
suble dx,x1,x0
movle sx,#1

/* determine the delta-y and step */
cmp y0,y1
subgt dyn,y1,y0
movgt sy,#-1
suble dyn,y0,y1
movle sy,#1

/* set error to deltax - deltay */
add err,dx,dyn
add x1,sx
add y1,sy

pixelLoop$:
    teq x0,x1
    teqne y0,y1
    popeq {r4,r5,r6,r7,r8,r9,r10,r11,r12,pc}

    /* set this pixel */
    mov r0,x0
    mov r1,y0
    bl DrawPixel

    cmp dyn, err,lsl #1
        addle x0,sx
        addle err,dyn

    cmp dx, err,lsl #1
        addge y0,sy
        addge err,dx

    b pixelLoop$

.unreq x0
.unreq x1
.unreq y0
.unreq y1
.unreq dx
.unreq dyn
.unreq sx
.unreq sy
.unreq err
