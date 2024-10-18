#Starter template for lab 3
.data
                   #76543210
    digits: .word 0b00111111,   # 0
            .word 0b00000110,   # 1
            .word 0b01011011,   # 2
            .word 0b01001111,   # 3
            .word 0b01100110,   # 4
            .word 0b01101101,   # 5
            .word 0b01111101,   # 6
            .word 0b00000111,   # 7
            .word 0b01111111,   # 8
            .word 0b01100111    # 9
    digit_msk : .word 0b111111111111111
    digit_max : .word 100
    digits_sz : .word 10

.text
# some useful constants that you might want to use in your program to improve
#readability
.equ LEFT_PRESS, 0b10
.equ RIGHT_PRESS, 0b01
.equ NO_PRESS, 0b00

.equ MIN_VAL, 0
.equ MAX_VAL, 99
	.globl  main

main:

#start by initializing the LCD, write 0 to the display
li s0, 0
mv a0,s0
jal write_lcd

#this is the main loop that will run forever
loop:
    #we will be using register s0 to hold the current counter value
    #the adjust_counter function will render the next value and return
    #it in a0.  Note the adjusted value will be INCREMENTED if the
    #left button is pressed, and DECREMENTED if the right button is
    #pressed. Note that we start by getting the current state of the
    #pushbutton by making ecall 0x122.
    li a0, 0x122
    ecall
    mv a1, s0
    jal adjust_counter #adjust_counter(button_state, current_counter)
    mv s0, a0
j loop

    ret #you will never get here but its god practice

#this function accepts the state of the buttons in a0, and the current counter
#value in a1 and will adjust it based on the button press state.
adjust_counter:

#you can change this, but in my implmentation I saved s0 and ra on the stack
    addi sp, sp, -8
    sw s0, 4(sp)
    sw ra, 0(sp)

    #STEP 1, take the appropriate action based on the button press
    mv s0, a1 #hold the current counter in s0
    li t0, NO_PRESS
    beq a0, t0, exit_adj_counter
    li t0, LEFT_PRESS
    beq a0, t0, dec_counter
    li t0, RIGHT_PRESS
    beq a0, t0, inc_counter
    j err_counter

    dec_counter:
        #TO DO - write the code to decrement the counter.  Note that this has
        #to take into account the edge condition where the counter is at 0. There
        #is a MIN_VAL constnt that you can use.  If the counter is at 0, do not
        #decrement it, but instead jump to error_counter. If its not at zero decrement
        #the counter and use write_lcd to update the display.
        li t1, MIN_VAL    # Load MIN_VAL (0)
        beq s0, t1, err_counter  # If current counter is MIN_VAL, jump to error
        addi s0, s0, -1   # Decrement the counter
        mv a0, s0         # Pass updated counter to write_lcd
        jal write_lcd
        j exit_adj_counter

    inc_counter:
        #TODO - do the same thing for incrementing the counter.  This time you will
        #need to check if the counter is at the MAX_VAL.
        li t1, MAX_VAL    # Load MAX_VAL (99)
        beq s0, t1, err_counter  # If current counter is MAX_VAL, jump to error
        addi s0, s0, 1    # Increment the counter
        mv a0, s0         # Pass updated counter to write_lcd
        jal write_lcd
        j exit_adj_counter


    err_counter:
        # if we get an error, like at teh boundry condition, flash the LEDs twice.
        # remember we have a sample program that shows how to do this
        li a0, 5 # Select how many times the led will flash
        jal flash_led
        j exit_adj_counter

#we are done restore the stack properly and return the next counter state in
#register a0
exit_adj_counter:
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 4
    ret

#This function writes the counter value passed in register a0 to the LCD
write_lcd:
    # Setup stack, again you can change this if you want.
    addi sp, sp, -4
    sw ra, 0(sp)

    # Write the code to update the LCD here.
    jal extract_bcd # Extract BCD for 10's and 1's place
    jal encode_digit # Encode digit for 7-segment display
    mv a1, a0 # Save encoded digit to a1 for 7-segment display

    # Now get the mask for the 7-segment display
    la t0, digit_msk
    lw a2, 0(t0)

    li a0, 0x120 # System call to update the 7-segment display
    ecall

    # Check if the current counter value is odd or even
    mv t0, s0 # Move the current counter value (s0) to t0
    andi t1, t0, 1 # Check the least significant bit (LSB)

    beq t1, zero, check_power_of_two # If LSB == 0, check if the number is a power of 2
    # If the number is odd (LSB == 1), turn on the red LED
    li a0, 0x121
    li a1, 0b10 # Red LED on, green LED off (0b10)
    ecall
    j done_led_control

check_power_of_two:
    # Check if the number is a power of 2
    beqz t0, set_green_led # If the number is 0, jump to set only green LED
    addi t1, t0, -1 # t1 = t0 - 1
    and t2, t0, t1 # t2 = t0 & (t0 - 1)
    bnez t2, set_green_led # If t2 != 0, it's not a power of 2, jump to set green LED

    # If t2 == 0, it's a power of 2, turn on both LEDs
    li a0, 0x121
    li a1, 0b11 # Both LEDs on (0b11)
    ecall
    j done_led_control

set_green_led:
    # If the number is even and not a power of 2, turn on the green LED
    li a0, 0x121
    li a1, 0b01 # Green LED on, red LED off (0b01)
    ecall

done_led_control:
    # Restore the stack
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#TODO - to implement write_lcd you might want to consider adding a few functions
#here as helpers to keep your code clean.
extract_bcd:
    # Load the input number from a0
    mv t0, a0           # t0 = input number

    # Extract the 10's place by dividing by 10
    li t1, 10           # t1 = 10
    div t2, t0, t1      # t2 = t0 / 10 (10's place)
    rem t3, t0, t1      # t3 = t0 % 10 (1's place)

    # Store the results in a0 and a1
    mv a0, t2           # a0 = 10's place
    mv a1, t3           # a1 = 1's place

    # Return from the function
    ret

encode_digit:
    # Load the input 10s place from a0

    # Calculate the address of the digit table
    la t0, digits       # t1 = &digits[0]

    # Calculate the offset for the digit table
    slli a0, a0, 2      # Table offset for 10's place
    slli a1, a1, 2      # Table offset for 1's place

    add t1, t0, a0      # address of 10's place digit
    add t2, t0, a1      # address of 1's place digit
    lw a0, 0(t1)        # a0 = 10's place digit
    lw a1, 0(t2)        # a1 = 1's place digit

    # Combine the 10's and 1's place digits
    slli a0, a0, 8      # Shift 10's place to the left
    or a0, a0, a1       # Combine 10's and 1's place

    #a0 now has the bitfield for the seven segment display
    # [ digit 10's place ][ digit 1's place ]
    ret

flash_led:
    #see the sample code for this function
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    li s0, 0
    mv s1, a0 #flash the number in a0
flash_loop:
    beq s0, s1, flash_done
    addi s0, s0, 1 #update counter

    #turn on both LEDs
    li a0, 0x121
    li a1, 0b11
    ecall
    #wait a little
    li a0, 250
    jal sleep

    #turn off both LEDs
    li a0, 0x121
    li a1, 0b00
    ecall

    #wait a little
    li a0, 250
    jal sleep

    j flash_loop

flash_done:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
ret

#you might find it helpful to include the sleep helper I have been using
#in my sample code.
sleep:
    mv t0, a0
    sleep_loop:
        addi t0, t0, -1  # Decrement counter
        bnez t0, sleep_loop  # Continue loop if t0 is not zero
ret