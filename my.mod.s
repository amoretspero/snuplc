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
    #   -124(%ebp)  112  [ $arr0     <array 5 of <array 5 of <int>>> %ebp-124 ]
    #   -152(%ebp)  28  [ $arr1     <array 5 of <int>> %ebp-152 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $140, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $35, %ecx              
    mov     %esp, %edi             
    rep     stosl                  
    movl    $2,-124(%ebp)           # local array 'arr0': 2 dimensions
    movl    $5,-120(%ebp)           #   dimension 1: 5 elements
    movl    $5,-116(%ebp)           #   dimension 2: 5 elements
    movl    $1,-152(%ebp)           # local array 'arr1': 1 dimensions
    movl    $5,-148(%ebp)           #   dimension 1: 5 elements

    # function body

l_foo_exit:
    # epilogue
    addl    $140, %esp              # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope hello
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t2       <int> %ebp-24 ]

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
    movl    $1, %eax                #   0:     mul    t0 <- 1, 2
    movl    $2, %ebx               
    imull   %ebx                   
    movl    %eax, -16(%ebp)        
    movl    $3, %eax                #   1:     mul    t1 <- 3, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    movl    -16(%ebp), %eax         #   2:     add    t2 <- t0, t1
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #   3:     assign i <- t2
    movl    %eax, i                

l_hello_exit:
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
