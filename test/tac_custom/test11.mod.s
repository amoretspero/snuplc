##################################################
# test11
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
    #    -13(%ebp)   1  [ $t0       <bool> %ebp-13 ]
    #    -14(%ebp)   1  [ $t1       <bool> %ebp-14 ]
    #    -15(%ebp)   1  [ $t2       <bool> %ebp-15 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $4, %esp                # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 0(%esp)          

    # function body
    movl    $1, %eax                #   0:     if     1 > 2 goto 5
    movl    $2, %ebx               
    cmpl    %ebx, %eax             
    jg      l_foo_5                
    jmp     l_foo_6                 #   1:     goto   6
l_foo_5:
    movl    $1, %eax                #   3:     assign t0 <- 1
    movb    %al, -13(%ebp)         
    jmp     l_foo_7                 #   4:     goto   7
l_foo_6:
    movl    $0, %eax                #   6:     assign t0 <- 0
    movb    %al, -13(%ebp)         
l_foo_7:
    movzbl  8(%ebp), %eax           #   8:     if     b0 = b1 goto 9
    movzbl  12(%ebp), %ebx         
    cmpl    %ebx, %eax             
    je      l_foo_9                
    jmp     l_foo_10                #   9:     goto   10
l_foo_9:
    movl    $1, %eax                #  11:     assign t1 <- 1
    movb    %al, -14(%ebp)         
    jmp     l_foo_11                #  12:     goto   11
l_foo_10:
    movl    $0, %eax                #  14:     assign t1 <- 0
    movb    %al, -14(%ebp)         
l_foo_11:
    movzbl  -13(%ebp), %eax         #  16:     if     t0 # t1 goto 1
    movzbl  -14(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jne     l_foo_1                
    jmp     l_foo_2                 #  17:     goto   2
l_foo_1:
    movl    $1, %eax                #  19:     assign t2 <- 1
    movb    %al, -15(%ebp)         
    jmp     l_foo_3                 #  20:     goto   3
l_foo_2:
    movl    $0, %eax                #  22:     assign t2 <- 0
    movb    %al, -15(%ebp)         
l_foo_3:
    movzbl  -15(%ebp), %eax         #  24:     return t2
    jmp     l_foo_exit             

l_foo_exit:
    # epilogue
    addl    $4, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test11
main:
    # stack offsets:
    #    -13(%ebp)   1  [ $t0       <bool> %ebp-13 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $4, %esp                # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 0(%esp)          

    # function body
    movzbl  c, %eax                 #   0:     param  1 <- c
    pushl   %eax                   
    movzbl  b, %eax                 #   1:     param  0 <- b
    pushl   %eax                   
    call    foo                     #   2:     call   t0 <- foo
    addl    $8, %esp               
    movb    %al, -13(%ebp)         

l_test11_exit:
    # epilogue
    addl    $4, %esp                # remove locals
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

    # scope: test11
b:                                  # <bool>
    .skip    1
c:                                  # <bool>
    .skip    1


    # end of global data section
    #-----------------------------------------

    .end
##################################################
