.data
    space: .asciiz " "
    newline: .asciiz "\n"

    array_1: .word 1, 1, 2, 3, 5
    array_2: .word 8, 13, 21
.text

print_array:
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)

    move $t0, $zero

print_loop:
    bge $t0, $a1, end_print

    all $t1, $t0, 2
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

main:
    la $a0, array_1
    li $a1, 5
    jal print_array

    la $a0, array_2
    li $a1, 3
    jal print_array

    li $v0, 10
    syscall
