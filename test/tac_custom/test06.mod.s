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
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t11      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t12      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t13      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t2       <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t3       <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t4       <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t5       <int> %ebp-52 ]
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
    movl    8(%ebp), %eax           #   0:     assign H <- G
    movl    %eax, 12(%ebp)         
    movl    $2, %eax                #   1:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #   2:     param  0 <- G
    pushl   %eax                   
    call    DIM                     #   3:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -16(%ebp)        
    movl    $2, %eax                #   4:     mul    t1 <- 2, t0
    movl    -16(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   5:     add    t2 <- t1, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #   6:     mul    t3 <- t2, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    8(%ebp), %eax           #   7:     param  0 <- G
    pushl   %eax                   
    call    DOFS                    #   8:     call   t4 <- DOFS
    addl    $4, %esp               
    movl    %eax, -48(%ebp)        
    movl    -44(%ebp), %eax         #   9:     add    t5 <- t3, t4
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    8(%ebp), %eax           #  10:     add    t6 <- G, t5
    movl    -52(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -56(%ebp)        
    movl    $2, %eax                #  11:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  12:     param  0 <- H
    pushl   %eax                   
    call    DIM                     #  13:     call   t7 <- DIM
    addl    $8, %esp               
    movl    %eax, -60(%ebp)        
    movl    $1, %eax                #  14:     mul    t8 <- 1, t7
    movl    -60(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -64(%ebp)        
    movl    -64(%ebp), %eax         #  15:     add    t9 <- t8, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         #  16:     mul    t10 <- t9, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -24(%ebp)        
    movl    12(%ebp), %eax          #  17:     param  0 <- H
    pushl   %eax                   
    call    DOFS                    #  18:     call   t11 <- DOFS
    addl    $4, %esp               
    movl    %eax, -28(%ebp)        
    movl    -24(%ebp), %eax         #  19:     add    t12 <- t10, t11
    movl    -28(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    12(%ebp), %eax          #  20:     add    t13 <- H, t12
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -36(%ebp)        
    movl    -56(%ebp), %edi        
    movl    (%edi), %eax            #  21:     assign @t13 <- @t6
    movl    -36(%ebp), %edi        
    movl    %eax, (%edi)           
    movl    $1, %eax                #  22:     return 1
    jmp     l_foo_exit             

l_foo_exit:
    # epilogue
    addl    $56, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope bar
bar:
    # stack offsets:
    #      8(%ebp)   4  [ %I        <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp+8 ]
    #     12(%ebp)   4  [ %J        <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp+12 ]
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t11      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t12      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t13      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t2       <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t3       <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t4       <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t5       <int> %ebp-52 ]
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
    movl    12(%ebp), %eax          #   0:     assign I <- J
    movl    %eax, 8(%ebp)          
    movl    $2, %eax                #   1:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #   2:     param  0 <- J
    pushl   %eax                   
    call    DIM                     #   3:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -16(%ebp)        
    movl    $2, %eax                #   4:     mul    t1 <- 2, t0
    movl    -16(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   5:     add    t2 <- t1, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #   6:     mul    t3 <- t2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    12(%ebp), %eax          #   7:     param  0 <- J
    pushl   %eax                   
    call    DOFS                    #   8:     call   t4 <- DOFS
    addl    $4, %esp               
    movl    %eax, -48(%ebp)        
    movl    -44(%ebp), %eax         #   9:     add    t5 <- t3, t4
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    12(%ebp), %eax          #  10:     add    t6 <- J, t5
    movl    -52(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -56(%ebp)        
    movl    $2, %eax                #  11:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  12:     param  0 <- I
    pushl   %eax                   
    call    DIM                     #  13:     call   t7 <- DIM
    addl    $8, %esp               
    movl    %eax, -60(%ebp)        
    movl    $1, %eax                #  14:     mul    t8 <- 1, t7
    movl    -60(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -64(%ebp)        
    movl    -64(%ebp), %eax         #  15:     add    t9 <- t8, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         #  16:     mul    t10 <- t9, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -24(%ebp)        
    movl    8(%ebp), %eax           #  17:     param  0 <- I
    pushl   %eax                   
    call    DOFS                    #  18:     call   t11 <- DOFS
    addl    $4, %esp               
    movl    %eax, -28(%ebp)        
    movl    -24(%ebp), %eax         #  19:     add    t12 <- t10, t11
    movl    -28(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    8(%ebp), %eax           #  20:     add    t13 <- I, t12
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -36(%ebp)        
    movl    -56(%ebp), %edi        
    movzbl  (%edi), %eax            #  21:     assign @t13 <- @t6
    movl    -36(%ebp), %edi        
    movb    %al, (%edi)            
    movl    $0, %eax                #  22:     return 0
    jmp     l_bar_exit             

l_bar_exit:
    # epilogue
    addl    $56, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope foobar
foobar:
    # stack offsets:
    #      8(%ebp)   4  [ %I        <ptr(4) to <array 5 of <int>>> %ebp+8 ]
    #     12(%ebp)   4  [ %J        <ptr(4) to <array 5 of <int>>> %ebp+12 ]
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t2       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t3       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t4       <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t5       <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t6       <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t7       <int> %ebp-44 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $32, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $8, %ecx               
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $2, %eax                #   0:     mul    t0 <- 2, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -16(%ebp)        
    movl    12(%ebp), %eax          #   1:     param  0 <- J
    pushl   %eax                   
    call    DOFS                    #   2:     call   t1 <- DOFS
    addl    $4, %esp               
    movl    %eax, -20(%ebp)        
    movl    -16(%ebp), %eax         #   3:     add    t2 <- t0, t1
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    12(%ebp), %eax          #   4:     add    t3 <- J, t2
    movl    -24(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    $1, %eax                #   5:     mul    t4 <- 1, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -32(%ebp)        
    movl    8(%ebp), %eax           #   6:     param  0 <- I
    pushl   %eax                   
    call    DOFS                    #   7:     call   t5 <- DOFS
    addl    $4, %esp               
    movl    %eax, -36(%ebp)        
    movl    -32(%ebp), %eax         #   8:     add    t6 <- t4, t5
    movl    -36(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    8(%ebp), %eax           #   9:     add    t7 <- I, t6
    movl    -40(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -44(%ebp)        
    movl    -28(%ebp), %edi        
    movl    (%edi), %eax            #  10:     assign @t7 <- @t3
    movl    -44(%ebp), %edi        
    movl    %eax, (%edi)           
    movl    $0, %eax                #  11:     return 0
    jmp     l_foobar_exit          

l_foobar_exit:
    # epilogue
    addl    $32, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope simple
simple:
    # stack offsets:
    #      8(%ebp)   4  [ %A        <ptr(4) to <array 5 of <int>>> %ebp+8 ]
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t2       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t3       <int> %ebp-28 ]

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
    movl    $1, %eax                #   0:     mul    t0 <- 1, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -16(%ebp)        
    movl    8(%ebp), %eax           #   1:     param  0 <- A
    pushl   %eax                   
    call    DOFS                    #   2:     call   t1 <- DOFS
    addl    $4, %esp               
    movl    %eax, -20(%ebp)        
    movl    -16(%ebp), %eax         #   3:     add    t2 <- t0, t1
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    8(%ebp), %eax           #   4:     add    t3 <- A, t2
    movl    -24(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    $2, %eax                #   5:     assign @t3 <- 2
    movl    -28(%ebp), %edi        
    movl    %eax, (%edi)           
    movl    $1, %eax                #   6:     return 1
    jmp     l_simple_exit          

l_simple_exit:
    # epilogue
    addl    $16, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope fun
fun:
    # stack offsets:
    #      8(%ebp)   4  [ %a        <int> %ebp+8 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body
    movl    $1, %eax                #   0:     return 1
    jmp     l_fun_exit             

l_fun_exit:
    # epilogue
    addl    $0, %esp                # remove locals
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
    #    -40(%ebp)   4  [ $t14      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-40 ]
    #    -44(%ebp)   4  [ $t15      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-44 ]
    #    -48(%ebp)   4  [ $t16      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t17      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t18      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t19      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t2       <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t20      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-68 ]
    #    -72(%ebp)   4  [ $t21      <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t22      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t23      <int> %ebp-80 ]
    #    -81(%ebp)   1  [ $t24      <bool> %ebp-81 ]
    #    -88(%ebp)   4  [ $t25      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-88 ]
    #    -92(%ebp)   4  [ $t26      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-92 ]
    #    -96(%ebp)   4  [ $t27      <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t28      <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t29      <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t3       <int> %ebp-108 ]
    #   -112(%ebp)   4  [ $t30      <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t31      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-116 ]
    #   -120(%ebp)   4  [ $t32      <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t33      <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t34      <int> %ebp-128 ]
    #   -132(%ebp)   4  [ $t35      <ptr(4) to <int>> %ebp-132 ]
    #   -133(%ebp)   1  [ $t36      <bool> %ebp-133 ]
    #   -140(%ebp)   4  [ $t37      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-140 ]
    #   -144(%ebp)   4  [ $t38      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-144 ]
    #   -148(%ebp)   4  [ $t39      <int> %ebp-148 ]
    #   -152(%ebp)   4  [ $t4       <int> %ebp-152 ]
    #   -156(%ebp)   4  [ $t40      <int> %ebp-156 ]
    #   -160(%ebp)   4  [ $t41      <int> %ebp-160 ]
    #   -164(%ebp)   4  [ $t42      <int> %ebp-164 ]
    #   -168(%ebp)   4  [ $t43      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-168 ]
    #   -172(%ebp)   4  [ $t44      <int> %ebp-172 ]
    #   -176(%ebp)   4  [ $t45      <int> %ebp-176 ]
    #   -180(%ebp)   4  [ $t46      <int> %ebp-180 ]
    #   -184(%ebp)   4  [ $t47      <ptr(4) to <int>> %ebp-184 ]
    #   -185(%ebp)   1  [ $t48      <bool> %ebp-185 ]
    #   -192(%ebp)   4  [ $t49      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-192 ]
    #   -196(%ebp)   4  [ $t5       <ptr(4) to <array 5 of <array 5 of <array 5 of <int>>>>> %ebp-196 ]
    #   -200(%ebp)   4  [ $t50      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-200 ]
    #   -204(%ebp)   4  [ $t51      <int> %ebp-204 ]
    #   -208(%ebp)   4  [ $t52      <int> %ebp-208 ]
    #   -212(%ebp)   4  [ $t53      <int> %ebp-212 ]
    #   -216(%ebp)   4  [ $t54      <int> %ebp-216 ]
    #   -220(%ebp)   4  [ $t55      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-220 ]
    #   -224(%ebp)   4  [ $t56      <int> %ebp-224 ]
    #   -228(%ebp)   4  [ $t57      <int> %ebp-228 ]
    #   -232(%ebp)   4  [ $t58      <int> %ebp-232 ]
    #   -236(%ebp)   4  [ $t59      <ptr(4) to <int>> %ebp-236 ]
    #   -240(%ebp)   4  [ $t6       <int> %ebp-240 ]
    #   -241(%ebp)   1  [ $t60      <bool> %ebp-241 ]
    #   -242(%ebp)   1  [ $t61      <bool> %ebp-242 ]
    #   -248(%ebp)   4  [ $t62      <ptr(4) to <array 5 of <bool>>> %ebp-248 ]
    #   -252(%ebp)   4  [ $t63      <int> %ebp-252 ]
    #   -256(%ebp)   4  [ $t64      <ptr(4) to <array 5 of <bool>>> %ebp-256 ]
    #   -260(%ebp)   4  [ $t65      <int> %ebp-260 ]
    #   -264(%ebp)   4  [ $t66      <int> %ebp-264 ]
    #   -268(%ebp)   4  [ $t67      <int> %ebp-268 ]
    #   -272(%ebp)   4  [ $t68      <ptr(4) to <array 5 of <bool>>> %ebp-272 ]
    #   -276(%ebp)   4  [ $t69      <int> %ebp-276 ]
    #   -280(%ebp)   4  [ $t7       <int> %ebp-280 ]
    #   -284(%ebp)   4  [ $t70      <ptr(4) to <array 5 of <bool>>> %ebp-284 ]
    #   -288(%ebp)   4  [ $t71      <int> %ebp-288 ]
    #   -292(%ebp)   4  [ $t72      <int> %ebp-292 ]
    #   -296(%ebp)   4  [ $t73      <int> %ebp-296 ]
    #   -297(%ebp)   1  [ $t74      <bool> %ebp-297 ]
    #   -304(%ebp)   4  [ $t75      <ptr(4) to <array 14 of <char>>> %ebp-304 ]
    #   -308(%ebp)   4  [ $t8       <int> %ebp-308 ]
    #   -312(%ebp)   4  [ $t9       <int> %ebp-312 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $300, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $75, %ecx              
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
    movl    %eax, -64(%ebp)        
    movl    $1, %eax                #   5:     mul    t3 <- 1, t2
    movl    -64(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #   6:     add    t4 <- t3, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -152(%ebp)       
    movl    $3, %eax                #   7:     param  1 <- 3
    pushl   %eax                   
    leal    F, %eax                 #   8:     &()    t5 <- F
    movl    %eax, -196(%ebp)       
    movl    -196(%ebp), %eax        #   9:     param  0 <- t5
    pushl   %eax                   
    call    DIM                     #  10:     call   t6 <- DIM
    addl    $8, %esp               
    movl    %eax, -240(%ebp)       
    movl    -152(%ebp), %eax        #  11:     mul    t7 <- t4, t6
    movl    -240(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -280(%ebp)       
    movl    -280(%ebp), %eax        #  12:     add    t8 <- t7, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -308(%ebp)       
    movl    -308(%ebp), %eax        #  13:     mul    t9 <- t8, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -312(%ebp)       
    leal    F, %eax                 #  14:     &()    t10 <- F
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #  15:     param  0 <- t10
    pushl   %eax                   
    call    DOFS                    #  16:     call   t11 <- DOFS
    addl    $4, %esp               
    movl    %eax, -28(%ebp)        
    movl    -312(%ebp), %eax        #  17:     add    t12 <- t9, t11
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
    leal    C, %eax                 #  20:     &()    t14 <- C
    movl    %eax, -40(%ebp)        
    movl    $2, %eax                #  21:     param  1 <- 2
    pushl   %eax                   
    leal    C, %eax                 #  22:     &()    t15 <- C
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #  23:     param  0 <- t15
    pushl   %eax                   
    call    DIM                     #  24:     call   t16 <- DIM
    addl    $8, %esp               
    movl    %eax, -48(%ebp)        
    movl    $1, %eax                #  25:     mul    t17 <- 1, t16
    movl    -48(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -52(%ebp)        
    movl    -52(%ebp), %eax         #  26:     add    t18 <- t17, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         #  27:     mul    t19 <- t18, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -60(%ebp)        
    leal    C, %eax                 #  28:     &()    t20 <- C
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         #  29:     param  0 <- t20
    pushl   %eax                   
    call    DOFS                    #  30:     call   t21 <- DOFS
    addl    $4, %esp               
    movl    %eax, -72(%ebp)        
    movl    -60(%ebp), %eax         #  31:     add    t22 <- t19, t21
    movl    -72(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -76(%ebp)        
    movl    -40(%ebp), %eax         #  32:     add    t23 <- t14, t22
    movl    -76(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -80(%ebp), %edi        
    movl    (%edi), %eax            #  33:     param  0 <- @t23
    pushl   %eax                   
    call    fun                     #  34:     call   t24 <- fun
    addl    $4, %esp               
    movb    %al, -81(%ebp)         
    movzbl  -81(%ebp), %eax         #  35:     assign b <- t24
    movb    %al, b                 
    leal    C, %eax                 #  36:     &()    t25 <- C
    movl    %eax, -88(%ebp)        
    movl    $2, %eax                #  37:     param  1 <- 2
    pushl   %eax                   
    leal    C, %eax                 #  38:     &()    t26 <- C
    movl    %eax, -92(%ebp)        
    movl    -92(%ebp), %eax         #  39:     param  0 <- t26
    pushl   %eax                   
    call    DIM                     #  40:     call   t27 <- DIM
    addl    $8, %esp               
    movl    %eax, -96(%ebp)        
    movl    $1, %eax                #  41:     mul    t28 <- 1, t27
    movl    -96(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -100(%ebp)       
    movl    -100(%ebp), %eax        #  42:     add    t29 <- t28, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -104(%ebp)       
    movl    -104(%ebp), %eax        #  43:     mul    t30 <- t29, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -112(%ebp)       
    leal    C, %eax                 #  44:     &()    t31 <- C
    movl    %eax, -116(%ebp)       
    movl    -116(%ebp), %eax        #  45:     param  0 <- t31
    pushl   %eax                   
    call    DOFS                    #  46:     call   t32 <- DOFS
    addl    $4, %esp               
    movl    %eax, -120(%ebp)       
    movl    -112(%ebp), %eax        #  47:     add    t33 <- t30, t32
    movl    -120(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -124(%ebp)       
    movl    -88(%ebp), %eax         #  48:     add    t34 <- t25, t33
    movl    -124(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -128(%ebp)       
    movl    -128(%ebp), %edi       
    leal    (%edi), %eax            #  49:     &()    t35 <- @t34
    movl    %eax, -132(%ebp)       
    movl    -132(%ebp), %eax        #  50:     param  0 <- t35
    pushl   %eax                   
    call    simple                  #  51:     call   t36 <- simple
    addl    $4, %esp               
    movb    %al, -133(%ebp)        
    movzbl  -133(%ebp), %eax        #  52:     assign b <- t36
    movb    %al, b                 
    leal    C, %eax                 #  53:     &()    t37 <- C
    movl    %eax, -140(%ebp)       
    movl    $2, %eax                #  54:     param  1 <- 2
    pushl   %eax                   
    leal    C, %eax                 #  55:     &()    t38 <- C
    movl    %eax, -144(%ebp)       
    movl    -144(%ebp), %eax        #  56:     param  0 <- t38
    pushl   %eax                   
    call    DIM                     #  57:     call   t39 <- DIM
    addl    $8, %esp               
    movl    %eax, -148(%ebp)       
    movl    $1, %eax                #  58:     mul    t40 <- 1, t39
    movl    -148(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -156(%ebp)       
    movl    -156(%ebp), %eax        #  59:     add    t41 <- t40, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -160(%ebp)       
    movl    -160(%ebp), %eax        #  60:     mul    t42 <- t41, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -164(%ebp)       
    leal    C, %eax                 #  61:     &()    t43 <- C
    movl    %eax, -168(%ebp)       
    movl    -168(%ebp), %eax        #  62:     param  0 <- t43
    pushl   %eax                   
    call    DOFS                    #  63:     call   t44 <- DOFS
    addl    $4, %esp               
    movl    %eax, -172(%ebp)       
    movl    -164(%ebp), %eax        #  64:     add    t45 <- t42, t44
    movl    -172(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -176(%ebp)       
    movl    -140(%ebp), %eax        #  65:     add    t46 <- t37, t45
    movl    -176(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -180(%ebp)       
    movl    -180(%ebp), %edi       
    leal    (%edi), %eax            #  66:     &()    t47 <- @t46
    movl    %eax, -184(%ebp)       
    movl    -184(%ebp), %eax        #  67:     param  0 <- t47
    pushl   %eax                   
    call    simple                  #  68:     call   t48 <- simple
    addl    $4, %esp               
    movb    %al, -185(%ebp)        
    movzbl  -185(%ebp), %eax        #  69:     if     t48 = 1 goto 7
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test05_7             
    jmp     l_test05_5              #  70:     goto   5
l_test05_7:
    leal    C, %eax                 #  72:     &()    t49 <- C
    movl    %eax, -192(%ebp)       
    movl    $2, %eax                #  73:     param  1 <- 2
    pushl   %eax                   
    leal    C, %eax                 #  74:     &()    t50 <- C
    movl    %eax, -200(%ebp)       
    movl    -200(%ebp), %eax        #  75:     param  0 <- t50
    pushl   %eax                   
    call    DIM                     #  76:     call   t51 <- DIM
    addl    $8, %esp               
    movl    %eax, -204(%ebp)       
    movl    $2, %eax                #  77:     mul    t52 <- 2, t51
    movl    -204(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -208(%ebp)       
    movl    -208(%ebp), %eax        #  78:     add    t53 <- t52, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -212(%ebp)       
    movl    -212(%ebp), %eax        #  79:     mul    t54 <- t53, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -216(%ebp)       
    leal    C, %eax                 #  80:     &()    t55 <- C
    movl    %eax, -220(%ebp)       
    movl    -220(%ebp), %eax        #  81:     param  0 <- t55
    pushl   %eax                   
    call    DOFS                    #  82:     call   t56 <- DOFS
    addl    $4, %esp               
    movl    %eax, -224(%ebp)       
    movl    -216(%ebp), %eax        #  83:     add    t57 <- t54, t56
    movl    -224(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -228(%ebp)       
    movl    -192(%ebp), %eax        #  84:     add    t58 <- t49, t57
    movl    -228(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -232(%ebp)       
    movl    -232(%ebp), %edi       
    leal    (%edi), %eax            #  85:     &()    t59 <- @t58
    movl    %eax, -236(%ebp)       
    movl    -236(%ebp), %eax        #  86:     param  0 <- t59
    pushl   %eax                   
    call    simple                  #  87:     call   t60 <- simple
    addl    $4, %esp               
    movb    %al, -241(%ebp)        
    movzbl  -241(%ebp), %eax        #  88:     if     t60 = 1 goto 4
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test05_4             
    jmp     l_test05_5              #  89:     goto   5
l_test05_4:
    movl    $1, %eax                #  91:     assign t61 <- 1
    movb    %al, -242(%ebp)        
    jmp     l_test05_6              #  92:     goto   6
l_test05_5:
    movl    $0, %eax                #  94:     assign t61 <- 0
    movb    %al, -242(%ebp)        
l_test05_6:
    movzbl  -242(%ebp), %eax        #  96:     assign b <- t61
    movb    %al, b                 
    leal    B, %eax                 #  97:     &()    t62 <- B
    movl    %eax, -248(%ebp)       
    movl    $1, %eax                #  98:     mul    t63 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -252(%ebp)       
    leal    B, %eax                 #  99:     &()    t64 <- B
    movl    %eax, -256(%ebp)       
    movl    -256(%ebp), %eax        # 100:     param  0 <- t64
    pushl   %eax                   
    call    DOFS                    # 101:     call   t65 <- DOFS
    addl    $4, %esp               
    movl    %eax, -260(%ebp)       
    movl    -252(%ebp), %eax        # 102:     add    t66 <- t63, t65
    movl    -260(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -264(%ebp)       
    movl    -248(%ebp), %eax        # 103:     add    t67 <- t62, t66
    movl    -264(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -268(%ebp)       
    movl    -268(%ebp), %edi       
    movzbl  (%edi), %eax            # 104:     if     @t67 = 1 goto 12
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test05_12            
    jmp     l_test05_10             # 105:     goto   10
l_test05_12:
    leal    B, %eax                 # 107:     &()    t68 <- B
    movl    %eax, -272(%ebp)       
    movl    $2, %eax                # 108:     mul    t69 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -276(%ebp)       
    leal    B, %eax                 # 109:     &()    t70 <- B
    movl    %eax, -284(%ebp)       
    movl    -284(%ebp), %eax        # 110:     param  0 <- t70
    pushl   %eax                   
    call    DOFS                    # 111:     call   t71 <- DOFS
    addl    $4, %esp               
    movl    %eax, -288(%ebp)       
    movl    -276(%ebp), %eax        # 112:     add    t72 <- t69, t71
    movl    -288(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -292(%ebp)       
    movl    -272(%ebp), %eax        # 113:     add    t73 <- t68, t72
    movl    -292(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -296(%ebp)       
    movl    -296(%ebp), %edi       
    movzbl  (%edi), %eax            # 114:     if     @t73 = 1 goto 9
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test05_9             
    jmp     l_test05_10             # 115:     goto   10
l_test05_9:
    movl    $1, %eax                # 117:     assign t74 <- 1
    movb    %al, -297(%ebp)        
    jmp     l_test05_11             # 118:     goto   11
l_test05_10:
    movl    $0, %eax                # 120:     assign t74 <- 0
    movb    %al, -297(%ebp)        
l_test05_11:
    movzbl  -297(%ebp), %eax        # 122:     assign b <- t74
    movb    %al, b                 
    leal    _str_1, %eax            # 123:     &()    t75 <- _str_1
    movl    %eax, -304(%ebp)       
    movl    -304(%ebp), %eax        # 124:     param  0 <- t75
    pushl   %eax                   
    call    WriteStr                # 125:     call   WriteStr
    addl    $4, %esp               

l_test05_exit:
    # epilogue
    addl    $300, %esp              # remove locals
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
C1:                                 # <array 5 of <array 5 of <int>>>
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
_str_1:                             # <array 14 of <char>>
    .long    1
    .long   14
    .asciz "Hello, World!"
b:                                  # <bool>
    .skip    1
c:                                  # <bool>
    .skip    1
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
