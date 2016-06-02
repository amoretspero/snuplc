##################################################
# test08
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

    # scope booltest1
booltest1:
    # stack offsets:
    #      8(%ebp)   1  [ %p1       <bool> %ebp+8 ]
    #     12(%ebp)   1  [ %p2       <bool> %ebp+12 ]
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t100     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-28 ]
    #    -32(%ebp)   4  [ $t101     <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t102     <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t103     <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t104     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-44 ]
    #    -48(%ebp)   4  [ $t105     <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t106     <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t107     <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t108     <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t109     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-64 ]
    #    -68(%ebp)   4  [ $t11      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-68 ]
    #    -72(%ebp)   4  [ $t110     <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t111     <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t112     <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t113     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-84 ]
    #    -88(%ebp)   4  [ $t114     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-88 ]
    #    -92(%ebp)   4  [ $t115     <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t116     <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t117     <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t118     <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t119     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-108 ]
    #   -112(%ebp)   4  [ $t12      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-112 ]
    #   -116(%ebp)   4  [ $t120     <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t121     <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t122     <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t123     <ptr(4) to <array 5 of <bool>>> %ebp-128 ]
    #   -132(%ebp)   4  [ $t124     <int> %ebp-132 ]
    #   -136(%ebp)   4  [ $t125     <ptr(4) to <array 5 of <bool>>> %ebp-136 ]
    #   -140(%ebp)   4  [ $t126     <int> %ebp-140 ]
    #   -144(%ebp)   4  [ $t127     <int> %ebp-144 ]
    #   -148(%ebp)   4  [ $t128     <int> %ebp-148 ]
    #   -152(%ebp)   4  [ $t129     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-152 ]
    #   -156(%ebp)   4  [ $t13      <int> %ebp-156 ]
    #   -160(%ebp)   4  [ $t130     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-160 ]
    #   -164(%ebp)   4  [ $t131     <int> %ebp-164 ]
    #   -168(%ebp)   4  [ $t132     <int> %ebp-168 ]
    #   -172(%ebp)   4  [ $t133     <int> %ebp-172 ]
    #   -176(%ebp)   4  [ $t134     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-176 ]
    #   -180(%ebp)   4  [ $t135     <int> %ebp-180 ]
    #   -184(%ebp)   4  [ $t136     <int> %ebp-184 ]
    #   -188(%ebp)   4  [ $t137     <int> %ebp-188 ]
    #   -192(%ebp)   4  [ $t138     <int> %ebp-192 ]
    #   -196(%ebp)   4  [ $t139     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-196 ]
    #   -200(%ebp)   4  [ $t14      <int> %ebp-200 ]
    #   -204(%ebp)   4  [ $t140     <int> %ebp-204 ]
    #   -208(%ebp)   4  [ $t141     <int> %ebp-208 ]
    #   -212(%ebp)   4  [ $t142     <int> %ebp-212 ]
    #   -216(%ebp)   4  [ $t143     <ptr(4) to <array 15 of <char>>> %ebp-216 ]
    #   -220(%ebp)   4  [ $t144     <int> %ebp-220 ]
    #   -224(%ebp)   4  [ $t145     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-224 ]
    #   -228(%ebp)   4  [ $t146     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-228 ]
    #   -232(%ebp)   4  [ $t147     <int> %ebp-232 ]
    #   -236(%ebp)   4  [ $t148     <int> %ebp-236 ]
    #   -240(%ebp)   4  [ $t149     <int> %ebp-240 ]
    #   -244(%ebp)   4  [ $t15      <int> %ebp-244 ]
    #   -248(%ebp)   4  [ $t150     <int> %ebp-248 ]
    #   -252(%ebp)   4  [ $t151     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-252 ]
    #   -256(%ebp)   4  [ $t152     <int> %ebp-256 ]
    #   -260(%ebp)   4  [ $t153     <int> %ebp-260 ]
    #   -264(%ebp)   4  [ $t154     <int> %ebp-264 ]
    #   -268(%ebp)   4  [ $t155     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-268 ]
    #   -272(%ebp)   4  [ $t156     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-272 ]
    #   -276(%ebp)   4  [ $t157     <int> %ebp-276 ]
    #   -280(%ebp)   4  [ $t158     <int> %ebp-280 ]
    #   -284(%ebp)   4  [ $t159     <int> %ebp-284 ]
    #   -288(%ebp)   4  [ $t16      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-288 ]
    #   -292(%ebp)   4  [ $t160     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-292 ]
    #   -296(%ebp)   4  [ $t161     <int> %ebp-296 ]
    #   -300(%ebp)   4  [ $t162     <int> %ebp-300 ]
    #   -304(%ebp)   4  [ $t163     <int> %ebp-304 ]
    #   -308(%ebp)   4  [ $t164     <int> %ebp-308 ]
    #   -312(%ebp)   4  [ $t165     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-312 ]
    #   -316(%ebp)   4  [ $t166     <int> %ebp-316 ]
    #   -320(%ebp)   4  [ $t167     <int> %ebp-320 ]
    #   -324(%ebp)   4  [ $t168     <int> %ebp-324 ]
    #   -325(%ebp)   1  [ $t169     <bool> %ebp-325 ]
    #   -332(%ebp)   4  [ $t17      <int> %ebp-332 ]
    #   -333(%ebp)   1  [ $t170     <bool> %ebp-333 ]
    #   -340(%ebp)   4  [ $t171     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-340 ]
    #   -344(%ebp)   4  [ $t172     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-344 ]
    #   -348(%ebp)   4  [ $t173     <int> %ebp-348 ]
    #   -352(%ebp)   4  [ $t174     <int> %ebp-352 ]
    #   -356(%ebp)   4  [ $t175     <int> %ebp-356 ]
    #   -360(%ebp)   4  [ $t176     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-360 ]
    #   -364(%ebp)   4  [ $t177     <int> %ebp-364 ]
    #   -368(%ebp)   4  [ $t178     <int> %ebp-368 ]
    #   -372(%ebp)   4  [ $t179     <int> %ebp-372 ]
    #   -376(%ebp)   4  [ $t18      <int> %ebp-376 ]
    #   -380(%ebp)   4  [ $t180     <int> %ebp-380 ]
    #   -384(%ebp)   4  [ $t181     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-384 ]
    #   -388(%ebp)   4  [ $t182     <int> %ebp-388 ]
    #   -392(%ebp)   4  [ $t183     <int> %ebp-392 ]
    #   -396(%ebp)   4  [ $t184     <int> %ebp-396 ]
    #   -400(%ebp)   4  [ $t185     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-400 ]
    #   -404(%ebp)   4  [ $t186     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-404 ]
    #   -408(%ebp)   4  [ $t187     <int> %ebp-408 ]
    #   -412(%ebp)   4  [ $t188     <int> %ebp-412 ]
    #   -416(%ebp)   4  [ $t189     <int> %ebp-416 ]
    #   -420(%ebp)   4  [ $t19      <int> %ebp-420 ]
    #   -424(%ebp)   4  [ $t190     <int> %ebp-424 ]
    #   -428(%ebp)   4  [ $t191     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-428 ]
    #   -432(%ebp)   4  [ $t192     <int> %ebp-432 ]
    #   -436(%ebp)   4  [ $t193     <int> %ebp-436 ]
    #   -440(%ebp)   4  [ $t194     <int> %ebp-440 ]
    #   -444(%ebp)   4  [ $t195     <ptr(4) to <array 5 of <bool>>> %ebp-444 ]
    #   -448(%ebp)   4  [ $t196     <int> %ebp-448 ]
    #   -452(%ebp)   4  [ $t197     <ptr(4) to <array 5 of <bool>>> %ebp-452 ]
    #   -456(%ebp)   4  [ $t198     <int> %ebp-456 ]
    #   -460(%ebp)   4  [ $t199     <int> %ebp-460 ]
    #   -464(%ebp)   4  [ $t2       <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-464 ]
    #   -468(%ebp)   4  [ $t20      <int> %ebp-468 ]
    #   -472(%ebp)   4  [ $t200     <int> %ebp-472 ]
    #   -476(%ebp)   4  [ $t201     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-476 ]
    #   -480(%ebp)   4  [ $t202     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-480 ]
    #   -484(%ebp)   4  [ $t203     <int> %ebp-484 ]
    #   -488(%ebp)   4  [ $t204     <int> %ebp-488 ]
    #   -492(%ebp)   4  [ $t205     <int> %ebp-492 ]
    #   -496(%ebp)   4  [ $t206     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-496 ]
    #   -500(%ebp)   4  [ $t207     <int> %ebp-500 ]
    #   -504(%ebp)   4  [ $t208     <int> %ebp-504 ]
    #   -508(%ebp)   4  [ $t209     <int> %ebp-508 ]
    #   -512(%ebp)   4  [ $t21      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-512 ]
    #   -516(%ebp)   4  [ $t210     <int> %ebp-516 ]
    #   -520(%ebp)   4  [ $t211     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-520 ]
    #   -524(%ebp)   4  [ $t212     <int> %ebp-524 ]
    #   -528(%ebp)   4  [ $t213     <int> %ebp-528 ]
    #   -532(%ebp)   4  [ $t214     <int> %ebp-532 ]
    #   -536(%ebp)   4  [ $t215     <ptr(4) to <array 5 of <bool>>> %ebp-536 ]
    #   -540(%ebp)   4  [ $t216     <int> %ebp-540 ]
    #   -544(%ebp)   4  [ $t217     <ptr(4) to <array 5 of <bool>>> %ebp-544 ]
    #   -548(%ebp)   4  [ $t218     <int> %ebp-548 ]
    #   -552(%ebp)   4  [ $t219     <int> %ebp-552 ]
    #   -556(%ebp)   4  [ $t22      <int> %ebp-556 ]
    #   -560(%ebp)   4  [ $t220     <int> %ebp-560 ]
    #   -561(%ebp)   1  [ $t221     <bool> %ebp-561 ]
    #   -568(%ebp)   4  [ $t222     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-568 ]
    #   -572(%ebp)   4  [ $t223     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-572 ]
    #   -576(%ebp)   4  [ $t224     <int> %ebp-576 ]
    #   -580(%ebp)   4  [ $t225     <int> %ebp-580 ]
    #   -584(%ebp)   4  [ $t226     <int> %ebp-584 ]
    #   -588(%ebp)   4  [ $t227     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-588 ]
    #   -592(%ebp)   4  [ $t228     <int> %ebp-592 ]
    #   -596(%ebp)   4  [ $t229     <int> %ebp-596 ]
    #   -600(%ebp)   4  [ $t23      <int> %ebp-600 ]
    #   -604(%ebp)   4  [ $t230     <int> %ebp-604 ]
    #   -608(%ebp)   4  [ $t231     <int> %ebp-608 ]
    #   -612(%ebp)   4  [ $t232     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-612 ]
    #   -616(%ebp)   4  [ $t233     <int> %ebp-616 ]
    #   -620(%ebp)   4  [ $t234     <int> %ebp-620 ]
    #   -624(%ebp)   4  [ $t235     <int> %ebp-624 ]
    #   -628(%ebp)   4  [ $t236     <ptr(4) to <array 5 of <bool>>> %ebp-628 ]
    #   -632(%ebp)   4  [ $t237     <int> %ebp-632 ]
    #   -636(%ebp)   4  [ $t238     <ptr(4) to <array 5 of <bool>>> %ebp-636 ]
    #   -640(%ebp)   4  [ $t239     <int> %ebp-640 ]
    #   -644(%ebp)   4  [ $t24      <int> %ebp-644 ]
    #   -648(%ebp)   4  [ $t240     <int> %ebp-648 ]
    #   -652(%ebp)   4  [ $t241     <int> %ebp-652 ]
    #   -656(%ebp)   4  [ $t242     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-656 ]
    #   -660(%ebp)   4  [ $t243     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-660 ]
    #   -664(%ebp)   4  [ $t244     <int> %ebp-664 ]
    #   -668(%ebp)   4  [ $t245     <int> %ebp-668 ]
    #   -672(%ebp)   4  [ $t246     <int> %ebp-672 ]
    #   -676(%ebp)   4  [ $t247     <int> %ebp-676 ]
    #   -680(%ebp)   4  [ $t248     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-680 ]
    #   -684(%ebp)   4  [ $t249     <int> %ebp-684 ]
    #   -685(%ebp)   1  [ $t25      <bool> %ebp-685 ]
    #   -692(%ebp)   4  [ $t250     <int> %ebp-692 ]
    #   -696(%ebp)   4  [ $t251     <int> %ebp-696 ]
    #   -697(%ebp)   1  [ $t252     <bool> %ebp-697 ]
    #   -698(%ebp)   1  [ $t253     <bool> %ebp-698 ]
    #   -699(%ebp)   1  [ $t254     <bool> %ebp-699 ]
    #   -700(%ebp)   1  [ $t255     <bool> %ebp-700 ]
    #   -704(%ebp)   4  [ $t256     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-704 ]
    #   -708(%ebp)   4  [ $t257     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-708 ]
    #   -712(%ebp)   4  [ $t258     <int> %ebp-712 ]
    #   -716(%ebp)   4  [ $t259     <int> %ebp-716 ]
    #   -717(%ebp)   1  [ $t26      <bool> %ebp-717 ]
    #   -724(%ebp)   4  [ $t260     <int> %ebp-724 ]
    #   -728(%ebp)   4  [ $t261     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-728 ]
    #   -732(%ebp)   4  [ $t262     <int> %ebp-732 ]
    #   -736(%ebp)   4  [ $t263     <int> %ebp-736 ]
    #   -740(%ebp)   4  [ $t264     <int> %ebp-740 ]
    #   -744(%ebp)   4  [ $t265     <int> %ebp-744 ]
    #   -748(%ebp)   4  [ $t266     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-748 ]
    #   -752(%ebp)   4  [ $t267     <int> %ebp-752 ]
    #   -756(%ebp)   4  [ $t268     <int> %ebp-756 ]
    #   -760(%ebp)   4  [ $t269     <int> %ebp-760 ]
    #   -764(%ebp)   4  [ $t27      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-764 ]
    #   -768(%ebp)   4  [ $t270     <ptr(4) to <array 5 of <bool>>> %ebp-768 ]
    #   -772(%ebp)   4  [ $t271     <int> %ebp-772 ]
    #   -776(%ebp)   4  [ $t272     <ptr(4) to <array 5 of <bool>>> %ebp-776 ]
    #   -780(%ebp)   4  [ $t273     <int> %ebp-780 ]
    #   -784(%ebp)   4  [ $t274     <int> %ebp-784 ]
    #   -788(%ebp)   4  [ $t275     <int> %ebp-788 ]
    #   -789(%ebp)   1  [ $t276     <bool> %ebp-789 ]
    #   -796(%ebp)   4  [ $t28      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-796 ]
    #   -800(%ebp)   4  [ $t29      <int> %ebp-800 ]
    #   -804(%ebp)   4  [ $t3       <int> %ebp-804 ]
    #   -808(%ebp)   4  [ $t30      <int> %ebp-808 ]
    #   -812(%ebp)   4  [ $t31      <int> %ebp-812 ]
    #   -816(%ebp)   4  [ $t32      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-816 ]
    #   -820(%ebp)   4  [ $t33      <int> %ebp-820 ]
    #   -824(%ebp)   4  [ $t34      <int> %ebp-824 ]
    #   -828(%ebp)   4  [ $t35      <int> %ebp-828 ]
    #   -832(%ebp)   4  [ $t36      <int> %ebp-832 ]
    #   -836(%ebp)   4  [ $t37      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-836 ]
    #   -840(%ebp)   4  [ $t38      <int> %ebp-840 ]
    #   -844(%ebp)   4  [ $t39      <int> %ebp-844 ]
    #   -848(%ebp)   4  [ $t4       <int> %ebp-848 ]
    #   -852(%ebp)   4  [ $t40      <int> %ebp-852 ]
    #   -856(%ebp)   4  [ $t41      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-856 ]
    #   -860(%ebp)   4  [ $t42      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-860 ]
    #   -864(%ebp)   4  [ $t43      <int> %ebp-864 ]
    #   -868(%ebp)   4  [ $t44      <int> %ebp-868 ]
    #   -872(%ebp)   4  [ $t45      <int> %ebp-872 ]
    #   -876(%ebp)   4  [ $t46      <int> %ebp-876 ]
    #   -880(%ebp)   4  [ $t47      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-880 ]
    #   -884(%ebp)   4  [ $t48      <int> %ebp-884 ]
    #   -888(%ebp)   4  [ $t49      <int> %ebp-888 ]
    #   -892(%ebp)   4  [ $t5       <int> %ebp-892 ]
    #   -896(%ebp)   4  [ $t50      <int> %ebp-896 ]
    #   -900(%ebp)   4  [ $t51      <ptr(4) to <array 5 of <bool>>> %ebp-900 ]
    #   -904(%ebp)   4  [ $t52      <int> %ebp-904 ]
    #   -908(%ebp)   4  [ $t53      <ptr(4) to <array 5 of <bool>>> %ebp-908 ]
    #   -912(%ebp)   4  [ $t54      <int> %ebp-912 ]
    #   -916(%ebp)   4  [ $t55      <int> %ebp-916 ]
    #   -920(%ebp)   4  [ $t56      <int> %ebp-920 ]
    #   -924(%ebp)   4  [ $t57      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-924 ]
    #   -928(%ebp)   4  [ $t58      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-928 ]
    #   -932(%ebp)   4  [ $t59      <int> %ebp-932 ]
    #   -936(%ebp)   4  [ $t6       <int> %ebp-936 ]
    #   -940(%ebp)   4  [ $t60      <int> %ebp-940 ]
    #   -944(%ebp)   4  [ $t61      <int> %ebp-944 ]
    #   -948(%ebp)   4  [ $t62      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-948 ]
    #   -952(%ebp)   4  [ $t63      <int> %ebp-952 ]
    #   -956(%ebp)   4  [ $t64      <int> %ebp-956 ]
    #   -960(%ebp)   4  [ $t65      <int> %ebp-960 ]
    #   -964(%ebp)   4  [ $t66      <int> %ebp-964 ]
    #   -968(%ebp)   4  [ $t67      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-968 ]
    #   -972(%ebp)   4  [ $t68      <int> %ebp-972 ]
    #   -976(%ebp)   4  [ $t69      <int> %ebp-976 ]
    #   -980(%ebp)   4  [ $t7       <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-980 ]
    #   -984(%ebp)   4  [ $t70      <int> %ebp-984 ]
    #   -985(%ebp)   1  [ $t71      <bool> %ebp-985 ]
    #   -992(%ebp)   4  [ $t72      <int> %ebp-992 ]
    #   -996(%ebp)   4  [ $t73      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-996 ]
    #   -1000(%ebp)   4  [ $t74      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-1000 ]
    #   -1004(%ebp)   4  [ $t75      <int> %ebp-1004 ]
    #   -1008(%ebp)   4  [ $t76      <int> %ebp-1008 ]
    #   -1012(%ebp)   4  [ $t77      <int> %ebp-1012 ]
    #   -1016(%ebp)   4  [ $t78      <int> %ebp-1016 ]
    #   -1020(%ebp)   4  [ $t79      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-1020 ]
    #   -1024(%ebp)   4  [ $t8       <int> %ebp-1024 ]
    #   -1028(%ebp)   4  [ $t80      <int> %ebp-1028 ]
    #   -1032(%ebp)   4  [ $t81      <int> %ebp-1032 ]
    #   -1036(%ebp)   4  [ $t82      <int> %ebp-1036 ]
    #   -1040(%ebp)   4  [ $t83      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-1040 ]
    #   -1044(%ebp)   4  [ $t84      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-1044 ]
    #   -1048(%ebp)   4  [ $t85      <int> %ebp-1048 ]
    #   -1052(%ebp)   4  [ $t86      <int> %ebp-1052 ]
    #   -1056(%ebp)   4  [ $t87      <int> %ebp-1056 ]
    #   -1060(%ebp)   4  [ $t88      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-1060 ]
    #   -1064(%ebp)   4  [ $t89      <int> %ebp-1064 ]
    #   -1068(%ebp)   4  [ $t9       <int> %ebp-1068 ]
    #   -1072(%ebp)   4  [ $t90      <int> %ebp-1072 ]
    #   -1076(%ebp)   4  [ $t91      <int> %ebp-1076 ]
    #   -1080(%ebp)   4  [ $t92      <int> %ebp-1080 ]
    #   -1084(%ebp)   4  [ $t93      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-1084 ]
    #   -1088(%ebp)   4  [ $t94      <int> %ebp-1088 ]
    #   -1092(%ebp)   4  [ $t95      <int> %ebp-1092 ]
    #   -1096(%ebp)   4  [ $t96      <int> %ebp-1096 ]
    #   -1097(%ebp)   1  [ $t97      <bool> %ebp-1097 ]
    #   -1098(%ebp)   1  [ $t98      <bool> %ebp-1098 ]
    #   -1104(%ebp)   4  [ $t99      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-1104 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $1092, %esp             # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $273, %ecx             
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $1, %eax                #   0:     assign p1 <- 1
    movb    %al, 8(%ebp)           
    movzbl  12(%ebp), %eax          #   1:     assign p1 <- p2
    movb    %al, 8(%ebp)           
    movzbl  b0, %eax                #   2:     assign p1 <- b0
    movb    %al, 8(%ebp)           
    movzbl  12(%ebp), %eax          #   3:     if     p2 = 1 goto 8
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_8          
    jmp     l_booltest1_7           #   4:     goto   7
