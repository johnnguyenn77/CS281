.data
    A : .word 5, 4, 3, 2, 1, 10, 9, 8, 7, 6
    sz_A : .word 10
    min : .word 0x7FFFFFFF
    max : .word 0x80000000

    prompt_min: .asciiz "The minimum value in the array is: "
    prompt_max: .asciiz "The maximum value in the array is: "
    new_line: .asciiz "\n"

.text
    .globl main

main:
    la s0, A                                     # Load the address of array 'A' into register s0.
    lw s1, sz_A                                  # Load the size of the array (sz_A) into register s1.
    la s2, min                                   # Load the address of the variable 'min' into register s2.
    la s3, max                                   # Load the address of the variable 'max' into register s3.
    neg s3, s3                                   # Negate the value in s3 (max) to ensure max is the smallest value (0x80000000 becomes negative).

    li t0, 0                                     # Initialize counter t0 to 0, which will keep track of the index in the loop.

loop:
    lw t1, 0(s0)                                 # Load the current element of array 'A' (pointed to by s0) into register t1.

    blt t1, s2, if_min                           # If the current element (t1) is less than the current minimum (s2), branch to if_min.
    j end_if_min                                 # Otherwise, jump to the end of the if_min block to skip the update.

if_min:
    add s2, t1, zero                             # Update the minimum value (s2) with the current element (t1).
end_if_min:

    bgt t1, s3, if_max                           # If the current element (t1) is greater than the current maximum (s3), branch to if_max.
    j end_if_max                                 # Otherwise, jump to the end of the if_max block to skip the update.

if_max:
    add s3, t1, zero                             # Update the maximum value (s3) with the current element (t1).
end_if_max:

    addi t0, t0, 1                               # Increment the index counter t0 by 1.
    addi s0, s0, 4                               # Move to the next element in the array by incrementing s0 by 4 (size of a word).
    bne t0, s1, loop                             # If the counter t0 is not equal to the array size (s1), repeat the loop.

    # Print the minimum value
    li a0, 4                                     # Set system call code for print string (syscall code 4).
    la a1, prompt_min                            # Load the address of the prompt_min string into a1.
    ecall                                        # Make the system call to print the prompt_min string.

    li a0, 1                                     # Set system call code for print integer (syscall code 1).
    mv a1, s2                                    # Move the minimum value (s2) into a1 for printing.
    ecall                                        # Make the system call to print the minimum value.

    # Print a newline
    li a0, 4                                     # Set system call code for print string (syscall code 4).
    la a1, new_line                              # Load the address of the newline character into a1.
    ecall                                        # Make the system call to print a newline.

    # Print the maximum value
    li a0, 4                                     # Set system call code for print string (syscall code 4).
    la a1, prompt_max                            # Load the address of the prompt_max string into a1.
    ecall                                        # Make the system call to print the prompt_max string.

    li a0, 1                                     # Set system call code for print integer (syscall code 1).
    mv a1, s3                                    # Move the maximum value (s3) into a1 for printing.
    ecall                                        # Make the system call to print the maximum value.

    # Print a newline
    li a0, 4                                     # Set system call code for print string (syscall code 4).
    la a1, new_line                              # Load the address of the newline character into a1.
    ecall                                        # Make the system call to print a newline.

    # Exit the program
    li a0, 10                                    # Set system call code for program exit (syscall code 10).
    ecall                                        # Make the system call to exit the program.
