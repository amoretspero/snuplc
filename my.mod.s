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
    #      8(%ebp)   4   [ %b        <int> %ebp+8 ]
    #    -20(%ebp)   4   [ $t0       <int> %ebp-20 ]
    #     12(%ebp)   4   [ %v        <int> %ebp+12 ]
    #    -24(%ebp)   4   [ $z        <int> %ebp-24 ]
    #    -28(%ebp)   4   [ $z1       <int> %ebp-28 ]

    # prologue
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $16, %esp               # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 12(%esp)
    movl    %eax, 8(%esp)
    movl    %eax, 4(%esp)
    movl    %eax, 0(%esp)

    # function body
    movl    $1, %eax                #   0:     add    t0 <- 1, 1
    movl    $1, %ebx               
    # ???   not implemented         #   1:     assign i <- t0

l_foo_end:
    # epilogue
    addl    $16, %esp
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
    addl    $4, %esp
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
