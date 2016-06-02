##################################################
# test07
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

    # scope MatAdd
MatAdd:
    # stack offsets:
    #      8(%ebp)   4  [ %A        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+8 ]
    #     12(%ebp)   4  [ %B        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+12 ]
    #    -16(%ebp)   4  [ $colcnt   <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $rowcnt   <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t0       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t1       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t10      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t11      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t12      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t13      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t14      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t15      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t16      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t17      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t18      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t19      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t2       <ptr(4) to <array 27 of <char>>> %ebp-72 ]
    #    -76(%ebp)   4  [ $t20      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t21      <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t22      <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t23      <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t24      <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t25      <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t26      <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t27      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-104 ]
    #   -108(%ebp)   4  [ $t28      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-108 ]
    #   -112(%ebp)   4  [ $t29      <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t3       <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t30      <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t31      <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t32      <int> %ebp-128 ]
    #   -132(%ebp)   4  [ $t33      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-132 ]
    #   -136(%ebp)   4  [ $t34      <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t35      <int> %ebp-140 ]
    #   -144(%ebp)   4  [ $t36      <int> %ebp-144 ]
    #   -148(%ebp)   4  [ $t37      <int> %ebp-148 ]
    #   -152(%ebp)   4  [ $t38      <int> %ebp-152 ]
    #   -156(%ebp)   4  [ $t4       <int> %ebp-156 ]
    #   -160(%ebp)   4  [ $t5       <ptr(4) to <array 30 of <char>>> %ebp-160 ]
    #   -164(%ebp)   4  [ $t6       <int> %ebp-164 ]
    #   -168(%ebp)   4  [ $t7       <ptr(4) to <array 28 of <char>>> %ebp-168 ]
    #   -172(%ebp)   4  [ $t8       <int> %ebp-172 ]
    #   -176(%ebp)   4  [ $t9       <ptr(4) to <array 28 of <char>>> %ebp-176 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $164, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $41, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $0, %eax                #   0:     assign rowcnt <- 0
    movl    %eax, -20(%ebp)        
    movl    $0, %eax                #   1:     assign colcnt <- 0
    movl    %eax, -16(%ebp)        
    movl    $1, %eax                #   2:     param  1 <- 1
    pushl   %eax                   
    movl    8(%ebp), %eax           #   3:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #   4:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -24(%ebp)        
    movl    $1, %eax                #   5:     param  1 <- 1
    pushl   %eax                   
    movl    12(%ebp), %eax          #   6:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #   7:     call   t1 <- DIM
    addl    $8, %esp               
    movl    %eax, -28(%ebp)        
    movl    -24(%ebp), %eax         #   8:     if     t0 # t1 goto 3_if_true
    movl    -28(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jne     l_MatAdd_3_if_true     
    jmp     l_MatAdd_4_if_false     #   9:     goto   4_if_false
l_MatAdd_3_if_true:
    leal    _str_1, %eax            #  11:     &()    t2 <- _str_1
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %eax         #  12:     param  0 <- t2
    pushl   %eax                   
    call    WriteStr                #  13:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  14:     return 0
    jmp     l_MatAdd_exit          
    jmp     l_MatAdd_2              #  15:     goto   2
l_MatAdd_4_if_false:
l_MatAdd_2:
    movl    $2, %eax                #  18:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  19:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  20:     call   t3 <- DIM
    addl    $8, %esp               
    movl    %eax, -116(%ebp)       
    movl    $2, %eax                #  21:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  22:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  23:     call   t4 <- DIM
    addl    $8, %esp               
    movl    %eax, -156(%ebp)       
    movl    -116(%ebp), %eax        #  24:     if     t3 # t4 goto 9_if_true
    movl    -156(%ebp), %ebx       
    cmpl    %ebx, %eax             
    jne     l_MatAdd_9_if_true     
    jmp     l_MatAdd_10_if_false    #  25:     goto   10_if_false
l_MatAdd_9_if_true:
    leal    _str_2, %eax            #  27:     &()    t5 <- _str_2
    movl    %eax, -160(%ebp)       
    movl    -160(%ebp), %eax        #  28:     param  0 <- t5
    pushl   %eax                   
    call    WriteStr                #  29:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  30:     return 0
    jmp     l_MatAdd_exit          
    jmp     l_MatAdd_8              #  31:     goto   8
l_MatAdd_10_if_false:
l_MatAdd_8:
    movl    $0, %eax                #  34:     param  1 <- 0
    pushl   %eax                   
    movl    8(%ebp), %eax           #  35:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  36:     call   t6 <- DIM
    addl    $8, %esp               
    movl    %eax, -164(%ebp)       
    movl    -164(%ebp), %eax        #  37:     if     t6 # 2 goto 15_if_true
    movl    $2, %ebx               
    cmpl    %ebx, %eax             
    jne     l_MatAdd_15_if_true    
    jmp     l_MatAdd_16_if_false    #  38:     goto   16_if_false
l_MatAdd_15_if_true:
    leal    _str_3, %eax            #  40:     &()    t7 <- _str_3
    movl    %eax, -168(%ebp)       
    movl    -168(%ebp), %eax        #  41:     param  0 <- t7
    pushl   %eax                   
    call    WriteStr                #  42:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  43:     return 0
    jmp     l_MatAdd_exit          
    jmp     l_MatAdd_14             #  44:     goto   14
l_MatAdd_16_if_false:
l_MatAdd_14:
    movl    $0, %eax                #  47:     param  1 <- 0
    pushl   %eax                   
    movl    12(%ebp), %eax          #  48:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  49:     call   t8 <- DIM
    addl    $8, %esp               
    movl    %eax, -172(%ebp)       
    movl    -172(%ebp), %eax        #  50:     if     t8 # 2 goto 21_if_true
    movl    $2, %ebx               
    cmpl    %ebx, %eax             
    jne     l_MatAdd_21_if_true    
    jmp     l_MatAdd_22_if_false    #  51:     goto   22_if_false
l_MatAdd_21_if_true:
    leal    _str_4, %eax            #  53:     &()    t9 <- _str_4
    movl    %eax, -176(%ebp)       
    movl    -176(%ebp), %eax        #  54:     param  0 <- t9
    pushl   %eax                   
    call    WriteStr                #  55:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  56:     return 0
    jmp     l_MatAdd_exit          
    jmp     l_MatAdd_20             #  57:     goto   20
l_MatAdd_22_if_false:
l_MatAdd_20:
l_MatAdd_27_while_cond:
    movl    $1, %eax                #  61:     param  1 <- 1
    pushl   %eax                   
    movl    8(%ebp), %eax           #  62:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  63:     call   t10 <- DIM
    addl    $8, %esp               
    movl    %eax, -32(%ebp)        
    movl    -20(%ebp), %eax         #  64:     if     rowcnt < t10 goto 28_while_body
    movl    -32(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_MatAdd_28_while_body 
    jmp     l_MatAdd_26             #  65:     goto   26
l_MatAdd_28_while_body:
l_MatAdd_31_while_cond:
    movl    $2, %eax                #  68:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  69:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  70:     call   t11 <- DIM
    addl    $8, %esp               
    movl    %eax, -36(%ebp)        
    movl    -16(%ebp), %eax         #  71:     if     colcnt < t11 goto 32_while_body
    movl    -36(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_MatAdd_32_while_body 
    jmp     l_MatAdd_30             #  72:     goto   30
l_MatAdd_32_while_body:
    movl    $2, %eax                #  74:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  75:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  76:     call   t12 <- DIM
    addl    $8, %esp               
    movl    %eax, -40(%ebp)        
    movl    -20(%ebp), %eax         #  77:     mul    t13 <- rowcnt, t12
    movl    -40(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #  78:     add    t14 <- t13, colcnt
    movl    -16(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  79:     mul    t15 <- t14, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -52(%ebp)        
    movl    8(%ebp), %eax           #  80:     param  0 <- A
    pushl   %eax                   
    call    DOFS                    #  81:     call   t16 <- DOFS
    addl    $4, %esp               
    movl    %eax, -56(%ebp)        
    movl    -52(%ebp), %eax         #  82:     add    t17 <- t15, t16
    movl    -56(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -60(%ebp)        
    movl    8(%ebp), %eax           #  83:     add    t18 <- A, t17
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    $2, %eax                #  84:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  85:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  86:     call   t19 <- DIM
    addl    $8, %esp               
    movl    %eax, -68(%ebp)        
    movl    -20(%ebp), %eax         #  87:     mul    t20 <- rowcnt, t19
    movl    -68(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -76(%ebp)        
    movl    -76(%ebp), %eax         #  88:     add    t21 <- t20, colcnt
    movl    -16(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -80(%ebp), %eax         #  89:     mul    t22 <- t21, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -84(%ebp)        
    movl    12(%ebp), %eax          #  90:     param  0 <- B
    pushl   %eax                   
    call    DOFS                    #  91:     call   t23 <- DOFS
    addl    $4, %esp               
    movl    %eax, -88(%ebp)        
    movl    -84(%ebp), %eax         #  92:     add    t24 <- t22, t23
    movl    -88(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -92(%ebp)        
    movl    12(%ebp), %eax          #  93:     add    t25 <- B, t24
    movl    -92(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -96(%ebp)        
    movl    -64(%ebp), %edi        
    movl    (%edi), %eax            #  94:     add    t26 <- @t18, @t25
    movl    -96(%ebp), %edi        
    movl    (%edi), %ebx           
    addl    %ebx, %eax             
    movl    %eax, -100(%ebp)       
    leal    MatRes, %eax            #  95:     &()    t27 <- MatRes
    movl    %eax, -104(%ebp)       
    movl    $2, %eax                #  96:     param  1 <- 2
    pushl   %eax                   
    leal    MatRes, %eax            #  97:     &()    t28 <- MatRes
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  98:     param  0 <- t28
    pushl   %eax                   
    call    DIM                     #  99:     call   t29 <- DIM
    addl    $8, %esp               
    movl    %eax, -112(%ebp)       
    movl    -20(%ebp), %eax         # 100:     mul    t30 <- rowcnt, t29
    movl    -112(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %eax        # 101:     add    t31 <- t30, colcnt
    movl    -16(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -124(%ebp)       
    movl    -124(%ebp), %eax        # 102:     mul    t32 <- t31, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -128(%ebp)       
    leal    MatRes, %eax            # 103:     &()    t33 <- MatRes
    movl    %eax, -132(%ebp)       
    movl    -132(%ebp), %eax        # 104:     param  0 <- t33
    pushl   %eax                   
    call    DOFS                    # 105:     call   t34 <- DOFS
    addl    $4, %esp               
    movl    %eax, -136(%ebp)       
    movl    -128(%ebp), %eax        # 106:     add    t35 <- t32, t34
    movl    -136(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -140(%ebp)       
    movl    -104(%ebp), %eax        # 107:     add    t36 <- t27, t35
    movl    -140(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -144(%ebp)       
    movl    -100(%ebp), %eax        # 108:     assign @t36 <- t26
    movl    -144(%ebp), %edi       
    movl    %eax, (%edi)           
    movl    -16(%ebp), %eax         # 109:     add    t37 <- colcnt, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -148(%ebp)       
    movl    -148(%ebp), %eax        # 110:     assign colcnt <- t37
    movl    %eax, -16(%ebp)        
    jmp     l_MatAdd_31_while_cond  # 111:     goto   31_while_cond
l_MatAdd_30:
    movl    -20(%ebp), %eax         # 113:     add    t38 <- rowcnt, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -152(%ebp)       
    movl    -152(%ebp), %eax        # 114:     assign rowcnt <- t38
    movl    %eax, -20(%ebp)        
    jmp     l_MatAdd_27_while_cond  # 115:     goto   27_while_cond
l_MatAdd_26:
    movl    $1, %eax                # 117:     return 1
    jmp     l_MatAdd_exit          

l_MatAdd_exit:
    # epilogue
    addl    $164, %esp              # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope MatSub
MatSub:
    # stack offsets:
    #      8(%ebp)   4  [ %A        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+8 ]
    #     12(%ebp)   4  [ %B        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+12 ]
    #    -16(%ebp)   4  [ $colcnt   <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $rowcnt   <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t0       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t1       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t10      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t11      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t12      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t13      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t14      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t15      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t16      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t17      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t18      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t19      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t2       <ptr(4) to <array 27 of <char>>> %ebp-72 ]
    #    -76(%ebp)   4  [ $t20      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t21      <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t22      <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t23      <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t24      <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t25      <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t26      <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t27      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-104 ]
    #   -108(%ebp)   4  [ $t28      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-108 ]
    #   -112(%ebp)   4  [ $t29      <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t3       <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t30      <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t31      <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t32      <int> %ebp-128 ]
    #   -132(%ebp)   4  [ $t33      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-132 ]
    #   -136(%ebp)   4  [ $t34      <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t35      <int> %ebp-140 ]
    #   -144(%ebp)   4  [ $t36      <int> %ebp-144 ]
    #   -148(%ebp)   4  [ $t37      <int> %ebp-148 ]
    #   -152(%ebp)   4  [ $t38      <int> %ebp-152 ]
    #   -156(%ebp)   4  [ $t4       <int> %ebp-156 ]
    #   -160(%ebp)   4  [ $t5       <ptr(4) to <array 30 of <char>>> %ebp-160 ]
    #   -164(%ebp)   4  [ $t6       <int> %ebp-164 ]
    #   -168(%ebp)   4  [ $t7       <ptr(4) to <array 28 of <char>>> %ebp-168 ]
    #   -172(%ebp)   4  [ $t8       <int> %ebp-172 ]
    #   -176(%ebp)   4  [ $t9       <ptr(4) to <array 28 of <char>>> %ebp-176 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $164, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $41, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $0, %eax                #   0:     assign rowcnt <- 0
    movl    %eax, -20(%ebp)        
    movl    $0, %eax                #   1:     assign colcnt <- 0
    movl    %eax, -16(%ebp)        
    movl    $1, %eax                #   2:     param  1 <- 1
    pushl   %eax                   
    movl    8(%ebp), %eax           #   3:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #   4:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -24(%ebp)        
    movl    $1, %eax                #   5:     param  1 <- 1
    pushl   %eax                   
    movl    12(%ebp), %eax          #   6:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #   7:     call   t1 <- DIM
    addl    $8, %esp               
    movl    %eax, -28(%ebp)        
    movl    -24(%ebp), %eax         #   8:     if     t0 # t1 goto 3_if_true
    movl    -28(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jne     l_MatSub_3_if_true     
    jmp     l_MatSub_4_if_false     #   9:     goto   4_if_false
l_MatSub_3_if_true:
    leal    _str_5, %eax            #  11:     &()    t2 <- _str_5
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %eax         #  12:     param  0 <- t2
    pushl   %eax                   
    call    WriteStr                #  13:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  14:     return 0
    jmp     l_MatSub_exit          
    jmp     l_MatSub_2              #  15:     goto   2
l_MatSub_4_if_false:
l_MatSub_2:
    movl    $2, %eax                #  18:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  19:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  20:     call   t3 <- DIM
    addl    $8, %esp               
    movl    %eax, -116(%ebp)       
    movl    $2, %eax                #  21:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  22:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  23:     call   t4 <- DIM
    addl    $8, %esp               
    movl    %eax, -156(%ebp)       
    movl    -116(%ebp), %eax        #  24:     if     t3 # t4 goto 9_if_true
    movl    -156(%ebp), %ebx       
    cmpl    %ebx, %eax             
    jne     l_MatSub_9_if_true     
    jmp     l_MatSub_10_if_false    #  25:     goto   10_if_false
l_MatSub_9_if_true:
    leal    _str_6, %eax            #  27:     &()    t5 <- _str_6
    movl    %eax, -160(%ebp)       
    movl    -160(%ebp), %eax        #  28:     param  0 <- t5
    pushl   %eax                   
    call    WriteStr                #  29:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  30:     return 0
    jmp     l_MatSub_exit          
    jmp     l_MatSub_8              #  31:     goto   8
l_MatSub_10_if_false:
l_MatSub_8:
    movl    $0, %eax                #  34:     param  1 <- 0
    pushl   %eax                   
    movl    8(%ebp), %eax           #  35:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  36:     call   t6 <- DIM
    addl    $8, %esp               
    movl    %eax, -164(%ebp)       
    movl    -164(%ebp), %eax        #  37:     if     t6 # 2 goto 15_if_true
    movl    $2, %ebx               
    cmpl    %ebx, %eax             
    jne     l_MatSub_15_if_true    
    jmp     l_MatSub_16_if_false    #  38:     goto   16_if_false
l_MatSub_15_if_true:
    leal    _str_7, %eax            #  40:     &()    t7 <- _str_7
    movl    %eax, -168(%ebp)       
    movl    -168(%ebp), %eax        #  41:     param  0 <- t7
    pushl   %eax                   
    call    WriteStr                #  42:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  43:     return 0
    jmp     l_MatSub_exit          
    jmp     l_MatSub_14             #  44:     goto   14
l_MatSub_16_if_false:
l_MatSub_14:
    movl    $0, %eax                #  47:     param  1 <- 0
    pushl   %eax                   
    movl    12(%ebp), %eax          #  48:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  49:     call   t8 <- DIM
    addl    $8, %esp               
    movl    %eax, -172(%ebp)       
    movl    -172(%ebp), %eax        #  50:     if     t8 # 2 goto 21_if_true
    movl    $2, %ebx               
    cmpl    %ebx, %eax             
    jne     l_MatSub_21_if_true    
    jmp     l_MatSub_22_if_false    #  51:     goto   22_if_false
l_MatSub_21_if_true:
    leal    _str_8, %eax            #  53:     &()    t9 <- _str_8
    movl    %eax, -176(%ebp)       
    movl    -176(%ebp), %eax        #  54:     param  0 <- t9
    pushl   %eax                   
    call    WriteStr                #  55:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  56:     return 0
    jmp     l_MatSub_exit          
    jmp     l_MatSub_20             #  57:     goto   20
l_MatSub_22_if_false:
l_MatSub_20:
l_MatSub_27_while_cond:
    movl    $1, %eax                #  61:     param  1 <- 1
    pushl   %eax                   
    movl    8(%ebp), %eax           #  62:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  63:     call   t10 <- DIM
    addl    $8, %esp               
    movl    %eax, -32(%ebp)        
    movl    -20(%ebp), %eax         #  64:     if     rowcnt < t10 goto 28_while_body
    movl    -32(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_MatSub_28_while_body 
    jmp     l_MatSub_26             #  65:     goto   26
l_MatSub_28_while_body:
l_MatSub_31_while_cond:
    movl    $2, %eax                #  68:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  69:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  70:     call   t11 <- DIM
    addl    $8, %esp               
    movl    %eax, -36(%ebp)        
    movl    -16(%ebp), %eax         #  71:     if     colcnt < t11 goto 32_while_body
    movl    -36(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_MatSub_32_while_body 
    jmp     l_MatSub_30             #  72:     goto   30
l_MatSub_32_while_body:
    movl    $2, %eax                #  74:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  75:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  76:     call   t12 <- DIM
    addl    $8, %esp               
    movl    %eax, -40(%ebp)        
    movl    -20(%ebp), %eax         #  77:     mul    t13 <- rowcnt, t12
    movl    -40(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #  78:     add    t14 <- t13, colcnt
    movl    -16(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  79:     mul    t15 <- t14, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -52(%ebp)        
    movl    8(%ebp), %eax           #  80:     param  0 <- A
    pushl   %eax                   
    call    DOFS                    #  81:     call   t16 <- DOFS
    addl    $4, %esp               
    movl    %eax, -56(%ebp)        
    movl    -52(%ebp), %eax         #  82:     add    t17 <- t15, t16
    movl    -56(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -60(%ebp)        
    movl    8(%ebp), %eax           #  83:     add    t18 <- A, t17
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    $2, %eax                #  84:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  85:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  86:     call   t19 <- DIM
    addl    $8, %esp               
    movl    %eax, -68(%ebp)        
    movl    -20(%ebp), %eax         #  87:     mul    t20 <- rowcnt, t19
    movl    -68(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -76(%ebp)        
    movl    -76(%ebp), %eax         #  88:     add    t21 <- t20, colcnt
    movl    -16(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -80(%ebp), %eax         #  89:     mul    t22 <- t21, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -84(%ebp)        
    movl    12(%ebp), %eax          #  90:     param  0 <- B
    pushl   %eax                   
    call    DOFS                    #  91:     call   t23 <- DOFS
    addl    $4, %esp               
    movl    %eax, -88(%ebp)        
    movl    -84(%ebp), %eax         #  92:     add    t24 <- t22, t23
    movl    -88(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -92(%ebp)        
    movl    12(%ebp), %eax          #  93:     add    t25 <- B, t24
    movl    -92(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -96(%ebp)        
    movl    -64(%ebp), %edi        
    movl    (%edi), %eax            #  94:     sub    t26 <- @t18, @t25
    movl    -96(%ebp), %edi        
    movl    (%edi), %ebx           
    subl    %ebx, %eax             
    movl    %eax, -100(%ebp)       
    leal    MatRes, %eax            #  95:     &()    t27 <- MatRes
    movl    %eax, -104(%ebp)       
    movl    $2, %eax                #  96:     param  1 <- 2
    pushl   %eax                   
    leal    MatRes, %eax            #  97:     &()    t28 <- MatRes
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  98:     param  0 <- t28
    pushl   %eax                   
    call    DIM                     #  99:     call   t29 <- DIM
    addl    $8, %esp               
    movl    %eax, -112(%ebp)       
    movl    -20(%ebp), %eax         # 100:     mul    t30 <- rowcnt, t29
    movl    -112(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %eax        # 101:     add    t31 <- t30, colcnt
    movl    -16(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -124(%ebp)       
    movl    -124(%ebp), %eax        # 102:     mul    t32 <- t31, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -128(%ebp)       
    leal    MatRes, %eax            # 103:     &()    t33 <- MatRes
    movl    %eax, -132(%ebp)       
    movl    -132(%ebp), %eax        # 104:     param  0 <- t33
    pushl   %eax                   
    call    DOFS                    # 105:     call   t34 <- DOFS
    addl    $4, %esp               
    movl    %eax, -136(%ebp)       
    movl    -128(%ebp), %eax        # 106:     add    t35 <- t32, t34
    movl    -136(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -140(%ebp)       
    movl    -104(%ebp), %eax        # 107:     add    t36 <- t27, t35
    movl    -140(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -144(%ebp)       
    movl    -100(%ebp), %eax        # 108:     assign @t36 <- t26
    movl    -144(%ebp), %edi       
    movl    %eax, (%edi)           
    movl    -16(%ebp), %eax         # 109:     add    t37 <- colcnt, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -148(%ebp)       
    movl    -148(%ebp), %eax        # 110:     assign colcnt <- t37
    movl    %eax, -16(%ebp)        
    jmp     l_MatSub_31_while_cond  # 111:     goto   31_while_cond
l_MatSub_30:
    movl    -20(%ebp), %eax         # 113:     add    t38 <- rowcnt, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -152(%ebp)       
    movl    -152(%ebp), %eax        # 114:     assign rowcnt <- t38
    movl    %eax, -20(%ebp)        
    jmp     l_MatSub_27_while_cond  # 115:     goto   27_while_cond
l_MatSub_26:
    movl    $1, %eax                # 117:     return 1
    jmp     l_MatSub_exit          

l_MatSub_exit:
    # epilogue
    addl    $164, %esp              # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope MatMult
MatMult:
    # stack offsets:
    #      8(%ebp)   4  [ %A        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+8 ]
    #     12(%ebp)   4  [ %B        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+12 ]
    #    -16(%ebp)   4  [ $colcnt   <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $rowcnt   <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t0       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t1       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t10      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t11      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t12      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t13      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t14      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t15      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t16      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t17      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t18      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t19      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t2       <ptr(4) to <array 69 of <char>>> %ebp-72 ]
    #    -76(%ebp)   4  [ $t20      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t21      <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t22      <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t23      <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t24      <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t25      <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t26      <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t27      <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t28      <int> %ebp-108 ]
    #   -112(%ebp)   4  [ $t3       <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t4       <ptr(4) to <array 28 of <char>>> %ebp-116 ]
    #   -120(%ebp)   4  [ $t5       <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t6       <ptr(4) to <array 28 of <char>>> %ebp-124 ]
    #   -128(%ebp)   4  [ $t7       <int> %ebp-128 ]
    #   -132(%ebp)   4  [ $t8       <int> %ebp-132 ]
    #   -136(%ebp)   4  [ $t9       <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $tempcnt  <int> %ebp-140 ]
    #   -144(%ebp)   4  [ $tempval  <int> %ebp-144 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $132, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $33, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $0, %eax                #   0:     assign rowcnt <- 0
    movl    %eax, -20(%ebp)        
    movl    $0, %eax                #   1:     assign colcnt <- 0
    movl    %eax, -16(%ebp)        
    movl    $0, %eax                #   2:     assign tempcnt <- 0
    movl    %eax, -140(%ebp)       
    movl    $0, %eax                #   3:     assign tempval <- 0
    movl    %eax, -144(%ebp)       
    movl    $2, %eax                #   4:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #   5:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #   6:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -24(%ebp)        
    movl    $1, %eax                #   7:     param  1 <- 1
    pushl   %eax                   
    movl    12(%ebp), %eax          #   8:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #   9:     call   t1 <- DIM
    addl    $8, %esp               
    movl    %eax, -28(%ebp)        
    movl    -24(%ebp), %eax         #  10:     if     t0 # t1 goto 5_if_true
    movl    -28(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jne     l_MatMult_5_if_true    
    jmp     l_MatMult_6_if_false    #  11:     goto   6_if_false
l_MatMult_5_if_true:
    leal    _str_9, %eax            #  13:     &()    t2 <- _str_9
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %eax         #  14:     param  0 <- t2
    pushl   %eax                   
    call    WriteStr                #  15:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  16:     return 0
    jmp     l_MatMult_exit         
    jmp     l_MatMult_4             #  17:     goto   4
l_MatMult_6_if_false:
l_MatMult_4:
    movl    $0, %eax                #  20:     param  1 <- 0
    pushl   %eax                   
    movl    8(%ebp), %eax           #  21:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  22:     call   t3 <- DIM
    addl    $8, %esp               
    movl    %eax, -112(%ebp)       
    movl    -112(%ebp), %eax        #  23:     if     t3 # 2 goto 11_if_true
    movl    $2, %ebx               
    cmpl    %ebx, %eax             
    jne     l_MatMult_11_if_true   
    jmp     l_MatMult_12_if_false   #  24:     goto   12_if_false
l_MatMult_11_if_true:
    leal    _str_10, %eax           #  26:     &()    t4 <- _str_10
    movl    %eax, -116(%ebp)       
    movl    -116(%ebp), %eax        #  27:     param  0 <- t4
    pushl   %eax                   
    call    WriteStr                #  28:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  29:     return 0
    jmp     l_MatMult_exit         
    jmp     l_MatMult_10            #  30:     goto   10
l_MatMult_12_if_false:
l_MatMult_10:
    movl    $0, %eax                #  33:     param  1 <- 0
    pushl   %eax                   
    movl    12(%ebp), %eax          #  34:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  35:     call   t5 <- DIM
    addl    $8, %esp               
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %eax        #  36:     if     t5 # 2 goto 17_if_true
    movl    $2, %ebx               
    cmpl    %ebx, %eax             
    jne     l_MatMult_17_if_true   
    jmp     l_MatMult_18_if_false   #  37:     goto   18_if_false
l_MatMult_17_if_true:
    leal    _str_11, %eax           #  39:     &()    t6 <- _str_11
    movl    %eax, -124(%ebp)       
    movl    -124(%ebp), %eax        #  40:     param  0 <- t6
    pushl   %eax                   
    call    WriteStr                #  41:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  42:     return 0
    jmp     l_MatMult_exit         
    jmp     l_MatMult_16            #  43:     goto   16
l_MatMult_18_if_false:
l_MatMult_16:
l_MatMult_23_while_cond:
    movl    $1, %eax                #  47:     param  1 <- 1
    pushl   %eax                   
    movl    8(%ebp), %eax           #  48:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  49:     call   t7 <- DIM
    addl    $8, %esp               
    movl    %eax, -128(%ebp)       
    movl    -20(%ebp), %eax         #  50:     if     rowcnt < t7 goto 24_while_body
    movl    -128(%ebp), %ebx       
    cmpl    %ebx, %eax             
    jl      l_MatMult_24_while_body
    jmp     l_MatMult_22            #  51:     goto   22
l_MatMult_24_while_body:
l_MatMult_27_while_cond:
    movl    $2, %eax                #  54:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  55:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  56:     call   t8 <- DIM
    addl    $8, %esp               
    movl    %eax, -132(%ebp)       
    movl    -16(%ebp), %eax         #  57:     if     colcnt < t8 goto 28_while_body
    movl    -132(%ebp), %ebx       
    cmpl    %ebx, %eax             
    jl      l_MatMult_28_while_body
    jmp     l_MatMult_26            #  58:     goto   26
l_MatMult_28_while_body:
l_MatMult_31_while_cond:
    movl    $2, %eax                #  61:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  62:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  63:     call   t9 <- DIM
    addl    $8, %esp               
    movl    %eax, -136(%ebp)       
    movl    -140(%ebp), %eax        #  64:     if     tempcnt < t9 goto 32_while_body
    movl    -136(%ebp), %ebx       
    cmpl    %ebx, %eax             
    jl      l_MatMult_32_while_body
    jmp     l_MatMult_30            #  65:     goto   30
l_MatMult_32_while_body:
    movl    $2, %eax                #  67:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  68:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  69:     call   t10 <- DIM
    addl    $8, %esp               
    movl    %eax, -32(%ebp)        
    movl    -20(%ebp), %eax         #  70:     mul    t11 <- rowcnt, t10
    movl    -32(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #  71:     add    t12 <- t11, tempcnt
    movl    -140(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #  72:     mul    t13 <- t12, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    8(%ebp), %eax           #  73:     param  0 <- A
    pushl   %eax                   
    call    DOFS                    #  74:     call   t14 <- DOFS
    addl    $4, %esp               
    movl    %eax, -48(%ebp)        
    movl    -44(%ebp), %eax         #  75:     add    t15 <- t13, t14
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    8(%ebp), %eax           #  76:     add    t16 <- A, t15
    movl    -52(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -56(%ebp)        
    movl    $2, %eax                #  77:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  78:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  79:     call   t17 <- DIM
    addl    $8, %esp               
    movl    %eax, -60(%ebp)        
    movl    -140(%ebp), %eax        #  80:     mul    t18 <- tempcnt, t17
    movl    -60(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -64(%ebp)        
    movl    -64(%ebp), %eax         #  81:     add    t19 <- t18, colcnt
    movl    -16(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         #  82:     mul    t20 <- t19, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -76(%ebp)        
    movl    12(%ebp), %eax          #  83:     param  0 <- B
    pushl   %eax                   
    call    DOFS                    #  84:     call   t21 <- DOFS
    addl    $4, %esp               
    movl    %eax, -80(%ebp)        
    movl    -76(%ebp), %eax         #  85:     add    t22 <- t20, t21
    movl    -80(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -84(%ebp)        
    movl    12(%ebp), %eax          #  86:     add    t23 <- B, t22
    movl    -84(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -88(%ebp)        
    movl    -56(%ebp), %edi        
    movl    (%edi), %eax            #  87:     mul    t24 <- @t16, @t23
    movl    -88(%ebp), %edi        
    movl    (%edi), %ebx           
    imull   %ebx                   
    movl    %eax, -92(%ebp)        
    movl    -144(%ebp), %eax        #  88:     add    t25 <- tempval, t24
    movl    -92(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -96(%ebp)        
    movl    -96(%ebp), %eax         #  89:     assign tempval <- t25
    movl    %eax, -144(%ebp)       
    movl    -140(%ebp), %eax        #  90:     add    t26 <- tempcnt, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -100(%ebp)       
    movl    -100(%ebp), %eax        #  91:     assign tempcnt <- t26
    movl    %eax, -140(%ebp)       
    jmp     l_MatMult_31_while_cond #  92:     goto   31_while_cond
l_MatMult_30:
    movl    -16(%ebp), %eax         #  94:     add    t27 <- colcnt, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -104(%ebp)       
    movl    -104(%ebp), %eax        #  95:     assign colcnt <- t27
    movl    %eax, -16(%ebp)        
    jmp     l_MatMult_27_while_cond #  96:     goto   27_while_cond
l_MatMult_26:
    movl    -20(%ebp), %eax         #  98:     add    t28 <- rowcnt, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  99:     assign rowcnt <- t28
    movl    %eax, -20(%ebp)        
    jmp     l_MatMult_23_while_cond # 100:     goto   23_while_cond
l_MatMult_22:
    movl    $1, %eax                # 102:     return 1
    jmp     l_MatMult_exit         

l_MatMult_exit:
    # epilogue
    addl    $132, %esp              # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test07
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t11      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t12      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-32 ]
    #    -36(%ebp)   4  [ $t13      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-36 ]
    #    -40(%ebp)   4  [ $t14      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t15      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t16      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t17      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t18      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-56 ]
    #    -60(%ebp)   4  [ $t19      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t2       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-64 ]
    #    -68(%ebp)   4  [ $t20      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t21      <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t22      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t23      <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t24      <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t25      <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t26      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-92 ]
    #    -96(%ebp)   4  [ $t27      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-96 ]
    #   -100(%ebp)   4  [ $t28      <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t29      <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t3       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-108 ]
    #   -112(%ebp)   4  [ $t30      <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t31      <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t32      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-120 ]
    #   -124(%ebp)   4  [ $t33      <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t34      <int> %ebp-128 ]
    #   -132(%ebp)   4  [ $t35      <int> %ebp-132 ]
    #   -136(%ebp)   4  [ $t36      <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t37      <int> %ebp-140 ]
    #   -144(%ebp)   4  [ $t38      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-144 ]
    #   -148(%ebp)   4  [ $t39      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-148 ]
    #   -152(%ebp)   4  [ $t4       <int> %ebp-152 ]
    #   -153(%ebp)   1  [ $t40      <bool> %ebp-153 ]
    #   -160(%ebp)   4  [ $t41      <ptr(4) to <array 29 of <char>>> %ebp-160 ]
    #   -164(%ebp)   4  [ $t42      <ptr(4) to <array 25 of <char>>> %ebp-164 ]
    #   -168(%ebp)   4  [ $t43      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-168 ]
    #   -172(%ebp)   4  [ $t44      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-172 ]
    #   -173(%ebp)   1  [ $t45      <bool> %ebp-173 ]
    #   -180(%ebp)   4  [ $t46      <ptr(4) to <array 32 of <char>>> %ebp-180 ]
    #   -184(%ebp)   4  [ $t47      <ptr(4) to <array 28 of <char>>> %ebp-184 ]
    #   -188(%ebp)   4  [ $t48      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-188 ]
    #   -192(%ebp)   4  [ $t49      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-192 ]
    #   -196(%ebp)   4  [ $t5       <int> %ebp-196 ]
    #   -197(%ebp)   1  [ $t50      <bool> %ebp-197 ]
    #   -204(%ebp)   4  [ $t51      <ptr(4) to <array 35 of <char>>> %ebp-204 ]
    #   -208(%ebp)   4  [ $t52      <ptr(4) to <array 31 of <char>>> %ebp-208 ]
    #   -212(%ebp)   4  [ $t53      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-212 ]
    #   -216(%ebp)   4  [ $t54      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-216 ]
    #   -217(%ebp)   1  [ $t55      <bool> %ebp-217 ]
    #   -224(%ebp)   4  [ $t56      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-224 ]
    #   -228(%ebp)   4  [ $t57      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-228 ]
    #   -229(%ebp)   1  [ $t58      <bool> %ebp-229 ]
    #   -236(%ebp)   4  [ $t59      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-236 ]
    #   -240(%ebp)   4  [ $t6       <int> %ebp-240 ]
    #   -244(%ebp)   4  [ $t60      <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-244 ]
    #   -245(%ebp)   1  [ $t61      <bool> %ebp-245 ]
    #   -252(%ebp)   4  [ $t62      <ptr(4) to <array 25 of <char>>> %ebp-252 ]
    #   -256(%ebp)   4  [ $t63      <ptr(4) to <array 21 of <char>>> %ebp-256 ]
    #   -260(%ebp)   4  [ $t64      <ptr(4) to <array 21 of <char>>> %ebp-260 ]
    #   -264(%ebp)   4  [ $t7       <int> %ebp-264 ]
    #   -268(%ebp)   4  [ $t8       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-268 ]
    #   -272(%ebp)   4  [ $t9       <int> %ebp-272 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $260, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $65, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $0, %eax                #   0:     assign i0 <- 0
    movl    %eax, i0               
    movl    $0, %eax                #   1:     assign i1 <- 0
    movl    %eax, i1               
l_test07_3_while_cond:
    movl    i0, %eax                #   3:     if     i0 < 5 goto 4_while_body
    movl    $5, %ebx               
    cmpl    %ebx, %eax             
    jl      l_test07_4_while_body  
    jmp     l_test07_2              #   4:     goto   2
l_test07_4_while_body:
l_test07_7_while_cond:
    movl    i1, %eax                #   7:     if     i1 < 5 goto 8_while_body
    movl    $5, %ebx               
    cmpl    %ebx, %eax             
    jl      l_test07_8_while_body  
    jmp     l_test07_6              #   8:     goto   6
l_test07_8_while_body:
    movl    i0, %eax                #  10:     mul    t0 <- i0, 2
    movl    $2, %ebx               
    imull   %ebx                   
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #  11:     add    t1 <- t0, i1
    movl    i1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -20(%ebp)        
    leal    MatA, %eax              #  12:     &()    t2 <- MatA
    movl    %eax, -64(%ebp)        
    movl    $2, %eax                #  13:     param  1 <- 2
    pushl   %eax                   
    leal    MatA, %eax              #  14:     &()    t3 <- MatA
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  15:     param  0 <- t3
    pushl   %eax                   
    call    DIM                     #  16:     call   t4 <- DIM
    addl    $8, %esp               
    movl    %eax, -152(%ebp)       
    movl    i0, %eax                #  17:     mul    t5 <- i0, t4
    movl    -152(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -196(%ebp)       
    movl    -196(%ebp), %eax        #  18:     add    t6 <- t5, i1
    movl    i1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -240(%ebp)       
    movl    -240(%ebp), %eax        #  19:     mul    t7 <- t6, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -264(%ebp)       
    leal    MatA, %eax              #  20:     &()    t8 <- MatA
    movl    %eax, -268(%ebp)       
    movl    -268(%ebp), %eax        #  21:     param  0 <- t8
    pushl   %eax                   
    call    DOFS                    #  22:     call   t9 <- DOFS
    addl    $4, %esp               
    movl    %eax, -272(%ebp)       
    movl    -264(%ebp), %eax        #  23:     add    t10 <- t7, t9
    movl    -272(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -64(%ebp), %eax         #  24:     add    t11 <- t2, t10
    movl    -24(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    -20(%ebp), %eax         #  25:     assign @t11 <- t1
    movl    -28(%ebp), %edi        
    movl    %eax, (%edi)           
    leal    MatA, %eax              #  26:     &()    t12 <- MatA
    movl    %eax, -32(%ebp)        
    movl    $2, %eax                #  27:     param  1 <- 2
    pushl   %eax                   
    leal    MatA, %eax              #  28:     &()    t13 <- MatA
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #  29:     param  0 <- t13
    pushl   %eax                   
    call    DIM                     #  30:     call   t14 <- DIM
    addl    $8, %esp               
    movl    %eax, -40(%ebp)        
    movl    i0, %eax                #  31:     mul    t15 <- i0, t14
    movl    -40(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #  32:     add    t16 <- t15, i1
    movl    i1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  33:     mul    t17 <- t16, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -52(%ebp)        
    leal    MatA, %eax              #  34:     &()    t18 <- MatA
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         #  35:     param  0 <- t18
    pushl   %eax                   
    call    DOFS                    #  36:     call   t19 <- DOFS
    addl    $4, %esp               
    movl    %eax, -60(%ebp)        
    movl    -52(%ebp), %eax         #  37:     add    t20 <- t17, t19
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -32(%ebp), %eax         #  38:     add    t21 <- t12, t20
    movl    -68(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %edi        
    movl    (%edi), %eax            #  39:     mul    t22 <- @t21, 2
    movl    $2, %ebx               
    imull   %ebx                   
    movl    %eax, -76(%ebp)        
    movl    i0, %eax                #  40:     mul    t23 <- i0, 3
    movl    $3, %ebx               
    imull   %ebx                   
    movl    %eax, -80(%ebp)        
    movl    -76(%ebp), %eax         #  41:     add    t24 <- t22, t23
    movl    -80(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -84(%ebp)        
    movl    -84(%ebp), %eax         #  42:     add    t25 <- t24, i1
    movl    i1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -88(%ebp)        
    leal    MatB, %eax              #  43:     &()    t26 <- MatB
    movl    %eax, -92(%ebp)        
    movl    $2, %eax                #  44:     param  1 <- 2
    pushl   %eax                   
    leal    MatB, %eax              #  45:     &()    t27 <- MatB
    movl    %eax, -96(%ebp)        
    movl    -96(%ebp), %eax         #  46:     param  0 <- t27
    pushl   %eax                   
    call    DIM                     #  47:     call   t28 <- DIM
    addl    $8, %esp               
    movl    %eax, -100(%ebp)       
    movl    i0, %eax                #  48:     mul    t29 <- i0, t28
    movl    -100(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -104(%ebp)       
    movl    -104(%ebp), %eax        #  49:     add    t30 <- t29, i1
    movl    i1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -112(%ebp)       
    movl    -112(%ebp), %eax        #  50:     mul    t31 <- t30, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -116(%ebp)       
    leal    MatB, %eax              #  51:     &()    t32 <- MatB
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %eax        #  52:     param  0 <- t32
    pushl   %eax                   
    call    DOFS                    #  53:     call   t33 <- DOFS
    addl    $4, %esp               
    movl    %eax, -124(%ebp)       
    movl    -116(%ebp), %eax        #  54:     add    t34 <- t31, t33
    movl    -124(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -128(%ebp)       
    movl    -92(%ebp), %eax         #  55:     add    t35 <- t26, t34
    movl    -128(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -132(%ebp)       
    movl    -88(%ebp), %eax         #  56:     assign @t35 <- t25
    movl    -132(%ebp), %edi       
    movl    %eax, (%edi)           
    movl    i1, %eax                #  57:     add    t36 <- i1, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -136(%ebp)       
    movl    -136(%ebp), %eax        #  58:     assign i1 <- t36
    movl    %eax, i1               
    jmp     l_test07_7_while_cond   #  59:     goto   7_while_cond
l_test07_6:
    movl    i0, %eax                #  61:     add    t37 <- i0, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -140(%ebp)       
    movl    -140(%ebp), %eax        #  62:     assign i0 <- t37
    movl    %eax, i0               
    jmp     l_test07_3_while_cond   #  63:     goto   3_while_cond
l_test07_2:
    leal    MatB, %eax              #  65:     &()    t38 <- MatB
    movl    %eax, -144(%ebp)       
    movl    -144(%ebp), %eax        #  66:     param  1 <- t38
    pushl   %eax                   
    leal    MatA, %eax              #  67:     &()    t39 <- MatA
    movl    %eax, -148(%ebp)       
    movl    -148(%ebp), %eax        #  68:     param  0 <- t39
    pushl   %eax                   
    call    MatAdd                  #  69:     call   t40 <- MatAdd
    addl    $8, %esp               
    movb    %al, -153(%ebp)        
    movzbl  -153(%ebp), %eax        #  70:     assign b0 <- t40
    movb    %al, b0                
    movzbl  b0, %eax                #  71:     if     b0 = 1 goto 16_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_16_if_true    
    jmp     l_test07_17_if_false    #  72:     goto   17_if_false
l_test07_16_if_true:
    leal    _str_12, %eax           #  74:     &()    t41 <- _str_12
    movl    %eax, -160(%ebp)       
    movl    -160(%ebp), %eax        #  75:     param  0 <- t41
    pushl   %eax                   
    call    WriteStr                #  76:     call   WriteStr
    addl    $4, %esp               
    jmp     l_test07_15             #  77:     goto   15
l_test07_17_if_false:
    leal    _str_13, %eax           #  79:     &()    t42 <- _str_13
    movl    %eax, -164(%ebp)       
    movl    -164(%ebp), %eax        #  80:     param  0 <- t42
    pushl   %eax                   
    call    WriteStr                #  81:     call   WriteStr
    addl    $4, %esp               
l_test07_15:
    leal    MatB, %eax              #  83:     &()    t43 <- MatB
    movl    %eax, -168(%ebp)       
    movl    -168(%ebp), %eax        #  84:     param  1 <- t43
    pushl   %eax                   
    leal    MatA, %eax              #  85:     &()    t44 <- MatA
    movl    %eax, -172(%ebp)       
    movl    -172(%ebp), %eax        #  86:     param  0 <- t44
    pushl   %eax                   
    call    MatSub                  #  87:     call   t45 <- MatSub
    addl    $8, %esp               
    movb    %al, -173(%ebp)        
    movzbl  -173(%ebp), %eax        #  88:     assign b1 <- t45
    movb    %al, b1                
    movzbl  b1, %eax                #  89:     if     b1 = 1 goto 22_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_22_if_true    
    jmp     l_test07_23_if_false    #  90:     goto   23_if_false
l_test07_22_if_true:
    leal    _str_14, %eax           #  92:     &()    t46 <- _str_14
    movl    %eax, -180(%ebp)       
    movl    -180(%ebp), %eax        #  93:     param  0 <- t46
    pushl   %eax                   
    call    WriteStr                #  94:     call   WriteStr
    addl    $4, %esp               
    jmp     l_test07_21             #  95:     goto   21
l_test07_23_if_false:
    leal    _str_15, %eax           #  97:     &()    t47 <- _str_15
    movl    %eax, -184(%ebp)       
    movl    -184(%ebp), %eax        #  98:     param  0 <- t47
    pushl   %eax                   
    call    WriteStr                #  99:     call   WriteStr
    addl    $4, %esp               
l_test07_21:
    leal    MatB, %eax              # 101:     &()    t48 <- MatB
    movl    %eax, -188(%ebp)       
    movl    -188(%ebp), %eax        # 102:     param  1 <- t48
    pushl   %eax                   
    leal    MatA, %eax              # 103:     &()    t49 <- MatA
    movl    %eax, -192(%ebp)       
    movl    -192(%ebp), %eax        # 104:     param  0 <- t49
    pushl   %eax                   
    call    MatMult                 # 105:     call   t50 <- MatMult
    addl    $8, %esp               
    movb    %al, -197(%ebp)        
    movzbl  -197(%ebp), %eax        # 106:     assign b2 <- t50
    movb    %al, b2                
    movzbl  b2, %eax                # 107:     if     b2 = 1 goto 28_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_28_if_true    
    jmp     l_test07_29_if_false    # 108:     goto   29_if_false
l_test07_28_if_true:
    leal    _str_16, %eax           # 110:     &()    t51 <- _str_16
    movl    %eax, -204(%ebp)       
    movl    -204(%ebp), %eax        # 111:     param  0 <- t51
    pushl   %eax                   
    call    WriteStr                # 112:     call   WriteStr
    addl    $4, %esp               
    jmp     l_test07_27             # 113:     goto   27
l_test07_29_if_false:
    leal    _str_17, %eax           # 115:     &()    t52 <- _str_17
    movl    %eax, -208(%ebp)       
    movl    -208(%ebp), %eax        # 116:     param  0 <- t52
    pushl   %eax                   
    call    WriteStr                # 117:     call   WriteStr
    addl    $4, %esp               
l_test07_27:
    movzbl  b0, %eax                # 119:     if     b0 = 1 goto 37
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_37            
    jmp     l_test07_35             # 120:     goto   35
l_test07_37:
    movzbl  b1, %eax                # 122:     if     b1 = 1 goto 36
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_36            
    jmp     l_test07_35             # 123:     goto   35
l_test07_36:
    movzbl  b2, %eax                # 125:     if     b2 = 1 goto 33_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_33_if_true    
l_test07_35:
    leal    MatB, %eax              # 127:     &()    t53 <- MatB
    movl    %eax, -212(%ebp)       
    movl    -212(%ebp), %eax        # 128:     param  1 <- t53
    pushl   %eax                   
    leal    MatA, %eax              # 129:     &()    t54 <- MatA
    movl    %eax, -216(%ebp)       
    movl    -216(%ebp), %eax        # 130:     param  0 <- t54
    pushl   %eax                   
    call    MatAdd                  # 131:     call   t55 <- MatAdd
    addl    $8, %esp               
    movb    %al, -217(%ebp)        
    movzbl  -217(%ebp), %eax        # 132:     if     t55 = 1 goto 39
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_39            
    jmp     l_test07_34_if_false    # 133:     goto   34_if_false
l_test07_39:
    leal    MatB, %eax              # 135:     &()    t56 <- MatB
    movl    %eax, -224(%ebp)       
    movl    -224(%ebp), %eax        # 136:     param  1 <- t56
    pushl   %eax                   
    leal    MatA, %eax              # 137:     &()    t57 <- MatA
    movl    %eax, -228(%ebp)       
    movl    -228(%ebp), %eax        # 138:     param  0 <- t57
    pushl   %eax                   
    call    MatSub                  # 139:     call   t58 <- MatSub
    addl    $8, %esp               
    movb    %al, -229(%ebp)        
    movzbl  -229(%ebp), %eax        # 140:     if     t58 = 1 goto 38
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_38            
    jmp     l_test07_34_if_false    # 141:     goto   34_if_false
l_test07_38:
    leal    MatB, %eax              # 143:     &()    t59 <- MatB
    movl    %eax, -236(%ebp)       
    movl    -236(%ebp), %eax        # 144:     param  1 <- t59
    pushl   %eax                   
    leal    MatA, %eax              # 145:     &()    t60 <- MatA
    movl    %eax, -244(%ebp)       
    movl    -244(%ebp), %eax        # 146:     param  0 <- t60
    pushl   %eax                   
    call    MatMult                 # 147:     call   t61 <- MatMult
    addl    $8, %esp               
    movb    %al, -245(%ebp)        
    movzbl  -245(%ebp), %eax        # 148:     if     t61 = 1 goto 33_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test07_33_if_true    
    jmp     l_test07_34_if_false    # 149:     goto   34_if_false
l_test07_33_if_true:
    leal    _str_18, %eax           # 151:     &()    t62 <- _str_18
    movl    %eax, -252(%ebp)       
    movl    -252(%ebp), %eax        # 152:     param  0 <- t62
    pushl   %eax                   
    call    WriteStr                # 153:     call   WriteStr
    addl    $4, %esp               
    jmp     l_test07_32             # 154:     goto   32
l_test07_34_if_false:
    leal    _str_19, %eax           # 156:     &()    t63 <- _str_19
    movl    %eax, -256(%ebp)       
    movl    -256(%ebp), %eax        # 157:     param  0 <- t63
    pushl   %eax                   
    call    WriteStr                # 158:     call   WriteStr
    addl    $4, %esp               
l_test07_32:
    leal    _str_20, %eax           # 160:     &()    t64 <- _str_20
    movl    %eax, -260(%ebp)       
    movl    -260(%ebp), %eax        # 161:     param  0 <- t64
    pushl   %eax                   
    call    WriteStr                # 162:     call   WriteStr
    addl    $4, %esp               

l_test07_exit:
    # epilogue
    addl    $260, %esp              # remove locals
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

    # scope: test07
IntArr0:                            # <array 5 of <int>>
    .long    1
    .long    5
    .skip   20
IntArr1:                            # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100
IntArr2:                            # <array 5 of <array 5 of <array 5 of <int>>>>
    .long    3
    .long    5
    .long    5
    .long    5
    .skip  500
IntArr3:                            # <array 5 of <array 5 of <array 5 of <int>>>>
    .long    3
    .long    5
    .long    5
    .long    5
    .skip  500
MatA:                               # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100
MatB:                               # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100
MatRes:                             # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100
_str_1:                             # <array 27 of <char>>
    .long    1
    .long   27
    .asciz "Row count does not match!\n"
    .align   4
_str_10:                            # <array 28 of <char>>
    .long    1
    .long   28
    .asciz "Parameter A is not matrix!\n"
_str_11:                            # <array 28 of <char>>
    .long    1
    .long   28
    .asciz "Parameter B is not matrix!\n"
_str_12:                            # <array 29 of <char>>
    .long    1
    .long   29
    .asciz "Matrix addition successful!\n"
    .align   4
_str_13:                            # <array 25 of <char>>
    .long    1
    .long   25
    .asciz "Matrix addition failed!\n"
    .align   4
_str_14:                            # <array 32 of <char>>
    .long    1
    .long   32
    .asciz "Matrix subtraction successful!\n"
_str_15:                            # <array 28 of <char>>
    .long    1
    .long   28
    .asciz "Matrix subtraction failed!\n"
_str_16:                            # <array 35 of <char>>
    .long    1
    .long   35
    .asciz "Matrix multiplication successful!\n"
    .align   4
_str_17:                            # <array 31 of <char>>
    .long    1
    .long   31
    .asciz "Matrix multiplication failed!\n"
    .align   4
_str_18:                            # <array 25 of <char>>
    .long    1
    .long   25
    .asciz "Matrix test successful!\n"
    .align   4
_str_19:                            # <array 21 of <char>>
    .long    1
    .long   21
    .asciz "Matrix test failed!\n"
    .align   4
_str_2:                             # <array 30 of <char>>
    .long    1
    .long   30
    .asciz "Column count does not match!\n"
    .align   4
_str_20:                            # <array 21 of <char>>
    .long    1
    .long   21
    .asciz "End of matrix test.\n"
    .align   4
_str_3:                             # <array 28 of <char>>
    .long    1
    .long   28
    .asciz "Parameter A is not matrix!\n"
_str_4:                             # <array 28 of <char>>
    .long    1
    .long   28
    .asciz "Parameter B is not matrix!\n"
_str_5:                             # <array 27 of <char>>
    .long    1
    .long   27
    .asciz "Row count does not match!\n"
    .align   4
_str_6:                             # <array 30 of <char>>
    .long    1
    .long   30
    .asciz "Column count does not match!\n"
    .align   4
_str_7:                             # <array 28 of <char>>
    .long    1
    .long   28
    .asciz "Parameter A is not matrix!\n"
_str_8:                             # <array 28 of <char>>
    .long    1
    .long   28
    .asciz "Parameter B is not matrix!\n"
_str_9:                             # <array 69 of <char>>
    .long    1
    .long   69
    .asciz "Column count of Matrix A does not match with Row count of Matrix B!\n"
b0:                                 # <bool>
    .skip    1
b1:                                 # <bool>
    .skip    1
b2:                                 # <bool>
    .skip    1
c0:                                 # <char>
    .skip    1
c1:                                 # <char>
    .skip    1
c2:                                 # <char>
    .skip    1
    .align   4
i0:                                 # <int>
    .skip    4
i1:                                 # <int>
    .skip    4
i2:                                 # <int>
    .skip    4




    # end of global data section
    #-----------------------------------------

    .end
##################################################
