.text

    .globl _start

_start:
    li t0, 0
    li t1, 10
    li t2, 0x14
    add t0, t1, t2
    li t3, 0b100010
    add t0, t0, t3

li a0, 10
ecall
