##################################################
# test
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

    # scope dummyINTfunc
dummyINTfunc:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_dummyINTfunc_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope dummyCHARfunc
dummyCHARfunc:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_dummyCHARfunc_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope dummyBOOLfunc
dummyBOOLfunc:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_dummyBOOLfunc_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope dummyProcedure
dummyProcedure:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_dummyProcedure_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope f0
f0:
    # stack offsets:
    #    -13(%ebp)   1  [ $t3       <bool> %ebp-13 ]

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
    jmp     l_f0_2_if_false         #   0:     goto   2_if_false
l_f0_4_while_cond:
    movl    $96341, %eax            #   2:     if     96341 <= 79637 goto 5_while_body
    movl    $79637, %ebx           
    cmpl    %ebx, %eax             
    jle     l_f0_5_while_body      
    jmp     l_f0_3                  #   3:     goto   3
l_f0_5_while_body:
    jmp     l_f0_4_while_cond       #   5:     goto   4_while_cond
l_f0_3:
    jmp     l_f0_9_if_false         #   7:     goto   9_if_false
    jmp     l_f0_7                  #   8:     goto   7
l_f0_9_if_false:
l_f0_7:
    jmp     l_f0_0                  #  11:     goto   0
l_f0_2_if_false:
l_f0_0:
l_f0_11_while_cond:
    movl    $100, %eax              #  15:     if     100 = 99 goto 12_while_body
    movl    $99, %ebx              
    cmpl    %ebx, %eax             
    je      l_f0_12_while_body     
    jmp     l_f0_10                 #  16:     goto   10
l_f0_12_while_body:
l_f0_15_while_cond:
l_f0_18_while_cond:
    jmp     l_f0_18_while_cond      #  20:     goto   18_while_cond
    jmp     l_f0_15_while_cond      #  21:     goto   15_while_cond
    jmp     l_f0_11_while_cond      #  22:     goto   11_while_cond
l_f0_10:
    call    dummyBOOLfunc           #  24:     call   t3 <- dummyBOOLfunc
    movb    %al, -13(%ebp)         

l_f0_exit:
    # epilogue
    addl    $4, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope f1
f1:
    # stack offsets:
    #    -16(%ebp)   4  [ $t3       <int> %ebp-16 ]
    #      8(%ebp)   4  [ %v0       <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp+8 ]
    #    -17(%ebp)   1  [ $v1       <char> %ebp-17 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $8, %esp                # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 4(%esp)          
    movl    %eax, 0(%esp)          

    # function body
    movl    $7789, %eax             #   0:     param  0 <- 7789
    pushl   %eax                   
    call    WriteInt                #   1:     call   WriteInt
    addl    $4, %esp               
    call    ReadInt                 #   2:     call   t3 <- ReadInt
    movl    %eax, -16(%ebp)        
    movl    $97, %eax               #   3:     assign v1 <- 97
    movb    %al, -17(%ebp)         

l_f1_exit:
    # epilogue
    addl    $8, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope f2
f2:
    # stack offsets:
    #    -16(%ebp)   4  [ $t10      <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t11      <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t12      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t13      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t14      <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp-32 ]
    #    -36(%ebp)   4  [ $t15      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t16      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t17      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t18      <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp-48 ]
    #    -52(%ebp)   4  [ $t19      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t20      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t21      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t22      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t23      <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp-68 ]
    #    -72(%ebp)   4  [ $t24      <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t25      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t26      <int> %ebp-80 ]
    #    -81(%ebp)   1  [ $t27      <char> %ebp-81 ]
    #    -88(%ebp)   4  [ $t3       <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp-88 ]
    #    -89(%ebp)   1  [ $t4       <char> %ebp-89 ]
    #    -96(%ebp)   4  [ $t5       <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp-96 ]
    #   -100(%ebp)   4  [ $t6       <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp-100 ]
    #   -104(%ebp)   4  [ $t7       <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t8       <int> %ebp-108 ]
    #   -112(%ebp)   4  [ $t9       <int> %ebp-112 ]
    #   -3650536(%ebp)  3650424  [ $v0       <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>> %ebp-3650536 ]
    #   -3650537(%ebp)   1  [ $v1       <bool> %ebp-3650537 ]
    #   -3650538(%ebp)   1  [ $v2       <char> %ebp-3650538 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $3650528, %esp          # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $912632, %ecx          
    mov     %esp, %edi             
    rep     stosl                  
    movl    $5,-3650536(%ebp)       # local array 'v0': 5 dimensions
    movl    $9,-3650532(%ebp)       #   dimension 1: 9 elements
    movl    $26,-3650528(%ebp)      #   dimension 2: 26 elements
    movl    $60,-3650524(%ebp)      #   dimension 3: 60 elements
    movl    $4,-3650520(%ebp)       #   dimension 4: 4 elements
    movl    $65,-3650516(%ebp)      #   dimension 5: 65 elements

    # function body
    leal    -3650536(%ebp), %eax    #   0:     &()    t3 <- v0
    movl    %eax, -88(%ebp)        
    movl    -88(%ebp), %eax         #   1:     param  0 <- t3
    pushl   %eax                   
    call    f1                      #   2:     call   t4 <- f1
    addl    $4, %esp               
    movb    %al, -89(%ebp)         
    movzbl  -89(%ebp), %eax         #   3:     return t4
    jmp     l_f2_exit              
