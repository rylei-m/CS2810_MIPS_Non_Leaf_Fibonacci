.data
    space: .asciiz " "
    newline: .asciiz "\n"
    .align 2
    fibonacci_array: .space 128
    prompt: .asciiz "Enter Number of Fibonacci Numbers: "

.text
.globl main
main:
    la $a0, prompt
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $t0, $v0
    move $t1, $zero

begin_loop:
    bge $t1, $t0, end_loop

    move $a0, $t1
    jal fib
    move $t2, $v0

    sll $t3, $t1, 2
    la $t4, fibonacci_array
    add $t4, $t4, $t3
    sw $t2, 0($t4)

    la $a0, fibonacci_array
    addi $a1, $t1, 1
    jal print_array

    addi $t1, $t1, 1
    j begin_loop

end_loop:
    li $v0, 10
    syscall

fib:
    li $v0, 0
    beq $a0, $zero, fib_return

    li $v0, 1
    li $t0, 1
    beq $a0, $t0, fib_return

    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $t1, 8($sp)
    sw $t2, 12($sp)

    addi $a0, $a0, -1
    jal fib
    move $t1, $v0

    lw $a0, 4($sp)
    addi $a0, $a0, -2
    jal fib
    move $t2, $v0

    add $v0, $t1, $t2

    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    addi $sp, $sp, 16

fib_return:
    jr $ra

print_array:
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)

    move $t0, $zero

print_loop:
    bge $t0, $a1, end_print

    sll $t1, $t0, 2
    add $t1, $t1, $a0
    lw $a0, 0($t1)
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall

    addi $t0, $t0, 1
    j print_loop

end_print:
    la $a0, newline
    li $v0, 4
    syscall

    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    jr $ra
