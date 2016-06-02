##################################################
# test04
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
    #      8(%ebp)   4  [ %a        <int> %ebp+8 ]
    #    -16(%ebp)   4  [ $p1       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t0       <int> %ebp-20 ]

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
    movl    i, %eax                 #   0:     assign a <- i
    movl    %eax, 8(%ebp)          
    movl    8(%ebp), %eax           #   1:     add    t0 <- a, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   2:     assign a <- t0
    movl    %eax, 8(%ebp)          
    jmp     l_foo_exit             

l_foo_exit:
    # epilogue
    addl    $8, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope bar
bar:
    # stack offsets:
    #      8(%ebp)   1  [ %d        <bool> %ebp+8 ]
    #    -13(%ebp)   1  [ $t0       <bool> %ebp-13 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -21(%ebp)   1  [ $t2       <bool> %ebp-21 ]

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
    movzbl  8(%ebp), %eax           #   0:     if     d = 1 goto 1_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_bar_1_if_true        
    jmp     l_bar_2_if_false        #   1:     goto   2_if_false
l_bar_1_if_true:
    movzbl  c, %eax                 #   3:     assign b <- c
    movb    %al, b                 
    jmp     l_bar_0                 #   4:     goto   0
l_bar_2_if_false:
    movzbl  c, %eax                 #   6:     if     c = 1 goto 6
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_bar_6                
    movl    $1, %eax                #   7:     assign t0 <- 1
    movb    %al, -13(%ebp)         
    jmp     l_bar_7                 #   8:     goto   7
l_bar_6:
    movl    $0, %eax                #  10:     assign t0 <- 0
    movb    %al, -13(%ebp)         
l_bar_7:
    movzbl  -13(%ebp), %eax         #  12:     assign b <- t0
    movb    %al, b                 
l_bar_0:
    movl    j, %eax                 #  14:     add    t1 <- j, k
    movl    k, %ebx                
    addl    %ebx, %eax             
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #  15:     assign i <- t1
    movl    %eax, i                
    movzbl  8(%ebp), %eax           #  16:     if     d = 1 goto 11
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_bar_11               
    movzbl  c, %eax                 #  17:     if     c = 1 goto 10
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_bar_10               
    jmp     l_bar_11                #  18:     goto   11
l_bar_10:
    movl    $1, %eax                #  20:     assign t2 <- 1
    movb    %al, -21(%ebp)         
    jmp     l_bar_12                #  21:     goto   12
l_bar_11:
    movl    $0, %eax                #  23:     assign t2 <- 0
    movb    %al, -21(%ebp)         
l_bar_12:
    movzbl  -21(%ebp), %eax         #  25:     return t2
    jmp     l_bar_exit             

l_bar_exit:
    # epilogue
    addl    $12, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test04
main:
    # stack offsets:
    #    -13(%ebp)   1  [ $t0       <bool> %ebp-13 ]
    #    -14(%ebp)   1  [ $t1       <bool> %ebp-14 ]
    #    -15(%ebp)   1  [ $t2       <bool> %ebp-15 ]
    #    -16(%ebp)   1  [ $t3       <bool> %ebp-16 ]
    #    -20(%ebp)   4  [ $t4       <int> %ebp-20 ]
    #    -21(%ebp)   1  [ $t5       <bool> %ebp-21 ]
    #    -28(%ebp)   4  [ $t6       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t7       <int> %ebp-32 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $20, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $5, %ecx               
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $1, %eax                #   0:     assign i <- 1
    movl    %eax, i                
    movl    $3, %eax                #   1:     param  0 <- 3
    pushl   %eax                   
    call    foo                     #   2:     call   foo
    addl    $4, %esp               
    movl    k, %eax                 #   3:     param  0 <- k
    pushl   %eax                   
    call    foo                     #   4:     call   foo
    addl    $4, %esp               
    movzbl  c, %eax                 #   5:     if     c = 1 goto 5
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test04_5             
    movl    $1, %eax                #   6:     assign t0 <- 1
    movb    %al, -13(%ebp)         
    jmp     l_test04_6              #   7:     goto   6
l_test04_5:
    movl    $0, %eax                #   9:     assign t0 <- 0
    movb    %al, -13(%ebp)         
l_test04_6:
    movzbl  -13(%ebp), %eax         #  11:     assign b <- t0
    movb    %al, b                 
    movzbl  b, %eax                 #  12:     param  0 <- b
    pushl   %eax                   
    call    bar                     #  13:     call   t1 <- bar
    addl    $4, %esp               
    movb    %al, -14(%ebp)         
    movzbl  -14(%ebp), %eax         #  14:     assign b <- t1
    movb    %al, b                 
    movzbl  b, %eax                 #  15:     param  0 <- b
    pushl   %eax                   
    call    bar                     #  16:     call   t2 <- bar
    addl    $4, %esp               
    movb    %al, -15(%ebp)         
    movzbl  -15(%ebp), %eax         #  17:     if     t2 = 1 goto 11
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test04_11            
    jmp     l_test04_10_if_false    #  18:     goto   10_if_false
l_test04_11:
    movzbl  c, %eax                 #  20:     param  0 <- c
    pushl   %eax                   
    call    bar                     #  21:     call   t3 <- bar
    addl    $4, %esp               
    movb    %al, -16(%ebp)         
    movzbl  -16(%ebp), %eax         #  22:     if     t3 = 1 goto 9_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test04_9_if_true     
    jmp     l_test04_10_if_false    #  23:     goto   10_if_false
l_test04_9_if_true:
    movl    k, %eax                 #  25:     add    t4 <- k, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #  26:     assign k <- t4
    movl    %eax, k                
    jmp     l_test04_8              #  27:     goto   8
l_test04_10_if_false:
l_test04_8:
    movl    $1, %eax                #  30:     param  0 <- 1
    pushl   %eax                   
    call    bar                     #  31:     call   t5 <- bar
    addl    $4, %esp               
    movb    %al, -21(%ebp)         
    movl    i, %eax                 #  32:     add    t6 <- i, j
    movl    j, %ebx                
    addl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #  33:     add    t7 <- t6, k
    movl    k, %ebx                
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #  34:     assign i <- t7
    movl    %eax, i                

l_test04_exit:
    # epilogue
    addl    $20, %esp               # remove locals
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

    # scope: test04
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
