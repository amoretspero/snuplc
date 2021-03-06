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
    #    -17(%ebp)   1  [ $b1       <bool> %ebp-17 ]
    #    -18(%ebp)   1  [ $c1       <char> %ebp-18 ]
    #      8(%ebp)   4  [ %i1       <int> %ebp+8 ]
    #    -19(%ebp)   1  [ $t0       <bool> %ebp-19 ]
    #    -20(%ebp)   1  [ $t1       <bool> %ebp-20 ]
    #    -24(%ebp)   4  [ $z        <int> %ebp-24 ]

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
    jmp     l_foo_2                 #   0:     goto   2
    movl    $1, %eax                #   1:     assign t0 <- 1
    movb    %al, -19(%ebp)         
    jmp     l_foo_3                 #   2:     goto   3
l_foo_2:
    movl    $0, %eax                #   4:     assign t0 <- 0
    movb    %al, -19(%ebp)         
l_foo_3:
    movzbl  -19(%ebp), %eax         #   6:     assign b <- t0
    movb    %al, b                 
    jmp     l_foo_6                 #   7:     goto   6
    jmp     l_foo_7                 #   8:     goto   7
l_foo_6:
    movl    $1, %eax                #  10:     assign t1 <- 1
    movb    %al, -20(%ebp)         
    jmp     l_foo_8                 #  11:     goto   8
l_foo_7:
    movl    $0, %eax                #  13:     assign t1 <- 0
    movb    %al, -20(%ebp)         
l_foo_8:
    movzbl  -20(%ebp), %eax         #  15:     assign b <- t1
    movb    %al, b                 
    movl    $97, %eax               #  16:     if     97 = 122 goto 11_if_true
    movl    $122, %ebx             
    cmpl    %ebx, %eax             
    je      l_foo_11_if_true       
    jmp     l_foo_12_if_false       #  17:     goto   12_if_false
l_foo_11_if_true:
    movl    $1, %eax                #  19:     assign i1 <- 1
    movl    %eax, 8(%ebp)          
    jmp     l_foo_10                #  20:     goto   10
l_foo_12_if_false:
    movl    $2, %eax                #  22:     assign i1 <- 2
    movl    %eax, 8(%ebp)          
l_foo_10:

l_foo_exit:
    # epilogue
    addl    $12, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope bar
bar:
    # stack offsets:
    #    -40(%ebp)  28  [ $arr      <array 5 of <int>> %ebp-40 ]
    #      8(%ebp)   4  [ %i2       <int> %ebp+8 ]
    #     12(%ebp)   4  [ %ia       <ptr(4) to <array 5 of <int>>> %ebp+12 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $28, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $7, %ecx               
    mov     %esp, %edi             
    rep     stosl                  
    movl    $1,-40(%ebp)            # local array 'arr': 1 dimensions
    movl    $5,-36(%ebp)            #   dimension 1: 5 elements

    # function body

l_bar_exit:
    # epilogue
    addl    $28, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope hello
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -17(%ebp)   1  [ $t1       <bool> %ebp-17 ]
    #    -24(%ebp)   4  [ $t2       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t3       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t4       <ptr(4) to <array 5 of <int>>> %ebp-32 ]
    #    -36(%ebp)   4  [ $t5       <ptr(4) to <array 5 of <int>>> %ebp-36 ]

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
    movl    j, %eax                 #   0:     add    t0 <- j, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   1:     assign i <- t0
    movl    %eax, i                
    movzbl  b, %eax                 #   2:     if     b = 1 goto 3
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_hello_3              
    movl    $1, %eax                #   3:     assign t1 <- 1
    movb    %al, -17(%ebp)         
    jmp     l_hello_4               #   4:     goto   4
l_hello_3:
    movl    $0, %eax                #   6:     assign t1 <- 0
    movb    %al, -17(%ebp)         
l_hello_4:
    movzbl  -17(%ebp), %eax         #   8:     assign b <- t1
    movb    %al, b                 
    movl    i, %eax                 #   9:     param  0 <- i
    pushl   %eax                   
    call    foo                     #  10:     call   t2 <- foo
    addl    $4, %esp               
    movl    %eax, -24(%ebp)        
    movl    $1, %eax                #  11:     param  0 <- 1
    pushl   %eax                   
    call    foo                     #  12:     call   t3 <- foo
    addl    $4, %esp               
    movl    %eax, -28(%ebp)        
    leal    arr0, %eax              #  13:     &()    t4 <- arr0
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #  14:     param  1 <- t4
    pushl   %eax                   
    movl    j, %eax                 #  15:     param  0 <- j
    pushl   %eax                   
    call    bar                     #  16:     call   bar
    addl    $8, %esp               
    leal    arr0, %eax              #  17:     &()    t5 <- arr0
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #  18:     param  1 <- t5
    pushl   %eax                   
    movl    $2, %eax                #  19:     param  0 <- 2
    pushl   %eax                   
    call    bar                     #  20:     call   bar
    addl    $8, %esp               

l_hello_exit:
    # epilogue
    addl    $24, %esp               # remove locals
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
arr0:                               # <array 5 of <int>>
    .long    1
    .long    5
    .skip   20
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
