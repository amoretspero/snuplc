##################################################
# test03
#

    #-----------------------------------------
    # text section
    #
    .text
    .align 4

    # entry point and pre-defined functions
    .global main
    .extern DIM
    .extern DOFS
    .extern ReadInt
    .extern WriteInt
    .extern WriteStr
    .extern WriteChar
    .extern WriteLn

    # scope test03
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -17(%ebp)   1  [ $t1       <bool> %ebp-17 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $8, %esp                # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 4(%esp)          
    movl    %eax, 0(%esp)          

    # function body
    movl    $0, %eax                #   0:     assign i <- 0
    movl    %eax, i                
    movl    $5, %eax                #   1:     assign j <- 5
    movl    %eax, j                
    movl    i, %eax                 #   2:     if     i < j goto 3_if_true
    movl    j, %ebx                
    cmpl    %ebx, %eax             
    jl      l_test03_3_if_true     
    jmp     l_test03_4_if_false     #   3:     goto   4_if_false
l_test03_3_if_true:
    movl    k, %eax                 #   5:     add    t0 <- k, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   6:     assign k <- t0
    movl    %eax, k                
    jmp     l_test03_2              #   7:     goto   2
l_test03_4_if_false:
l_test03_2:
    movl    $10, %eax               #  10:     assign i <- 10
    movl    %eax, i                
    movl    $10, %eax               #  11:     assign j <- 10
    movl    %eax, j                
    movzbl  c, %eax                 #  12:     if     c = 1 goto 11
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test03_11            
    movl    $1, %eax                #  13:     assign t1 <- 1
    movb    %al, -17(%ebp)         
    jmp     l_test03_12             #  14:     goto   12
l_test03_11:
    movl    $0, %eax                #  16:     assign t1 <- 0
    movb    %al, -17(%ebp)         
l_test03_12:
    movzbl  -17(%ebp), %eax         #  18:     assign b <- t1
    movb    %al, b                 

l_test03_exit:
    # epilogue
    addl    $8, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # end of text section
    #-----------------------------------------

    #-----------------------------------------
    # global data section
    #
    .data
    .align 4

    # scope: test03
b:                                  # <bool>
    .skip    1
c:                                  # <bool>
    .skip    1
    .align   4
i:                                  # <int>
    .skip    4
j:                                  # <int>
    .skip    4
k:                                  # <int>
    .skip    4

    # end of global data section
    #-----------------------------------------

    .end
##################################################
