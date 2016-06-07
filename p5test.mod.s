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

    # scope bar
bar:
    # stack offsets:
    #    -13(%ebp)   1  [ $b        <bool> %ebp-13 ]
    #    -28(%ebp)  15  [ $booleanArr <array 7 of <bool>> %ebp-28 ]
    #    -32(%ebp)   4  [ $t0       <ptr(4) to <array 7 of <bool>>> %ebp-32 ]
    #    -36(%ebp)   4  [ $t1       <int> %ebp-36 ]

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
    movl    $1,-28(%ebp)            # local array 'booleanArr': 1 dimensions
    movl    $7,-24(%ebp)            #   dimension 1: 7 elements

    # function body
    movl    $1, %eax                #   0:     param  1 <- 1
    pushl   %eax                   
    leal    -28(%ebp), %eax         #   1:     &()    t0 <- booleanArr
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #   2:     param  0 <- t0
    pushl   %eax                   
    call    DIM                     #   3:     call   t1 <- DIM
    addl    $8, %esp               
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #   4:     param  0 <- t1
    pushl   %eax                   
    call    WriteInt                #   5:     call   WriteInt
    addl    $4, %esp               

l_bar_exit:
    # epilogue
    addl    $24, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope hello
main:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body
    call    bar                     #   0:     call   bar

l_hello_exit:
    # epilogue
    addl    $0, %esp                # remove locals
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



    # end of global data section
    #-----------------------------------------

    .end
##################################################
