.section .data
filename: .string "input.txt"
yesString: .string "Yes\n"
noString: .string "No\n"

.section .bss
charBuffer: .space 1

.section .text
.global main

main:
    # openat function (syscall 54 and AT_FDCWD)
    li a0, -100        
    la a1, filename
    li a2, 0           
    li a3, 0
    li a7, 56          
    ecall
    mv t0, a0          

    # lseek on t0 (we just opened t0)
    mv a0, t0
    li a1, 0
    li a2, 2           
    # lseek (seeking the end)
    li a7, 62          
    ecall
    # s2 - left pointer, s3 - right pointer
    addi t2, a0, -1      
    li t1, 0           

    la t5, charBuffer   

check_loop:

    # if(left>=right) is_palindrome();
    bge t1, t2, is_palindrome

    # get left character and put it in s4
    mv a0, t0
    mv a1, t1
    li a2, 0           
    li a7, 62
    ecall
    mv a0, t0
    mv a1, t5
    li a2, 1
    # 63 is read syscall
    li a7, 63          
    ecall
    lb t3, 0(t5)      

    # get right character and put it in s5
    mv a0, t0
    mv a1, t2
    li a2, 0           
    li a7, 62
    ecall
    mv a0, t0
    mv a1, t5
    li a2, 1
    # 63 is read syscall
    li a7, 63          
    ecall
    lb t4, 0(t5)       

    bne t3, t4, not_palindrome

    # increment left and decrement right

    addi t1, t1, 1       
    addi t2, t2, -1      

    j check_loop

is_palindrome:
    li a0, 1
    la a1, yesString
    li a2, 4
    # 64 is write syscall
    li a7, 64          
    ecall
    j done

not_palindrome:
    li a0, 1
    la a1, noString
    li a2, 3
    # 64 is write syscall
    li a7, 64          
    ecall

done:

    li a0, 0
    li a7, 93          
    ecall