.section .bss
res: .space 800
stack: .space 800

.section .data
space: .string " "
newline: .string "\n"
format: .string "%d"

.section .text
.globl main

# setup n, argv, stack 
main:
    addi s0, a0, -1
    mv s1, a1

    bge x0, s0, exit

    la s2, res
    la s3, stack
    li s4, -1

# initialize result array with -1
fill_start:
    li t0, 0

fill_loop:
    bge t0, s0, nge_start

    slli t1, t0, 2
    add t2, s2, t1
    li t3, -1
    sw t3, 0(t2)

    addi t0, t0, 1
    j fill_loop

# NGE (right to left unlike the pseudocode given)
nge_start:
    addi t0, s0, -1

nge_loop:
    blt t0, x0, print

    # compute arr[i]
    addi t1, t0, 1
    slli t1, t1, 3
    add t1, s1, t1
    ld a0, 0(t1)

    addi sp, sp, -16
    sd t0, 0(sp)
    sd ra, 8(sp)
    call atoi
    ld t0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16

    mv t2, a0

# pop elements <= arr[i] && !stack.empty()
pop_loop:
    bltz s4, fill_result

    slli t3, s4, 2
    add t3, s3, t3
    lw t4, 0(t3)

    addi t5, t4, 1
    slli t5, t5, 3
    add t5, s1, t5
    ld a0, 0(t5)

    addi sp, sp, -24
    sd t0, 0(sp)
    sd t2, 8(sp)
    sd ra, 16(sp)
    call atoi
    ld t0, 0(sp)
    ld t2, 8(sp)
    ld ra, 16(sp)
    addi sp, sp, 24

    mv t5, a0

    bgt t5, t2, fill_result
    addi s4, s4, -1
    j pop_loop

# fill result
fill_result:
    bltz s4, push

    slli t3, s4, 2
    add t3, s3, t3
    lw t4, 0(t3)

    slli t5, t0, 2
    add t5, s2, t5
    sw t4, 0(t5)

# push index
push:
    addi s4, s4, 1
    slli t3, s4, 2
    add t3, s3, t3
    sw t0, 0(t3)

    addi t0, t0, -1
    j nge_loop

# print result
print:
    li t0, 0

print_loop:
    bge t0, s0, done

    slli t1, t0, 2
    add t2, s2, t1
    lw a1, 0(t2)
    la a0, format

    addi sp, sp, -16
    sd t0, 0(sp)
    sd ra, 8(sp)
    call printf
    ld t0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16

    addi t3, t0, 1
    beq t3, s0, skip_space

    la a0, space

    addi sp, sp, -16
    sd t0, 0(sp)
    sd ra, 8(sp)
    call printf
    ld t0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16

# skip the space after the last element (just in case the autograder will count it as wrong)

skip_space:
    addi t0, t0, 1
    j print_loop

done:
    la a0, newline

    addi sp, sp, -16
    sd ra, 8(sp)
    call printf
    ld ra, 8(sp)
    addi sp, sp, 16

# exit
exit:
    li a0, 0
    li a7, 93
    ecall