##################################################
# test02
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

    # scope test02
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -21(%ebp)   1  [ $t2       <bool> %ebp-21 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $12, %esp               # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 8(%esp)          
    movl    %eax, 4(%esp)          
    movl    %eax, 0(%esp)          

    # function body
    movl    i, %eax                 #   0:     add    t0 <- i, j
    movl    j, %ebx                
    addl    %ebx, %eax             
    movl    %eax, -16(%ebp)        
    movl    i, %eax                 #   1:     mul    t1 <- i, j
    movl    j, %ebx                
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    movl    -16(%ebp), %eax         #   2:     if     t0 < t1 goto 1_if_true
    movl    -20(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_test02_1_if_true     
    jmp     l_test02_2_if_false     #   3:     goto   2_if_false
l_test02_1_if_true:
    movl    $0, %eax                #   5:     assign k <- 0
    movl    %eax, k                
    jmp     l_test02_0              #   6:     goto   0
l_test02_2_if_false:
    movl    $1, %eax                #   8:     assign k <- 1
    movl    %eax, k                
l_test02_0:
    movzbl  c, %eax                 #  10:     if     c = 1 goto 8
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test02_8             
    movl    $1, %eax                #  11:     assign t2 <- 1
    movb    %al, -21(%ebp)         
    jmp     l_test02_9              #  12:     goto   9
l_test02_8:
    movl    $0, %eax                #  14:     assign t2 <- 0
    movb    %al, -21(%ebp)         
l_test02_9:
    movzbl  -21(%ebp), %eax         #  16:     assign b <- t2
    movb    %al, b                 

l_test02_exit:
    # epilogue
    addl    $12, %esp               # remove locals
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

    # scope: test02
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
