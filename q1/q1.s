.section .text
.globl make_node
.globl insert
.globl get
.globl getAtMost

getAtMost:
    li t2, -1

atmost_loop:
    beqz a1, atmost_done
    lw t3, 0(a1)
    blt a0, t3, atmost_left

    mv t2, t3
    ld a1, 16(a1)
    j atmost_loop

atmost_left:
    ld a1, 8(a1)
    j atmost_loop

atmost_done:
    mv a0, t2
    ret

get:
search_loop:
    beqz a0, search_fail
    lw t0, 0(a0)
    beq t0, a1, search_found
    bgt t0, a1, search_left

    ld a0, 16(a0)
    j search_loop

search_left:
    ld a0, 8(a0)
    j search_loop

search_found:
    ret

search_fail:
    li a0, 0
    ret

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s1, 16(sp)
    sd s2, 8(sp)

    mv s1, a0
    mv s2, a1

    beqz s1, insert_new

    lw t1, 0(s1)
    blt s2, t1, insert_left

insert_right:
    ld a0, 16(s1)
    mv a1, s2
    call insert

    sd a0, 16(s1)
    mv a0, s1
    j insert_done

insert_left:
    ld a0, 8(s1)
    mv a1, s2
    call insert

    sd a0, 8(s1)
    mv a0, s1
    j insert_done

insert_new:
    mv a0, s2
    call make_node

insert_done:
    ld ra, 24(sp)
    ld s1, 16(sp)
    ld s2, 8(sp)
    addi sp, sp, 32
    ret

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0, a0

    li a0, 24
    call malloc

    sw s0, 0(a0)
    sd zero, 8(a0)
    sd zero, 16(a0)

    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret