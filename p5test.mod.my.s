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
    #    -16(%ebp)   4   [ $a        <int> %ebp-16 ]
    #      8(%ebp)   1   [ %b        <bool> %ebp+8 ]
    #    -17(%ebp)   1   [ $b1       <bool> %ebp-17 ]
    #     20(%ebp)   1   [ %b5       <bool> %ebp+20 ]
    #     12(%ebp)   1   [ %b6       <bool> %ebp+12 ]
    #    -18(%ebp)   1   [ $c1       <char> %ebp-18 ]
    #     24(%ebp)   1   [ %c3       <char> %ebp+24 ]
    #     16(%ebp)   4   [ %i1       <int> %ebp+16 ]
    #     28(%ebp)   4   [ %i2       <int> %ebp+28 ]
    #    -24(%ebp)   4   [ $t0       <int> %ebp-24 ]
    #    -30(%ebp)   4   [ $z        <int> %ebp-30 ]

    # prologue
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $42, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $10, %ecx
    movl    %esp, %edi             
    rep     stosl                  

    # function body
    movl    $1, %eax                #   0:     add    t0 <- 1, 1
    movl    $1, %ebx               
    # ???   not implemented         #   1:     assign i <- t0

l_foo_end:
    # epilogue
    addl    $42, %esp               # remove locals
    popl    %ebx
    popl    %esi
    popl    %edi
    popl    %ebp
    ret

    # scope hello
main:
    #-16    (%ebp)4      [ $t0       <int> %ebp-16 ]

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
    movl    $1, %eax                #   0:     add    t0 <- 1, 1
    movl    $1, %ebx               
    # ???   not implemented         #   1:     assign i <- t0

l_main_end:
    # epilogue
    addl    $4, %esp                # remove locals
    popl    %ebx
    popl    %esi
    popl    %edi
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


    # end of global data section
    #-----------------------------------------

    .end
##################################################
