##################################################
# test09
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

    # scope booltest2
booltest2:
    # stack offsets:
    #      8(%ebp)   1  [ %p1       <bool> %ebp+8 ]
    #     12(%ebp)   1  [ %p2       <bool> %ebp+12 ]
    #     16(%ebp)   4  [ %p3       <ptr(4) to <array 5 of <bool>>> %ebp+16 ]
    #     20(%ebp)   4  [ %p4       <ptr(4) to <array 5 of <bool>>> %ebp+20 ]
    #    -16(%ebp)   4  [ $t134     <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t135     <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t136     <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t137     <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t138     <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t139     <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t140     <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t141     <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t142     <ptr(4) to <array 15 of <char>>> %ebp-48 ]
    #    -52(%ebp)   4  [ $t143     <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t144     <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t145     <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t146     <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t147     <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t148     <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t149     <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t150     <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t151     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-84 ]
    #    -88(%ebp)   4  [ $t152     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-88 ]
    #    -92(%ebp)   4  [ $t153     <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t154     <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t155     <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t156     <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t157     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-108 ]
    #   -112(%ebp)   4  [ $t158     <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t159     <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t160     <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t161     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-124 ]
    #   -128(%ebp)   4  [ $t162     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-128 ]
    #   -132(%ebp)   4  [ $t163     <int> %ebp-132 ]
    #   -136(%ebp)   4  [ $t164     <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t165     <int> %ebp-140 ]
    #   -144(%ebp)   4  [ $t166     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-144 ]
    #   -148(%ebp)   4  [ $t167     <int> %ebp-148 ]
    #   -152(%ebp)   4  [ $t168     <int> %ebp-152 ]
    #   -156(%ebp)   4  [ $t169     <int> %ebp-156 ]
    #   -160(%ebp)   4  [ $t170     <int> %ebp-160 ]
    #   -164(%ebp)   4  [ $t171     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-164 ]
    #   -168(%ebp)   4  [ $t172     <int> %ebp-168 ]
    #   -172(%ebp)   4  [ $t173     <int> %ebp-172 ]
    #   -176(%ebp)   4  [ $t174     <int> %ebp-176 ]
    #   -180(%ebp)   4  [ $t175     <int> %ebp-180 ]
    #   -184(%ebp)   4  [ $t176     <int> %ebp-184 ]
    #   -188(%ebp)   4  [ $t177     <int> %ebp-188 ]
    #   -192(%ebp)   4  [ $t178     <int> %ebp-192 ]
    #   -196(%ebp)   4  [ $t179     <int> %ebp-196 ]
    #   -200(%ebp)   4  [ $t180     <int> %ebp-200 ]
    #   -204(%ebp)   4  [ $t181     <int> %ebp-204 ]
    #   -208(%ebp)   4  [ $t182     <int> %ebp-208 ]
    #   -209(%ebp)   1  [ $t183     <bool> %ebp-209 ]
    #   -216(%ebp)   4  [ $t184     <int> %ebp-216 ]
    #   -220(%ebp)   4  [ $t185     <int> %ebp-220 ]
    #   -224(%ebp)   4  [ $t186     <int> %ebp-224 ]
    #   -228(%ebp)   4  [ $t187     <int> %ebp-228 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $216, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $54, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    jmp     l_booltest2_5_if_false  #   0:     goto   5_if_false
    movl    $2, %eax                #   1:     mul    t134 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -16(%ebp)        
    movl    16(%ebp), %eax          #   2:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #   3:     call   t135 <- DOFS
    addl    $4, %esp               
    movl    %eax, -20(%ebp)        
    movl    -16(%ebp), %eax         #   4:     add    t136 <- t134, t135
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    16(%ebp), %eax          #   5:     add    t137 <- p3, t136
    movl    -24(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %edi        
    movzbl  (%edi), %eax            #   6:     if     @t137 = 1 goto 10
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_10         
    jmp     l_booltest2_8_if_false  #   7:     goto   8_if_false
l_booltest2_10:
    movl    $1, %eax                #   9:     mul    t138 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -32(%ebp)        
    movl    20(%ebp), %eax          #  10:     param  0 <- p4
    pushl   %eax                   
    call    DOFS                    #  11:     call   t139 <- DOFS
    addl    $4, %esp               
    movl    %eax, -36(%ebp)        
    movl    -32(%ebp), %eax         #  12:     add    t140 <- t138, t139
    movl    -36(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    20(%ebp), %eax          #  13:     add    t141 <- p4, t140
    movl    -40(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %edi        
    movzbl  (%edi), %eax            #  14:     if     @t141 = 1 goto 9
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_9          
    jmp     l_booltest2_8_if_false  #  15:     goto   8_if_false
l_booltest2_9:
    movzbl  8(%ebp), %eax           #  17:     if     p1 = 1 goto 8_if_false
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_8_if_false 
    leal    _str_1, %eax            #  18:     &()    t142 <- _str_1
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  19:     param  0 <- t142
    pushl   %eax                   
    call    WriteStr                #  20:     call   WriteStr
    addl    $4, %esp               
    movl    $0, %eax                #  21:     mul    t143 <- 0, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -52(%ebp)        
    movl    16(%ebp), %eax          #  22:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #  23:     call   t144 <- DOFS
    addl    $4, %esp               
    movl    %eax, -56(%ebp)        
    movl    -52(%ebp), %eax         #  24:     add    t145 <- t143, t144
    movl    -56(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -60(%ebp)        
    movl    16(%ebp), %eax          #  25:     add    t146 <- p3, t145
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    -64(%ebp), %edi        
    movzbl  (%edi), %eax            #  26:     if     @t146 = 1 goto 13_if_true
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
    movl    $2, %eax                #  36:     mul    t147 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -68(%ebp)        
    movl    16(%ebp), %eax          #  37:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #  38:     call   t148 <- DOFS
    addl    $4, %esp               
    movl    %eax, -72(%ebp)        
    movl    -68(%ebp), %eax         #  39:     add    t149 <- t147, t148
    movl    -72(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -76(%ebp)        
    movl    16(%ebp), %eax          #  40:     add    t150 <- p3, t149
    movl    -76(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -80(%ebp), %edi        
    movzbl  (%edi), %eax            #  41:     if     @t150 = 1 goto 23
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_23         
    jmp     l_booltest2_22          #  42:     goto   22
l_booltest2_23:
    leal    BoolArr1, %eax          #  44:     &()    t151 <- BoolArr1
    movl    %eax, -84(%ebp)        
    movl    $2, %eax                #  45:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          #  46:     &()    t152 <- BoolArr1
    movl    %eax, -88(%ebp)        
    movl    -88(%ebp), %eax         #  47:     param  0 <- t152
    pushl   %eax                   
    call    DIM                     #  48:     call   t153 <- DIM
    addl    $8, %esp               
    movl    %eax, -92(%ebp)        
    movl    $1, %eax                #  49:     mul    t154 <- 1, t153
    movl    -92(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -96(%ebp)        
    movl    -96(%ebp), %eax         #  50:     add    t155 <- t154, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -100(%ebp)       
    movl    -100(%ebp), %eax        #  51:     mul    t156 <- t155, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -104(%ebp)       
    leal    BoolArr1, %eax          #  52:     &()    t157 <- BoolArr1
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  53:     param  0 <- t157
    pushl   %eax                   
    call    DOFS                    #  54:     call   t158 <- DOFS
    addl    $4, %esp               
    movl    %eax, -112(%ebp)       
    movl    -104(%ebp), %eax        #  55:     add    t159 <- t156, t158
    movl    -112(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -116(%ebp)       
    movl    -84(%ebp), %eax         #  56:     add    t160 <- t151, t159
    movl    -116(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %edi       
    movzbl  (%edi), %eax            #  57:     if     @t160 = 1 goto 18
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_18         
l_booltest2_22:
    leal    BoolArr2, %eax          #  59:     &()    t161 <- BoolArr2
    movl    %eax, -124(%ebp)       
    movl    $2, %eax                #  60:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          #  61:     &()    t162 <- BoolArr2
    movl    %eax, -128(%ebp)       
    movl    -128(%ebp), %eax        #  62:     param  0 <- t162
    pushl   %eax                   
    call    DIM                     #  63:     call   t163 <- DIM
    addl    $8, %esp               
    movl    %eax, -132(%ebp)       
    movl    $1, %eax                #  64:     mul    t164 <- 1, t163
    movl    -132(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -136(%ebp)       
    movl    -136(%ebp), %eax        #  65:     add    t165 <- t164, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -140(%ebp)       
    movl    $3, %eax                #  66:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          #  67:     &()    t166 <- BoolArr2
    movl    %eax, -144(%ebp)       
    movl    -144(%ebp), %eax        #  68:     param  0 <- t166
    pushl   %eax                   
    call    DIM                     #  69:     call   t167 <- DIM
    addl    $8, %esp               
    movl    %eax, -148(%ebp)       
    movl    -140(%ebp), %eax        #  70:     mul    t168 <- t165, t167
    movl    -148(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -152(%ebp)       
    movl    -152(%ebp), %eax        #  71:     add    t169 <- t168, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -156(%ebp)       
    movl    -156(%ebp), %eax        #  72:     mul    t170 <- t169, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -160(%ebp)       
    leal    BoolArr2, %eax          #  73:     &()    t171 <- BoolArr2
    movl    %eax, -164(%ebp)       
    movl    -164(%ebp), %eax        #  74:     param  0 <- t171
    pushl   %eax                   
    call    DOFS                    #  75:     call   t172 <- DOFS
    addl    $4, %esp               
    movl    %eax, -168(%ebp)       
    movl    -160(%ebp), %eax        #  76:     add    t173 <- t170, t172
    movl    -168(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -172(%ebp)       
    movl    -124(%ebp), %eax        #  77:     add    t174 <- t161, t173
    movl    -172(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -176(%ebp)       
    movl    -176(%ebp), %edi       
    movzbl  (%edi), %eax            #  78:     if     @t174 = 1 goto 21
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_21         
    jmp     l_booltest2_18          #  79:     goto   18
l_booltest2_21:
    movl    $1, %eax                #  81:     mul    t175 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -180(%ebp)       
    movl    16(%ebp), %eax          #  82:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #  83:     call   t176 <- DOFS
    addl    $4, %esp               
    movl    %eax, -184(%ebp)       
    movl    -180(%ebp), %eax        #  84:     add    t177 <- t175, t176
    movl    -184(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -188(%ebp)       
    movl    16(%ebp), %eax          #  85:     add    t178 <- p3, t177
    movl    -188(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -192(%ebp)       
    movl    -192(%ebp), %edi       
    movzbl  (%edi), %eax            #  86:     if     @t178 = 1 goto 19
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_19         
    movl    $1, %eax                #  87:     mul    t179 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -196(%ebp)       
    movl    20(%ebp), %eax          #  88:     param  0 <- p4
    pushl   %eax                   
    call    DOFS                    #  89:     call   t180 <- DOFS
    addl    $4, %esp               
    movl    %eax, -200(%ebp)       
    movl    -196(%ebp), %eax        #  90:     add    t181 <- t179, t180
    movl    -200(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -204(%ebp)       
    movl    20(%ebp), %eax          #  91:     add    t182 <- p4, t181
    movl    -204(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -208(%ebp)       
    movl    -208(%ebp), %edi       
    movzbl  (%edi), %eax            #  92:     if     @t182 = 1 goto 19
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_booltest2_19         
l_booltest2_18:
    movl    $1, %eax                #  94:     assign t183 <- 1
    movb    %al, -209(%ebp)        
    jmp     l_booltest2_20          #  95:     goto   20
l_booltest2_19:
    movl    $0, %eax                #  97:     assign t183 <- 0
    movb    %al, -209(%ebp)        
l_booltest2_20:
    movzbl  -209(%ebp), %eax        #  99:     return t183
    jmp     l_booltest2_exit       
l_booltest2_6:
    jmp     l_booltest2_3           # 101:     goto   3
l_booltest2_5_if_false:
    movzbl  8(%ebp), %eax           # 103:     return p1
    jmp     l_booltest2_exit       
l_booltest2_3:
    jmp     l_booltest2_0           # 105:     goto   0
    movl    $1, %eax                # 106:     mul    t184 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -216(%ebp)       
    movl    16(%ebp), %eax          # 107:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    # 108:     call   t185 <- DOFS
    addl    $4, %esp               
    movl    %eax, -220(%ebp)       
    movl    -216(%ebp), %eax        # 109:     add    t186 <- t184, t185
    movl    -220(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -224(%ebp)       
    movl    16(%ebp), %eax          # 110:     add    t187 <- p3, t186
    movl    -224(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -228(%ebp)       
    movl    -228(%ebp), %edi       
    movzbl  (%edi), %eax            # 111:     return @t187
    jmp     l_booltest2_exit       
l_booltest2_0:
    movl    $0, %eax                # 113:     return 0
    jmp     l_booltest2_exit       

l_booltest2_exit:
    # epilogue
    addl    $216, %esp              # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test09
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <bool>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 5 of <bool>>> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -25(%ebp)   1  [ $t100     <bool> %ebp-25 ]
    #    -26(%ebp)   1  [ $t101     <bool> %ebp-26 ]
    #    -32(%ebp)   4  [ $t102     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-32 ]
    #    -36(%ebp)   4  [ $t103     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-36 ]
    #    -40(%ebp)   4  [ $t104     <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t105     <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t106     <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t107     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-52 ]
    #    -56(%ebp)   4  [ $t108     <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t109     <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t11      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t110     <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t111     <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t112     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-76 ]
    #    -80(%ebp)   4  [ $t113     <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t114     <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t115     <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t116     <ptr(4) to <bool>> %ebp-92 ]
    #    -96(%ebp)   4  [ $t117     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-96 ]
    #   -100(%ebp)   4  [ $t118     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-100 ]
    #   -104(%ebp)   4  [ $t119     <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t12      <int> %ebp-108 ]
    #   -112(%ebp)   4  [ $t120     <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t121     <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t122     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-120 ]
    #   -124(%ebp)   4  [ $t123     <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t124     <int> %ebp-128 ]
    #   -132(%ebp)   4  [ $t125     <int> %ebp-132 ]
    #   -136(%ebp)   4  [ $t126     <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t127     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-140 ]
    #   -144(%ebp)   4  [ $t128     <int> %ebp-144 ]
    #   -148(%ebp)   4  [ $t129     <int> %ebp-148 ]
    #   -152(%ebp)   4  [ $t13      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-152 ]
    #   -156(%ebp)   4  [ $t130     <int> %ebp-156 ]
    #   -160(%ebp)   4  [ $t131     <ptr(4) to <bool>> %ebp-160 ]
    #   -161(%ebp)   1  [ $t132     <bool> %ebp-161 ]
    #   -162(%ebp)   1  [ $t133     <bool> %ebp-162 ]
    #   -168(%ebp)   4  [ $t14      <int> %ebp-168 ]
    #   -172(%ebp)   4  [ $t15      <int> %ebp-172 ]
    #   -176(%ebp)   4  [ $t16      <int> %ebp-176 ]
    #   -180(%ebp)   4  [ $t17      <ptr(4) to <bool>> %ebp-180 ]
    #   -184(%ebp)   4  [ $t18      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-184 ]
    #   -188(%ebp)   4  [ $t19      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-188 ]
    #   -189(%ebp)   1  [ $t2       <bool> %ebp-189 ]
    #   -196(%ebp)   4  [ $t20      <int> %ebp-196 ]
    #   -200(%ebp)   4  [ $t21      <int> %ebp-200 ]
    #   -204(%ebp)   4  [ $t22      <int> %ebp-204 ]
    #   -208(%ebp)   4  [ $t23      <int> %ebp-208 ]
    #   -212(%ebp)   4  [ $t24      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-212 ]
    #   -216(%ebp)   4  [ $t25      <int> %ebp-216 ]
    #   -220(%ebp)   4  [ $t26      <int> %ebp-220 ]
    #   -224(%ebp)   4  [ $t27      <int> %ebp-224 ]
    #   -228(%ebp)   4  [ $t28      <ptr(4) to <bool>> %ebp-228 ]
    #   -232(%ebp)   4  [ $t29      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-232 ]
    #   -236(%ebp)   4  [ $t3       <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-236 ]
    #   -240(%ebp)   4  [ $t30      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-240 ]
    #   -244(%ebp)   4  [ $t31      <int> %ebp-244 ]
    #   -248(%ebp)   4  [ $t32      <int> %ebp-248 ]
    #   -252(%ebp)   4  [ $t33      <int> %ebp-252 ]
    #   -256(%ebp)   4  [ $t34      <int> %ebp-256 ]
    #   -260(%ebp)   4  [ $t35      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-260 ]
    #   -264(%ebp)   4  [ $t36      <int> %ebp-264 ]
    #   -268(%ebp)   4  [ $t37      <int> %ebp-268 ]
    #   -272(%ebp)   4  [ $t38      <int> %ebp-272 ]
    #   -276(%ebp)   4  [ $t39      <ptr(4) to <array 5 of <bool>>> %ebp-276 ]
    #   -280(%ebp)   4  [ $t4       <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-280 ]
    #   -284(%ebp)   4  [ $t40      <int> %ebp-284 ]
    #   -288(%ebp)   4  [ $t41      <ptr(4) to <array 5 of <bool>>> %ebp-288 ]
    #   -292(%ebp)   4  [ $t42      <int> %ebp-292 ]
    #   -296(%ebp)   4  [ $t43      <int> %ebp-296 ]
    #   -300(%ebp)   4  [ $t44      <int> %ebp-300 ]
    #   -301(%ebp)   1  [ $t45      <bool> %ebp-301 ]
    #   -308(%ebp)   4  [ $t46      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-308 ]
    #   -312(%ebp)   4  [ $t47      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-312 ]
    #   -316(%ebp)   4  [ $t48      <int> %ebp-316 ]
    #   -320(%ebp)   4  [ $t49      <int> %ebp-320 ]
    #   -324(%ebp)   4  [ $t5       <int> %ebp-324 ]
    #   -328(%ebp)   4  [ $t50      <int> %ebp-328 ]
    #   -332(%ebp)   4  [ $t51      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-332 ]
    #   -336(%ebp)   4  [ $t52      <int> %ebp-336 ]
    #   -340(%ebp)   4  [ $t53      <int> %ebp-340 ]
    #   -344(%ebp)   4  [ $t54      <int> %ebp-344 ]
    #   -348(%ebp)   4  [ $t55      <int> %ebp-348 ]
    #   -352(%ebp)   4  [ $t56      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-352 ]
    #   -356(%ebp)   4  [ $t57      <int> %ebp-356 ]
    #   -360(%ebp)   4  [ $t58      <int> %ebp-360 ]
    #   -364(%ebp)   4  [ $t59      <int> %ebp-364 ]
    #   -368(%ebp)   4  [ $t6       <int> %ebp-368 ]
    #   -372(%ebp)   4  [ $t60      <ptr(4) to <bool>> %ebp-372 ]
    #   -376(%ebp)   4  [ $t61      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-376 ]
    #   -380(%ebp)   4  [ $t62      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-380 ]
    #   -384(%ebp)   4  [ $t63      <int> %ebp-384 ]
    #   -388(%ebp)   4  [ $t64      <int> %ebp-388 ]
    #   -392(%ebp)   4  [ $t65      <int> %ebp-392 ]
    #   -396(%ebp)   4  [ $t66      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-396 ]
    #   -400(%ebp)   4  [ $t67      <int> %ebp-400 ]
    #   -404(%ebp)   4  [ $t68      <int> %ebp-404 ]
    #   -408(%ebp)   4  [ $t69      <int> %ebp-408 ]
    #   -412(%ebp)   4  [ $t7       <int> %ebp-412 ]
    #   -416(%ebp)   4  [ $t70      <int> %ebp-416 ]
    #   -420(%ebp)   4  [ $t71      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-420 ]
    #   -424(%ebp)   4  [ $t72      <int> %ebp-424 ]
    #   -428(%ebp)   4  [ $t73      <int> %ebp-428 ]
    #   -432(%ebp)   4  [ $t74      <int> %ebp-432 ]
    #   -436(%ebp)   4  [ $t75      <ptr(4) to <bool>> %ebp-436 ]
    #   -440(%ebp)   4  [ $t76      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-440 ]
    #   -444(%ebp)   4  [ $t77      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-444 ]
    #   -448(%ebp)   4  [ $t78      <int> %ebp-448 ]
    #   -452(%ebp)   4  [ $t79      <int> %ebp-452 ]
    #   -456(%ebp)   4  [ $t8       <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-456 ]
    #   -460(%ebp)   4  [ $t80      <int> %ebp-460 ]
    #   -464(%ebp)   4  [ $t81      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-464 ]
    #   -468(%ebp)   4  [ $t82      <int> %ebp-468 ]
    #   -472(%ebp)   4  [ $t83      <int> %ebp-472 ]
    #   -476(%ebp)   4  [ $t84      <int> %ebp-476 ]
    #   -480(%ebp)   4  [ $t85      <int> %ebp-480 ]
    #   -484(%ebp)   4  [ $t86      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-484 ]
    #   -488(%ebp)   4  [ $t87      <int> %ebp-488 ]
    #   -492(%ebp)   4  [ $t88      <int> %ebp-492 ]
    #   -496(%ebp)   4  [ $t89      <int> %ebp-496 ]
    #   -500(%ebp)   4  [ $t9       <int> %ebp-500 ]
    #   -504(%ebp)   4  [ $t90      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-504 ]
    #   -508(%ebp)   4  [ $t91      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-508 ]
    #   -512(%ebp)   4  [ $t92      <int> %ebp-512 ]
    #   -516(%ebp)   4  [ $t93      <int> %ebp-516 ]
    #   -520(%ebp)   4  [ $t94      <int> %ebp-520 ]
    #   -524(%ebp)   4  [ $t95      <int> %ebp-524 ]
    #   -528(%ebp)   4  [ $t96      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-528 ]
    #   -532(%ebp)   4  [ $t97      <int> %ebp-532 ]
    #   -536(%ebp)   4  [ $t98      <int> %ebp-536 ]
    #   -540(%ebp)   4  [ $t99      <int> %ebp-540 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $528, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $132, %ecx             
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    leal    BoolArr0, %eax          #   0:     &()    t0 <- BoolArr0
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   1:     param  3 <- t0
    pushl   %eax                   
    leal    BoolArr0, %eax          #   2:     &()    t1 <- BoolArr0
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   3:     param  2 <- t1
    pushl   %eax                   
    movl    $0, %eax                #   4:     param  1 <- 0
    pushl   %eax                   
    movl    $1, %eax                #   5:     param  0 <- 1
    pushl   %eax                   
    call    booltest2               #   6:     call   t2 <- booltest2
    addl    $16, %esp              
    movb    %al, -189(%ebp)        
    leal    BoolArr2, %eax          #   7:     &()    t3 <- BoolArr2
    movl    %eax, -236(%ebp)       
    movl    $2, %eax                #   8:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          #   9:     &()    t4 <- BoolArr2
    movl    %eax, -280(%ebp)       
    movl    -280(%ebp), %eax        #  10:     param  0 <- t4
    pushl   %eax                   
    call    DIM                     #  11:     call   t5 <- DIM
    addl    $8, %esp               
    movl    %eax, -324(%ebp)       
    movl    $1, %eax                #  12:     mul    t6 <- 1, t5
    movl    -324(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -368(%ebp)       
    movl    -368(%ebp), %eax        #  13:     add    t7 <- t6, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -412(%ebp)       
    movl    $3, %eax                #  14:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          #  15:     &()    t8 <- BoolArr2
    movl    %eax, -456(%ebp)       
    movl    -456(%ebp), %eax        #  16:     param  0 <- t8
    pushl   %eax                   
    call    DIM                     #  17:     call   t9 <- DIM
    addl    $8, %esp               
    movl    %eax, -500(%ebp)       
    movl    -412(%ebp), %eax        #  18:     mul    t10 <- t7, t9
    movl    -500(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #  19:     add    t11 <- t10, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    -64(%ebp), %eax         #  20:     mul    t12 <- t11, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -108(%ebp)       
    leal    BoolArr2, %eax          #  21:     &()    t13 <- BoolArr2
    movl    %eax, -152(%ebp)       
    movl    -152(%ebp), %eax        #  22:     param  0 <- t13
    pushl   %eax                   
    call    DOFS                    #  23:     call   t14 <- DOFS
    addl    $4, %esp               
    movl    %eax, -168(%ebp)       
    movl    -108(%ebp), %eax        #  24:     add    t15 <- t12, t14
    movl    -168(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -172(%ebp)       
    movl    -236(%ebp), %eax        #  25:     add    t16 <- t3, t15
    movl    -172(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -176(%ebp)       
    movl    -176(%ebp), %edi       
    leal    (%edi), %eax            #  26:     &()    t17 <- @t16
    movl    %eax, -180(%ebp)       
    movl    -180(%ebp), %eax        #  27:     param  3 <- t17
    pushl   %eax                   
    leal    BoolArr1, %eax          #  28:     &()    t18 <- BoolArr1
    movl    %eax, -184(%ebp)       
    movl    $2, %eax                #  29:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          #  30:     &()    t19 <- BoolArr1
    movl    %eax, -188(%ebp)       
    movl    -188(%ebp), %eax        #  31:     param  0 <- t19
    pushl   %eax                   
    call    DIM                     #  32:     call   t20 <- DIM
    addl    $8, %esp               
    movl    %eax, -196(%ebp)       
    movl    $2, %eax                #  33:     mul    t21 <- 2, t20
    movl    -196(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -200(%ebp)       
    movl    -200(%ebp), %eax        #  34:     add    t22 <- t21, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -204(%ebp)       
    movl    -204(%ebp), %eax        #  35:     mul    t23 <- t22, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -208(%ebp)       
    leal    BoolArr1, %eax          #  36:     &()    t24 <- BoolArr1
    movl    %eax, -212(%ebp)       
    movl    -212(%ebp), %eax        #  37:     param  0 <- t24
    pushl   %eax                   
    call    DOFS                    #  38:     call   t25 <- DOFS
    addl    $4, %esp               
    movl    %eax, -216(%ebp)       
    movl    -208(%ebp), %eax        #  39:     add    t26 <- t23, t25
    movl    -216(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -220(%ebp)       
    movl    -184(%ebp), %eax        #  40:     add    t27 <- t18, t26
    movl    -220(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -224(%ebp)       
    movl    -224(%ebp), %edi       
    leal    (%edi), %eax            #  41:     &()    t28 <- @t27
    movl    %eax, -228(%ebp)       
    movl    -228(%ebp), %eax        #  42:     param  2 <- t28
    pushl   %eax                   
    leal    BoolArr1, %eax          #  43:     &()    t29 <- BoolArr1
    movl    %eax, -232(%ebp)       
    movl    $2, %eax                #  44:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          #  45:     &()    t30 <- BoolArr1
    movl    %eax, -240(%ebp)       
    movl    -240(%ebp), %eax        #  46:     param  0 <- t30
    pushl   %eax                   
    call    DIM                     #  47:     call   t31 <- DIM
    addl    $8, %esp               
    movl    %eax, -244(%ebp)       
    movl    $1, %eax                #  48:     mul    t32 <- 1, t31
    movl    -244(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -248(%ebp)       
    movl    -248(%ebp), %eax        #  49:     add    t33 <- t32, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -252(%ebp)       
    movl    -252(%ebp), %eax        #  50:     mul    t34 <- t33, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -256(%ebp)       
    leal    BoolArr1, %eax          #  51:     &()    t35 <- BoolArr1
    movl    %eax, -260(%ebp)       
    movl    -260(%ebp), %eax        #  52:     param  0 <- t35
    pushl   %eax                   
    call    DOFS                    #  53:     call   t36 <- DOFS
    addl    $4, %esp               
    movl    %eax, -264(%ebp)       
    movl    -256(%ebp), %eax        #  54:     add    t37 <- t34, t36
    movl    -264(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -268(%ebp)       
    movl    -232(%ebp), %eax        #  55:     add    t38 <- t29, t37
    movl    -268(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -272(%ebp)       
    movl    -272(%ebp), %edi       
    movzbl  (%edi), %eax            #  56:     param  1 <- @t38
    pushl   %eax                   
    leal    BoolArr0, %eax          #  57:     &()    t39 <- BoolArr0
    movl    %eax, -276(%ebp)       
    movl    $2, %eax                #  58:     mul    t40 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -284(%ebp)       
    leal    BoolArr0, %eax          #  59:     &()    t41 <- BoolArr0
    movl    %eax, -288(%ebp)       
    movl    -288(%ebp), %eax        #  60:     param  0 <- t41
    pushl   %eax                   
    call    DOFS                    #  61:     call   t42 <- DOFS
    addl    $4, %esp               
    movl    %eax, -292(%ebp)       
    movl    -284(%ebp), %eax        #  62:     add    t43 <- t40, t42
    movl    -292(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -296(%ebp)       
    movl    -276(%ebp), %eax        #  63:     add    t44 <- t39, t43
    movl    -296(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -300(%ebp)       
    movl    -300(%ebp), %edi       
    movzbl  (%edi), %eax            #  64:     param  0 <- @t44
    pushl   %eax                   
    call    booltest2               #  65:     call   t45 <- booltest2
    addl    $16, %esp              
    movb    %al, -301(%ebp)        
    movzbl  -301(%ebp), %eax        #  66:     assign b0 <- t45
    movb    %al, b0                
    leal    BoolArr2, %eax          #  67:     &()    t46 <- BoolArr2
    movl    %eax, -308(%ebp)       
    movl    $2, %eax                #  68:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          #  69:     &()    t47 <- BoolArr2
    movl    %eax, -312(%ebp)       
    movl    -312(%ebp), %eax        #  70:     param  0 <- t47
    pushl   %eax                   
    call    DIM                     #  71:     call   t48 <- DIM
    addl    $8, %esp               
    movl    %eax, -316(%ebp)       
    movl    $0, %eax                #  72:     mul    t49 <- 0, t48
    movl    -316(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -320(%ebp)       
    movl    -320(%ebp), %eax        #  73:     add    t50 <- t49, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -328(%ebp)       
    movl    $3, %eax                #  74:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          #  75:     &()    t51 <- BoolArr2
    movl    %eax, -332(%ebp)       
    movl    -332(%ebp), %eax        #  76:     param  0 <- t51
    pushl   %eax                   
    call    DIM                     #  77:     call   t52 <- DIM
    addl    $8, %esp               
    movl    %eax, -336(%ebp)       
    movl    -328(%ebp), %eax        #  78:     mul    t53 <- t50, t52
    movl    -336(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -340(%ebp)       
    movl    -340(%ebp), %eax        #  79:     add    t54 <- t53, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -344(%ebp)       
    movl    -344(%ebp), %eax        #  80:     mul    t55 <- t54, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -348(%ebp)       
    leal    BoolArr2, %eax          #  81:     &()    t56 <- BoolArr2
    movl    %eax, -352(%ebp)       
    movl    -352(%ebp), %eax        #  82:     param  0 <- t56
    pushl   %eax                   
    call    DOFS                    #  83:     call   t57 <- DOFS
    addl    $4, %esp               
    movl    %eax, -356(%ebp)       
    movl    -348(%ebp), %eax        #  84:     add    t58 <- t55, t57
    movl    -356(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -360(%ebp)       
    movl    -308(%ebp), %eax        #  85:     add    t59 <- t46, t58
    movl    -360(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -364(%ebp)       
    movl    -364(%ebp), %edi       
    leal    (%edi), %eax            #  86:     &()    t60 <- @t59
    movl    %eax, -372(%ebp)       
    movl    -372(%ebp), %eax        #  87:     param  3 <- t60
    pushl   %eax                   
    leal    BoolArr3, %eax          #  88:     &()    t61 <- BoolArr3
    movl    %eax, -376(%ebp)       
    movl    $2, %eax                #  89:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr3, %eax          #  90:     &()    t62 <- BoolArr3
    movl    %eax, -380(%ebp)       
    movl    -380(%ebp), %eax        #  91:     param  0 <- t62
    pushl   %eax                   
    call    DIM                     #  92:     call   t63 <- DIM
    addl    $8, %esp               
    movl    %eax, -384(%ebp)       
    movl    $1, %eax                #  93:     mul    t64 <- 1, t63
    movl    -384(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -388(%ebp)       
    movl    -388(%ebp), %eax        #  94:     add    t65 <- t64, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -392(%ebp)       
    movl    $3, %eax                #  95:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr3, %eax          #  96:     &()    t66 <- BoolArr3
    movl    %eax, -396(%ebp)       
    movl    -396(%ebp), %eax        #  97:     param  0 <- t66
    pushl   %eax                   
    call    DIM                     #  98:     call   t67 <- DIM
    addl    $8, %esp               
    movl    %eax, -400(%ebp)       
    movl    -392(%ebp), %eax        #  99:     mul    t68 <- t65, t67
    movl    -400(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -404(%ebp)       
    movl    -404(%ebp), %eax        # 100:     add    t69 <- t68, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -408(%ebp)       
    movl    -408(%ebp), %eax        # 101:     mul    t70 <- t69, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -416(%ebp)       
    leal    BoolArr3, %eax          # 102:     &()    t71 <- BoolArr3
    movl    %eax, -420(%ebp)       
    movl    -420(%ebp), %eax        # 103:     param  0 <- t71
    pushl   %eax                   
    call    DOFS                    # 104:     call   t72 <- DOFS
    addl    $4, %esp               
    movl    %eax, -424(%ebp)       
    movl    -416(%ebp), %eax        # 105:     add    t73 <- t70, t72
    movl    -424(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -428(%ebp)       
    movl    -376(%ebp), %eax        # 106:     add    t74 <- t61, t73
    movl    -428(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -432(%ebp)       
    movl    -432(%ebp), %edi       
    leal    (%edi), %eax            # 107:     &()    t75 <- @t74
    movl    %eax, -436(%ebp)       
    movl    -436(%ebp), %eax        # 108:     param  2 <- t75
    pushl   %eax                   
    leal    BoolArr2, %eax          # 109:     &()    t76 <- BoolArr2
    movl    %eax, -440(%ebp)       
    movl    $2, %eax                # 110:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 111:     &()    t77 <- BoolArr2
    movl    %eax, -444(%ebp)       
    movl    -444(%ebp), %eax        # 112:     param  0 <- t77
    pushl   %eax                   
    call    DIM                     # 113:     call   t78 <- DIM
    addl    $8, %esp               
    movl    %eax, -448(%ebp)       
    movl    $1, %eax                # 114:     mul    t79 <- 1, t78
    movl    -448(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -452(%ebp)       
    movl    -452(%ebp), %eax        # 115:     add    t80 <- t79, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -460(%ebp)       
    movl    $3, %eax                # 116:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 117:     &()    t81 <- BoolArr2
    movl    %eax, -464(%ebp)       
    movl    -464(%ebp), %eax        # 118:     param  0 <- t81
    pushl   %eax                   
    call    DIM                     # 119:     call   t82 <- DIM
    addl    $8, %esp               
    movl    %eax, -468(%ebp)       
    movl    -460(%ebp), %eax        # 120:     mul    t83 <- t80, t82
    movl    -468(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -472(%ebp)       
    movl    -472(%ebp), %eax        # 121:     add    t84 <- t83, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -476(%ebp)       
    movl    -476(%ebp), %eax        # 122:     mul    t85 <- t84, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -480(%ebp)       
    leal    BoolArr2, %eax          # 123:     &()    t86 <- BoolArr2
    movl    %eax, -484(%ebp)       
    movl    -484(%ebp), %eax        # 124:     param  0 <- t86
    pushl   %eax                   
    call    DOFS                    # 125:     call   t87 <- DOFS
    addl    $4, %esp               
    movl    %eax, -488(%ebp)       
    movl    -480(%ebp), %eax        # 126:     add    t88 <- t85, t87
    movl    -488(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -492(%ebp)       
    movl    -440(%ebp), %eax        # 127:     add    t89 <- t76, t88
    movl    -492(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -496(%ebp)       
    movl    -496(%ebp), %edi       
    movzbl  (%edi), %eax            # 128:     param  1 <- @t89
    pushl   %eax                   
    leal    BoolArr1, %eax          # 129:     &()    t90 <- BoolArr1
    movl    %eax, -504(%ebp)       
    movl    $2, %eax                # 130:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr1, %eax          # 131:     &()    t91 <- BoolArr1
    movl    %eax, -508(%ebp)       
    movl    -508(%ebp), %eax        # 132:     param  0 <- t91
    pushl   %eax                   
    call    DIM                     # 133:     call   t92 <- DIM
    addl    $8, %esp               
    movl    %eax, -512(%ebp)       
    movl    $2, %eax                # 134:     mul    t93 <- 2, t92
    movl    -512(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -516(%ebp)       
    movl    -516(%ebp), %eax        # 135:     add    t94 <- t93, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -520(%ebp)       
    movl    -520(%ebp), %eax        # 136:     mul    t95 <- t94, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -524(%ebp)       
    leal    BoolArr1, %eax          # 137:     &()    t96 <- BoolArr1
    movl    %eax, -528(%ebp)       
    movl    -528(%ebp), %eax        # 138:     param  0 <- t96
    pushl   %eax                   
    call    DOFS                    # 139:     call   t97 <- DOFS
    addl    $4, %esp               
    movl    %eax, -532(%ebp)       
    movl    -524(%ebp), %eax        # 140:     add    t98 <- t95, t97
    movl    -532(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -536(%ebp)       
    movl    -504(%ebp), %eax        # 141:     add    t99 <- t90, t98
    movl    -536(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -540(%ebp)       
    movl    -540(%ebp), %edi       
    movzbl  (%edi), %eax            # 142:     param  0 <- @t99
    pushl   %eax                   
    call    booltest2               # 143:     call   t100 <- booltest2
    addl    $16, %esp              
    movb    %al, -25(%ebp)         
    movzbl  -25(%ebp), %eax         # 144:     if     t100 = 1 goto 4
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test09_4             
    movl    $1, %eax                # 145:     assign t101 <- 1
    movb    %al, -26(%ebp)         
    jmp     l_test09_5              # 146:     goto   5
l_test09_4:
    movl    $0, %eax                # 148:     assign t101 <- 0
    movb    %al, -26(%ebp)         
l_test09_5:
    movzbl  -26(%ebp), %eax         # 150:     assign b1 <- t101
    movb    %al, b1                
    leal    BoolArr2, %eax          # 151:     &()    t102 <- BoolArr2
    movl    %eax, -32(%ebp)        
    movl    $2, %eax                # 152:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr2, %eax          # 153:     &()    t103 <- BoolArr2
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         # 154:     param  0 <- t103
    pushl   %eax                   
    call    DIM                     # 155:     call   t104 <- DIM
    addl    $8, %esp               
    movl    %eax, -40(%ebp)        
    movl    $0, %eax                # 156:     mul    t105 <- 0, t104
    movl    -40(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         # 157:     add    t106 <- t105, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    $3, %eax                # 158:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr2, %eax          # 159:     &()    t107 <- BoolArr2
    movl    %eax, -52(%ebp)        
    movl    -52(%ebp), %eax         # 160:     param  0 <- t107
    pushl   %eax                   
    call    DIM                     # 161:     call   t108 <- DIM
    addl    $8, %esp               
    movl    %eax, -56(%ebp)        
    movl    -48(%ebp), %eax         # 162:     mul    t109 <- t106, t108
    movl    -56(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -60(%ebp)        
    movl    -60(%ebp), %eax         # 163:     add    t110 <- t109, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         # 164:     mul    t111 <- t110, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -72(%ebp)        
    leal    BoolArr2, %eax          # 165:     &()    t112 <- BoolArr2
    movl    %eax, -76(%ebp)        
    movl    -76(%ebp), %eax         # 166:     param  0 <- t112
    pushl   %eax                   
    call    DOFS                    # 167:     call   t113 <- DOFS
    addl    $4, %esp               
    movl    %eax, -80(%ebp)        
    movl    -72(%ebp), %eax         # 168:     add    t114 <- t111, t113
    movl    -80(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -84(%ebp)        
    movl    -32(%ebp), %eax         # 169:     add    t115 <- t102, t114
    movl    -84(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -88(%ebp)        
    movl    -88(%ebp), %edi        
    leal    (%edi), %eax            # 170:     &()    t116 <- @t115
    movl    %eax, -92(%ebp)        
    movl    -92(%ebp), %eax         # 171:     param  3 <- t116
    pushl   %eax                   
    leal    BoolArr3, %eax          # 172:     &()    t117 <- BoolArr3
    movl    %eax, -96(%ebp)        
    movl    $2, %eax                # 173:     param  1 <- 2
    pushl   %eax                   
    leal    BoolArr3, %eax          # 174:     &()    t118 <- BoolArr3
    movl    %eax, -100(%ebp)       
    movl    -100(%ebp), %eax        # 175:     param  0 <- t118
    pushl   %eax                   
    call    DIM                     # 176:     call   t119 <- DIM
    addl    $8, %esp               
    movl    %eax, -104(%ebp)       
    movl    $1, %eax                # 177:     mul    t120 <- 1, t119
    movl    -104(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -112(%ebp)       
    movl    -112(%ebp), %eax        # 178:     add    t121 <- t120, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -116(%ebp)       
    movl    $3, %eax                # 179:     param  1 <- 3
    pushl   %eax                   
    leal    BoolArr3, %eax          # 180:     &()    t122 <- BoolArr3
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %eax        # 181:     param  0 <- t122
    pushl   %eax                   
    call    DIM                     # 182:     call   t123 <- DIM
    addl    $8, %esp               
    movl    %eax, -124(%ebp)       
    movl    -116(%ebp), %eax        # 183:     mul    t124 <- t121, t123
    movl    -124(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -128(%ebp)       
    movl    -128(%ebp), %eax        # 184:     add    t125 <- t124, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -132(%ebp)       
    movl    -132(%ebp), %eax        # 185:     mul    t126 <- t125, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -136(%ebp)       
    leal    BoolArr3, %eax          # 186:     &()    t127 <- BoolArr3
    movl    %eax, -140(%ebp)       
    movl    -140(%ebp), %eax        # 187:     param  0 <- t127
    pushl   %eax                   
    call    DOFS                    # 188:     call   t128 <- DOFS
    addl    $4, %esp               
    movl    %eax, -144(%ebp)       
    movl    -136(%ebp), %eax        # 189:     add    t129 <- t126, t128
    movl    -144(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -148(%ebp)       
    movl    -96(%ebp), %eax         # 190:     add    t130 <- t117, t129
    movl    -148(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -156(%ebp)       
    movl    -156(%ebp), %edi       
    leal    (%edi), %eax            # 191:     &()    t131 <- @t130
    movl    %eax, -160(%ebp)       
    movl    -160(%ebp), %eax        # 192:     param  2 <- t131
    pushl   %eax                   
    movl    $0, %eax                # 193:     param  1 <- 0
    pushl   %eax                   
    movl    $1, %eax                # 194:     param  0 <- 1
    pushl   %eax                   
    call    booltest2               # 195:     call   t132 <- booltest2
    addl    $16, %esp              
    movb    %al, -161(%ebp)        
    movzbl  -161(%ebp), %eax        # 196:     if     t132 = 1 goto 7
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test09_7             
    jmp     l_test09_8              # 197:     goto   8
l_test09_7:
    movl    $1, %eax                # 199:     assign t133 <- 1
    movb    %al, -162(%ebp)        
    jmp     l_test09_9              # 200:     goto   9
l_test09_8:
    movl    $0, %eax                # 202:     assign t133 <- 0
    movb    %al, -162(%ebp)        
l_test09_9:
    movzbl  -162(%ebp), %eax        # 204:     assign b0 <- t133
    movb    %al, b0                

l_test09_exit:
    # epilogue
    addl    $528, %esp              # remove locals
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

    # scope: test09
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
_str_1:                             # <array 15 of <char>>
    .long    1
    .long   15
    .asciz "Hello, World!\n"
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
