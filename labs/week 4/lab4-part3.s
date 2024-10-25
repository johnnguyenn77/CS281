##################################################################
# THIS PROGRAM EXECUTES FACTORIAL VIA RECURSIVE MULTIPLICATION
##################################################################
    .data
result: .word 0
arg:   .word 10

    .text
    .globl _start

_start:
    # Load the values of a and b from memory
    la s0, arg          #
    lw s0, 0(s0)        # a

    # Call the multiply function
    mv a0, s0
    jal factorial

    # Store the result in memory (optional, for checking)
    la t0, result
    sw a0, 0(t0)     # Store the value in result

    #NOW PRINT THE RESULT
    mv a1, s0
    jal print_result

    # Exit the program
    li a0, 10         # Exit code for ecall
    ecall

########################################
#ALGORITHM
#  factorial(a):
#    #base case
#    if a == 0:
#       return 1
#    #recursive case
#    else:
#      return a * factorial(a-1)
#######################################

factorial:
    # Save the current state on the stack
    addi sp, sp, -8     # Push 1 words on stack
    sw a0, 4(sp)        # Save a
    li a2, 1
    sw ra, 0(sp)        # Save ra

    # Base case: if a == 0 or a == 1, return 1
    li t0, 1            # Load 1 into t0 for comparison
    ble a0, t0, base_case   # If a <= 1, go to base case

recursive_case:
    # Recursive case: result = a * factorial(a--)
    addi a0, a0, -1
    # Call the multiply function
    jal factorial       # Recursive call factorial(a-1)

    lw t0, 4(sp)        # Load the address of result into t0
    mul a0, a0, t0      # result in a0 = a * factorial(a-1)

    #Get ready to return from recursive call
    lw ra, 0(sp)        # Restore ra
    addi sp, sp, 8      # Pop stack
    jr ra

base_case:
    li a0, 1            # Return 1 for factorial(0) or factorial(1)
    addi sp, sp, 8      # Pop the stack
    jr ra               # Return

#LETS HANDLE OUTPUT
.data
    prompt:   .asciiz "The result of "
    exclaimation_point:    .asciiz "!"
    equals:   .asciiz " = "
    new_line: .asciiz "\n"

.text

#the result will be in the a0 register
#print results takes 2 arguments a0 = result, a1 = a
print_result:
    #save a0 & a1 they are needed for syscalls
    mv t0, a0
    mv t1, a1

    #print the prompt
    li a0, 4        # 4 is syscall for print_str
    la a1, prompt
    ecall

    # Print arg which is now in t1
    li a0, 1        # 1 is syscall for print_int
    mv a1, t1
    ecall

    #print the multiply symbox
    li a0, 4        # 4 is syscall for print_str
    la a1, exclaimation_point
    ecall

    #print the multiply symbox
    li a0, 4        # 4 is syscall for print_str
    la a1, equals
    ecall

    # Print the result
    li a0, 1        # 1 is syscall for print_int
    mv a1, t0
    ecall

    # Print a newline
    li a0, 4
    la a1, new_line
    ecall

    jr ra
