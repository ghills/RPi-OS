/* ------------------------------------------------------------------ */

.globl GetMailboxBase
GetMailboxBase:

ldr r0,=0x2000B880

mov pc,lr

/* ------------------------------------------------------------------ */

.globl GetMailboxStatus
GetMailboxStatus:

push {lr}

bl GetMailboxBase
ldr r0,[r0,#0x18]

pop {pc}

/* ------------------------------------------------------------------ */

.globl MailBoxWrite
MailBoxWrite:

/* check inputs */
tst r0,#0b1111
movne pc,lr 
cmp r1,#15
movhi pc,lr

push {lr}

mov r2,r0
message .req r2
mov r3,r1
channel .req r3

bl GetMailboxBase
mailAddr .req r0

status .req r1
waitForStatus$:

ldr status,[mailAddr,#0x18]
tst status,#0x80000000
bne waitForStatus$

.unreq status

/* combine message and channel */
orr message,channel

/* write the results */
str message,[mailAddr,#0x20]

.unreq message
.unreq channel
.unreq mailAddr

pop {pc}

/* ------------------------------------------------------------------ */

.globl MailBoxRead
MailBoxRead:

/* check inputs */
cmp r0,#15
movhi pc,lr

push {lr}

mov r2,r0
channel .req r2

bl GetMailboxBase
mailAddr .req r0

status .req r1
waitForStatusRead$:

ldr status,[mailAddr,#0x18]
tst status,#0x40000000
bne waitForStatusRead$

.unreq status

mail .req r1
readFromMailbox$:

/* read data from mailbox */
ldr mail,[mailAddr]

rxChannel .req r3
and rxChannel,mail,#0b1111
teq rxChannel,channel
bne readFromMailbox$

.unreq mailAddr
.unreq channel
.unreq rxChannel

mov r0,mail
and r0,mail,#0xFFFFFFF0

.unreq mail

pop {pc}

/* ------------------------------------------------------------------ */
