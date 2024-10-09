.data
    A : .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    sum : .word 0

    prompt: .asciiz "The sum of the array is: "
    new_line: .asciiz "\n"

.text
    .globl main

main:
    la s0, A
    # Calculating the size of A
    la t3, A # Load the address of the first element of the array (A) into t3
    la t4, sum # Load the address of the 'sum' variable into t4
    sub s1, t4, t3 # Calculate the size of the array in bytes by subtracting the two addresses
    srai s1, s1, 2 # Divide by 4 (right shift by 2 bits) to convert byte count to word count

    li t0, 0
    li t2, 0

sum_loop:
    lw t1, 0(s0) # Load the current element of A (pointed by s0) into t1
    add t2, t2, t1 # Add the value in t1 (current element) to the sum in t2
    addi t0, t0, 1 # Increment the index counter t0 by 1
    addi s0, s0, 4 # Move to the next element in the array by incrementing s0 by 4 (size of a word)
    bne t0, s1, sum_loop # If the counter t0 is not equal to the array size (s1), repeat the loop

    la t0, sum
    sw t2, 0(t0)

    li a0, 4
    la a1, prompt
    ecall

    la t1, sum
    lw t1, 0(t1)
    li a0, 1
    mv a1, t1
    ecall

    li a0, 4
    la a1, new_line
    ecall

    li a0, 10
    ecall
