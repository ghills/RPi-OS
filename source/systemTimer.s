/* ------------------------------------------------------------------ */

.globl TimerWait
TimerWait:
waitTime  .req r0
timerAddr .req r1
timeLow   .req r2
timeHigh  .req r3

/* set the base timer address */
ldr timerAddr,=0x20003000

/* get the initial time to base it on */
ldrd timeLow, timeHigh,[timerAddr,#4]
add waitTime,timeLow @ disregard high 4 bytes, limits wait to 4 byte value

checkTime$:

/* offset of 4 is the actual tick (8 bytes) */
ldrd timeLow, timeHigh,[timerAddr,#4]
cmp waitTime,timeLow
bgt checkTime$

mov pc,lr

/* ------------------------------------------------------------------ */