l_f2_2_while_cond:
    movl    $98, %eax               #   5:     if     98 > 100 goto 3_while_body
    movl    $100, %ebx             
    cmpl    %ebx, %eax             
    jg      l_f2_3_while_body      
    jmp     l_f2_1                  #   6:     goto   1
l_f2_3_while_body:
    movl    $97, %eax               #   8:     return 97
    jmp     l_f2_exit              
    jmp     l_f2_8_if_false         #   9:     goto   8_if_false
    jmp     l_f2_6                  #  10:     goto   6
l_f2_8_if_false:
l_f2_6:
    jmp     l_f2_2_while_cond       #  13:     goto   2_while_cond
l_f2_1:
    movl    $17795, %eax            #  15:     if     17795 < 95649 goto 10_if_true
    movl    $95649, %ebx           
    cmpl    %ebx, %eax             
    jl      l_f2_10_if_true        
    jmp     l_f2_11_if_false        #  16:     goto   11_if_false
l_f2_10_if_true:
    movl    $98, %eax               #  18:     return 98
    jmp     l_f2_exit              
    movl    $0, %eax                #  19:     assign v1 <- 0
    movb    %al, -3650537(%ebp)    
    leal    -3650536(%ebp), %eax    #  20:     &()    t5 <- v0
    movl    %eax, -96(%ebp)        
    movl    $2, %eax                #  21:     param  1 <- 2
    pushl   %eax                   
    leal    -3650536(%ebp), %eax    #  22:     &()    t6 <- v0
    movl    %eax, -100(%ebp)       
    movl    -100(%ebp), %eax        #  23:     param  0 <- t6
    pushl   %eax                   
    call    DIM                     #  24:     call   t7 <- DIM
    addl    $8, %esp               
    movl    %eax, -104(%ebp)       
    movl    $2276, %eax             #  25:     mul    t8 <- 2276, t7
    movl    -104(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  26:     add    t9 <- t8, 64262
    movl    $64262, %ebx           
    addl    %ebx, %eax             
    movl    %eax, -112(%ebp)       
    movl    $3, %eax                #  27:     param  1 <- 3
    pushl   %eax                   
    leal    -3650536(%ebp), %eax    #  28:     &()    t10 <- v0
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #  29:     param  0 <- t10
    pushl   %eax                   
    call    DIM                     #  30:     call   t11 <- DIM
    addl    $8, %esp               
    movl    %eax, -20(%ebp)        
    movl    -112(%ebp), %eax        #  31:     mul    t12 <- t9, t11
    movl    -20(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #  32:     add    t13 <- t12, 31851
    movl    $31851, %ebx           
    addl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    $4, %eax                #  33:     param  1 <- 4
    pushl   %eax                   
    leal    -3650536(%ebp), %eax    #  34:     &()    t14 <- v0
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #  35:     param  0 <- t14
    pushl   %eax                   
    call    DIM                     #  36:     call   t15 <- DIM
    addl    $8, %esp               
    movl    %eax, -36(%ebp)        
    movl    -28(%ebp), %eax         #  37:     mul    t16 <- t13, t15
    movl    -36(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #  38:     add    t17 <- t16, 51484
    movl    $51484, %ebx           
    addl    %ebx, %eax             
    movl    %eax, -44(%ebp)        
    movl    $5, %eax                #  39:     param  1 <- 5
    pushl   %eax                   
    leal    -3650536(%ebp), %eax    #  40:     &()    t18 <- v0
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  41:     param  0 <- t18
    pushl   %eax                   
    call    DIM                     #  42:     call   t19 <- DIM
    addl    $8, %esp               
    movl    %eax, -52(%ebp)        
    movl    -44(%ebp), %eax         #  43:     mul    t20 <- t17, t19
    movl    -52(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         #  44:     add    t21 <- t20, 49501
    movl    $49501, %ebx           
    addl    %ebx, %eax             
    movl    %eax, -60(%ebp)        
    movl    -60(%ebp), %eax         #  45:     mul    t22 <- t21, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -64(%ebp)        
    leal    -3650536(%ebp), %eax    #  46:     &()    t23 <- v0
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         #  47:     param  0 <- t23
    pushl   %eax                   
    call    DOFS                    #  48:     call   t24 <- DOFS
    addl    $4, %esp               
    movl    %eax, -72(%ebp)        
    movl    -64(%ebp), %eax         #  49:     add    t25 <- t22, t24
    movl    -72(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -76(%ebp)        
    movl    -96(%ebp), %eax         #  50:     add    t26 <- t5, t25
    movl    -76(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    $97, %eax               #  51:     assign @t26 <- 97
    movl    -80(%ebp), %edi        
    movb    %al, (%edi)            
    call    dummyCHARfunc           #  52:     call   t27 <- dummyCHARfunc
    movb    %al, -81(%ebp)         
    movl    $98, %eax               #  53:     return 98
    jmp     l_f2_exit              
    jmp     l_f2_9                  #  54:     goto   9
l_f2_11_if_false:
l_f2_9:

l_f2_exit:
    # epilogue
    addl    $3650528, %esp          # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test
main:
    # stack offsets:
    #    -13(%ebp)   1  [ $t0       <bool> %ebp-13 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>> %ebp-20 ]
    #    -21(%ebp)   1  [ $t2       <char> %ebp-21 ]

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
l_test_1_while_cond:
    movl    $97, %eax               #   1:     if     97 >= 98 goto 2_while_body
    movl    $98, %ebx              
    cmpl    %ebx, %eax             
    jge     l_test_2_while_body    
    jmp     l_test_0                #   2:     goto   0
l_test_2_while_body:
    jmp     l_test_1_while_cond     #   4:     goto   1_while_cond
l_test_0:
    call    dummyProcedure          #   6:     call   dummyProcedure
l_test_6_while_cond:
l_test_10_while_cond:
    movl    $1, %eax                #   9:     if     1 = 0 goto 11_while_body
    movl    $0, %ebx               
    cmpl    %ebx, %eax             
    je      l_test_11_while_body   
    jmp     l_test_9                #  10:     goto   9
l_test_11_while_body:
    jmp     l_test_10_while_cond    #  12:     goto   10_while_cond
l_test_9:
    jmp     l_test_6_while_cond     #  14:     goto   6_while_cond
    movl    $1, %eax                #  15:     if     1 = 0 goto 14
    movl    $0, %ebx               
    cmpl    %ebx, %eax             
    je      l_test_14              
    jmp     l_test_15               #  16:     goto   15
l_test_14:
    movl    $1, %eax                #  18:     assign t0 <- 1
    movb    %al, -13(%ebp)         
    jmp     l_test_16               #  19:     goto   16
l_test_15:
    movl    $0, %eax                #  21:     assign t0 <- 0
    movb    %al, -13(%ebp)         
l_test_16:
    movzbl  -13(%ebp), %eax         #  23:     assign v0 <- t0
    movb    %al, v0                
l_test_19_while_cond:
    leal    v1, %eax                #  25:     &()    t1 <- v1
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #  26:     param  0 <- t1
    pushl   %eax                   
    call    f1                      #  27:     call   t2 <- f1
    addl    $4, %esp               
    movb    %al, -21(%ebp)         
    movzbl  -21(%ebp), %eax         #  28:     if     t2 <= 100 goto 20_while_body
    movl    $100, %ebx             
    cmpl    %ebx, %eax             
    jle     l_test_20_while_body   
    jmp     l_test_18               #  29:     goto   18
l_test_20_while_body:
    jmp     l_test_19_while_cond    #  31:     goto   19_while_cond
l_test_18:

l_test_exit:
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

    # scope: test
v0:                                 # <bool>
    .skip    1
    .align   4
v1:                                 # <array 9 of <array 26 of <array 60 of <array 4 of <array 65 of <char>>>>>>
    .long    5
    .long    9
    .long   26
    .long   60
    .long    4
    .long   65
    .skip 3650400








    # end of global data section
    #-----------------------------------------

    .end
##################################################
