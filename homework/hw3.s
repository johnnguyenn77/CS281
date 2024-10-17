.data
    A : .word 5, 4, 3, 2, 1, 10, 9, 8, 7, 6
    newline: .asciiz "\n"
    space: .asciiz " "

    .equ sz_A, 10

.text
    .globl main # Assembly directive that makes the symbol main global

main:
    # Load the array A and size into registers, then call print_array
    la a0, A # a0 = &A[0]
    li a1, sz_A # a1 = sz_A
    jal print_array

    # Call reverse to reverse the array
    la a0, A # a0 = &A[0]
    li a1, sz_A # a1 = sz_A
    jal reverse

    # Print the reversed array
    la a0, A # a0 = &A[0]
    li a1, sz_A # a1 = sz_A
    jal print_array

    ret

# Reverse function (a0 = &A[0], a1 = sz_A)
reverse:
    # Set up stack frame
    addi sp, sp, -4 # Reserve space on stack
    sw ra, 0(sp) # Save return address

    # i = 0, j = sz_A - 1
    li t0, 0 # t0 = i
    mv t1, a1 # t1 = sz_A
    addi t1, t1, -1 # t1 = j = sz_A - 1

reverse_loop:
    # Check if i >= j
    bge t0, t1, reverse_done

    # Swap elements A[i] and A[j]
    mv a1, t0 # a1 = i
    mv a2, t1 # a2 = j
    jal swap

    # Increment i, decrement j
    addi t0, t0, 1 # i++
    addi t1, t1, -1 # j--

    # Loop back
    j reverse_loop

reverse_done:
    # Restore stack and return
    lw ra, 0(sp) # Restore return address
    addi sp, sp, 4 # Free space on stack
    jr ra # Return to caller

# Swap function (a0 = &A[0], a1 = i, a2 = j)
swap:
    # Calculate addresses of A[i] and A[j]
    slli a1, a1, 2 # a1 = i * 4 (word size)
    slli a2, a2, 2 # a2 = j * 4 (word size)
    add a1, a0, a1 # a1 = &A[i]
    add a2, a0, a2 # a2 = &A[j]

    # Load A[i] and A[j] into temporary registers
    lw t2, 0(a1) # t2 = A[i]
    lw t3, 0(a2) # t3 = A[j]

    # Swap the values
    sw t2, 0(a2) # A[j] = A[i]
    sw t3, 0(a1) # A[i] = A[j]

    jr ra # Return to caller

    ret

# Print array function (a0 = &A[0], a1 = sz_A)
print_array:
    # Save the array's base address (a0) into t4
    mv t4, a0 # t4 = &A[0]

    # Save sz_A into t3 to preserve it
    mv t3, a1 # t3 = sz_A

    # Loop over the array and print each element
    li t0, 0 # t0 = index i = 0

print_loop:
    # Check if i >= sz_A (using t3 for sz_A)
    bge t0, t3, print_done

    # Calculate address of A[i] using t4 instead of s0
    slli t1, t0, 2 # t1 = i * 4 (word size)
    add t1, t4, t1 # t1 = &A[i]

    # Load A[i] and print it
    lw t2, 0(t1) # t2 = A[i]
    mv a1, t2 # a1 = A[i]
    li a0, 1 # syscall for print integer
    ecall

    # Print space after the number
    la a1, space # a1 = address of space
    li a0, 4 # syscall for print string
    ecall

    # Increment i and loop
    addi t0, t0, 1 # i++
    j print_loop

print_done:
    # Print newline at the end
    la a1, newline # a1 = address of newline
    li a0, 4 # syscall for print string
    ecall

    jr ra # Return to caller
