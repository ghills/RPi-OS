/* ------------------------------------------------------------------ */

.globl GetSystemTimerBase
GetSystemTimerBase:

ldr r0,=0x20003000

mov pc,lr

/* ------------------------------------------------------------------ */

.globl GetTimeStamp
GetTimeStamp:

push {lr}

timeAddr .req r0
bl GetSystemTimerBase
ldrd r0,r1,[timeAddr,#4]

pop {pc}

/* ------------------------------------------------------------------ */

.globl Wait
Wait:

push {lr}

/* save the time to wait */
waitTime  .req r2
mov waitTime,r0

/* get the initial time to base it on */
bl GetTimeStamp
add waitTime,r0 @ disregard high 4 bytes, limits wait to 4 byte value

checkTime$:
    bl GetTimeStamp
    cmp waitTime,r0 @ disregard high 4 bytes, limits wait to 4 byte value
    bgt checkTime$

pop {pc}

/* ------------------------------------------------------------------ */