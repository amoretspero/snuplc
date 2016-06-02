##################################################
# test12
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

    # scope foo
foo:
    # stack offsets:
    #      8(%ebp)   1  [ %b0       <bool> %ebp+8 ]
    #     12(%ebp)   1  [ %b1       <bool> %ebp+12 ]
    #     16(%ebp)   4  [ %i0       <int> %ebp+16 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_foo_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test12
main:
    # stack offsets:
    #    -13(%ebp)   1  [ $t0       <bool> %ebp-13 ]
    #    -14(%ebp)   1  [ $t1       <bool> %ebp-14 ]
    #    -15(%ebp)   1  [ $t2       <bool> %ebp-15 ]
    #    -16(%ebp)   1  [ $t3       <bool> %ebp-16 ]
    #    -17(%ebp)   1  [ $t4       <bool> %ebp-17 ]
    #    -18(%ebp)   1  [ $t5       <bool> %ebp-18 ]

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
    movl    j, %eax                 #   0:     param  2 <- j
    pushl   %eax                   
    movzbl  b, %eax                 #   1:     if     b = 1 goto 6
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test12_6             
    movl    $1, %eax                #   2:     assign t0 <- 1
    movb    %al, -13(%ebp)         
    jmp     l_test12_7              #   3:     goto   7
l_test12_6:
    movl    $0, %eax                #   5:     assign t0 <- 0
    movb    %al, -13(%ebp)         
l_test12_7:
    movzbl  b, %eax                 #   7:     if     b # t0 goto 1
    movzbl  -13(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jne     l_test12_1             
    jmp     l_test12_2              #   8:     goto   2
l_test12_1:
    movl    $1, %eax                #  10:     assign t1 <- 1
    movb    %al, -14(%ebp)         
    jmp     l_test12_3              #  11:     goto   3
l_test12_2:
    movl    $0, %eax                #  13:     assign t1 <- 0
    movb    %al, -14(%ebp)         
l_test12_3:
    movzbl  -14(%ebp), %eax         #  15:     param  1 <- t1
    pushl   %eax                   
    movl    i, %eax                 #  16:     if     i < j goto 8
    movl    j, %ebx                
    cmpl    %ebx, %eax             
    jl      l_test12_8             
    jmp     l_test12_9              #  17:     goto   9
l_test12_8:
    movl    $1, %eax                #  19:     assign t2 <- 1
    movb    %al, -15(%ebp)         
    jmp     l_test12_10             #  20:     goto   10
l_test12_9:
    movl    $0, %eax                #  22:     assign t2 <- 0
    movb    %al, -15(%ebp)         
l_test12_10:
    movzbl  -15(%ebp), %eax         #  24:     param  0 <- t2
    pushl   %eax                   
    call    foo                     #  25:     call   t3 <- foo
    addl    $12, %esp              
    movb    %al, -16(%ebp)         
    movl    i, %eax                 #  26:     param  2 <- i
    pushl   %eax                   
    movzbl  b, %eax                 #  27:     if     b = 1 goto 14
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test12_14            
    movl    $1, %eax                #  28:     assign t4 <- 1
    movb    %al, -17(%ebp)         
    jmp     l_test12_15             #  29:     goto   15
l_test12_14:
    movl    $0, %eax                #  31:     assign t4 <- 0
    movb    %al, -17(%ebp)         
l_test12_15:
    movzbl  -17(%ebp), %eax         #  33:     param  1 <- t4
    pushl   %eax                   
    movzbl  b, %eax                 #  34:     param  0 <- b
    pushl   %eax                   
    call    foo                     #  35:     call   t5 <- foo
    addl    $12, %esp              
    movb    %al, -18(%ebp)         

l_test12_exit:
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

    # scope: test12
b:                                  # <bool>
    .skip    1
    .align   4
i:                                  # <int>
    .skip    4
j:                                  # <int>
    .skip    4


    # end of global data section
    #-----------------------------------------

    .end
##################################################