l_booltest1_8:
    movl    i2, %eax                #   6:     mul    t0 <- i2, i1
    movl    i1, %ebx               
    imull   %ebx                   
    movl    %eax, -16(%ebp)        
    movl    i0, %eax                #   7:     if     i0 < t0 goto 4
    movl    -16(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_booltest1_4          
l_booltest1_7:
    movzbl  8(%ebp), %eax           #   9:     if     p1 = 1 goto 5
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_5          
    leal    BoolArr1, %eax          #  10:     &()    t1 <- BoolArr1
    movl    %eax, -20(%ebp)        
    movl    $2, %eax                #  11:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          #  12:     &()    t2 <- BoolArr1
    movl    %eax, -464(%ebp)       
    movl    -464(%ebp), %eax        #  13:     param  0 <- t2
    pushl   %eax                   
    call    DIM                     #  14:     call   t3 <- DIM
    addl    $8, %esp               
    movl    %eax, -804(%ebp)       
    movl    $2, %eax                #  15:     mul    t4 <- 2, t3
    movl    -804(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -848(%ebp)       
    movl    -848(%ebp), %eax        #  16:     add    t5 <- t4, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -892(%ebp)       
    movl    -892(%ebp), %eax        #  17:     mul    t6 <- t5, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -936(%ebp)       
    leal    BoolArr1, %eax          #  18:     &()    t7 <- BoolArr1
    movl    %eax, -980(%ebp)       
    movl    -980(%ebp), %eax        #  19:     param  0 <- t7
    pushl   %eax                   
    call    DOFS                    #  20:     call   t8 <- DOFS
    addl    $4, %esp               
    movl    %eax, -1024(%ebp)      
    movl    -936(%ebp), %eax        #  21:     add    t9 <- t6, t8
    movl    -1024(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1068(%ebp)      
    movl    -20(%ebp), %eax         #  22:     add    t10 <- t1, t9
    movl    -1068(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %edi        
    movzbl  (%edi), %eax            #  23:     if     @t10 = 1 goto 4
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_4          
    leal    BoolArr3, %eax          #  24:     &()    t11 <- BoolArr3
    movl    %eax, -68(%ebp)        
    movl    $2, %eax                #  25:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr3, %eax          #  26:     &()    t12 <- BoolArr3
    movl    %eax, -112(%ebp)       
    movl    -112(%ebp), %eax        #  27:     param  0 <- t12
    pushl   %eax                   
    call    DIM                     #  28:     call   t13 <- DIM
    addl    $8, %esp               
    movl    %eax, -156(%ebp)       
    movl    $2, %eax                #  29:     mul    t14 <- 2, t13
    movl    -156(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -200(%ebp)       
    movl    -200(%ebp), %eax        #  30:     add    t15 <- t14, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -244(%ebp)       
    movl    $3, %eax                #  31:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr3, %eax          #  32:     &()    t16 <- BoolArr3
    movl    %eax, -288(%ebp)       
    movl    -288(%ebp), %eax        #  33:     param  0 <- t16
    pushl   %eax                   
    call    DIM                     #  34:     call   t17 <- DIM
    addl    $8, %esp               
    movl    %eax, -332(%ebp)       
    movl    -244(%ebp), %eax        #  35:     mul    t18 <- t15, t17
    movl    -332(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -376(%ebp)       
    movl    -376(%ebp), %eax        #  36:     add    t19 <- t18, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -420(%ebp)       
    movl    -420(%ebp), %eax        #  37:     mul    t20 <- t19, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -468(%ebp)       
    leal    BoolArr3, %eax          #  38:     &()    t21 <- BoolArr3
    movl    %eax, -512(%ebp)       
    movl    -512(%ebp), %eax        #  39:     param  0 <- t21
    pushl   %eax                   
    call    DOFS                    #  40:     call   t22 <- DOFS
    addl    $4, %esp               
    movl    %eax, -556(%ebp)       
    movl    -468(%ebp), %eax        #  41:     add    t23 <- t20, t22
    movl    -556(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -600(%ebp)       
    movl    -68(%ebp), %eax         #  42:     add    t24 <- t11, t23
    movl    -600(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -644(%ebp)       
    movl    -644(%ebp), %edi       
    movzbl  (%edi), %eax            #  43:     if     @t24 = 1 goto 4
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_4          
    jmp     l_booltest1_5           #  44:     goto   5
l_booltest1_4:
    movl    $1, %eax                #  46:     assign t25 <- 1
    movb    %al, -685(%ebp)        
    jmp     l_booltest1_6           #  47:     goto   6
l_booltest1_5:
    movl    $0, %eax                #  49:     assign t25 <- 0
    movb    %al, -685(%ebp)        
l_booltest1_6:
    movzbl  -685(%ebp), %eax        #  51:     assign p1 <- t25
    movb    %al, 8(%ebp)           
    movzbl  12(%ebp), %eax          #  52:     if     p2 = 1 goto 13
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_13         
    movzbl  8(%ebp), %eax           #  53:     if     p1 = 1 goto 13
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_13         
    jmp     l_booltest1_14          #  54:     goto   14
l_booltest1_13:
    movl    $1, %eax                #  56:     assign t26 <- 1
    movb    %al, -717(%ebp)        
    jmp     l_booltest1_15          #  57:     goto   15
l_booltest1_14:
    movl    $0, %eax                #  59:     assign t26 <- 0
    movb    %al, -717(%ebp)        
l_booltest1_15:
    movzbl  -717(%ebp), %eax        #  61:     assign p1 <- t26
    movb    %al, 8(%ebp)           
    leal    BoolArr2, %eax          #  62:     &()    t27 <- BoolArr2
    movl    %eax, -764(%ebp)       
    movl    $2, %eax                #  63:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          #  64:     &()    t28 <- BoolArr2
    movl    %eax, -796(%ebp)       
    movl    -796(%ebp), %eax        #  65:     param  0 <- t28
    pushl   %eax                   
    call    DIM                     #  66:     call   t29 <- DIM
    addl    $8, %esp               
    movl    %eax, -800(%ebp)       
    movl    $2, %eax                #  67:     mul    t30 <- 2, t29
    movl    -800(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -808(%ebp)       
    movl    -808(%ebp), %eax        #  68:     add    t31 <- t30, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -812(%ebp)       
    movl    $3, %eax                #  69:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          #  70:     &()    t32 <- BoolArr2
    movl    %eax, -816(%ebp)       
    movl    -816(%ebp), %eax        #  71:     param  0 <- t32
    pushl   %eax                   
    call    DIM                     #  72:     call   t33 <- DIM
    addl    $8, %esp               
    movl    %eax, -820(%ebp)       
    movl    -812(%ebp), %eax        #  73:     mul    t34 <- t31, t33
    movl    -820(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -824(%ebp)       
    movl    -824(%ebp), %eax        #  74:     add    t35 <- t34, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -828(%ebp)       
    movl    -828(%ebp), %eax        #  75:     mul    t36 <- t35, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -832(%ebp)       
    leal    BoolArr2, %eax          #  76:     &()    t37 <- BoolArr2
    movl    %eax, -836(%ebp)       
    movl    -836(%ebp), %eax        #  77:     param  0 <- t37
    pushl   %eax                   
    call    DOFS                    #  78:     call   t38 <- DOFS
    addl    $4, %esp               
    movl    %eax, -840(%ebp)       
    movl    -832(%ebp), %eax        #  79:     add    t39 <- t36, t38
    movl    -840(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -844(%ebp)       
    movl    -764(%ebp), %eax        #  80:     add    t40 <- t27, t39
    movl    -844(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -852(%ebp)       
    movl    -852(%ebp), %edi       
    movzbl  (%edi), %eax            #  81:     if     @t40 = 1 goto 22
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_22         
    jmp     l_booltest1_19          #  82:     goto   19
l_booltest1_22:
    movzbl  12(%ebp), %eax          #  84:     if     p2 = 1 goto 19
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_19         
    leal    BoolArr1, %eax          #  85:     &()    t41 <- BoolArr1
    movl    %eax, -856(%ebp)       
    movl    $2, %eax                #  86:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          #  87:     &()    t42 <- BoolArr1
    movl    %eax, -860(%ebp)       
    movl    -860(%ebp), %eax        #  88:     param  0 <- t42
    pushl   %eax                   
    call    DIM                     #  89:     call   t43 <- DIM
    addl    $8, %esp               
    movl    %eax, -864(%ebp)       
    movl    $2, %eax                #  90:     mul    t44 <- 2, t43
    movl    -864(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -868(%ebp)       
    movl    -868(%ebp), %eax        #  91:     add    t45 <- t44, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -872(%ebp)       
    movl    -872(%ebp), %eax        #  92:     mul    t46 <- t45, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -876(%ebp)       
    leal    BoolArr1, %eax          #  93:     &()    t47 <- BoolArr1
    movl    %eax, -880(%ebp)       
    movl    -880(%ebp), %eax        #  94:     param  0 <- t47
    pushl   %eax                   
    call    DOFS                    #  95:     call   t48 <- DOFS
    addl    $4, %esp               
    movl    %eax, -884(%ebp)       
    movl    -876(%ebp), %eax        #  96:     add    t49 <- t46, t48
    movl    -884(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -888(%ebp)       
    movl    -856(%ebp), %eax        #  97:     add    t50 <- t41, t49
    movl    -888(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -896(%ebp)       
    movl    -896(%ebp), %edi       
    movzbl  (%edi), %eax            #  98:     if     @t50 = 1 goto 24
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_24         
    jmp     l_booltest1_23          #  99:     goto   23
l_booltest1_24:
    leal    BoolArr0, %eax          # 101:     &()    t51 <- BoolArr0
    movl    %eax, -900(%ebp)       
    movl    $2, %eax                # 102:     mul    t52 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -904(%ebp)       
    leal    BoolArr0, %eax          # 103:     &()    t53 <- BoolArr0
    movl    %eax, -908(%ebp)       
    movl    -908(%ebp), %eax        # 104:     param  0 <- t53
    pushl   %eax                   
    call    DOFS                    # 105:     call   t54 <- DOFS
    addl    $4, %esp               
    movl    %eax, -912(%ebp)       
    movl    -904(%ebp), %eax        # 106:     add    t55 <- t52, t54
    movl    -912(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -916(%ebp)       
    movl    -900(%ebp), %eax        # 107:     add    t56 <- t51, t55
    movl    -916(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -920(%ebp)       
    movl    -920(%ebp), %edi       
    movzbl  (%edi), %eax            # 108:     if     @t56 = 1 goto 18
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_18         
l_booltest1_23:
    leal    BoolArr2, %eax          # 110:     &()    t57 <- BoolArr2
    movl    %eax, -924(%ebp)       
    movl    $2, %eax                # 111:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 112:     &()    t58 <- BoolArr2
    movl    %eax, -928(%ebp)       
    movl    -928(%ebp), %eax        # 113:     param  0 <- t58
    pushl   %eax                   
    call    DIM                     # 114:     call   t59 <- DIM
    addl    $8, %esp               
    movl    %eax, -932(%ebp)       
    movl    $2, %eax                # 115:     mul    t60 <- 2, t59
    movl    -932(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -940(%ebp)       
    movl    -940(%ebp), %eax        # 116:     add    t61 <- t60, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -944(%ebp)       
    movl    $3, %eax                # 117:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 118:     &()    t62 <- BoolArr2
    movl    %eax, -948(%ebp)       
    movl    -948(%ebp), %eax        # 119:     param  0 <- t62
    pushl   %eax                   
    call    DIM                     # 120:     call   t63 <- DIM
    addl    $8, %esp               
    movl    %eax, -952(%ebp)       
    movl    -944(%ebp), %eax        # 121:     mul    t64 <- t61, t63
    movl    -952(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -956(%ebp)       
    movl    -956(%ebp), %eax        # 122:     add    t65 <- t64, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -960(%ebp)       
    movl    -960(%ebp), %eax        # 123:     mul    t66 <- t65, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -964(%ebp)       
    leal    BoolArr2, %eax          # 124:     &()    t67 <- BoolArr2
    movl    %eax, -968(%ebp)       
    movl    -968(%ebp), %eax        # 125:     param  0 <- t67
    pushl   %eax                   
    call    DOFS                    # 126:     call   t68 <- DOFS
    addl    $4, %esp               
    movl    %eax, -972(%ebp)       
    movl    -964(%ebp), %eax        # 127:     add    t69 <- t66, t68
    movl    -972(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -976(%ebp)       
    movl    -924(%ebp), %eax        # 128:     add    t70 <- t57, t69
    movl    -976(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -984(%ebp)       
    movl    -984(%ebp), %edi       
    movzbl  (%edi), %eax            # 129:     if     @t70 = 1 goto 18
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_18         
    jmp     l_booltest1_19          # 130:     goto   19
l_booltest1_18:
    movl    $1, %eax                # 132:     assign t71 <- 1
    movb    %al, -985(%ebp)        
    jmp     l_booltest1_20          # 133:     goto   20
l_booltest1_19:
    movl    $0, %eax                # 135:     assign t71 <- 0
    movb    %al, -985(%ebp)        
l_booltest1_20:
    movzbl  -985(%ebp), %eax        # 137:     assign p2 <- t71
    movb    %al, 12(%ebp)          
    jmp     l_booltest1_30_if_false # 138:     goto   30_if_false
    movzbl  12(%ebp), %eax          # 139:     if     p2 = 1 goto 32_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_32_if_true 
    jmp     l_booltest1_33_if_false # 140:     goto   33_if_false
l_booltest1_32_if_true:
    movzbl  b0, %eax                # 142:     if     b0 = 1 goto 35_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_35_if_true 
    jmp     l_booltest1_36_if_false # 143:     goto   36_if_false
l_booltest1_35_if_true:
    movzbl  12(%ebp), %eax          # 145:     if     p2 = 1 goto 41
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_41         
    jmp     l_booltest1_40          # 146:     goto   40
l_booltest1_41:
    movl    i2, %eax                # 148:     mul    t72 <- i2, i1
    movl    i1, %ebx               
    imull   %ebx                   
    movl    %eax, -992(%ebp)       
    movl    i0, %eax                # 149:     if     i0 < t72 goto 38_if_true
    movl    -992(%ebp), %ebx       
    cmpl    %ebx, %eax             
    jl      l_booltest1_38_if_true 
l_booltest1_40:
    movzbl  8(%ebp), %eax           # 151:     if     p1 = 1 goto 39_if_false
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_39_if_false
    leal    BoolArr1, %eax          # 152:     &()    t73 <- BoolArr1
    movl    %eax, -996(%ebp)       
    movl    $2, %eax                # 153:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 154:     &()    t74 <- BoolArr1
    movl    %eax, -1000(%ebp)      
    movl    -1000(%ebp), %eax       # 155:     param  0 <- t74
    pushl   %eax                   
    call    DIM                     # 156:     call   t75 <- DIM
    addl    $8, %esp               
    movl    %eax, -1004(%ebp)      
    movl    $2, %eax                # 157:     mul    t76 <- 2, t75
    movl    -1004(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1008(%ebp)      
    movl    -1008(%ebp), %eax       # 158:     add    t77 <- t76, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1012(%ebp)      
    movl    -1012(%ebp), %eax       # 159:     mul    t78 <- t77, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -1016(%ebp)      
    leal    BoolArr1, %eax          # 160:     &()    t79 <- BoolArr1
    movl    %eax, -1020(%ebp)      
    movl    -1020(%ebp), %eax       # 161:     param  0 <- t79
    pushl   %eax                   
    call    DOFS                    # 162:     call   t80 <- DOFS
    addl    $4, %esp               
    movl    %eax, -1028(%ebp)      
    movl    -1016(%ebp), %eax       # 163:     add    t81 <- t78, t80
    movl    -1028(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1032(%ebp)      
    movl    -996(%ebp), %eax        # 164:     add    t82 <- t73, t81
    movl    -1032(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1036(%ebp)      
    movl    -1036(%ebp), %edi      
    movzbl  (%edi), %eax            # 165:     if     @t82 = 1 goto 38_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_38_if_true 
    leal    BoolArr3, %eax          # 166:     &()    t83 <- BoolArr3
    movl    %eax, -1040(%ebp)      
    movl    $2, %eax                # 167:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr3, %eax          # 168:     &()    t84 <- BoolArr3
    movl    %eax, -1044(%ebp)      
    movl    -1044(%ebp), %eax       # 169:     param  0 <- t84
    pushl   %eax                   
    call    DIM                     # 170:     call   t85 <- DIM
    addl    $8, %esp               
    movl    %eax, -1048(%ebp)      
    movl    $2, %eax                # 171:     mul    t86 <- 2, t85
    movl    -1048(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1052(%ebp)      
    movl    -1052(%ebp), %eax       # 172:     add    t87 <- t86, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1056(%ebp)      
    movl    $3, %eax                # 173:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr3, %eax          # 174:     &()    t88 <- BoolArr3
    movl    %eax, -1060(%ebp)      
    movl    -1060(%ebp), %eax       # 175:     param  0 <- t88
    pushl   %eax                   
    call    DIM                     # 176:     call   t89 <- DIM
    addl    $8, %esp               
    movl    %eax, -1064(%ebp)      
    movl    -1056(%ebp), %eax       # 177:     mul    t90 <- t87, t89
    movl    -1064(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1072(%ebp)      
    movl    -1072(%ebp), %eax       # 178:     add    t91 <- t90, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1076(%ebp)      
    movl    -1076(%ebp), %eax       # 179:     mul    t92 <- t91, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -1080(%ebp)      
    leal    BoolArr3, %eax          # 180:     &()    t93 <- BoolArr3
    movl    %eax, -1084(%ebp)      
    movl    -1084(%ebp), %eax       # 181:     param  0 <- t93
    pushl   %eax                   
    call    DOFS                    # 182:     call   t94 <- DOFS
    addl    $4, %esp               
    movl    %eax, -1088(%ebp)      
    movl    -1080(%ebp), %eax       # 183:     add    t95 <- t92, t94
    movl    -1088(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1092(%ebp)      
    movl    -1040(%ebp), %eax       # 184:     add    t96 <- t83, t95
    movl    -1092(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1096(%ebp)      
    movl    -1096(%ebp), %edi      
    movzbl  (%edi), %eax            # 185:     if     @t96 = 1 goto 38_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_38_if_true 
    jmp     l_booltest1_39_if_false # 186:     goto   39_if_false
l_booltest1_38_if_true:
    movzbl  b1, %eax                # 188:     if     b1 = 1 goto 49
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_49         
    jmp     l_booltest1_47          # 189:     goto   47
l_booltest1_49:
    movzbl  b2, %eax                # 191:     if     b2 = 1 goto 46
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_46         
    jmp     l_booltest1_47          # 192:     goto   47
l_booltest1_46:
    movl    $1, %eax                # 194:     assign t97 <- 1
    movb    %al, -1097(%ebp)       
    jmp     l_booltest1_48          # 195:     goto   48
l_booltest1_47:
    movl    $0, %eax                # 197:     assign t97 <- 0
    movb    %al, -1097(%ebp)       
l_booltest1_48:
    movzbl  -1097(%ebp), %eax       # 199:     assign b0 <- t97
    movb    %al, b0                
    jmp     l_booltest1_37          # 200:     goto   37
l_booltest1_39_if_false:
    movzbl  12(%ebp), %eax          # 202:     if     p2 = 1 goto 51_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_51_if_true 
    movzbl  8(%ebp), %eax           # 203:     if     p1 = 1 goto 51_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_51_if_true 
    jmp     l_booltest1_52_if_false # 204:     goto   52_if_false
l_booltest1_51_if_true:
    movzbl  b0, %eax                # 206:     if     b0 = 1 goto 55
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_55         
    movzbl  b1, %eax                # 207:     if     b1 = 1 goto 55
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_55         
    jmp     l_booltest1_56          # 208:     goto   56
l_booltest1_55:
    movl    $1, %eax                # 210:     assign t98 <- 1
    movb    %al, -1098(%ebp)       
    jmp     l_booltest1_57          # 211:     goto   57
l_booltest1_56:
    movl    $0, %eax                # 213:     assign t98 <- 0
    movb    %al, -1098(%ebp)       
l_booltest1_57:
    movzbl  -1098(%ebp), %eax       # 215:     assign b1 <- t98
    movb    %al, b1                
    jmp     l_booltest1_50          # 216:     goto   50
l_booltest1_52_if_false:
l_booltest1_50:
l_booltest1_37:
    jmp     l_booltest1_34          # 220:     goto   34
l_booltest1_36_if_false:
l_booltest1_34:
    jmp     l_booltest1_31          # 223:     goto   31
l_booltest1_33_if_false:
    leal    BoolArr2, %eax          # 225:     &()    t99 <- BoolArr2
    movl    %eax, -1104(%ebp)      
    movl    $2, %eax                # 226:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 227:     &()    t100 <- BoolArr2
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         # 228:     param  0 <- t100
    pushl   %eax                   
    call    DIM                     # 229:     call   t101 <- DIM
    addl    $8, %esp               
    movl    %eax, -32(%ebp)        
    movl    $2, %eax                # 230:     mul    t102 <- 2, t101
    movl    -32(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         # 231:     add    t103 <- t102, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    $3, %eax                # 232:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 233:     &()    t104 <- BoolArr2
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         # 234:     param  0 <- t104
    pushl   %eax                   
    call    DIM                     # 235:     call   t105 <- DIM
    addl    $8, %esp               
    movl    %eax, -48(%ebp)        
    movl    -40(%ebp), %eax         # 236:     mul    t106 <- t103, t105
    movl    -48(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -52(%ebp)        
    movl    -52(%ebp), %eax         # 237:     add    t107 <- t106, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         # 238:     mul    t108 <- t107, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -60(%ebp)        
    leal    BoolArr2, %eax          # 239:     &()    t109 <- BoolArr2
    movl    %eax, -64(%ebp)        
    movl    -64(%ebp), %eax         # 240:     param  0 <- t109
    pushl   %eax                   
    call    DOFS                    # 241:     call   t110 <- DOFS
    addl    $4, %esp               
    movl    %eax, -72(%ebp)        
    movl    -60(%ebp), %eax         # 242:     add    t111 <- t108, t110
    movl    -72(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -76(%ebp)        
    movl    -1104(%ebp), %eax       # 243:     add    t112 <- t99, t111
    movl    -76(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -80(%ebp), %edi        
    movzbl  (%edi), %eax            # 244:     if     @t112 = 1 goto 63
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_63         
    jmp     l_booltest1_61_if_false # 245:     goto   61_if_false
l_booltest1_63:
    movzbl  12(%ebp), %eax          # 247:     if     p2 = 1 goto 61_if_false
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_61_if_false
    leal    BoolArr1, %eax          # 248:     &()    t113 <- BoolArr1
    movl    %eax, -84(%ebp)        
    movl    $2, %eax                # 249:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 250:     &()    t114 <- BoolArr1
    movl    %eax, -88(%ebp)        
    movl    -88(%ebp), %eax         # 251:     param  0 <- t114
    pushl   %eax                   
    call    DIM                     # 252:     call   t115 <- DIM
    addl    $8, %esp               
    movl    %eax, -92(%ebp)        
    movl    $2, %eax                # 253:     mul    t116 <- 2, t115
    movl    -92(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -96(%ebp)        
    movl    -96(%ebp), %eax         # 254:     add    t117 <- t116, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -100(%ebp)       
    movl    -100(%ebp), %eax        # 255:     mul    t118 <- t117, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -104(%ebp)       
    leal    BoolArr1, %eax          # 256:     &()    t119 <- BoolArr1
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        # 257:     param  0 <- t119
    pushl   %eax                   
    call    DOFS                    # 258:     call   t120 <- DOFS
    addl    $4, %esp               
    movl    %eax, -116(%ebp)       
    movl    -104(%ebp), %eax        # 259:     add    t121 <- t118, t120
    movl    -116(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -120(%ebp)       
    movl    -84(%ebp), %eax         # 260:     add    t122 <- t113, t121
    movl    -120(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -124(%ebp)       
    movl    -124(%ebp), %edi       
    movzbl  (%edi), %eax            # 261:     if     @t122 = 1 goto 65
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_65         
    jmp     l_booltest1_64          # 262:     goto   64
l_booltest1_65:
    leal    BoolArr0, %eax          # 264:     &()    t123 <- BoolArr0
    movl    %eax, -128(%ebp)       
    movl    $2, %eax                # 265:     mul    t124 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -132(%ebp)       
    leal    BoolArr0, %eax          # 266:     &()    t125 <- BoolArr0
    movl    %eax, -136(%ebp)       
    movl    -136(%ebp), %eax        # 267:     param  0 <- t125
    pushl   %eax                   
    call    DOFS                    # 268:     call   t126 <- DOFS
    addl    $4, %esp               
    movl    %eax, -140(%ebp)       
    movl    -132(%ebp), %eax        # 269:     add    t127 <- t124, t126
    movl    -140(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -144(%ebp)       
    movl    -128(%ebp), %eax        # 270:     add    t128 <- t123, t127
    movl    -144(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -148(%ebp)       
    movl    -148(%ebp), %edi       
    movzbl  (%edi), %eax            # 271:     if     @t128 = 1 goto 60_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_60_if_true 
l_booltest1_64:
    leal    BoolArr2, %eax          # 273:     &()    t129 <- BoolArr2
    movl    %eax, -152(%ebp)       
    movl    $2, %eax                # 274:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 275:     &()    t130 <- BoolArr2
    movl    %eax, -160(%ebp)       
    movl    -160(%ebp), %eax        # 276:     param  0 <- t130
    pushl   %eax                   
    call    DIM                     # 277:     call   t131 <- DIM
    addl    $8, %esp               
    movl    %eax, -164(%ebp)       
    movl    $2, %eax                # 278:     mul    t132 <- 2, t131
    movl    -164(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -168(%ebp)       
    movl    -168(%ebp), %eax        # 279:     add    t133 <- t132, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -172(%ebp)       
    movl    $3, %eax                # 280:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 281:     &()    t134 <- BoolArr2
    movl    %eax, -176(%ebp)       
    movl    -176(%ebp), %eax        # 282:     param  0 <- t134
    pushl   %eax                   
    call    DIM                     # 283:     call   t135 <- DIM
    addl    $8, %esp               
    movl    %eax, -180(%ebp)       
    movl    -172(%ebp), %eax        # 284:     mul    t136 <- t133, t135
    movl    -180(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -184(%ebp)       
    movl    -184(%ebp), %eax        # 285:     add    t137 <- t136, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -188(%ebp)       
    movl    -188(%ebp), %eax        # 286:     mul    t138 <- t137, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -192(%ebp)       
    leal    BoolArr2, %eax          # 287:     &()    t139 <- BoolArr2
    movl    %eax, -196(%ebp)       
    movl    -196(%ebp), %eax        # 288:     param  0 <- t139
    pushl   %eax                   
    call    DOFS                    # 289:     call   t140 <- DOFS
    addl    $4, %esp               
    movl    %eax, -204(%ebp)       
    movl    -192(%ebp), %eax        # 290:     add    t141 <- t138, t140
    movl    -204(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -208(%ebp)       
    movl    -152(%ebp), %eax        # 291:     add    t142 <- t129, t141
    movl    -208(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -212(%ebp)       
    movl    -212(%ebp), %edi       
    movzbl  (%edi), %eax            # 292:     if     @t142 = 1 goto 60_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_60_if_true 
    jmp     l_booltest1_61_if_false # 293:     goto   61_if_false
l_booltest1_60_if_true:
    leal    _str_12, %eax           # 295:     &()    t143 <- _str_12
    movl    %eax, -216(%ebp)       
    movl    -216(%ebp), %eax        # 296:     param  0 <- t143
    pushl   %eax                   
    call    WriteStr                # 297:     call   WriteStr
    addl    $4, %esp               
    jmp     l_booltest1_59          # 298:     goto   59
l_booltest1_61_if_false:
l_booltest1_59:
l_booltest1_31:
    jmp     l_booltest1_28          # 302:     goto   28
l_booltest1_30_if_false:
l_booltest1_28:
    jmp     l_booltest1_25          # 305:     goto   25
l_booltest1_25:
l_booltest1_68_while_cond:
l_booltest1_71_while_cond:
    jmp     l_booltest1_70          # 309:     goto   70
l_booltest1_74_while_cond:
    movzbl  12(%ebp), %eax          # 311:     if     p2 = 1 goto 75_while_body
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_75_while_body
    jmp     l_booltest1_73          # 312:     goto   73
l_booltest1_75_while_body:
l_booltest1_77_while_cond:
    movzbl  b0, %eax                # 315:     if     b0 = 1 goto 78_while_body
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_78_while_body
    jmp     l_booltest1_76          # 316:     goto   76
l_booltest1_78_while_body:
l_booltest1_80_while_cond:
    movzbl  12(%ebp), %eax          # 319:     if     p2 = 1 goto 83
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_83         
    jmp     l_booltest1_82          # 320:     goto   82
l_booltest1_83:
    movl    i2, %eax                # 322:     mul    t144 <- i2, i1
    movl    i1, %ebx               
    imull   %ebx                   
    movl    %eax, -220(%ebp)       
    movl    i0, %eax                # 323:     if     i0 < t144 goto 81_while_body
    movl    -220(%ebp), %ebx       
    cmpl    %ebx, %eax             
    jl      l_booltest1_81_while_body
l_booltest1_82:
    movzbl  8(%ebp), %eax           # 325:     if     p1 = 1 goto 79
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_79         
    leal    BoolArr1, %eax          # 326:     &()    t145 <- BoolArr1
    movl    %eax, -224(%ebp)       
    movl    $2, %eax                # 327:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 328:     &()    t146 <- BoolArr1
    movl    %eax, -228(%ebp)       
    movl    -228(%ebp), %eax        # 329:     param  0 <- t146
    pushl   %eax                   
    call    DIM                     # 330:     call   t147 <- DIM
    addl    $8, %esp               
    movl    %eax, -232(%ebp)       
    movl    $2, %eax                # 331:     mul    t148 <- 2, t147
    movl    -232(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -236(%ebp)       
    movl    -236(%ebp), %eax        # 332:     add    t149 <- t148, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -240(%ebp)       
    movl    -240(%ebp), %eax        # 333:     mul    t150 <- t149, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -248(%ebp)       
    leal    BoolArr1, %eax          # 334:     &()    t151 <- BoolArr1
    movl    %eax, -252(%ebp)       
    movl    -252(%ebp), %eax        # 335:     param  0 <- t151
    pushl   %eax                   
    call    DOFS                    # 336:     call   t152 <- DOFS
    addl    $4, %esp               
    movl    %eax, -256(%ebp)       
    movl    -248(%ebp), %eax        # 337:     add    t153 <- t150, t152
    movl    -256(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -260(%ebp)       
    movl    -224(%ebp), %eax        # 338:     add    t154 <- t145, t153
    movl    -260(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -264(%ebp)       
    movl    -264(%ebp), %edi       
    movzbl  (%edi), %eax            # 339:     if     @t154 = 1 goto 81_while_body
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_81_while_body
    leal    BoolArr3, %eax          # 340:     &()    t155 <- BoolArr3
    movl    %eax, -268(%ebp)       
    movl    $2, %eax                # 341:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr3, %eax          # 342:     &()    t156 <- BoolArr3
    movl    %eax, -272(%ebp)       
    movl    -272(%ebp), %eax        # 343:     param  0 <- t156
    pushl   %eax                   
    call    DIM                     # 344:     call   t157 <- DIM
    addl    $8, %esp               
    movl    %eax, -276(%ebp)       
    movl    $2, %eax                # 345:     mul    t158 <- 2, t157
    movl    -276(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -280(%ebp)       
    movl    -280(%ebp), %eax        # 346:     add    t159 <- t158, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -284(%ebp)       
    movl    $3, %eax                # 347:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr3, %eax          # 348:     &()    t160 <- BoolArr3
    movl    %eax, -292(%ebp)       
    movl    -292(%ebp), %eax        # 349:     param  0 <- t160
    pushl   %eax                   
    call    DIM                     # 350:     call   t161 <- DIM
    addl    $8, %esp               
    movl    %eax, -296(%ebp)       
    movl    -284(%ebp), %eax        # 351:     mul    t162 <- t159, t161
    movl    -296(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -300(%ebp)       
    movl    -300(%ebp), %eax        # 352:     add    t163 <- t162, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -304(%ebp)       
    movl    -304(%ebp), %eax        # 353:     mul    t164 <- t163, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -308(%ebp)       
    leal    BoolArr3, %eax          # 354:     &()    t165 <- BoolArr3
    movl    %eax, -312(%ebp)       
    movl    -312(%ebp), %eax        # 355:     param  0 <- t165
    pushl   %eax                   
    call    DOFS                    # 356:     call   t166 <- DOFS
    addl    $4, %esp               
    movl    %eax, -316(%ebp)       
    movl    -308(%ebp), %eax        # 357:     add    t167 <- t164, t166
    movl    -316(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -320(%ebp)       
    movl    -268(%ebp), %eax        # 358:     add    t168 <- t155, t167
    movl    -320(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -324(%ebp)       
    movl    -324(%ebp), %edi       
    movzbl  (%edi), %eax            # 359:     if     @t168 = 1 goto 81_while_body
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_81_while_body
    jmp     l_booltest1_79          # 360:     goto   79
l_booltest1_81_while_body:
    movzbl  b1, %eax                # 362:     if     b1 = 1 goto 91
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_91         
    jmp     l_booltest1_89          # 363:     goto   89
l_booltest1_91:
    movzbl  b2, %eax                # 365:     if     b2 = 1 goto 88
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_88         
    jmp     l_booltest1_89          # 366:     goto   89
l_booltest1_88:
    movl    $1, %eax                # 368:     assign t169 <- 1
    movb    %al, -325(%ebp)        
    jmp     l_booltest1_90          # 369:     goto   90
l_booltest1_89:
    movl    $0, %eax                # 371:     assign t169 <- 0
    movb    %al, -325(%ebp)        
l_booltest1_90:
    movzbl  -325(%ebp), %eax        # 373:     assign b0 <- t169
    movb    %al, b0                
l_booltest1_93_while_cond:
    movzbl  12(%ebp), %eax          # 375:     if     p2 = 1 goto 94_while_body
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_94_while_body
    movzbl  8(%ebp), %eax           # 376:     if     p1 = 1 goto 94_while_body
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_94_while_body
    jmp     l_booltest1_92          # 377:     goto   92
l_booltest1_94_while_body:
    movzbl  b0, %eax                # 379:     if     b0 = 1 goto 97
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_97         
    movzbl  b1, %eax                # 380:     if     b1 = 1 goto 97
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_97         
    jmp     l_booltest1_98          # 381:     goto   98
l_booltest1_97:
    movl    $1, %eax                # 383:     assign t170 <- 1
    movb    %al, -333(%ebp)        
    jmp     l_booltest1_99          # 384:     goto   99
l_booltest1_98:
    movl    $0, %eax                # 386:     assign t170 <- 0
    movb    %al, -333(%ebp)        
l_booltest1_99:
    movzbl  -333(%ebp), %eax        # 388:     assign p2 <- t170
    movb    %al, 12(%ebp)          
    jmp     l_booltest1_93_while_cond # 389:     goto   93_while_cond
l_booltest1_92:
    jmp     l_booltest1_80_while_cond # 391:     goto   80_while_cond
l_booltest1_79:
    jmp     l_booltest1_77_while_cond # 393:     goto   77_while_cond
l_booltest1_76:
    jmp     l_booltest1_74_while_cond # 395:     goto   74_while_cond
l_booltest1_73:
l_booltest1_102_while_cond:
    leal    BoolArr2, %eax          # 398:     &()    t171 <- BoolArr2
    movl    %eax, -340(%ebp)       
    movl    $2, %eax                # 399:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 400:     &()    t172 <- BoolArr2
    movl    %eax, -344(%ebp)       
    movl    -344(%ebp), %eax        # 401:     param  0 <- t172
    pushl   %eax                   
    call    DIM                     # 402:     call   t173 <- DIM
    addl    $8, %esp               
    movl    %eax, -348(%ebp)       
    movl    $2, %eax                # 403:     mul    t174 <- 2, t173
    movl    -348(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -352(%ebp)       
    movl    -352(%ebp), %eax        # 404:     add    t175 <- t174, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -356(%ebp)       
    movl    $3, %eax                # 405:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 406:     &()    t176 <- BoolArr2
    movl    %eax, -360(%ebp)       
    movl    -360(%ebp), %eax        # 407:     param  0 <- t176
    pushl   %eax                   
    call    DIM                     # 408:     call   t177 <- DIM
    addl    $8, %esp               
    movl    %eax, -364(%ebp)       
    movl    -356(%ebp), %eax        # 409:     mul    t178 <- t175, t177
    movl    -364(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -368(%ebp)       
    movl    -368(%ebp), %eax        # 410:     add    t179 <- t178, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -372(%ebp)       
    movl    -372(%ebp), %eax        # 411:     mul    t180 <- t179, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -380(%ebp)       
    leal    BoolArr2, %eax          # 412:     &()    t181 <- BoolArr2
    movl    %eax, -384(%ebp)       
    movl    -384(%ebp), %eax        # 413:     param  0 <- t181
    pushl   %eax                   
    call    DOFS                    # 414:     call   t182 <- DOFS
    addl    $4, %esp               
    movl    %eax, -388(%ebp)       
    movl    -380(%ebp), %eax        # 415:     add    t183 <- t180, t182
    movl    -388(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -392(%ebp)       
    movl    -340(%ebp), %eax        # 416:     add    t184 <- t171, t183
    movl    -392(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -396(%ebp)       
    movl    -396(%ebp), %edi       
    movzbl  (%edi), %eax            # 417:     if     @t184 = 1 goto 105
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_105        
    jmp     l_booltest1_101         # 418:     goto   101
l_booltest1_105:
    movzbl  12(%ebp), %eax          # 420:     if     p2 = 1 goto 101
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_101        
    leal    BoolArr1, %eax          # 421:     &()    t185 <- BoolArr1
    movl    %eax, -400(%ebp)       
    movl    $2, %eax                # 422:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 423:     &()    t186 <- BoolArr1
    movl    %eax, -404(%ebp)       
    movl    -404(%ebp), %eax        # 424:     param  0 <- t186
    pushl   %eax                   
    call    DIM                     # 425:     call   t187 <- DIM
    addl    $8, %esp               
    movl    %eax, -408(%ebp)       
    movl    $2, %eax                # 426:     mul    t188 <- 2, t187
    movl    -408(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -412(%ebp)       
    movl    -412(%ebp), %eax        # 427:     add    t189 <- t188, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -416(%ebp)       
    movl    -416(%ebp), %eax        # 428:     mul    t190 <- t189, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -424(%ebp)       
    leal    BoolArr1, %eax          # 429:     &()    t191 <- BoolArr1
    movl    %eax, -428(%ebp)       
    movl    -428(%ebp), %eax        # 430:     param  0 <- t191
    pushl   %eax                   
    call    DOFS                    # 431:     call   t192 <- DOFS
    addl    $4, %esp               
    movl    %eax, -432(%ebp)       
    movl    -424(%ebp), %eax        # 432:     add    t193 <- t190, t192
    movl    -432(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -436(%ebp)       
    movl    -400(%ebp), %eax        # 433:     add    t194 <- t185, t193
    movl    -436(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -440(%ebp)       
    movl    -440(%ebp), %edi       
    movzbl  (%edi), %eax            # 434:     if     @t194 = 1 goto 107
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_107        
    jmp     l_booltest1_106         # 435:     goto   106
l_booltest1_107:
    leal    BoolArr0, %eax          # 437:     &()    t195 <- BoolArr0
    movl    %eax, -444(%ebp)       
    movl    $2, %eax                # 438:     mul    t196 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -448(%ebp)       
    leal    BoolArr0, %eax          # 439:     &()    t197 <- BoolArr0
    movl    %eax, -452(%ebp)       
    movl    -452(%ebp), %eax        # 440:     param  0 <- t197
    pushl   %eax                   
    call    DOFS                    # 441:     call   t198 <- DOFS
    addl    $4, %esp               
    movl    %eax, -456(%ebp)       
    movl    -448(%ebp), %eax        # 442:     add    t199 <- t196, t198
    movl    -456(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -460(%ebp)       
    movl    -444(%ebp), %eax        # 443:     add    t200 <- t195, t199
    movl    -460(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -472(%ebp)       
    movl    -472(%ebp), %edi       
    movzbl  (%edi), %eax            # 444:     if     @t200 = 1 goto 103_while_body
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_103_while_body
l_booltest1_106:
    leal    BoolArr2, %eax          # 446:     &()    t201 <- BoolArr2
    movl    %eax, -476(%ebp)       
    movl    $2, %eax                # 447:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 448:     &()    t202 <- BoolArr2
    movl    %eax, -480(%ebp)       
    movl    -480(%ebp), %eax        # 449:     param  0 <- t202
    pushl   %eax                   
    call    DIM                     # 450:     call   t203 <- DIM
    addl    $8, %esp               
    movl    %eax, -484(%ebp)       
    movl    $2, %eax                # 451:     mul    t204 <- 2, t203
    movl    -484(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -488(%ebp)       
    movl    -488(%ebp), %eax        # 452:     add    t205 <- t204, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -492(%ebp)       
    movl    $3, %eax                # 453:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 454:     &()    t206 <- BoolArr2
    movl    %eax, -496(%ebp)       
    movl    -496(%ebp), %eax        # 455:     param  0 <- t206
    pushl   %eax                   
    call    DIM                     # 456:     call   t207 <- DIM
    addl    $8, %esp               
    movl    %eax, -500(%ebp)       
    movl    -492(%ebp), %eax        # 457:     mul    t208 <- t205, t207
    movl    -500(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -504(%ebp)       
    movl    -504(%ebp), %eax        # 458:     add    t209 <- t208, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -508(%ebp)       
    movl    -508(%ebp), %eax        # 459:     mul    t210 <- t209, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -516(%ebp)       
    leal    BoolArr2, %eax          # 460:     &()    t211 <- BoolArr2
    movl    %eax, -520(%ebp)       
    movl    -520(%ebp), %eax        # 461:     param  0 <- t211
    pushl   %eax                   
    call    DOFS                    # 462:     call   t212 <- DOFS
    addl    $4, %esp               
    movl    %eax, -524(%ebp)       
    movl    -516(%ebp), %eax        # 463:     add    t213 <- t210, t212
    movl    -524(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -528(%ebp)       
    movl    -476(%ebp), %eax        # 464:     add    t214 <- t201, t213
    movl    -528(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -532(%ebp)       
    movl    -532(%ebp), %edi       
    movzbl  (%edi), %eax            # 465:     if     @t214 = 1 goto 103_while_body
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_103_while_body
    jmp     l_booltest1_101         # 466:     goto   101
l_booltest1_103_while_body:
    movzbl  12(%ebp), %eax          # 468:     if     p2 = 1 goto 110
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_110        
    leal    BoolArr0, %eax          # 469:     &()    t215 <- BoolArr0
    movl    %eax, -536(%ebp)       
    movl    $2, %eax                # 470:     mul    t216 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -540(%ebp)       
    leal    BoolArr0, %eax          # 471:     &()    t217 <- BoolArr0
    movl    %eax, -544(%ebp)       
    movl    -544(%ebp), %eax        # 472:     param  0 <- t217
    pushl   %eax                   
    call    DOFS                    # 473:     call   t218 <- DOFS
    addl    $4, %esp               
    movl    %eax, -548(%ebp)       
    movl    -540(%ebp), %eax        # 474:     add    t219 <- t216, t218
    movl    -548(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -552(%ebp)       
    movl    -536(%ebp), %eax        # 475:     add    t220 <- t215, t219
    movl    -552(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -560(%ebp)       
    movl    -560(%ebp), %edi       
    movzbl  (%edi), %eax            # 476:     if     @t220 = 1 goto 109
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_109        
    jmp     l_booltest1_110         # 477:     goto   110
l_booltest1_109:
    movl    $1, %eax                # 479:     assign t221 <- 1
    movb    %al, -561(%ebp)        
    jmp     l_booltest1_111         # 480:     goto   111
l_booltest1_110:
    movl    $0, %eax                # 482:     assign t221 <- 0
    movb    %al, -561(%ebp)        
l_booltest1_111:
    leal    BoolArr2, %eax          # 484:     &()    t222 <- BoolArr2
    movl    %eax, -568(%ebp)       
    movl    $2, %eax                # 485:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 486:     &()    t223 <- BoolArr2
    movl    %eax, -572(%ebp)       
    movl    -572(%ebp), %eax        # 487:     param  0 <- t223
    pushl   %eax                   
    call    DIM                     # 488:     call   t224 <- DIM
    addl    $8, %esp               
    movl    %eax, -576(%ebp)       
    movl    $2, %eax                # 489:     mul    t225 <- 2, t224
    movl    -576(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -580(%ebp)       
    movl    -580(%ebp), %eax        # 490:     add    t226 <- t225, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -584(%ebp)       
    movl    $3, %eax                # 491:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 492:     &()    t227 <- BoolArr2
    movl    %eax, -588(%ebp)       
    movl    -588(%ebp), %eax        # 493:     param  0 <- t227
    pushl   %eax                   
    call    DIM                     # 494:     call   t228 <- DIM
    addl    $8, %esp               
    movl    %eax, -592(%ebp)       
    movl    -584(%ebp), %eax        # 495:     mul    t229 <- t226, t228
    movl    -592(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -596(%ebp)       
    movl    -596(%ebp), %eax        # 496:     add    t230 <- t229, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -604(%ebp)       
    movl    -604(%ebp), %eax        # 497:     mul    t231 <- t230, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -608(%ebp)       
    leal    BoolArr2, %eax          # 498:     &()    t232 <- BoolArr2
    movl    %eax, -612(%ebp)       
    movl    -612(%ebp), %eax        # 499:     param  0 <- t232
    pushl   %eax                   
    call    DOFS                    # 500:     call   t233 <- DOFS
    addl    $4, %esp               
    movl    %eax, -616(%ebp)       
    movl    -608(%ebp), %eax        # 501:     add    t234 <- t231, t233
    movl    -616(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -620(%ebp)       
    movl    -568(%ebp), %eax        # 502:     add    t235 <- t222, t234
    movl    -620(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -624(%ebp)       
    movzbl  -561(%ebp), %eax        # 503:     assign @t235 <- t221
    movl    -624(%ebp), %edi       
    movb    %al, (%edi)            
    leal    BoolArr0, %eax          # 504:     &()    t236 <- BoolArr0
    movl    %eax, -628(%ebp)       
    movl    $2, %eax                # 505:     mul    t237 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -632(%ebp)       
    leal    BoolArr0, %eax          # 506:     &()    t238 <- BoolArr0
    movl    %eax, -636(%ebp)       
    movl    -636(%ebp), %eax        # 507:     param  0 <- t238
    pushl   %eax                   
    call    DOFS                    # 508:     call   t239 <- DOFS
    addl    $4, %esp               
    movl    %eax, -640(%ebp)       
    movl    -632(%ebp), %eax        # 509:     add    t240 <- t237, t239
    movl    -640(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -648(%ebp)       
    movl    -628(%ebp), %eax        # 510:     add    t241 <- t236, t240
    movl    -648(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -652(%ebp)       
    leal    BoolArr1, %eax          # 511:     &()    t242 <- BoolArr1
    movl    %eax, -656(%ebp)       
    movl    $2, %eax                # 512:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 513:     &()    t243 <- BoolArr1
    movl    %eax, -660(%ebp)       
    movl    -660(%ebp), %eax        # 514:     param  0 <- t243
    pushl   %eax                   
    call    DIM                     # 515:     call   t244 <- DIM
    addl    $8, %esp               
    movl    %eax, -664(%ebp)       
    movl    $2, %eax                # 516:     mul    t245 <- 2, t244
    movl    -664(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -668(%ebp)       
    movl    -668(%ebp), %eax        # 517:     add    t246 <- t245, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -672(%ebp)       
    movl    -672(%ebp), %eax        # 518:     mul    t247 <- t246, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -676(%ebp)       
    leal    BoolArr1, %eax          # 519:     &()    t248 <- BoolArr1
    movl    %eax, -680(%ebp)       
    movl    -680(%ebp), %eax        # 520:     param  0 <- t248
    pushl   %eax                   
    call    DOFS                    # 521:     call   t249 <- DOFS
    addl    $4, %esp               
    movl    %eax, -684(%ebp)       
    movl    -676(%ebp), %eax        # 522:     add    t250 <- t247, t249
    movl    -684(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -692(%ebp)       
    movl    -656(%ebp), %eax        # 523:     add    t251 <- t242, t250
    movl    -692(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -696(%ebp)       
    movl    -652(%ebp), %edi       
    movzbl  (%edi), %eax            # 524:     assign @t251 <- @t241
    movl    -696(%ebp), %edi       
    movb    %al, (%edi)            
    jmp     l_booltest1_102_while_cond # 525:     goto   102_while_cond
l_booltest1_101:
    jmp     l_booltest1_71_while_cond # 527:     goto   71_while_cond
l_booltest1_70:
    jmp     l_booltest1_68_while_cond # 529:     goto   68_while_cond
    jmp     l_booltest1_116         # 530:     goto   116
    movl    $1, %eax                # 531:     assign t252 <- 1
    movb    %al, -697(%ebp)        
    jmp     l_booltest1_117         # 532:     goto   117
l_booltest1_116:
    movl    $0, %eax                # 534:     assign t252 <- 0
    movb    %al, -697(%ebp)        
l_booltest1_117:
    movzbl  -697(%ebp), %eax        # 536:     assign p1 <- t252
    movb    %al, 8(%ebp)           
    movl    $1, %eax                # 537:     assign t253 <- 1
    movb    %al, -698(%ebp)        
    jmp     l_booltest1_121         # 538:     goto   121
    movl    $0, %eax                # 539:     assign t253 <- 0
    movb    %al, -698(%ebp)        
l_booltest1_121:
    movzbl  -698(%ebp), %eax        # 541:     assign p2 <- t253
    movb    %al, 12(%ebp)          
    movzbl  b0, %eax                # 542:     if     b0 = 1 goto 124
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_124        
    movl    $1, %eax                # 543:     assign t254 <- 1
    movb    %al, -699(%ebp)        
    jmp     l_booltest1_125         # 544:     goto   125
l_booltest1_124:
    movl    $0, %eax                # 546:     assign t254 <- 0
    movb    %al, -699(%ebp)        
l_booltest1_125:
    movzbl  -699(%ebp), %eax        # 548:     assign p1 <- t254
    movb    %al, 8(%ebp)           
    movzbl  12(%ebp), %eax          # 549:     if     p2 = 1 goto 128
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_128        
    movl    $1, %eax                # 550:     assign t255 <- 1
    movb    %al, -700(%ebp)        
    jmp     l_booltest1_129         # 551:     goto   129
l_booltest1_128:
    movl    $0, %eax                # 553:     assign t255 <- 0
    movb    %al, -700(%ebp)        
l_booltest1_129:
    movzbl  -700(%ebp), %eax        # 555:     assign p2 <- t255
    movb    %al, 12(%ebp)          
    movzbl  12(%ebp), %eax          # 556:     if     p2 = 1 goto 132
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_132        
    leal    BoolArr2, %eax          # 557:     &()    t256 <- BoolArr2
    movl    %eax, -704(%ebp)       
    movl    $2, %eax                # 558:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 559:     &()    t257 <- BoolArr2
    movl    %eax, -708(%ebp)       
    movl    -708(%ebp), %eax        # 560:     param  0 <- t257
    pushl   %eax                   
    call    DIM                     # 561:     call   t258 <- DIM
    addl    $8, %esp               
    movl    %eax, -712(%ebp)       
    movl    $3, %eax                # 562:     mul    t259 <- 3, t258
    movl    -712(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -716(%ebp)       
    movl    -716(%ebp), %eax        # 563:     add    t260 <- t259, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -724(%ebp)       
    movl    $3, %eax                # 564:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 565:     &()    t261 <- BoolArr2
    movl    %eax, -728(%ebp)       
    movl    -728(%ebp), %eax        # 566:     param  0 <- t261
    pushl   %eax                   
    call    DIM                     # 567:     call   t262 <- DIM
    addl    $8, %esp               
    movl    %eax, -732(%ebp)       
    movl    -724(%ebp), %eax        # 568:     mul    t263 <- t260, t262
    movl    -732(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -736(%ebp)       
    movl    -736(%ebp), %eax        # 569:     add    t264 <- t263, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -740(%ebp)       
    movl    -740(%ebp), %eax        # 570:     mul    t265 <- t264, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -744(%ebp)       
    leal    BoolArr2, %eax          # 571:     &()    t266 <- BoolArr2
    movl    %eax, -748(%ebp)       
    movl    -748(%ebp), %eax        # 572:     param  0 <- t266
    pushl   %eax                   
    call    DOFS                    # 573:     call   t267 <- DOFS
    addl    $4, %esp               
    movl    %eax, -752(%ebp)       
    movl    -744(%ebp), %eax        # 574:     add    t268 <- t265, t267
    movl    -752(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -756(%ebp)       
    movl    -704(%ebp), %eax        # 575:     add    t269 <- t256, t268
    movl    -756(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -760(%ebp)       
    movl    -760(%ebp), %edi       
    movzbl  (%edi), %eax            # 576:     if     @t269 = 1 goto 135
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_135        
    jmp     l_booltest1_131         # 577:     goto   131
l_booltest1_135:
    leal    BoolArr0, %eax          # 579:     &()    t270 <- BoolArr0
    movl    %eax, -768(%ebp)       
    movl    $1, %eax                # 580:     mul    t271 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -772(%ebp)       
    leal    BoolArr0, %eax          # 581:     &()    t272 <- BoolArr0
    movl    %eax, -776(%ebp)       
    movl    -776(%ebp), %eax        # 582:     param  0 <- t272
    pushl   %eax                   
    call    DOFS                    # 583:     call   t273 <- DOFS
    addl    $4, %esp               
    movl    %eax, -780(%ebp)       
    movl    -772(%ebp), %eax        # 584:     add    t274 <- t271, t273
    movl    -780(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -784(%ebp)       
    movl    -768(%ebp), %eax        # 585:     add    t275 <- t270, t274
    movl    -784(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -788(%ebp)       
    movl    -788(%ebp), %edi       
    movzbl  (%edi), %eax            # 586:     if     @t275 = 1 goto 132
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest1_132        
l_booltest1_131:
    movl    $1, %eax                # 588:     assign t276 <- 1
    movb    %al, -789(%ebp)        
    jmp     l_booltest1_133         # 589:     goto   133
l_booltest1_132:
    movl    $0, %eax                # 591:     assign t276 <- 0
    movb    %al, -789(%ebp)        
l_booltest1_133:
    movzbl  -789(%ebp), %eax        # 593:     assign p2 <- t276
    movb    %al, 12(%ebp)          
    jmp     l_booltest1_exit       

l_booltest1_exit:
    # epilogue
    addl    $1092, %esp             # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope booltest2
booltest2:
    # stack offsets:
    #      8(%ebp)   1  [ %p1       <bool> %ebp+8 ]
    #     12(%ebp)   1  [ %p2       <bool> %ebp+12 ]
    #     16(%ebp)   4  [ %p3       <ptr(4) to <array 5 of <bool>>> %ebp+16 ]
    #     20(%ebp)   4  [ %p4       <ptr(4) to <array 5 of <bool>>> %ebp+20 ]
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t11      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t12      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t13      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t14      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t15      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t16      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t17      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-52 ]
    #    -56(%ebp)   4  [ $t18      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-56 ]
    #    -60(%ebp)   4  [ $t19      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t2       <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t20      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t21      <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t22      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t23      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-80 ]
    #    -84(%ebp)   4  [ $t24      <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t25      <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t26      <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t27      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-96 ]
    #   -100(%ebp)   4  [ $t28      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-100 ]
    #   -104(%ebp)   4  [ $t29      <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t3       <int> %ebp-108 ]
    #   -112(%ebp)   4  [ $t30      <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t31      <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t32      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-120 ]
    #   -124(%ebp)   4  [ $t33      <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t34      <int> %ebp-128 ]
    #   -132(%ebp)   4  [ $t35      <int> %ebp-132 ]
    #   -136(%ebp)   4  [ $t36      <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t37      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-140 ]
    #   -144(%ebp)   4  [ $t38      <int> %ebp-144 ]
    #   -148(%ebp)   4  [ $t39      <int> %ebp-148 ]
    #   -152(%ebp)   4  [ $t4       <int> %ebp-152 ]
    #   -156(%ebp)   4  [ $t40      <int> %ebp-156 ]
    #   -160(%ebp)   4  [ $t41      <int> %ebp-160 ]
    #   -164(%ebp)   4  [ $t42      <int> %ebp-164 ]
    #   -168(%ebp)   4  [ $t43      <int> %ebp-168 ]
    #   -172(%ebp)   4  [ $t44      <int> %ebp-172 ]
    #   -176(%ebp)   4  [ $t45      <int> %ebp-176 ]
    #   -180(%ebp)   4  [ $t46      <int> %ebp-180 ]
    #   -184(%ebp)   4  [ $t47      <int> %ebp-184 ]
    #   -188(%ebp)   4  [ $t48      <int> %ebp-188 ]
    #   -189(%ebp)   1  [ $t49      <bool> %ebp-189 ]
    #   -196(%ebp)   4  [ $t5       <int> %ebp-196 ]
    #   -200(%ebp)   4  [ $t6       <int> %ebp-200 ]
    #   -204(%ebp)   4  [ $t7       <int> %ebp-204 ]
    #   -208(%ebp)   4  [ $t8       <ptr(4) to <array 15 of <char>>> %ebp-208 ]
    #   -212(%ebp)   4  [ $t9       <int> %ebp-212 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $200, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $50, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    jmp     l_booltest2_5_if_false  #   0:     goto   5_if_false
    movl    $2, %eax                #   1:     mul    t0 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -16(%ebp)        
    movl    16(%ebp), %eax          #   2:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #   3:     call   t1 <- DOFS
    addl    $4, %esp               
    movl    %eax, -20(%ebp)        
    movl    -16(%ebp), %eax         #   4:     add    t2 <- t0, t1
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    16(%ebp), %eax          #   5:     add    t3 <- p3, t2
    movl    -64(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %edi       
    movzbl  (%edi), %eax            #   6:     if     @t3 = 1 goto 10
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_10         
    jmp     l_booltest2_8_if_false  #   7:     goto   8_if_false
l_booltest2_10:
    movl    $1, %eax                #   9:     mul    t4 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -152(%ebp)       
    movl    20(%ebp), %eax          #  10:     param  0 <- p4
    pushl   %eax                   
    call    DOFS                    #  11:     call   t5 <- DOFS
    addl    $4, %esp               
    movl    %eax, -196(%ebp)       
    movl    -152(%ebp), %eax        #  12:     add    t6 <- t4, t5
    movl    -196(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -200(%ebp)       
    movl    20(%ebp), %eax          #  13:     add    t7 <- p4, t6
    movl    -200(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -204(%ebp)       
    movl    -204(%ebp), %edi       
    movzbl  (%edi), %eax            #  14:     if     @t7 = 1 goto 9
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_9          
    jmp     l_booltest2_8_if_false  #  15:     goto   8_if_false
l_booltest2_9:
    movzbl  8(%ebp), %eax           #  17:     if     p1 = 1 goto 8_if_false
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_8_if_false 
    leal    _str_13, %eax           #  18:     &()    t8 <- _str_13
    movl    %eax, -208(%ebp)       
    movl    -208(%ebp), %eax        #  19:     param  0 <- t8
    pushl   %eax                   
    call    WriteStr                #  20:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  21:     mul    t9 <- 0, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -212(%ebp)       
    movl    16(%ebp), %eax          #  22:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #  23:     call   t10 <- DOFS
    addl    $4, %esp               
    movl    %eax, -24(%ebp)        
    movl    -212(%ebp), %eax        #  24:     add    t11 <- t9, t10
    movl    -24(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    16(%ebp), %eax          #  25:     add    t12 <- p3, t11
    movl    -28(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %edi        
    movzbl  (%edi), %eax            #  26:     if     @t12 = 1 goto 13_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_13_if_true 
    jmp     l_booltest2_14_if_false #  27:     goto   14_if_false
l_booltest2_13_if_true:
    movl    $1, %eax                #  29:     return 1
    jmp     l_booltest2_exit       
    jmp     l_booltest2_12          #  30:     goto   12
l_booltest2_14_if_false:
    movl    $0, %eax                #  32:     return 0
    jmp     l_booltest2_exit       
l_booltest2_12:
    jmp     l_booltest2_6           #  34:     goto   6
l_booltest2_8_if_false:
    movl    $2, %eax                #  36:     mul    t13 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -36(%ebp)        
    movl    16(%ebp), %eax          #  37:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #  38:     call   t14 <- DOFS
    addl    $4, %esp               
    movl    %eax, -40(%ebp)        
    movl    -36(%ebp), %eax         #  39:     add    t15 <- t13, t14
    movl    -40(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -44(%ebp)        
    movl    16(%ebp), %eax          #  40:     add    t16 <- p3, t15
    movl    -44(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %edi        
    movzbl  (%edi), %eax            #  41:     if     @t16 = 1 goto 23
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_23         
    jmp     l_booltest2_22          #  42:     goto   22
l_booltest2_23:
    leal    BoolArr1, %eax          #  44:     &()    t17 <- BoolArr1
    movl    %eax, -52(%ebp)        
    movl    $2, %eax                #  45:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          #  46:     &()    t18 <- BoolArr1
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         #  47:     param  0 <- t18
    pushl   %eax                   
    call    DIM                     #  48:     call   t19 <- DIM
    addl    $8, %esp               
    movl    %eax, -60(%ebp)        
    movl    $1, %eax                #  49:     mul    t20 <- 1, t19
    movl    -60(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         #  50:     add    t21 <- t20, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %eax         #  51:     mul    t22 <- t21, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -76(%ebp)        
    leal    BoolArr1, %eax          #  52:     &()    t23 <- BoolArr1
    movl    %eax, -80(%ebp)        
    movl    -80(%ebp), %eax         #  53:     param  0 <- t23
    pushl   %eax                   
    call    DOFS                    #  54:     call   t24 <- DOFS
    addl    $4, %esp               
    movl    %eax, -84(%ebp)        
    movl    -76(%ebp), %eax         #  55:     add    t25 <- t22, t24
    movl    -84(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -88(%ebp)        
    movl    -52(%ebp), %eax         #  56:     add    t26 <- t17, t25
    movl    -88(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -92(%ebp)        
    movl    -92(%ebp), %edi        
    movzbl  (%edi), %eax            #  57:     if     @t26 = 1 goto 18
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_18         
l_booltest2_22:
    leal    BoolArr2, %eax          #  59:     &()    t27 <- BoolArr2
    movl    %eax, -96(%ebp)        
    movl    $2, %eax                #  60:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          #  61:     &()    t28 <- BoolArr2
    movl    %eax, -100(%ebp)       
    movl    -100(%ebp), %eax        #  62:     param  0 <- t28
    pushl   %eax                   
    call    DIM                     #  63:     call   t29 <- DIM
    addl    $8, %esp               
    movl    %eax, -104(%ebp)       
    movl    $1, %eax                #  64:     mul    t30 <- 1, t29
    movl    -104(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -112(%ebp)       
    movl    -112(%ebp), %eax        #  65:     add    t31 <- t30, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -116(%ebp)       
    movl    $3, %eax                #  66:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          #  67:     &()    t32 <- BoolArr2
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %eax        #  68:     param  0 <- t32
    pushl   %eax                   
    call    DIM                     #  69:     call   t33 <- DIM
    addl    $8, %esp               
    movl    %eax, -124(%ebp)       
    movl    -116(%ebp), %eax        #  70:     mul    t34 <- t31, t33
    movl    -124(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -128(%ebp)       
    movl    -128(%ebp), %eax        #  71:     add    t35 <- t34, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -132(%ebp)       
    movl    -132(%ebp), %eax        #  72:     mul    t36 <- t35, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -136(%ebp)       
    leal    BoolArr2, %eax          #  73:     &()    t37 <- BoolArr2
    movl    %eax, -140(%ebp)       
    movl    -140(%ebp), %eax        #  74:     param  0 <- t37
    pushl   %eax                   
    call    DOFS                    #  75:     call   t38 <- DOFS
    addl    $4, %esp               
    movl    %eax, -144(%ebp)       
    movl    -136(%ebp), %eax        #  76:     add    t39 <- t36, t38
    movl    -144(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -148(%ebp)       
    movl    -96(%ebp), %eax         #  77:     add    t40 <- t27, t39
    movl    -148(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -156(%ebp)       
    movl    -156(%ebp), %edi       
    movzbl  (%edi), %eax            #  78:     if     @t40 = 1 goto 21
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_21         
    jmp     l_booltest2_18          #  79:     goto   18
l_booltest2_21:
    movl    $1, %eax                #  81:     mul    t41 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -160(%ebp)       
    movl    16(%ebp), %eax          #  82:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #  83:     call   t42 <- DOFS
    addl    $4, %esp               
    movl    %eax, -164(%ebp)       
    movl    -160(%ebp), %eax        #  84:     add    t43 <- t41, t42
    movl    -164(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -168(%ebp)       
    movl    16(%ebp), %eax          #  85:     add    t44 <- p3, t43
    movl    -168(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -172(%ebp)       
    movl    -172(%ebp), %edi       
    movzbl  (%edi), %eax            #  86:     if     @t44 = 1 goto 19
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_19         
    movl    $1, %eax                #  87:     mul    t45 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -176(%ebp)       
    movl    20(%ebp), %eax          #  88:     param  0 <- p4
    pushl   %eax                   
    call    DOFS                    #  89:     call   t46 <- DOFS
    addl    $4, %esp               
    movl    %eax, -180(%ebp)       
    movl    -176(%ebp), %eax        #  90:     add    t47 <- t45, t46
    movl    -180(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -184(%ebp)       
    movl    20(%ebp), %eax          #  91:     add    t48 <- p4, t47
    movl    -184(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -188(%ebp)       
    movl    -188(%ebp), %edi       
    movzbl  (%edi), %eax            #  92:     if     @t48 = 1 goto 19
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_19         
l_booltest2_18:
    movl    $1, %eax                #  94:     assign t49 <- 1
    movb    %al, -189(%ebp)        
    jmp     l_booltest2_20          #  95:     goto   20
l_booltest2_19:
    movl    $0, %eax                #  97:     assign t49 <- 0
    movb    %al, -189(%ebp)        
l_booltest2_20:
    movzbl  -189(%ebp), %eax        #  99:     return t49
    jmp     l_booltest2_exit       
l_booltest2_6:
    jmp     l_booltest2_3           # 101:     goto   3
l_booltest2_5_if_false:
    movzbl  8(%ebp), %eax           # 103:     return p1
    jmp     l_booltest2_exit       
l_booltest2_3:
    jmp     l_booltest2_0           # 105:     goto   0
    movzbl  12(%ebp), %eax          # 106:     return p2
    jmp     l_booltest2_exit       
l_booltest2_0:
    movl    $0, %eax                # 108:     return 0
    jmp     l_booltest2_exit       

l_booltest2_exit:
    # epilogue
    addl    $200, %esp              # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope booltest3
booltest3:
    # stack offsets:
    #      8(%ebp)   4  [ %p1       <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp+8 ]
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <bool>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t11      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t12      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t13      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t2       <ptr(4) to <array 5 of <bool>>> %ebp-40 ]
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
    leal    BoolArr0, %eax          #   0:     &()    t0 <- BoolArr0
    movl    %eax, -16(%ebp)        
    movl    $1, %eax                #   1:     mul    t1 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    leal    BoolArr0, %eax          #   2:     &()    t2 <- BoolArr0
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #   3:     param  0 <- t2
    pushl   %eax                   
    call    DOFS                    #   4:     call   t3 <- DOFS
    addl    $4, %esp               
    movl    %eax, -44(%ebp)        
    movl    -20(%ebp), %eax         #   5:     add    t4 <- t1, t3
    movl    -44(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -16(%ebp), %eax         #   6:     add    t5 <- t0, t4
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    $2, %eax                #   7:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #   8:     param  0 <- p1
    pushl   %eax                   
    call    DIM                     #   9:     call   t6 <- DIM
    addl    $8, %esp               
    movl    %eax, -56(%ebp)        
    movl    i0, %eax                #  10:     mul    t7 <- i0, t6
    movl    -56(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -60(%ebp)        
    movl    i1, %eax                #  11:     mul    t8 <- i1, i2
    movl    i2, %ebx               
    imull   %ebx                   
    movl    %eax, -64(%ebp)        
    movl    -60(%ebp), %eax         #  12:     add    t9 <- t7, t8
    movl    -64(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         #  13:     mul    t10 <- t9, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -24(%ebp)        
    movl    8(%ebp), %eax           #  14:     param  0 <- p1
    pushl   %eax                   
    call    DOFS                    #  15:     call   t11 <- DOFS
    addl    $4, %esp               
    movl    %eax, -28(%ebp)        
    movl    -24(%ebp), %eax         #  16:     add    t12 <- t10, t11
    movl    -28(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    8(%ebp), %eax           #  17:     add    t13 <- p1, t12
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -36(%ebp)        
    movl    -52(%ebp), %edi        
    movzbl  (%edi), %eax            #  18:     assign @t13 <- @t5
    movl    -36(%ebp), %edi        
    movb    %al, (%edi)            
    jmp     l_booltest3_exit       

l_booltest3_exit:
    # epilogue
    addl    $56, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test08
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <bool>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t100     <ptr(4) to <bool>> %ebp-28 ]
    #    -32(%ebp)   4  [ $t101     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-32 ]
    #    -36(%ebp)   4  [ $t102     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-36 ]
    #    -40(%ebp)   4  [ $t103     <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t104     <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t105     <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t106     <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t107     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-56 ]
    #    -60(%ebp)   4  [ $t108     <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t109     <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t11      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t110     <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t111     <ptr(4) to <array 5 of <bool>>> %ebp-76 ]
    #    -80(%ebp)   4  [ $t112     <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t113     <ptr(4) to <array 5 of <bool>>> %ebp-84 ]
    #    -88(%ebp)   4  [ $t114     <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t115     <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t116     <int> %ebp-96 ]
    #    -97(%ebp)   1  [ $t117     <bool> %ebp-97 ]
    #   -104(%ebp)   4  [ $t118     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-104 ]
    #   -108(%ebp)   4  [ $t119     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-108 ]
    #   -112(%ebp)   4  [ $t12      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-112 ]
    #   -116(%ebp)   4  [ $t120     <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t121     <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t122     <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t123     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-128 ]
    #   -132(%ebp)   4  [ $t124     <int> %ebp-132 ]
    #   -136(%ebp)   4  [ $t125     <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t126     <int> %ebp-140 ]
    #   -144(%ebp)   4  [ $t127     <int> %ebp-144 ]
    #   -148(%ebp)   4  [ $t128     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-148 ]
    #   -152(%ebp)   4  [ $t129     <int> %ebp-152 ]
    #   -156(%ebp)   4  [ $t13      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-156 ]
    #   -160(%ebp)   4  [ $t130     <int> %ebp-160 ]
    #   -164(%ebp)   4  [ $t131     <int> %ebp-164 ]
    #   -168(%ebp)   4  [ $t132     <ptr(4) to <bool>> %ebp-168 ]
    #   -172(%ebp)   4  [ $t133     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-172 ]
    #   -176(%ebp)   4  [ $t134     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-176 ]
    #   -180(%ebp)   4  [ $t135     <int> %ebp-180 ]
    #   -184(%ebp)   4  [ $t136     <int> %ebp-184 ]
    #   -188(%ebp)   4  [ $t137     <int> %ebp-188 ]
    #   -192(%ebp)   4  [ $t138     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-192 ]
    #   -196(%ebp)   4  [ $t139     <int> %ebp-196 ]
    #   -200(%ebp)   4  [ $t14      <int> %ebp-200 ]
    #   -204(%ebp)   4  [ $t140     <int> %ebp-204 ]
    #   -208(%ebp)   4  [ $t141     <int> %ebp-208 ]
    #   -212(%ebp)   4  [ $t142     <int> %ebp-212 ]
    #   -216(%ebp)   4  [ $t143     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-216 ]
    #   -220(%ebp)   4  [ $t144     <int> %ebp-220 ]
    #   -224(%ebp)   4  [ $t145     <int> %ebp-224 ]
    #   -228(%ebp)   4  [ $t146     <int> %ebp-228 ]
    #   -232(%ebp)   4  [ $t147     <ptr(4) to <bool>> %ebp-232 ]
    #   -236(%ebp)   4  [ $t148     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-236 ]
    #   -240(%ebp)   4  [ $t149     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-240 ]
    #   -244(%ebp)   4  [ $t15      <int> %ebp-244 ]
    #   -248(%ebp)   4  [ $t150     <int> %ebp-248 ]
    #   -252(%ebp)   4  [ $t151     <int> %ebp-252 ]
    #   -256(%ebp)   4  [ $t152     <int> %ebp-256 ]
    #   -260(%ebp)   4  [ $t153     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-260 ]
    #   -264(%ebp)   4  [ $t154     <int> %ebp-264 ]
    #   -268(%ebp)   4  [ $t155     <int> %ebp-268 ]
    #   -272(%ebp)   4  [ $t156     <int> %ebp-272 ]
    #   -276(%ebp)   4  [ $t157     <int> %ebp-276 ]
    #   -280(%ebp)   4  [ $t158     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-280 ]
    #   -284(%ebp)   4  [ $t159     <int> %ebp-284 ]
    #   -288(%ebp)   4  [ $t16      <int> %ebp-288 ]
    #   -292(%ebp)   4  [ $t160     <int> %ebp-292 ]
    #   -296(%ebp)   4  [ $t161     <int> %ebp-296 ]
    #   -300(%ebp)   4  [ $t162     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-300 ]
    #   -304(%ebp)   4  [ $t163     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-304 ]
    #   -308(%ebp)   4  [ $t164     <int> %ebp-308 ]
    #   -312(%ebp)   4  [ $t165     <int> %ebp-312 ]
    #   -316(%ebp)   4  [ $t166     <int> %ebp-316 ]
    #   -320(%ebp)   4  [ $t167     <int> %ebp-320 ]
    #   -324(%ebp)   4  [ $t168     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-324 ]
    #   -328(%ebp)   4  [ $t169     <int> %ebp-328 ]
    #   -332(%ebp)   4  [ $t17      <int> %ebp-332 ]
    #   -336(%ebp)   4  [ $t170     <int> %ebp-336 ]
    #   -340(%ebp)   4  [ $t171     <int> %ebp-340 ]
    #   -341(%ebp)   1  [ $t172     <bool> %ebp-341 ]
    #   -342(%ebp)   1  [ $t173     <bool> %ebp-342 ]
    #   -348(%ebp)   4  [ $t174     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-348 ]
    #   -352(%ebp)   4  [ $t175     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-352 ]
    #   -356(%ebp)   4  [ $t176     <int> %ebp-356 ]
    #   -360(%ebp)   4  [ $t177     <int> %ebp-360 ]
    #   -364(%ebp)   4  [ $t178     <int> %ebp-364 ]
    #   -368(%ebp)   4  [ $t179     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-368 ]
    #   -372(%ebp)   4  [ $t18      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-372 ]
    #   -376(%ebp)   4  [ $t180     <int> %ebp-376 ]
    #   -380(%ebp)   4  [ $t181     <int> %ebp-380 ]
    #   -384(%ebp)   4  [ $t182     <int> %ebp-384 ]
    #   -388(%ebp)   4  [ $t183     <int> %ebp-388 ]
    #   -392(%ebp)   4  [ $t184     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-392 ]
    #   -396(%ebp)   4  [ $t185     <int> %ebp-396 ]
    #   -400(%ebp)   4  [ $t186     <int> %ebp-400 ]
    #   -404(%ebp)   4  [ $t187     <int> %ebp-404 ]
    #   -408(%ebp)   4  [ $t188     <ptr(4) to <bool>> %ebp-408 ]
    #   -412(%ebp)   4  [ $t189     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-412 ]
    #   -416(%ebp)   4  [ $t19      <int> %ebp-416 ]
    #   -420(%ebp)   4  [ $t190     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-420 ]
    #   -424(%ebp)   4  [ $t191     <int> %ebp-424 ]
    #   -428(%ebp)   4  [ $t192     <int> %ebp-428 ]
    #   -432(%ebp)   4  [ $t193     <int> %ebp-432 ]
    #   -436(%ebp)   4  [ $t194     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-436 ]
    #   -440(%ebp)   4  [ $t195     <int> %ebp-440 ]
    #   -444(%ebp)   4  [ $t196     <int> %ebp-444 ]
    #   -448(%ebp)   4  [ $t197     <int> %ebp-448 ]
    #   -452(%ebp)   4  [ $t198     <int> %ebp-452 ]
    #   -456(%ebp)   4  [ $t199     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-456 ]
    #   -460(%ebp)   4  [ $t2       <ptr(4) to <array 5 of <bool>>> %ebp-460 ]
    #   -464(%ebp)   4  [ $t20      <int> %ebp-464 ]
    #   -468(%ebp)   4  [ $t200     <int> %ebp-468 ]
    #   -472(%ebp)   4  [ $t201     <int> %ebp-472 ]
    #   -476(%ebp)   4  [ $t202     <int> %ebp-476 ]
    #   -480(%ebp)   4  [ $t203     <ptr(4) to <bool>> %ebp-480 ]
    #   -481(%ebp)   1  [ $t204     <bool> %ebp-481 ]
    #   -482(%ebp)   1  [ $t205     <bool> %ebp-482 ]
    #   -488(%ebp)   4  [ $t206     <ptr(4) to <array 5 of <bool>>> %ebp-488 ]
    #   -492(%ebp)   4  [ $t207     <ptr(4) to <array 5 of <bool>>> %ebp-492 ]
    #   -493(%ebp)   1  [ $t208     <bool> %ebp-493 ]
    #   -500(%ebp)   4  [ $t209     <ptr(4) to <array 5 of <bool>>> %ebp-500 ]
    #   -504(%ebp)   4  [ $t21      <int> %ebp-504 ]
    #   -508(%ebp)   4  [ $t210     <ptr(4) to <array 5 of <bool>>> %ebp-508 ]
    #   -512(%ebp)   4  [ $t211     <ptr(4) to <array 5 of <bool>>> %ebp-512 ]
    #   -516(%ebp)   4  [ $t212     <int> %ebp-516 ]
    #   -520(%ebp)   4  [ $t213     <ptr(4) to <array 5 of <bool>>> %ebp-520 ]
    #   -524(%ebp)   4  [ $t214     <int> %ebp-524 ]
    #   -528(%ebp)   4  [ $t215     <int> %ebp-528 ]
    #   -532(%ebp)   4  [ $t216     <int> %ebp-532 ]
    #   -536(%ebp)   4  [ $t217     <ptr(4) to <array 5 of <bool>>> %ebp-536 ]
    #   -540(%ebp)   4  [ $t218     <int> %ebp-540 ]
    #   -544(%ebp)   4  [ $t219     <ptr(4) to <array 5 of <bool>>> %ebp-544 ]
    #   -548(%ebp)   4  [ $t22      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-548 ]
    #   -552(%ebp)   4  [ $t220     <int> %ebp-552 ]
    #   -556(%ebp)   4  [ $t221     <int> %ebp-556 ]
    #   -560(%ebp)   4  [ $t222     <int> %ebp-560 ]
    #   -561(%ebp)   1  [ $t223     <bool> %ebp-561 ]
    #   -568(%ebp)   4  [ $t224     <ptr(4) to <array 15 of <char>>> %ebp-568 ]
    #   -572(%ebp)   4  [ $t225     <ptr(4) to <array 23 of <char>>> %ebp-572 ]
    #   -576(%ebp)   4  [ $t23      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-576 ]
    #   -580(%ebp)   4  [ $t24      <int> %ebp-580 ]
    #   -584(%ebp)   4  [ $t25      <int> %ebp-584 ]
    #   -588(%ebp)   4  [ $t26      <int> %ebp-588 ]
    #   -592(%ebp)   4  [ $t27      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-592 ]
    #   -596(%ebp)   4  [ $t28      <int> %ebp-596 ]
    #   -600(%ebp)   4  [ $t29      <int> %ebp-600 ]
    #   -604(%ebp)   4  [ $t3       <int> %ebp-604 ]
    #   -608(%ebp)   4  [ $t30      <int> %ebp-608 ]
    #   -612(%ebp)   4  [ $t31      <int> %ebp-612 ]
    #   -616(%ebp)   4  [ $t32      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-616 ]
    #   -620(%ebp)   4  [ $t33      <int> %ebp-620 ]
    #   -624(%ebp)   4  [ $t34      <int> %ebp-624 ]
    #   -628(%ebp)   4  [ $t35      <int> %ebp-628 ]
    #   -632(%ebp)   4  [ $t36      <ptr(4) to <array 5 of <bool>>> %ebp-632 ]
    #   -636(%ebp)   4  [ $t37      <int> %ebp-636 ]
    #   -640(%ebp)   4  [ $t38      <ptr(4) to <array 5 of <bool>>> %ebp-640 ]
    #   -644(%ebp)   4  [ $t39      <int> %ebp-644 ]
    #   -648(%ebp)   4  [ $t4       <int> %ebp-648 ]
    #   -652(%ebp)   4  [ $t40      <int> %ebp-652 ]
    #   -656(%ebp)   4  [ $t41      <int> %ebp-656 ]
    #   -660(%ebp)   4  [ $t42      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-660 ]
    #   -664(%ebp)   4  [ $t43      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-664 ]
    #   -668(%ebp)   4  [ $t44      <int> %ebp-668 ]
    #   -672(%ebp)   4  [ $t45      <int> %ebp-672 ]
    #   -676(%ebp)   4  [ $t46      <int> %ebp-676 ]
    #   -680(%ebp)   4  [ $t47      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-680 ]
    #   -684(%ebp)   4  [ $t48      <int> %ebp-684 ]
    #   -688(%ebp)   4  [ $t49      <int> %ebp-688 ]
    #   -692(%ebp)   4  [ $t5       <int> %ebp-692 ]
    #   -696(%ebp)   4  [ $t50      <int> %ebp-696 ]
    #   -700(%ebp)   4  [ $t51      <int> %ebp-700 ]
    #   -704(%ebp)   4  [ $t52      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-704 ]
    #   -708(%ebp)   4  [ $t53      <int> %ebp-708 ]
    #   -712(%ebp)   4  [ $t54      <int> %ebp-712 ]
    #   -716(%ebp)   4  [ $t55      <int> %ebp-716 ]
    #   -720(%ebp)   4  [ $t56      <ptr(4) to <array 5 of <bool>>> %ebp-720 ]
    #   -724(%ebp)   4  [ $t57      <ptr(4) to <array 5 of <bool>>> %ebp-724 ]
    #   -725(%ebp)   1  [ $t58      <bool> %ebp-725 ]
    #   -732(%ebp)   4  [ $t59      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-732 ]
    #   -736(%ebp)   4  [ $t6       <ptr(4) to <array 5 of <bool>>> %ebp-736 ]
    #   -740(%ebp)   4  [ $t60      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-740 ]
    #   -744(%ebp)   4  [ $t61      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-744 ]
    #   -748(%ebp)   4  [ $t62      <int> %ebp-748 ]
    #   -752(%ebp)   4  [ $t63      <int> %ebp-752 ]
    #   -756(%ebp)   4  [ $t64      <int> %ebp-756 ]
    #   -760(%ebp)   4  [ $t65      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-760 ]
    #   -764(%ebp)   4  [ $t66      <int> %ebp-764 ]
    #   -768(%ebp)   4  [ $t67      <int> %ebp-768 ]
    #   -772(%ebp)   4  [ $t68      <int> %ebp-772 ]
    #   -776(%ebp)   4  [ $t69      <int> %ebp-776 ]
    #   -780(%ebp)   4  [ $t7       <int> %ebp-780 ]
    #   -784(%ebp)   4  [ $t70      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-784 ]
    #   -788(%ebp)   4  [ $t71      <int> %ebp-788 ]
    #   -792(%ebp)   4  [ $t72      <int> %ebp-792 ]
    #   -796(%ebp)   4  [ $t73      <int> %ebp-796 ]
    #   -800(%ebp)   4  [ $t74      <ptr(4) to <bool>> %ebp-800 ]
    #   -804(%ebp)   4  [ $t75      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-804 ]
    #   -808(%ebp)   4  [ $t76      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-808 ]
    #   -812(%ebp)   4  [ $t77      <int> %ebp-812 ]
    #   -816(%ebp)   4  [ $t78      <int> %ebp-816 ]
    #   -820(%ebp)   4  [ $t79      <int> %ebp-820 ]
    #   -824(%ebp)   4  [ $t8       <ptr(4) to <array 5 of <bool>>> %ebp-824 ]
    #   -828(%ebp)   4  [ $t80      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-828 ]
    #   -832(%ebp)   4  [ $t81      <int> %ebp-832 ]
    #   -836(%ebp)   4  [ $t82      <int> %ebp-836 ]
    #   -840(%ebp)   4  [ $t83      <int> %ebp-840 ]
    #   -844(%ebp)   4  [ $t84      <int> %ebp-844 ]
    #   -848(%ebp)   4  [ $t85      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-848 ]
    #   -852(%ebp)   4  [ $t86      <int> %ebp-852 ]
    #   -856(%ebp)   4  [ $t87      <int> %ebp-856 ]
    #   -860(%ebp)   4  [ $t88      <int> %ebp-860 ]
    #   -864(%ebp)   4  [ $t89      <ptr(4) to <bool>> %ebp-864 ]
    #   -868(%ebp)   4  [ $t9       <int> %ebp-868 ]
    #   -872(%ebp)   4  [ $t90      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-872 ]
    #   -876(%ebp)   4  [ $t91      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-876 ]
    #   -880(%ebp)   4  [ $t92      <int> %ebp-880 ]
    #   -884(%ebp)   4  [ $t93      <int> %ebp-884 ]
    #   -888(%ebp)   4  [ $t94      <int> %ebp-888 ]
    #   -892(%ebp)   4  [ $t95      <int> %ebp-892 ]
    #   -896(%ebp)   4  [ $t96      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-896 ]
    #   -900(%ebp)   4  [ $t97      <int> %ebp-900 ]
    #   -904(%ebp)   4  [ $t98      <int> %ebp-904 ]
    #   -908(%ebp)   4  [ $t99      <int> %ebp-908 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $896, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $224, %ecx             
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    leal    BoolArr0, %eax          #   0:     &()    t0 <- BoolArr0
    movl    %eax, -16(%ebp)        
    movl    $2, %eax                #   1:     mul    t1 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    leal    BoolArr0, %eax          #   2:     &()    t2 <- BoolArr0
    movl    %eax, -460(%ebp)       
    movl    -460(%ebp), %eax        #   3:     param  0 <- t2
    pushl   %eax                   
    call    DOFS                    #   4:     call   t3 <- DOFS
    addl    $4, %esp               
    movl    %eax, -604(%ebp)       
    movl    -20(%ebp), %eax         #   5:     add    t4 <- t1, t3
    movl    -604(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -648(%ebp)       
    movl    -16(%ebp), %eax         #   6:     add    t5 <- t0, t4
    movl    -648(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -692(%ebp)       
    movl    -692(%ebp), %edi       
    movzbl  (%edi), %eax            #   7:     param  1 <- @t5
    pushl   %eax                   
    leal    BoolArr0, %eax          #   8:     &()    t6 <- BoolArr0
    movl    %eax, -736(%ebp)       
    movl    $1, %eax                #   9:     mul    t7 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -780(%ebp)       
    leal    BoolArr0, %eax          #  10:     &()    t8 <- BoolArr0
    movl    %eax, -824(%ebp)       
    movl    -824(%ebp), %eax        #  11:     param  0 <- t8
    pushl   %eax                   
    call    DOFS                    #  12:     call   t9 <- DOFS
    addl    $4, %esp               
    movl    %eax, -868(%ebp)       
    movl    -780(%ebp), %eax        #  13:     add    t10 <- t7, t9
    movl    -868(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -736(%ebp), %eax        #  14:     add    t11 <- t6, t10
    movl    -24(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %edi        
    movzbl  (%edi), %eax            #  15:     param  0 <- @t11
    pushl   %eax                   
    call    booltest1               #  16:     call   booltest1
    addl    $8, %esp               
    leal    BoolArr1, %eax          #  17:     &()    t12 <- BoolArr1
    movl    %eax, -112(%ebp)       
    movl    $2, %eax                #  18:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          #  19:     &()    t13 <- BoolArr1
    movl    %eax, -156(%ebp)       
    movl    -156(%ebp), %eax        #  20:     param  0 <- t13
    pushl   %eax                   
    call    DIM                     #  21:     call   t14 <- DIM
    addl    $8, %esp               
    movl    %eax, -200(%ebp)       
    movl    $2, %eax                #  22:     mul    t15 <- 2, t14
    movl    -200(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -244(%ebp)       
    movl    -244(%ebp), %eax        #  23:     add    t16 <- t15, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -288(%ebp)       
    movl    -288(%ebp), %eax        #  24:     mul    t17 <- t16, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -332(%ebp)       
    leal    BoolArr1, %eax          #  25:     &()    t18 <- BoolArr1
    movl    %eax, -372(%ebp)       
    movl    -372(%ebp), %eax        #  26:     param  0 <- t18
    pushl   %eax                   
    call    DOFS                    #  27:     call   t19 <- DOFS
    addl    $4, %esp               
    movl    %eax, -416(%ebp)       
    movl    -332(%ebp), %eax        #  28:     add    t20 <- t17, t19
    movl    -416(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -464(%ebp)       
    movl    -112(%ebp), %eax        #  29:     add    t21 <- t12, t20
    movl    -464(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -504(%ebp)       
    movl    -504(%ebp), %edi       
    movzbl  (%edi), %eax            #  30:     param  1 <- @t21
    pushl   %eax                   
    leal    BoolArr2, %eax          #  31:     &()    t22 <- BoolArr2
    movl    %eax, -548(%ebp)       
    movl    $2, %eax                #  32:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          #  33:     &()    t23 <- BoolArr2
    movl    %eax, -576(%ebp)       
    movl    -576(%ebp), %eax        #  34:     param  0 <- t23
    pushl   %eax                   
    call    DIM                     #  35:     call   t24 <- DIM
    addl    $8, %esp               
    movl    %eax, -580(%ebp)       
    movl    $1, %eax                #  36:     mul    t25 <- 1, t24
    movl    -580(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -584(%ebp)       
    movl    -584(%ebp), %eax        #  37:     add    t26 <- t25, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -588(%ebp)       
    movl    $3, %eax                #  38:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          #  39:     &()    t27 <- BoolArr2
    movl    %eax, -592(%ebp)       
    movl    -592(%ebp), %eax        #  40:     param  0 <- t27
    pushl   %eax                   
    call    DIM                     #  41:     call   t28 <- DIM
    addl    $8, %esp               
    movl    %eax, -596(%ebp)       
    movl    -588(%ebp), %eax        #  42:     mul    t29 <- t26, t28
    movl    -596(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -600(%ebp)       
    movl    -600(%ebp), %eax        #  43:     add    t30 <- t29, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -608(%ebp)       
    movl    -608(%ebp), %eax        #  44:     mul    t31 <- t30, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -612(%ebp)       
    leal    BoolArr2, %eax          #  45:     &()    t32 <- BoolArr2
    movl    %eax, -616(%ebp)       
    movl    -616(%ebp), %eax        #  46:     param  0 <- t32
    pushl   %eax                   
    call    DOFS                    #  47:     call   t33 <- DOFS
    addl    $4, %esp               
    movl    %eax, -620(%ebp)       
    movl    -612(%ebp), %eax        #  48:     add    t34 <- t31, t33
    movl    -620(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -624(%ebp)       
    movl    -548(%ebp), %eax        #  49:     add    t35 <- t22, t34
    movl    -624(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -628(%ebp)       
    movl    -628(%ebp), %edi       
    movzbl  (%edi), %eax            #  50:     param  0 <- @t35
    pushl   %eax                   
    call    booltest1               #  51:     call   booltest1
    addl    $8, %esp               
    leal    BoolArr0, %eax          #  52:     &()    t36 <- BoolArr0
    movl    %eax, -632(%ebp)       
    movl    $1, %eax                #  53:     mul    t37 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -636(%ebp)       
    leal    BoolArr0, %eax          #  54:     &()    t38 <- BoolArr0
    movl    %eax, -640(%ebp)       
    movl    -640(%ebp), %eax        #  55:     param  0 <- t38
    pushl   %eax                   
    call    DOFS                    #  56:     call   t39 <- DOFS
    addl    $4, %esp               
    movl    %eax, -644(%ebp)       
    movl    -636(%ebp), %eax        #  57:     add    t40 <- t37, t39
    movl    -644(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -652(%ebp)       
    movl    -632(%ebp), %eax        #  58:     add    t41 <- t36, t40
    movl    -652(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -656(%ebp)       
    movl    -656(%ebp), %edi       
    movzbl  (%edi), %eax            #  59:     param  1 <- @t41
    pushl   %eax                   
    leal    BoolArr3, %eax          #  60:     &()    t42 <- BoolArr3
    movl    %eax, -660(%ebp)       
    movl    $2, %eax                #  61:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr3, %eax          #  62:     &()    t43 <- BoolArr3
    movl    %eax, -664(%ebp)       
    movl    -664(%ebp), %eax        #  63:     param  0 <- t43
    pushl   %eax                   
    call    DIM                     #  64:     call   t44 <- DIM
    addl    $8, %esp               
    movl    %eax, -668(%ebp)       
    movl    $1, %eax                #  65:     mul    t45 <- 1, t44
    movl    -668(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -672(%ebp)       
    movl    -672(%ebp), %eax        #  66:     add    t46 <- t45, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -676(%ebp)       
    movl    $3, %eax                #  67:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr3, %eax          #  68:     &()    t47 <- BoolArr3
    movl    %eax, -680(%ebp)       
    movl    -680(%ebp), %eax        #  69:     param  0 <- t47
    pushl   %eax                   
    call    DIM                     #  70:     call   t48 <- DIM
    addl    $8, %esp               
    movl    %eax, -684(%ebp)       
    movl    -676(%ebp), %eax        #  71:     mul    t49 <- t46, t48
    movl    -684(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -688(%ebp)       
    movl    -688(%ebp), %eax        #  72:     add    t50 <- t49, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -696(%ebp)       
    movl    -696(%ebp), %eax        #  73:     mul    t51 <- t50, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -700(%ebp)       
    leal    BoolArr3, %eax          #  74:     &()    t52 <- BoolArr3
    movl    %eax, -704(%ebp)       
    movl    -704(%ebp), %eax        #  75:     param  0 <- t52
    pushl   %eax                   
    call    DOFS                    #  76:     call   t53 <- DOFS
    addl    $4, %esp               
    movl    %eax, -708(%ebp)       
    movl    -700(%ebp), %eax        #  77:     add    t54 <- t51, t53
    movl    -708(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -712(%ebp)       
    movl    -660(%ebp), %eax        #  78:     add    t55 <- t42, t54
    movl    -712(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -716(%ebp)       
    movl    -716(%ebp), %edi       
    movzbl  (%edi), %eax            #  79:     param  0 <- @t55
    pushl   %eax                   
    call    booltest1               #  80:     call   booltest1
    addl    $8, %esp               
    leal    BoolArr0, %eax          #  81:     &()    t56 <- BoolArr0
    movl    %eax, -720(%ebp)       
    movl    -720(%ebp), %eax        #  82:     param  3 <- t56
    pushl   %eax                   
    leal    BoolArr0, %eax          #  83:     &()    t57 <- BoolArr0
    movl    %eax, -724(%ebp)       
    movl    -724(%ebp), %eax        #  84:     param  2 <- t57
    pushl   %eax                   
    movl    $1, %eax                #  85:     param  1 <- 1
    pushl   %eax                   
    movl    $1, %eax                #  86:     param  0 <- 1
    pushl   %eax                   
    call    booltest2               #  87:     call   t58 <- booltest2
    addl    $16, %esp              
    movb    %al, -725(%ebp)        
    leal    BoolArr1, %eax          #  88:     &()    t59 <- BoolArr1
    movl    %eax, -732(%ebp)       
    movl    -732(%ebp), %eax        #  89:     param  0 <- t59
    pushl   %eax                   
    call    booltest3               #  90:     call   booltest3
    addl    $4, %esp               
    leal    BoolArr2, %eax          #  91:     &()    t60 <- BoolArr2
    movl    %eax, -740(%ebp)       
    movl    $2, %eax                #  92:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          #  93:     &()    t61 <- BoolArr2
    movl    %eax, -744(%ebp)       
    movl    -744(%ebp), %eax        #  94:     param  0 <- t61
    pushl   %eax                   
    call    DIM                     #  95:     call   t62 <- DIM
    addl    $8, %esp               
    movl    %eax, -748(%ebp)       
    movl    $1, %eax                #  96:     mul    t63 <- 1, t62
    movl    -748(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -752(%ebp)       
    movl    -752(%ebp), %eax        #  97:     add    t64 <- t63, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -756(%ebp)       
    movl    $3, %eax                #  98:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          #  99:     &()    t65 <- BoolArr2
    movl    %eax, -760(%ebp)       
    movl    -760(%ebp), %eax        # 100:     param  0 <- t65
    pushl   %eax                   
    call    DIM                     # 101:     call   t66 <- DIM
    addl    $8, %esp               
    movl    %eax, -764(%ebp)       
    movl    -756(%ebp), %eax        # 102:     mul    t67 <- t64, t66
    movl    -764(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -768(%ebp)       
    movl    -768(%ebp), %eax        # 103:     add    t68 <- t67, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -772(%ebp)       
    movl    -772(%ebp), %eax        # 104:     mul    t69 <- t68, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -776(%ebp)       
    leal    BoolArr2, %eax          # 105:     &()    t70 <- BoolArr2
    movl    %eax, -784(%ebp)       
    movl    -784(%ebp), %eax        # 106:     param  0 <- t70
    pushl   %eax                   
    call    DOFS                    # 107:     call   t71 <- DOFS
    addl    $4, %esp               
    movl    %eax, -788(%ebp)       
    movl    -776(%ebp), %eax        # 108:     add    t72 <- t69, t71
    movl    -788(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -792(%ebp)       
    movl    -740(%ebp), %eax        # 109:     add    t73 <- t60, t72
    movl    -792(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -796(%ebp)       
    movl    -796(%ebp), %edi       
    leal    (%edi), %eax            # 110:     &()    t74 <- @t73
    movl    %eax, -800(%ebp)       
    movl    -800(%ebp), %eax        # 111:     param  0 <- t74
    pushl   %eax                   
    call    booltest3               # 112:     call   booltest3
    addl    $4, %esp               
    leal    BoolArr2, %eax          # 113:     &()    t75 <- BoolArr2
    movl    %eax, -804(%ebp)       
    movl    $2, %eax                # 114:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 115:     &()    t76 <- BoolArr2
    movl    %eax, -808(%ebp)       
    movl    -808(%ebp), %eax        # 116:     param  0 <- t76
    pushl   %eax                   
    call    DIM                     # 117:     call   t77 <- DIM
    addl    $8, %esp               
    movl    %eax, -812(%ebp)       
    movl    $1, %eax                # 118:     mul    t78 <- 1, t77
    movl    -812(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -816(%ebp)       
    movl    -816(%ebp), %eax        # 119:     add    t79 <- t78, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -820(%ebp)       
    movl    $3, %eax                # 120:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 121:     &()    t80 <- BoolArr2
    movl    %eax, -828(%ebp)       
    movl    -828(%ebp), %eax        # 122:     param  0 <- t80
    pushl   %eax                   
    call    DIM                     # 123:     call   t81 <- DIM
    addl    $8, %esp               
    movl    %eax, -832(%ebp)       
    movl    -820(%ebp), %eax        # 124:     mul    t82 <- t79, t81
    movl    -832(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -836(%ebp)       
    movl    -836(%ebp), %eax        # 125:     add    t83 <- t82, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -840(%ebp)       
    movl    -840(%ebp), %eax        # 126:     mul    t84 <- t83, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -844(%ebp)       
    leal    BoolArr2, %eax          # 127:     &()    t85 <- BoolArr2
    movl    %eax, -848(%ebp)       
    movl    -848(%ebp), %eax        # 128:     param  0 <- t85
    pushl   %eax                   
    call    DOFS                    # 129:     call   t86 <- DOFS
    addl    $4, %esp               
    movl    %eax, -852(%ebp)       
    movl    -844(%ebp), %eax        # 130:     add    t87 <- t84, t86
    movl    -852(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -856(%ebp)       
    movl    -804(%ebp), %eax        # 131:     add    t88 <- t75, t87
    movl    -856(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -860(%ebp)       
    movl    -860(%ebp), %edi       
    leal    (%edi), %eax            # 132:     &()    t89 <- @t88
    movl    %eax, -864(%ebp)       
    movl    -864(%ebp), %eax        # 133:     param  3 <- t89
    pushl   %eax                   
    leal    BoolArr1, %eax          # 134:     &()    t90 <- BoolArr1
    movl    %eax, -872(%ebp)       
    movl    $2, %eax                # 135:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 136:     &()    t91 <- BoolArr1
    movl    %eax, -876(%ebp)       
    movl    -876(%ebp), %eax        # 137:     param  0 <- t91
    pushl   %eax                   
    call    DIM                     # 138:     call   t92 <- DIM
    addl    $8, %esp               
    movl    %eax, -880(%ebp)       
    movl    $2, %eax                # 139:     mul    t93 <- 2, t92
    movl    -880(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -884(%ebp)       
    movl    -884(%ebp), %eax        # 140:     add    t94 <- t93, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -888(%ebp)       
    movl    -888(%ebp), %eax        # 141:     mul    t95 <- t94, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -892(%ebp)       
    leal    BoolArr1, %eax          # 142:     &()    t96 <- BoolArr1
    movl    %eax, -896(%ebp)       
    movl    -896(%ebp), %eax        # 143:     param  0 <- t96
    pushl   %eax                   
    call    DOFS                    # 144:     call   t97 <- DOFS
    addl    $4, %esp               
    movl    %eax, -900(%ebp)       
    movl    -892(%ebp), %eax        # 145:     add    t98 <- t95, t97
    movl    -900(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -904(%ebp)       
    movl    -872(%ebp), %eax        # 146:     add    t99 <- t90, t98
    movl    -904(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -908(%ebp)       
    movl    -908(%ebp), %edi       
    leal    (%edi), %eax            # 147:     &()    t100 <- @t99
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         # 148:     param  2 <- t100
    pushl   %eax                   
    leal    BoolArr1, %eax          # 149:     &()    t101 <- BoolArr1
    movl    %eax, -32(%ebp)        
    movl    $2, %eax                # 150:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 151:     &()    t102 <- BoolArr1
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         # 152:     param  0 <- t102
    pushl   %eax                   
    call    DIM                     # 153:     call   t103 <- DIM
    addl    $8, %esp               
    movl    %eax, -40(%ebp)        
    movl    $1, %eax                # 154:     mul    t104 <- 1, t103
    movl    -40(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         # 155:     add    t105 <- t104, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         # 156:     mul    t106 <- t105, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -52(%ebp)        
    leal    BoolArr1, %eax          # 157:     &()    t107 <- BoolArr1
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         # 158:     param  0 <- t107
    pushl   %eax                   
    call    DOFS                    # 159:     call   t108 <- DOFS
    addl    $4, %esp               
    movl    %eax, -60(%ebp)        
    movl    -52(%ebp), %eax         # 160:     add    t109 <- t106, t108
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    -32(%ebp), %eax         # 161:     add    t110 <- t101, t109
    movl    -64(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %edi        
    movzbl  (%edi), %eax            # 162:     param  1 <- @t110
    pushl   %eax                   
    leal    BoolArr0, %eax          # 163:     &()    t111 <- BoolArr0
    movl    %eax, -76(%ebp)        
    movl    $2, %eax                # 164:     mul    t112 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -80(%ebp)        
    leal    BoolArr0, %eax          # 165:     &()    t113 <- BoolArr0
    movl    %eax, -84(%ebp)        
    movl    -84(%ebp), %eax         # 166:     param  0 <- t113
    pushl   %eax                   
    call    DOFS                    # 167:     call   t114 <- DOFS
    addl    $4, %esp               
    movl    %eax, -88(%ebp)        
    movl    -80(%ebp), %eax         # 168:     add    t115 <- t112, t114
    movl    -88(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -92(%ebp)        
    movl    -76(%ebp), %eax         # 169:     add    t116 <- t111, t115
    movl    -92(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -96(%ebp)        
    movl    -96(%ebp), %edi        
    movzbl  (%edi), %eax            # 170:     param  0 <- @t116
    pushl   %eax                   
    call    booltest2               # 171:     call   t117 <- booltest2
    addl    $16, %esp              
    movb    %al, -97(%ebp)         
    movzbl  -97(%ebp), %eax         # 172:     assign b0 <- t117
    movb    %al, b0                
    leal    BoolArr2, %eax          # 173:     &()    t118 <- BoolArr2
    movl    %eax, -104(%ebp)       
    movl    $2, %eax                # 174:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 175:     &()    t119 <- BoolArr2
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        # 176:     param  0 <- t119
    pushl   %eax                   
    call    DIM                     # 177:     call   t120 <- DIM
    addl    $8, %esp               
    movl    %eax, -116(%ebp)       
    movl    $0, %eax                # 178:     mul    t121 <- 0, t120
    movl    -116(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %eax        # 179:     add    t122 <- t121, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -124(%ebp)       
    movl    $3, %eax                # 180:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 181:     &()    t123 <- BoolArr2
    movl    %eax, -128(%ebp)       
    movl    -128(%ebp), %eax        # 182:     param  0 <- t123
    pushl   %eax                   
    call    DIM                     # 183:     call   t124 <- DIM
    addl    $8, %esp               
    movl    %eax, -132(%ebp)       
    movl    -124(%ebp), %eax        # 184:     mul    t125 <- t122, t124
    movl    -132(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -136(%ebp)       
    movl    -136(%ebp), %eax        # 185:     add    t126 <- t125, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -140(%ebp)       
    movl    -140(%ebp), %eax        # 186:     mul    t127 <- t126, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -144(%ebp)       
    leal    BoolArr2, %eax          # 187:     &()    t128 <- BoolArr2
    movl    %eax, -148(%ebp)       
    movl    -148(%ebp), %eax        # 188:     param  0 <- t128
    pushl   %eax                   
    call    DOFS                    # 189:     call   t129 <- DOFS
    addl    $4, %esp               
    movl    %eax, -152(%ebp)       
    movl    -144(%ebp), %eax        # 190:     add    t130 <- t127, t129
    movl    -152(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -160(%ebp)       
    movl    -104(%ebp), %eax        # 191:     add    t131 <- t118, t130
    movl    -160(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -164(%ebp)       
    movl    -164(%ebp), %edi       
    leal    (%edi), %eax            # 192:     &()    t132 <- @t131
    movl    %eax, -168(%ebp)       
    movl    -168(%ebp), %eax        # 193:     param  3 <- t132
    pushl   %eax                   
    leal    BoolArr3, %eax          # 194:     &()    t133 <- BoolArr3
    movl    %eax, -172(%ebp)       
    movl    $2, %eax                # 195:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr3, %eax          # 196:     &()    t134 <- BoolArr3
    movl    %eax, -176(%ebp)       
    movl    -176(%ebp), %eax        # 197:     param  0 <- t134
    pushl   %eax                   
    call    DIM                     # 198:     call   t135 <- DIM
    addl    $8, %esp               
    movl    %eax, -180(%ebp)       
    movl    $1, %eax                # 199:     mul    t136 <- 1, t135
    movl    -180(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -184(%ebp)       
    movl    -184(%ebp), %eax        # 200:     add    t137 <- t136, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -188(%ebp)       
    movl    $3, %eax                # 201:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr3, %eax          # 202:     &()    t138 <- BoolArr3
    movl    %eax, -192(%ebp)       
    movl    -192(%ebp), %eax        # 203:     param  0 <- t138
    pushl   %eax                   
    call    DIM                     # 204:     call   t139 <- DIM
    addl    $8, %esp               
    movl    %eax, -196(%ebp)       
    movl    -188(%ebp), %eax        # 205:     mul    t140 <- t137, t139
    movl    -196(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -204(%ebp)       
    movl    -204(%ebp), %eax        # 206:     add    t141 <- t140, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -208(%ebp)       
    movl    -208(%ebp), %eax        # 207:     mul    t142 <- t141, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -212(%ebp)       
    leal    BoolArr3, %eax          # 208:     &()    t143 <- BoolArr3
    movl    %eax, -216(%ebp)       
    movl    -216(%ebp), %eax        # 209:     param  0 <- t143
    pushl   %eax                   
    call    DOFS                    # 210:     call   t144 <- DOFS
    addl    $4, %esp               
    movl    %eax, -220(%ebp)       
    movl    -212(%ebp), %eax        # 211:     add    t145 <- t142, t144
    movl    -220(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -224(%ebp)       
    movl    -172(%ebp), %eax        # 212:     add    t146 <- t133, t145
    movl    -224(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -228(%ebp)       
    movl    -228(%ebp), %edi       
    leal    (%edi), %eax            # 213:     &()    t147 <- @t146
    movl    %eax, -232(%ebp)       
    movl    -232(%ebp), %eax        # 214:     param  2 <- t147
    pushl   %eax                   
    leal    BoolArr2, %eax          # 215:     &()    t148 <- BoolArr2
    movl    %eax, -236(%ebp)       
    movl    $2, %eax                # 216:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 217:     &()    t149 <- BoolArr2
    movl    %eax, -240(%ebp)       
    movl    -240(%ebp), %eax        # 218:     param  0 <- t149
    pushl   %eax                   
    call    DIM                     # 219:     call   t150 <- DIM
    addl    $8, %esp               
    movl    %eax, -248(%ebp)       
    movl    $1, %eax                # 220:     mul    t151 <- 1, t150
    movl    -248(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -252(%ebp)       
    movl    -252(%ebp), %eax        # 221:     add    t152 <- t151, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -256(%ebp)       
    movl    $3, %eax                # 222:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 223:     &()    t153 <- BoolArr2
    movl    %eax, -260(%ebp)       
    movl    -260(%ebp), %eax        # 224:     param  0 <- t153
    pushl   %eax                   
    call    DIM                     # 225:     call   t154 <- DIM
    addl    $8, %esp               
    movl    %eax, -264(%ebp)       
    movl    -256(%ebp), %eax        # 226:     mul    t155 <- t152, t154
    movl    -264(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -268(%ebp)       
    movl    -268(%ebp), %eax        # 227:     add    t156 <- t155, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -272(%ebp)       
    movl    -272(%ebp), %eax        # 228:     mul    t157 <- t156, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -276(%ebp)       
    leal    BoolArr2, %eax          # 229:     &()    t158 <- BoolArr2
    movl    %eax, -280(%ebp)       
    movl    -280(%ebp), %eax        # 230:     param  0 <- t158
    pushl   %eax                   
    call    DOFS                    # 231:     call   t159 <- DOFS
    addl    $4, %esp               
    movl    %eax, -284(%ebp)       
    movl    -276(%ebp), %eax        # 232:     add    t160 <- t157, t159
    movl    -284(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -292(%ebp)       
    movl    -236(%ebp), %eax        # 233:     add    t161 <- t148, t160
    movl    -292(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -296(%ebp)       
    movl    -296(%ebp), %edi       
    movzbl  (%edi), %eax            # 234:     param  1 <- @t161
    pushl   %eax                   
    leal    BoolArr1, %eax          # 235:     &()    t162 <- BoolArr1
    movl    %eax, -300(%ebp)       
    movl    $2, %eax                # 236:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 237:     &()    t163 <- BoolArr1
    movl    %eax, -304(%ebp)       
    movl    -304(%ebp), %eax        # 238:     param  0 <- t163
    pushl   %eax                   
    call    DIM                     # 239:     call   t164 <- DIM
    addl    $8, %esp               
    movl    %eax, -308(%ebp)       
    movl    $2, %eax                # 240:     mul    t165 <- 2, t164
    movl    -308(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -312(%ebp)       
    movl    -312(%ebp), %eax        # 241:     add    t166 <- t165, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -316(%ebp)       
    movl    -316(%ebp), %eax        # 242:     mul    t167 <- t166, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -320(%ebp)       
    leal    BoolArr1, %eax          # 243:     &()    t168 <- BoolArr1
    movl    %eax, -324(%ebp)       
    movl    -324(%ebp), %eax        # 244:     param  0 <- t168
    pushl   %eax                   
    call    DOFS                    # 245:     call   t169 <- DOFS
    addl    $4, %esp               
    movl    %eax, -328(%ebp)       
    movl    -320(%ebp), %eax        # 246:     add    t170 <- t167, t169
    movl    -328(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -336(%ebp)       
    movl    -300(%ebp), %eax        # 247:     add    t171 <- t162, t170
    movl    -336(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -340(%ebp)       
    movl    -340(%ebp), %edi       
    movzbl  (%edi), %eax            # 248:     param  0 <- @t171
    pushl   %eax                   
    call    booltest2               # 249:     call   t172 <- booltest2
    addl    $16, %esp              
    movb    %al, -341(%ebp)        
    movzbl  -341(%ebp), %eax        # 250:     if     t172 = 1 goto 9
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test08_9             
    movl    $1, %eax                # 251:     assign t173 <- 1
    movb    %al, -342(%ebp)        
    jmp     l_test08_10             # 252:     goto   10
l_test08_9:
    movl    $0, %eax                # 254:     assign t173 <- 0
    movb    %al, -342(%ebp)        
l_test08_10:
    movzbl  -342(%ebp), %eax        # 256:     assign b1 <- t173
    movb    %al, b1                
    leal    BoolArr2, %eax          # 257:     &()    t174 <- BoolArr2
    movl    %eax, -348(%ebp)       
    movl    $2, %eax                # 258:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 259:     &()    t175 <- BoolArr2
    movl    %eax, -352(%ebp)       
    movl    -352(%ebp), %eax        # 260:     param  0 <- t175
    pushl   %eax                   
    call    DIM                     # 261:     call   t176 <- DIM
    addl    $8, %esp               
    movl    %eax, -356(%ebp)       
    movl    $0, %eax                # 262:     mul    t177 <- 0, t176
    movl    -356(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -360(%ebp)       
    movl    -360(%ebp), %eax        # 263:     add    t178 <- t177, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -364(%ebp)       
    movl    $3, %eax                # 264:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 265:     &()    t179 <- BoolArr2
    movl    %eax, -368(%ebp)       
    movl    -368(%ebp), %eax        # 266:     param  0 <- t179
    pushl   %eax                   
    call    DIM                     # 267:     call   t180 <- DIM
    addl    $8, %esp               
    movl    %eax, -376(%ebp)       
    movl    -364(%ebp), %eax        # 268:     mul    t181 <- t178, t180
    movl    -376(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -380(%ebp)       
    movl    -380(%ebp), %eax        # 269:     add    t182 <- t181, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -384(%ebp)       
    movl    -384(%ebp), %eax        # 270:     mul    t183 <- t182, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -388(%ebp)       
    leal    BoolArr2, %eax          # 271:     &()    t184 <- BoolArr2
    movl    %eax, -392(%ebp)       
    movl    -392(%ebp), %eax        # 272:     param  0 <- t184
    pushl   %eax                   
    call    DOFS                    # 273:     call   t185 <- DOFS
    addl    $4, %esp               
    movl    %eax, -396(%ebp)       
    movl    -388(%ebp), %eax        # 274:     add    t186 <- t183, t185
    movl    -396(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -400(%ebp)       
    movl    -348(%ebp), %eax        # 275:     add    t187 <- t174, t186
    movl    -400(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -404(%ebp)       
    movl    -404(%ebp), %edi       
    leal    (%edi), %eax            # 276:     &()    t188 <- @t187
    movl    %eax, -408(%ebp)       
    movl    -408(%ebp), %eax        # 277:     param  3 <- t188
    pushl   %eax                   
    leal    BoolArr3, %eax          # 278:     &()    t189 <- BoolArr3
    movl    %eax, -412(%ebp)       
    movl    $2, %eax                # 279:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr3, %eax          # 280:     &()    t190 <- BoolArr3
    movl    %eax, -420(%ebp)       
    movl    -420(%ebp), %eax        # 281:     param  0 <- t190
    pushl   %eax                   
    call    DIM                     # 282:     call   t191 <- DIM
    addl    $8, %esp               
    movl    %eax, -424(%ebp)       
    movl    $1, %eax                # 283:     mul    t192 <- 1, t191
    movl    -424(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -428(%ebp)       
    movl    -428(%ebp), %eax        # 284:     add    t193 <- t192, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -432(%ebp)       
    movl    $3, %eax                # 285:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr3, %eax          # 286:     &()    t194 <- BoolArr3
    movl    %eax, -436(%ebp)       
    movl    -436(%ebp), %eax        # 287:     param  0 <- t194
    pushl   %eax                   
    call    DIM                     # 288:     call   t195 <- DIM
    addl    $8, %esp               
    movl    %eax, -440(%ebp)       
    movl    -432(%ebp), %eax        # 289:     mul    t196 <- t193, t195
    movl    -440(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -444(%ebp)       
    movl    -444(%ebp), %eax        # 290:     add    t197 <- t196, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -448(%ebp)       
    movl    -448(%ebp), %eax        # 291:     mul    t198 <- t197, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -452(%ebp)       
    leal    BoolArr3, %eax          # 292:     &()    t199 <- BoolArr3
    movl    %eax, -456(%ebp)       
    movl    -456(%ebp), %eax        # 293:     param  0 <- t199
    pushl   %eax                   
    call    DOFS                    # 294:     call   t200 <- DOFS
    addl    $4, %esp               
    movl    %eax, -468(%ebp)       
    movl    -452(%ebp), %eax        # 295:     add    t201 <- t198, t200
    movl    -468(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -472(%ebp)       
    movl    -412(%ebp), %eax        # 296:     add    t202 <- t189, t201
    movl    -472(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -476(%ebp)       
    movl    -476(%ebp), %edi       
    leal    (%edi), %eax            # 297:     &()    t203 <- @t202
    movl    %eax, -480(%ebp)       
    movl    -480(%ebp), %eax        # 298:     param  2 <- t203
    pushl   %eax                   
    movl    $0, %eax                # 299:     param  1 <- 0
    pushl   %eax                   
    movl    $1, %eax                # 300:     param  0 <- 1
    pushl   %eax                   
    call    booltest2               # 301:     call   t204 <- booltest2
    addl    $16, %esp              
    movb    %al, -481(%ebp)        
    movzbl  -481(%ebp), %eax        # 302:     if     t204 = 1 goto 12
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test08_12            
    jmp     l_test08_13             # 303:     goto   13
l_test08_12:
    movl    $1, %eax                # 305:     assign t205 <- 1
    movb    %al, -482(%ebp)        
    jmp     l_test08_14             # 306:     goto   14
l_test08_13:
    movl    $0, %eax                # 308:     assign t205 <- 0
    movb    %al, -482(%ebp)        
l_test08_14:
    movzbl  -482(%ebp), %eax        # 310:     assign b0 <- t205
    movb    %al, b0                
    leal    BoolArr0, %eax          # 311:     &()    t206 <- BoolArr0
    movl    %eax, -488(%ebp)       
    movl    -488(%ebp), %eax        # 312:     param  3 <- t206
    pushl   %eax                   
    leal    BoolArr0, %eax          # 313:     &()    t207 <- BoolArr0
    movl    %eax, -492(%ebp)       
    movl    -492(%ebp), %eax        # 314:     param  2 <- t207
    pushl   %eax                   
    movl    $1, %eax                # 315:     param  1 <- 1
    pushl   %eax                   
    movl    $0, %eax                # 316:     param  0 <- 0
    pushl   %eax                   
    call    booltest2               # 317:     call   t208 <- booltest2
    addl    $16, %esp              
    movb    %al, -493(%ebp)        
    movzbl  -493(%ebp), %eax        # 318:     if     t208 = 1 goto 18
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test08_18            
    jmp     l_test08_17_if_false    # 319:     goto   17_if_false
l_test08_18:
    leal    BoolArr0, %eax          # 321:     &()    t209 <- BoolArr0
    movl    %eax, -500(%ebp)       
    movl    -500(%ebp), %eax        # 322:     param  3 <- t209
    pushl   %eax                   
    leal    BoolArr0, %eax          # 323:     &()    t210 <- BoolArr0
    movl    %eax, -508(%ebp)       
    movl    -508(%ebp), %eax        # 324:     param  2 <- t210
    pushl   %eax                   
    leal    BoolArr0, %eax          # 325:     &()    t211 <- BoolArr0
    movl    %eax, -512(%ebp)       
    movl    $0, %eax                # 326:     mul    t212 <- 0, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -516(%ebp)       
    leal    BoolArr0, %eax          # 327:     &()    t213 <- BoolArr0
    movl    %eax, -520(%ebp)       
    movl    -520(%ebp), %eax        # 328:     param  0 <- t213
    pushl   %eax                   
    call    DOFS                    # 329:     call   t214 <- DOFS
    addl    $4, %esp               
    movl    %eax, -524(%ebp)       
    movl    -516(%ebp), %eax        # 330:     add    t215 <- t212, t214
    movl    -524(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -528(%ebp)       
    movl    -512(%ebp), %eax        # 331:     add    t216 <- t211, t215
    movl    -528(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -532(%ebp)       
    movl    -532(%ebp), %edi       
    movzbl  (%edi), %eax            # 332:     param  1 <- @t216
    pushl   %eax                   
    leal    BoolArr0, %eax          # 333:     &()    t217 <- BoolArr0
    movl    %eax, -536(%ebp)       
    movl    $1, %eax                # 334:     mul    t218 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -540(%ebp)       
    leal    BoolArr0, %eax          # 335:     &()    t219 <- BoolArr0
    movl    %eax, -544(%ebp)       
    movl    -544(%ebp), %eax        # 336:     param  0 <- t219
    pushl   %eax                   
    call    DOFS                    # 337:     call   t220 <- DOFS
    addl    $4, %esp               
    movl    %eax, -552(%ebp)       
    movl    -540(%ebp), %eax        # 338:     add    t221 <- t218, t220
    movl    -552(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -556(%ebp)       
    movl    -536(%ebp), %eax        # 339:     add    t222 <- t217, t221
    movl    -556(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -560(%ebp)       
    movl    -560(%ebp), %edi       
    movzbl  (%edi), %eax            # 340:     param  0 <- @t222
    pushl   %eax                   
    call    booltest2               # 341:     call   t223 <- booltest2
    addl    $16, %esp              
    movb    %al, -561(%ebp)        
    movzbl  -561(%ebp), %eax        # 342:     if     t223 = 1 goto 16_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test08_16_if_true    
    jmp     l_test08_17_if_false    # 343:     goto   17_if_false
l_test08_16_if_true:
    leal    _str_14, %eax           # 345:     &()    t224 <- _str_14
    movl    %eax, -568(%ebp)       
    movl    -568(%ebp), %eax        # 346:     param  0 <- t224
    pushl   %eax                   
    call    WriteStr                # 347:     call   WriteStr
    addl    $4, %esp               
    jmp     l_test08_15             # 348:     goto   15
l_test08_17_if_false:
l_test08_15:
    leal    _str_15, %eax           # 351:     &()    t225 <- _str_15
    movl    %eax, -572(%ebp)       
    movl    -572(%ebp), %eax        # 352:     param  0 <- t225
    pushl   %eax                   
    call    WriteStr                # 353:     call   WriteStr
    addl    $4, %esp               

l_test08_exit:
    # epilogue
    addl    $896, %esp              # remove locals
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

    # scope: test08
BoolArr0:                           # <array 5 of <bool>>
    .long    1
    .long    5
    .skip    5
    .align   4
BoolArr1:                           # <array 5 of <array 5 of <bool>>>
    .long    2
    .long    5
    .long    5
    .skip   25
    .align   4
BoolArr2:                           # <array 5 of <array 5 of <array 5 of <bool>>>>
    .long    3
    .long    5
    .long    5
    .long    5
    .skip  125
    .align   4
BoolArr3:                           # <array 5 of <array 5 of <array 5 of <bool>>>>
    .long    3
    .long    5
    .long    5
    .long    5
    .skip  125
    .align   4
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
_str_12:                            # <array 15 of <char>>
    .long    1
    .long   15
    .asciz "Hello, World!\n"
    .align   4
_str_13:                            # <array 15 of <char>>
    .long    1
    .long   15
    .asciz "Hello, World!\n"
    .align   4
_str_14:                            # <array 15 of <char>>
    .long    1
    .long   15
    .asciz "Hello, World!\n"
    .align   4
_str_15:                            # <array 23 of <char>>
    .long    1
    .long   23
    .asciz "End of boolean tests.\n"
    .align   4
_str_2:                             # <array 30 of <char>>
    .long    1
    .long   30
    .asciz "Column count does not match!\n"
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
