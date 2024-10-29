.data
    space: .asciiz " "
    newline: .asciiz "\n"
    .align 2
    fibonacci_array: .space 128       # Array to store Fibonacci numbers
    prompt: .asciiz "Enter Number of Fibonacci Numbers: "

.text
.globl main
main:
    la $a0, prompt                   # Load the prompt string
    li $v0, 4
    syscall                          # Print prompt

    li $v0, 5                        # Read integer input
    syscall
    move $t0, $v0                    # $t0 = number of Fibonacci numbers to generate (n)
    move $t1, $zero                  # Loop counter i

begin_loop:
    bge $t1, $t0, end_loop           # If i >= n, exit loop

    move $a0, $t1                    # Pass i as argument to fib function
    jal fib                          # Call fib(i)
    move $t2, $v0                    # $t2 = fib(i)

    # Store the result in fibonacci_array[i]
    sll $t3, $t1, 2                  # $t3 = i * 4 (offset for array)
    la $t4, fibonacci_array          # Base address of fibonacci_array
    add $t4, $t4, $t3                # $t4 = &fibonacci_array[i]
    sw $t2, 0($t4)                   # Store fib(i) at fibonacci_array[i]

    # Print the first (i+1) elements of the array
    la $a0, fibonacci_array          # Base address of fibonacci_array
    addi $a1, $t1, 1                 # Number of elements to print = i + 1
    jal print_array                  # Call print_array

    addi $t1, $t1, 1                 # i++
    j begin_loop                     # Repeat loop

end_loop:
    li $v0, 10                       # Exit program
    syscall

# Fibonacci Function
fib:
    # Base Cases: fib(0) = 0, fib(1) = 1
    li $v0, 0
    beq $a0, $zero, fib_return       # If n == 0, return 0

    li $v0, 1
    li $t0, 1
    beq $a0, $t0, fib_return         # If n == 1, return 1

    # Recursive Case: Calculate fib(n-1) + fib(n-2)
    addi $sp, $sp, -16               # Allocate stack space
    sw $ra, 0($sp)                   # Save return address
    sw $a0, 4($sp)                   # Save n
    sw $t1, 8($sp)                   # Save $t1
    sw $t2, 12($sp)                  # Save $t2

    addi $a0, $a0, -1                # n - 1
    jal fib                          # fib(n-1)
    move $t1, $v0                    # $t1 = fib(n-1)

    lw $a0, 4($sp)                   # Restore n
    addi $a0, $a0, -2                # n - 2
    jal fib                          # fib(n-2)
    move $t2, $v0                    # $t2 = fib(n-2)

    add $v0, $t1, $t2                # fib(n) = fib(n-1) + fib(n-2)

    # Restore registers and stack
    lw $ra, 0($sp)                   # Restore return address
    lw $a0, 4($sp)                   # Restore n
    lw $t1, 8($sp)                   # Restore $t1
    lw $t2, 12($sp)                  # Restore $t2
    addi $sp, $sp, 16                # Deallocate stack space

fib_return:
    jr $ra                           # Return to caller

# Print Array Function
print_array:
    addi $sp, $sp, -8                # Allocate stack space
    sw $t0, 0($sp)                   # Save $t0
    sw $t1, 4($sp)                   # Save $t1

    move $t0, $zero                  # $t0 = loop counter

print_loop:
    bge $t0, $a1, end_print          # If loop counter >= size, exit loop

    sll $t1, $t0, 2                  # $t1 = t0 * 4 (offset)
    add $t1, $t1, $a0                # Address = base + offset
    lw $a0, 0($t1)                   # Load element
    li $v0, 1
    syscall                          # Print integer

    # Print space
    la $a0, space                    # Load space character
    li $v0, 4
    syscall                          # Print space

    addi $t0, $t0, 1                 # t0++
    j print_loop                     # Repeat loop

end_print:
    la $a0, newline                  # Print newline at end
    li $v0, 4
    syscall

    # Restore registers and stack
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8                 # Deallocate stack space
    jr $ra                           # Return to caller
