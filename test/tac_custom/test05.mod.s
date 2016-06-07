##################################################
# test05
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
    #      8(%ebp)   4  [ %G        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+8 ]
    #     12(%ebp)   4  [ %H        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+12 ]
    #    -16(%ebp)   4  [ $t14      <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t15      <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t16      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t17      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t18      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t19      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t20      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t21      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t22      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t23      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t24      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t25      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t26      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t27      <int> %ebp-68 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $56, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $14, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $2, %eax                #   0:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #   1:     param  0 <- G
    pushl   %eax                   
    call    DIM                     #   2:     call   t14 <- DIM
    addl    $8, %esp               
    movl    %eax, -16(%ebp)        
    movl    $2, %eax                #   3:     mul    t15 <- 2, t14
    movl    -16(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   4:     add    t16 <- t15, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #   5:     mul    t17 <- t16, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    8(%ebp), %eax           #   6:     param  0 <- G
    pushl   %eax                   
    call    DOFS                    #   7:     call   t18 <- DOFS
    addl    $4, %esp               
    movl    %eax, -32(%ebp)        
    movl    -28(%ebp), %eax         #   8:     add    t19 <- t17, t18
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -36(%ebp)        
    movl    8(%ebp), %eax           #   9:     add    t20 <- G, t19
    movl    -36(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    $2, %eax                #  10:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  11:     param  0 <- H
    pushl   %eax                   
    call    DIM                     #  12:     call   t21 <- DIM
    addl    $8, %esp               
    movl    %eax, -44(%ebp)        
    movl    $1, %eax                #  13:     mul    t22 <- 1, t21
    movl    -44(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  14:     add    t23 <- t22, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    -52(%ebp), %eax         #  15:     mul    t24 <- t23, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -56(%ebp)        
    movl    12(%ebp), %eax          #  16:     param  0 <- H
    pushl   %eax                   
    call    DOFS                    #  17:     call   t25 <- DOFS
    addl    $4, %esp               
    movl    %eax, -60(%ebp)        
    movl    -56(%ebp), %eax         #  18:     add    t26 <- t24, t25
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    12(%ebp), %eax          #  19:     add    t27 <- H, t26
    movl    -64(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -40(%ebp), %edi        
    movl    (%edi), %eax            #  20:     assign @t27 <- @t20
    movl    -68(%ebp), %edi        
    movl    %eax, (%edi)           
    movl    $1, %eax                #  21:     return 1
    jmp     l_foo_exit             

l_foo_exit:
    # epilogue
    addl    $56, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test05
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <array 5 of <array 5 of <int>>>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 5 of <array 5 of <array 5 of <int>>>>> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <ptr(4) to <array 5 of <array 5 of <array 5 of <int>>>>> %ebp-24 ]
    #    -28(%ebp)   4  [ $t11      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t12      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t13      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t2       <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t3       <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t4       <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t5       <ptr(4) to <array 5 of <array 5 of <array 5 of <int>>>>> %ebp-52 ]
    #    -56(%ebp)   4  [ $t6       <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t7       <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t8       <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t9       <int> %ebp-68 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $56, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $14, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    leal    F, %eax                 #   0:     &()    t0 <- F
    movl    %eax, -16(%ebp)        
    movl    $2, %eax                #   1:     param  1 <- 2
    pushl   %eax                   
    leal    F, %eax                 #   2:     &()    t1 <- F
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   3:     param  0 <- t1
    pushl   %eax                   
    call    DIM                     #   4:     call   t2 <- DIM
    addl    $8, %esp               
    movl    %eax, -40(%ebp)        
    movl    $1, %eax                #   5:     mul    t3 <- 1, t2
    movl    -40(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #   6:     add    t4 <- t3, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    $3, %eax                #   7:     param  1 <- 3
    pushl   %eax                   
    leal    F, %eax                 #   8:     &()    t5 <- F
    movl    %eax, -52(%ebp)        
    movl    -52(%ebp), %eax         #   9:     param  0 <- t5
    pushl   %eax                   
    call    DIM                     #  10:     call   t6 <- DIM
    addl    $8, %esp               
    movl    %eax, -56(%ebp)        
    movl    -48(%ebp), %eax         #  11:     mul    t7 <- t4, t6
    movl    -56(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -60(%ebp)        
    movl    -60(%ebp), %eax         #  12:     add    t8 <- t7, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    -64(%ebp), %eax         #  13:     mul    t9 <- t8, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -68(%ebp)        
    leal    F, %eax                 #  14:     &()    t10 <- F
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #  15:     param  0 <- t10
    pushl   %eax                   
    call    DOFS                    #  16:     call   t11 <- DOFS
    addl    $4, %esp               
    movl    %eax, -28(%ebp)        
    movl    -68(%ebp), %eax         #  17:     add    t12 <- t9, t11
    movl    -28(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    -16(%ebp), %eax         #  18:     add    t13 <- t0, t12
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -36(%ebp)        
    movl    i, %eax                 #  19:     assign @t13 <- i
    movl    -36(%ebp), %edi        
    movl    %eax, (%edi)           

l_test05_exit:
    # epilogue
    addl    $56, %esp               # remove locals
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

    # scope: test05
A:                                  # <array 5 of <int>>
    .long    1
    .long    5
    .skip   20
B:                                  # <array 5 of <bool>>
    .long    1
    .long    5
    .skip    5
    .align   4
C:                                  # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100
D:                                  # <array 5 of <array 5 of <bool>>>
    .long    2
    .long    5
    .long    5
    .skip   25
    .align   4
E:                                  # <array 5 of <int>>
    .long    1
    .long    5
    .skip   20
F:                                  # <array 5 of <array 5 of <array 5 of <int>>>>
    .long    3
    .long    5
    .long    5
    .long    5
    .skip  500
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
