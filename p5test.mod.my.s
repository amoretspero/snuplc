##################################################
# hello
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
    #    -16(%ebp)   4  [ $a        <int> %ebp-16 ]
    #      8(%ebp)   1  [ %b        <bool> %ebp+8 ]
    #    -17(%ebp)   1  [ $b1       <bool> %ebp-17 ]
    #     20(%ebp)   1  [ %b5       <bool> %ebp+20 ]
    #     12(%ebp)   1  [ %b6       <bool> %ebp+12 ]
    #    -18(%ebp)   1  [ $c1       <char> %ebp-18 ]
    #     24(%ebp)   1  [ %c3       <char> %ebp+24 ]
    #     16(%ebp)   4  [ %i1       <int> %ebp+16 ]
    #     28(%ebp)   4  [ %i2       <int> %ebp+28 ]
    #    -24(%ebp)   4  [ $t0       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t1       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t2       <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $z        <int> %ebp-36 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $24, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $6, %ecx               
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    -36(%ebp), %eax         #   0:     add    t0 <- z, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #   1:     assign a <- t0
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   2:     mul    t1 <- a, 2
    movl    $2, %ebx               
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #   3:     assign z <- t1
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #   4:     div    t2 <- z, 3
    movl    $3, %ebx               
    cdq                            
    idivl   %ebx                   
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #   5:     assign a <- t2
    movl    %eax, -16(%ebp)        

l_foo_exit:
    # epilogue
    addl    $24, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope hello
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]

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
    movl    j, %eax                 #   0:     add    t0 <- j, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   1:     assign i <- t0
    movl    %eax, i                

l_hello_exit:
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

    # scope: hello
b:                                  # <bool>
    .skip    1
c:                                  # <char>
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
