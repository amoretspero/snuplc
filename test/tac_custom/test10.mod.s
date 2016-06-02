##################################################
# test10
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
    #      8(%ebp)   1  [ %p1       <bool> %ebp+8 ]
    #     12(%ebp)   4  [ %p2       <ptr(4) to <array 5 of <bool>>> %ebp+12 ]
    #     16(%ebp)   4  [ %p3       <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp+16 ]
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t2       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t3       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t4       <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t5       <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t6       <int> %ebp-40 ]

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

    # function body
    movl    $2, %eax                #   0:     param  1 <- 2
    pushl   %eax                   
    movl    16(%ebp), %eax          #   1:     param  0 <- p3
    pushl   %eax                   
    call    DIM                     #   2:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -16(%ebp)        
    movl    $1, %eax                #   3:     mul    t1 <- 1, t0
    movl    -16(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   4:     add    t2 <- t1, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #   5:     mul    t3 <- t2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    16(%ebp), %eax          #   6:     param  0 <- p3
    pushl   %eax                   
    call    DOFS                    #   7:     call   t4 <- DOFS
    addl    $4, %esp               
    movl    %eax, -32(%ebp)        
    movl    -28(%ebp), %eax         #   8:     add    t5 <- t3, t4
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -36(%ebp)        
    movl    16(%ebp), %eax          #   9:     add    t6 <- p3, t5
    movl    -36(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %edi        
    movzbl  (%edi), %eax            #  10:     return @t6
    jmp     l_foo_exit             

l_foo_exit:
    # epilogue
    addl    $28, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope bar
bar:
    # stack offsets:
    #      8(%ebp)   4  [ %p1       <ptr(4) to <array 5 of <bool>>> %ebp+8 ]
    #     12(%ebp)   4  [ %p2       <ptr(4) to <array 5 of <bool>>> %ebp+12 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body
    movl    12(%ebp), %eax          #   0:     assign p1 <- p2
    movl    %eax, 8(%ebp)          
    jmp     l_bar_exit             

l_bar_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test10
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 5 of <bool>>> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t100     <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t101     <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t102     <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t103     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-40 ]
    #    -44(%ebp)   4  [ $t104     <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t105     <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t106     <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t107     <ptr(4) to <bool>> %ebp-56 ]
    #    -60(%ebp)   4  [ $t108     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-60 ]
    #    -64(%ebp)   4  [ $t109     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-64 ]
    #    -68(%ebp)   4  [ $t11      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t110     <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t111     <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t112     <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t113     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-84 ]
    #    -88(%ebp)   4  [ $t114     <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t115     <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t116     <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t117     <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t118     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-104 ]
    #   -108(%ebp)   4  [ $t119     <int> %ebp-108 ]
    #   -112(%ebp)   4  [ $t12      <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t120     <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t121     <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t122     <ptr(4) to <bool>> %ebp-124 ]
    #   -128(%ebp)   4  [ $t123     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-128 ]
    #   -132(%ebp)   4  [ $t124     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-132 ]
    #   -136(%ebp)   4  [ $t125     <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t126     <int> %ebp-140 ]
    #   -144(%ebp)   4  [ $t127     <int> %ebp-144 ]
    #   -148(%ebp)   4  [ $t128     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-148 ]
    #   -152(%ebp)   4  [ $t129     <int> %ebp-152 ]
    #   -156(%ebp)   4  [ $t13      <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-156 ]
    #   -160(%ebp)   4  [ $t130     <int> %ebp-160 ]
    #   -164(%ebp)   4  [ $t131     <int> %ebp-164 ]
    #   -168(%ebp)   4  [ $t132     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-168 ]
    #   -172(%ebp)   4  [ $t133     <int> %ebp-172 ]
    #   -176(%ebp)   4  [ $t134     <int> %ebp-176 ]
    #   -180(%ebp)   4  [ $t135     <int> %ebp-180 ]
    #   -184(%ebp)   4  [ $t136     <int> %ebp-184 ]
    #   -188(%ebp)   4  [ $t137     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-188 ]
    #   -192(%ebp)   4  [ $t138     <int> %ebp-192 ]
    #   -196(%ebp)   4  [ $t139     <int> %ebp-196 ]
    #   -200(%ebp)   4  [ $t14      <int> %ebp-200 ]
    #   -204(%ebp)   4  [ $t140     <int> %ebp-204 ]
    #   -205(%ebp)   1  [ $t141     <bool> %ebp-205 ]
    #   -212(%ebp)   4  [ $t142     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-212 ]
    #   -216(%ebp)   4  [ $t143     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-216 ]
    #   -220(%ebp)   4  [ $t144     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-220 ]
    #   -224(%ebp)   4  [ $t145     <int> %ebp-224 ]
    #   -228(%ebp)   4  [ $t146     <int> %ebp-228 ]
    #   -232(%ebp)   4  [ $t147     <int> %ebp-232 ]
    #   -236(%ebp)   4  [ $t148     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-236 ]
    #   -240(%ebp)   4  [ $t149     <int> %ebp-240 ]
    #   -244(%ebp)   4  [ $t15      <int> %ebp-244 ]
    #   -248(%ebp)   4  [ $t150     <int> %ebp-248 ]
    #   -252(%ebp)   4  [ $t151     <int> %ebp-252 ]
    #   -256(%ebp)   4  [ $t152     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-256 ]
    #   -260(%ebp)   4  [ $t153     <int> %ebp-260 ]
    #   -264(%ebp)   4  [ $t154     <int> %ebp-264 ]
    #   -268(%ebp)   4  [ $t155     <int> %ebp-268 ]
    #   -272(%ebp)   4  [ $t156     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-272 ]
    #   -276(%ebp)   4  [ $t157     <int> %ebp-276 ]
    #   -280(%ebp)   4  [ $t158     <int> %ebp-280 ]
    #   -284(%ebp)   4  [ $t159     <int> %ebp-284 ]
    #   -288(%ebp)   4  [ $t16      <int> %ebp-288 ]
    #   -292(%ebp)   4  [ $t160     <int> %ebp-292 ]
    #   -296(%ebp)   4  [ $t161     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-296 ]
    #   -300(%ebp)   4  [ $t162     <int> %ebp-300 ]
    #   -304(%ebp)   4  [ $t163     <int> %ebp-304 ]
    #   -308(%ebp)   4  [ $t164     <int> %ebp-308 ]
    #   -312(%ebp)   4  [ $t165     <ptr(4) to <bool>> %ebp-312 ]
    #   -316(%ebp)   4  [ $t166     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-316 ]
    #   -320(%ebp)   4  [ $t167     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-320 ]
    #   -324(%ebp)   4  [ $t168     <int> %ebp-324 ]
    #   -328(%ebp)   4  [ $t169     <int> %ebp-328 ]
    #   -332(%ebp)   4  [ $t17      <ptr(4) to <bool>> %ebp-332 ]
    #   -336(%ebp)   4  [ $t170     <int> %ebp-336 ]
    #   -340(%ebp)   4  [ $t171     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-340 ]
    #   -344(%ebp)   4  [ $t172     <int> %ebp-344 ]
    #   -348(%ebp)   4  [ $t173     <int> %ebp-348 ]
    #   -352(%ebp)   4  [ $t174     <int> %ebp-352 ]
    #   -356(%ebp)   4  [ $t175     <int> %ebp-356 ]
    #   -360(%ebp)   4  [ $t176     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-360 ]
    #   -364(%ebp)   4  [ $t177     <int> %ebp-364 ]
    #   -368(%ebp)   4  [ $t178     <int> %ebp-368 ]
    #   -372(%ebp)   4  [ $t179     <int> %ebp-372 ]
    #   -376(%ebp)   4  [ $t18      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-376 ]
    #   -377(%ebp)   1  [ $t180     <bool> %ebp-377 ]
    #   -384(%ebp)   4  [ $t181     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-384 ]
    #   -388(%ebp)   4  [ $t182     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-388 ]
    #   -392(%ebp)   4  [ $t183     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-392 ]
    #   -396(%ebp)   4  [ $t184     <int> %ebp-396 ]
    #   -400(%ebp)   4  [ $t185     <int> %ebp-400 ]
    #   -404(%ebp)   4  [ $t186     <int> %ebp-404 ]
    #   -408(%ebp)   4  [ $t187     <int> %ebp-408 ]
    #   -412(%ebp)   4  [ $t188     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-412 ]
    #   -416(%ebp)   4  [ $t189     <int> %ebp-416 ]
    #   -420(%ebp)   4  [ $t19      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-420 ]
    #   -424(%ebp)   4  [ $t190     <int> %ebp-424 ]
    #   -428(%ebp)   4  [ $t191     <int> %ebp-428 ]
    #   -432(%ebp)   4  [ $t192     <ptr(4) to <bool>> %ebp-432 ]
    #   -436(%ebp)   4  [ $t193     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-436 ]
    #   -440(%ebp)   4  [ $t194     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-440 ]
    #   -444(%ebp)   4  [ $t195     <int> %ebp-444 ]
    #   -448(%ebp)   4  [ $t196     <int> %ebp-448 ]
    #   -452(%ebp)   4  [ $t197     <int> %ebp-452 ]
    #   -456(%ebp)   4  [ $t198     <int> %ebp-456 ]
    #   -460(%ebp)   4  [ $t199     <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-460 ]
    #   -461(%ebp)   1  [ $t2       <bool> %ebp-461 ]
    #   -468(%ebp)   4  [ $t20      <int> %ebp-468 ]
    #   -472(%ebp)   4  [ $t200     <int> %ebp-472 ]
    #   -476(%ebp)   4  [ $t201     <int> %ebp-476 ]
    #   -480(%ebp)   4  [ $t202     <int> %ebp-480 ]
    #   -481(%ebp)   1  [ $t203     <bool> %ebp-481 ]
    #   -488(%ebp)   4  [ $t204     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-488 ]
    #   -492(%ebp)   4  [ $t205     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-492 ]
    #   -496(%ebp)   4  [ $t206     <int> %ebp-496 ]
    #   -500(%ebp)   4  [ $t207     <int> %ebp-500 ]
    #   -504(%ebp)   4  [ $t208     <int> %ebp-504 ]
    #   -508(%ebp)   4  [ $t209     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-508 ]
    #   -512(%ebp)   4  [ $t21      <int> %ebp-512 ]
    #   -516(%ebp)   4  [ $t210     <int> %ebp-516 ]
    #   -520(%ebp)   4  [ $t211     <int> %ebp-520 ]
    #   -524(%ebp)   4  [ $t212     <int> %ebp-524 ]
    #   -528(%ebp)   4  [ $t213     <int> %ebp-528 ]
    #   -532(%ebp)   4  [ $t214     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-532 ]
    #   -536(%ebp)   4  [ $t215     <int> %ebp-536 ]
    #   -540(%ebp)   4  [ $t216     <int> %ebp-540 ]
    #   -544(%ebp)   4  [ $t217     <int> %ebp-544 ]
    #   -548(%ebp)   4  [ $t218     <ptr(4) to <bool>> %ebp-548 ]
    #   -552(%ebp)   4  [ $t219     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-552 ]
    #   -556(%ebp)   4  [ $t22      <int> %ebp-556 ]
    #   -560(%ebp)   4  [ $t220     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-560 ]
    #   -564(%ebp)   4  [ $t221     <int> %ebp-564 ]
    #   -568(%ebp)   4  [ $t222     <int> %ebp-568 ]
    #   -572(%ebp)   4  [ $t223     <int> %ebp-572 ]
    #   -576(%ebp)   4  [ $t224     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-576 ]
    #   -580(%ebp)   4  [ $t225     <int> %ebp-580 ]
    #   -584(%ebp)   4  [ $t226     <int> %ebp-584 ]
    #   -588(%ebp)   4  [ $t227     <int> %ebp-588 ]
    #   -592(%ebp)   4  [ $t228     <int> %ebp-592 ]
    #   -596(%ebp)   4  [ $t229     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-596 ]
    #   -600(%ebp)   4  [ $t23      <int> %ebp-600 ]
    #   -604(%ebp)   4  [ $t230     <int> %ebp-604 ]
    #   -608(%ebp)   4  [ $t231     <int> %ebp-608 ]
    #   -612(%ebp)   4  [ $t232     <int> %ebp-612 ]
    #   -616(%ebp)   4  [ $t233     <ptr(4) to <bool>> %ebp-616 ]
    #   -620(%ebp)   4  [ $t234     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-620 ]
    #   -624(%ebp)   4  [ $t235     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-624 ]
    #   -628(%ebp)   4  [ $t236     <int> %ebp-628 ]
    #   -632(%ebp)   4  [ $t237     <int> %ebp-632 ]
    #   -636(%ebp)   4  [ $t238     <int> %ebp-636 ]
    #   -640(%ebp)   4  [ $t239     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-640 ]
    #   -644(%ebp)   4  [ $t24      <ptr(4) to <array 5 of <array 5 of <bool>>>> %ebp-644 ]
    #   -648(%ebp)   4  [ $t240     <int> %ebp-648 ]
    #   -652(%ebp)   4  [ $t241     <int> %ebp-652 ]
    #   -656(%ebp)   4  [ $t242     <int> %ebp-656 ]
    #   -660(%ebp)   4  [ $t243     <int> %ebp-660 ]
    #   -664(%ebp)   4  [ $t244     <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-664 ]
    #   -668(%ebp)   4  [ $t245     <int> %ebp-668 ]
    #   -672(%ebp)   4  [ $t246     <int> %ebp-672 ]
    #   -676(%ebp)   4  [ $t247     <int> %ebp-676 ]
    #   -677(%ebp)   1  [ $t248     <bool> %ebp-677 ]
    #   -684(%ebp)   4  [ $t249     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-684 ]
    #   -688(%ebp)   4  [ $t25      <int> %ebp-688 ]
    #   -692(%ebp)   4  [ $t250     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-692 ]
    #   -696(%ebp)   4  [ $t251     <int> %ebp-696 ]
    #   -700(%ebp)   4  [ $t252     <int> %ebp-700 ]
    #   -704(%ebp)   4  [ $t253     <int> %ebp-704 ]
    #   -708(%ebp)   4  [ $t254     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-708 ]
    #   -712(%ebp)   4  [ $t255     <int> %ebp-712 ]
    #   -716(%ebp)   4  [ $t256     <int> %ebp-716 ]
    #   -720(%ebp)   4  [ $t257     <int> %ebp-720 ]
    #   -724(%ebp)   4  [ $t258     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-724 ]
    #   -728(%ebp)   4  [ $t259     <int> %ebp-728 ]
    #   -732(%ebp)   4  [ $t26      <int> %ebp-732 ]
    #   -736(%ebp)   4  [ $t260     <int> %ebp-736 ]
    #   -740(%ebp)   4  [ $t261     <int> %ebp-740 ]
    #   -744(%ebp)   4  [ $t262     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-744 ]
    #   -748(%ebp)   4  [ $t263     <int> %ebp-748 ]
    #   -752(%ebp)   4  [ $t264     <int> %ebp-752 ]
    #   -756(%ebp)   4  [ $t265     <int> %ebp-756 ]
    #   -760(%ebp)   4  [ $t266     <int> %ebp-760 ]
    #   -764(%ebp)   4  [ $t267     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-764 ]
    #   -768(%ebp)   4  [ $t268     <int> %ebp-768 ]
    #   -772(%ebp)   4  [ $t269     <int> %ebp-772 ]
    #   -776(%ebp)   4  [ $t27      <int> %ebp-776 ]
    #   -780(%ebp)   4  [ $t270     <int> %ebp-780 ]
    #   -784(%ebp)   4  [ $t271     <ptr(4) to <bool>> %ebp-784 ]
    #   -788(%ebp)   4  [ $t272     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-788 ]
    #   -792(%ebp)   4  [ $t273     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-792 ]
    #   -796(%ebp)   4  [ $t274     <int> %ebp-796 ]
    #   -800(%ebp)   4  [ $t275     <int> %ebp-800 ]
    #   -804(%ebp)   4  [ $t276     <int> %ebp-804 ]
    #   -808(%ebp)   4  [ $t277     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-808 ]
    #   -812(%ebp)   4  [ $t278     <int> %ebp-812 ]
    #   -816(%ebp)   4  [ $t279     <int> %ebp-816 ]
    #   -820(%ebp)   4  [ $t28      <ptr(4) to <bool>> %ebp-820 ]
    #   -824(%ebp)   4  [ $t280     <int> %ebp-824 ]
    #   -828(%ebp)   4  [ $t281     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-828 ]
    #   -832(%ebp)   4  [ $t282     <int> %ebp-832 ]
    #   -836(%ebp)   4  [ $t283     <int> %ebp-836 ]
    #   -840(%ebp)   4  [ $t284     <int> %ebp-840 ]
    #   -844(%ebp)   4  [ $t285     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-844 ]
    #   -848(%ebp)   4  [ $t286     <int> %ebp-848 ]
    #   -852(%ebp)   4  [ $t287     <int> %ebp-852 ]
    #   -856(%ebp)   4  [ $t288     <int> %ebp-856 ]
    #   -860(%ebp)   4  [ $t289     <int> %ebp-860 ]
    #   -864(%ebp)   4  [ $t29      <ptr(4) to <array 5 of <bool>>> %ebp-864 ]
    #   -868(%ebp)   4  [ $t290     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-868 ]
    #   -872(%ebp)   4  [ $t291     <int> %ebp-872 ]
    #   -876(%ebp)   4  [ $t292     <int> %ebp-876 ]
    #   -880(%ebp)   4  [ $t293     <int> %ebp-880 ]
    #   -884(%ebp)   4  [ $t294     <ptr(4) to <bool>> %ebp-884 ]
    #   -888(%ebp)   4  [ $t295     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-888 ]
    #   -892(%ebp)   4  [ $t296     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-892 ]
    #   -896(%ebp)   4  [ $t297     <int> %ebp-896 ]
    #   -900(%ebp)   4  [ $t298     <int> %ebp-900 ]
    #   -904(%ebp)   4  [ $t299     <int> %ebp-904 ]
    #   -908(%ebp)   4  [ $t3       <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-908 ]
    #   -912(%ebp)   4  [ $t30      <int> %ebp-912 ]
    #   -916(%ebp)   4  [ $t300     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-916 ]
    #   -920(%ebp)   4  [ $t301     <int> %ebp-920 ]
    #   -924(%ebp)   4  [ $t302     <int> %ebp-924 ]
    #   -928(%ebp)   4  [ $t303     <int> %ebp-928 ]
    #   -932(%ebp)   4  [ $t304     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-932 ]
    #   -936(%ebp)   4  [ $t305     <int> %ebp-936 ]
    #   -940(%ebp)   4  [ $t306     <int> %ebp-940 ]
    #   -944(%ebp)   4  [ $t307     <int> %ebp-944 ]
    #   -948(%ebp)   4  [ $t308     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-948 ]
    #   -952(%ebp)   4  [ $t309     <int> %ebp-952 ]
    #   -956(%ebp)   4  [ $t31      <ptr(4) to <array 5 of <bool>>> %ebp-956 ]
    #   -960(%ebp)   4  [ $t310     <int> %ebp-960 ]
    #   -964(%ebp)   4  [ $t311     <int> %ebp-964 ]
    #   -968(%ebp)   4  [ $t312     <int> %ebp-968 ]
    #   -972(%ebp)   4  [ $t313     <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-972 ]
    #   -976(%ebp)   4  [ $t314     <int> %ebp-976 ]
    #   -980(%ebp)   4  [ $t315     <int> %ebp-980 ]
    #   -984(%ebp)   4  [ $t316     <int> %ebp-984 ]
    #   -985(%ebp)   1  [ $t317     <bool> %ebp-985 ]
    #   -992(%ebp)   4  [ $t32      <int> %ebp-992 ]
    #   -996(%ebp)   4  [ $t33      <int> %ebp-996 ]
    #   -1000(%ebp)   4  [ $t34      <int> %ebp-1000 ]
    #   -1001(%ebp)   1  [ $t35      <bool> %ebp-1001 ]
    #   -1008(%ebp)   4  [ $t36      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-1008 ]
    #   -1012(%ebp)   4  [ $t37      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-1012 ]
    #   -1016(%ebp)   4  [ $t38      <int> %ebp-1016 ]
    #   -1020(%ebp)   4  [ $t39      <int> %ebp-1020 ]
    #   -1024(%ebp)   4  [ $t4       <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-1024 ]
    #   -1028(%ebp)   4  [ $t40      <int> %ebp-1028 ]
    #   -1032(%ebp)   4  [ $t41      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-1032 ]
    #   -1036(%ebp)   4  [ $t42      <int> %ebp-1036 ]
    #   -1040(%ebp)   4  [ $t43      <int> %ebp-1040 ]
    #   -1044(%ebp)   4  [ $t44      <int> %ebp-1044 ]
    #   -1048(%ebp)   4  [ $t45      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-1048 ]
    #   -1052(%ebp)   4  [ $t46      <int> %ebp-1052 ]
    #   -1056(%ebp)   4  [ $t47      <int> %ebp-1056 ]
    #   -1060(%ebp)   4  [ $t48      <int> %ebp-1060 ]
    #   -1064(%ebp)   4  [ $t49      <int> %ebp-1064 ]
    #   -1068(%ebp)   4  [ $t5       <int> %ebp-1068 ]
    #   -1072(%ebp)   4  [ $t50      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>> %ebp-1072 ]
    #   -1076(%ebp)   4  [ $t51      <int> %ebp-1076 ]
    #   -1080(%ebp)   4  [ $t52      <int> %ebp-1080 ]
    #   -1084(%ebp)   4  [ $t53      <int> %ebp-1084 ]
    #   -1088(%ebp)   4  [ $t54      <ptr(4) to <bool>> %ebp-1088 ]
    #   -1092(%ebp)   4  [ $t55      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1092 ]
    #   -1096(%ebp)   4  [ $t56      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1096 ]
    #   -1100(%ebp)   4  [ $t57      <int> %ebp-1100 ]
    #   -1104(%ebp)   4  [ $t58      <int> %ebp-1104 ]
    #   -1108(%ebp)   4  [ $t59      <int> %ebp-1108 ]
    #   -1112(%ebp)   4  [ $t6       <int> %ebp-1112 ]
    #   -1116(%ebp)   4  [ $t60      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1116 ]
    #   -1120(%ebp)   4  [ $t61      <int> %ebp-1120 ]
    #   -1124(%ebp)   4  [ $t62      <int> %ebp-1124 ]
    #   -1128(%ebp)   4  [ $t63      <int> %ebp-1128 ]
    #   -1132(%ebp)   4  [ $t64      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1132 ]
    #   -1136(%ebp)   4  [ $t65      <int> %ebp-1136 ]
    #   -1140(%ebp)   4  [ $t66      <int> %ebp-1140 ]
    #   -1144(%ebp)   4  [ $t67      <int> %ebp-1144 ]
    #   -1148(%ebp)   4  [ $t68      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1148 ]
    #   -1152(%ebp)   4  [ $t69      <int> %ebp-1152 ]
    #   -1156(%ebp)   4  [ $t7       <int> %ebp-1156 ]
    #   -1160(%ebp)   4  [ $t70      <int> %ebp-1160 ]
    #   -1164(%ebp)   4  [ $t71      <int> %ebp-1164 ]
    #   -1168(%ebp)   4  [ $t72      <int> %ebp-1168 ]
    #   -1172(%ebp)   4  [ $t73      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1172 ]
    #   -1176(%ebp)   4  [ $t74      <int> %ebp-1176 ]
    #   -1180(%ebp)   4  [ $t75      <int> %ebp-1180 ]
    #   -1184(%ebp)   4  [ $t76      <int> %ebp-1184 ]
    #   -1188(%ebp)   4  [ $t77      <ptr(4) to <bool>> %ebp-1188 ]
    #   -1192(%ebp)   4  [ $t78      <ptr(4) to <array 5 of <bool>>> %ebp-1192 ]
    #   -1196(%ebp)   4  [ $t79      <int> %ebp-1196 ]
    #   -1200(%ebp)   4  [ $t8       <ptr(4) to <array 5 of <array 5 of <array 5 of <bool>>>>> %ebp-1200 ]
    #   -1204(%ebp)   4  [ $t80      <ptr(4) to <array 5 of <bool>>> %ebp-1204 ]
    #   -1208(%ebp)   4  [ $t81      <int> %ebp-1208 ]
    #   -1212(%ebp)   4  [ $t82      <int> %ebp-1212 ]
    #   -1216(%ebp)   4  [ $t83      <int> %ebp-1216 ]
    #   -1217(%ebp)   1  [ $t84      <bool> %ebp-1217 ]
    #   -1224(%ebp)   4  [ $t85      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1224 ]
    #   -1228(%ebp)   4  [ $t86      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1228 ]
    #   -1232(%ebp)   4  [ $t87      <int> %ebp-1232 ]
    #   -1236(%ebp)   4  [ $t88      <int> %ebp-1236 ]
    #   -1240(%ebp)   4  [ $t89      <int> %ebp-1240 ]
    #   -1244(%ebp)   4  [ $t9       <int> %ebp-1244 ]
    #   -1248(%ebp)   4  [ $t90      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1248 ]
    #   -1252(%ebp)   4  [ $t91      <int> %ebp-1252 ]
    #   -1256(%ebp)   4  [ $t92      <int> %ebp-1256 ]
    #   -1260(%ebp)   4  [ $t93      <int> %ebp-1260 ]
    #   -1264(%ebp)   4  [ $t94      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1264 ]
    #   -1268(%ebp)   4  [ $t95      <int> %ebp-1268 ]
    #   -1272(%ebp)   4  [ $t96      <int> %ebp-1272 ]
    #   -1276(%ebp)   4  [ $t97      <int> %ebp-1276 ]
    #   -1280(%ebp)   4  [ $t98      <ptr(4) to <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>> %ebp-1280 ]
    #   -1284(%ebp)   4  [ $t99      <int> %ebp-1284 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $1272, %esp             # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $318, %ecx             
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    leal    boolArr1, %eax          #   0:     &()    t0 <- boolArr1
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   1:     param  2 <- t0
    pushl   %eax                   
    leal    boolArr0, %eax          #   2:     &()    t1 <- boolArr0
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   3:     param  1 <- t1
    pushl   %eax                   
    movzbl  b0, %eax                #   4:     param  0 <- b0
    pushl   %eax                   
    call    foo                     #   5:     call   t2 <- foo
    addl    $12, %esp              
    movb    %al, -461(%ebp)        
    movzbl  -461(%ebp), %eax        #   6:     assign b0 <- t2
    movb    %al, b0                
    leal    boolArr2, %eax          #   7:     &()    t3 <- boolArr2
    movl    %eax, -908(%ebp)       
    movl    $2, %eax                #   8:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr2, %eax          #   9:     &()    t4 <- boolArr2
    movl    %eax, -1024(%ebp)      
    movl    -1024(%ebp), %eax       #  10:     param  0 <- t4
    pushl   %eax                   
    call    DIM                     #  11:     call   t5 <- DIM
    addl    $8, %esp               
    movl    %eax, -1068(%ebp)      
    movl    $1, %eax                #  12:     mul    t6 <- 1, t5
    movl    -1068(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1112(%ebp)      
    movl    -1112(%ebp), %eax       #  13:     add    t7 <- t6, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1156(%ebp)      
    movl    $3, %eax                #  14:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr2, %eax          #  15:     &()    t8 <- boolArr2
    movl    %eax, -1200(%ebp)      
    movl    -1200(%ebp), %eax       #  16:     param  0 <- t8
    pushl   %eax                   
    call    DIM                     #  17:     call   t9 <- DIM
    addl    $8, %esp               
    movl    %eax, -1244(%ebp)      
    movl    -1156(%ebp), %eax       #  18:     mul    t10 <- t7, t9
    movl    -1244(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #  19:     add    t11 <- t10, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %eax         #  20:     mul    t12 <- t11, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -112(%ebp)       
    leal    boolArr2, %eax          #  21:     &()    t13 <- boolArr2
    movl    %eax, -156(%ebp)       
    movl    -156(%ebp), %eax        #  22:     param  0 <- t13
    pushl   %eax                   
    call    DOFS                    #  23:     call   t14 <- DOFS
    addl    $4, %esp               
    movl    %eax, -200(%ebp)       
    movl    -112(%ebp), %eax        #  24:     add    t15 <- t12, t14
    movl    -200(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -244(%ebp)       
    movl    -908(%ebp), %eax        #  25:     add    t16 <- t3, t15
    movl    -244(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -288(%ebp)       
    movl    -288(%ebp), %edi       
    leal    (%edi), %eax            #  26:     &()    t17 <- @t16
    movl    %eax, -332(%ebp)       
    movl    -332(%ebp), %eax        #  27:     param  2 <- t17
    pushl   %eax                   
    leal    boolArr1, %eax          #  28:     &()    t18 <- boolArr1
    movl    %eax, -376(%ebp)       
    movl    $2, %eax                #  29:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr1, %eax          #  30:     &()    t19 <- boolArr1
    movl    %eax, -420(%ebp)       
    movl    -420(%ebp), %eax        #  31:     param  0 <- t19
    pushl   %eax                   
    call    DIM                     #  32:     call   t20 <- DIM
    addl    $8, %esp               
    movl    %eax, -468(%ebp)       
    movl    $1, %eax                #  33:     mul    t21 <- 1, t20
    movl    -468(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -512(%ebp)       
    movl    -512(%ebp), %eax        #  34:     add    t22 <- t21, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -556(%ebp)       
    movl    -556(%ebp), %eax        #  35:     mul    t23 <- t22, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -600(%ebp)       
    leal    boolArr1, %eax          #  36:     &()    t24 <- boolArr1
    movl    %eax, -644(%ebp)       
    movl    -644(%ebp), %eax        #  37:     param  0 <- t24
    pushl   %eax                   
    call    DOFS                    #  38:     call   t25 <- DOFS
    addl    $4, %esp               
    movl    %eax, -688(%ebp)       
    movl    -600(%ebp), %eax        #  39:     add    t26 <- t23, t25
    movl    -688(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -732(%ebp)       
    movl    -376(%ebp), %eax        #  40:     add    t27 <- t18, t26
    movl    -732(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -776(%ebp)       
    movl    -776(%ebp), %edi       
    leal    (%edi), %eax            #  41:     &()    t28 <- @t27
    movl    %eax, -820(%ebp)       
    movl    -820(%ebp), %eax        #  42:     param  1 <- t28
    pushl   %eax                   
    leal    boolArr0, %eax          #  43:     &()    t29 <- boolArr0
    movl    %eax, -864(%ebp)       
    movl    $1, %eax                #  44:     mul    t30 <- 1, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -912(%ebp)       
    leal    boolArr0, %eax          #  45:     &()    t31 <- boolArr0
    movl    %eax, -956(%ebp)       
    movl    -956(%ebp), %eax        #  46:     param  0 <- t31
    pushl   %eax                   
    call    DOFS                    #  47:     call   t32 <- DOFS
    addl    $4, %esp               
    movl    %eax, -992(%ebp)       
    movl    -912(%ebp), %eax        #  48:     add    t33 <- t30, t32
    movl    -992(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -996(%ebp)       
    movl    -864(%ebp), %eax        #  49:     add    t34 <- t29, t33
    movl    -996(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -1000(%ebp)      
    movl    -1000(%ebp), %edi      
    movzbl  (%edi), %eax            #  50:     param  0 <- @t34
    pushl   %eax                   
    call    foo                     #  51:     call   t35 <- foo
    addl    $12, %esp              
    movb    %al, -1001(%ebp)       
    movzbl  -1001(%ebp), %eax       #  52:     assign b1 <- t35
    movb    %al, b1                
    leal    boolArr3, %eax          #  53:     &()    t36 <- boolArr3
    movl    %eax, -1008(%ebp)      
    movl    $2, %eax                #  54:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr3, %eax          #  55:     &()    t37 <- boolArr3
    movl    %eax, -1012(%ebp)      
    movl    -1012(%ebp), %eax       #  56:     param  0 <- t37
    pushl   %eax                   
    call    DIM                     #  57:     call   t38 <- DIM
    addl    $8, %esp               
    movl    %eax, -1016(%ebp)      
    movl    $1, %eax                #  58:     mul    t39 <- 1, t38
    movl    -1016(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1020(%ebp)      
    movl    -1020(%ebp), %eax       #  59:     add    t40 <- t39, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1028(%ebp)      
    movl    $3, %eax                #  60:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr3, %eax          #  61:     &()    t41 <- boolArr3
    movl    %eax, -1032(%ebp)      
    movl    -1032(%ebp), %eax       #  62:     param  0 <- t41
    pushl   %eax                   
    call    DIM                     #  63:     call   t42 <- DIM
    addl    $8, %esp               
    movl    %eax, -1036(%ebp)      
    movl    -1028(%ebp), %eax       #  64:     mul    t43 <- t40, t42
    movl    -1036(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1040(%ebp)      
    movl    -1040(%ebp), %eax       #  65:     add    t44 <- t43, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1044(%ebp)      
    movl    $4, %eax                #  66:     param  1 <- 4
    pushl   %eax                   
    leal    boolArr3, %eax          #  67:     &()    t45 <- boolArr3
    movl    %eax, -1048(%ebp)      
    movl    -1048(%ebp), %eax       #  68:     param  0 <- t45
    pushl   %eax                   
    call    DIM                     #  69:     call   t46 <- DIM
    addl    $8, %esp               
    movl    %eax, -1052(%ebp)      
    movl    -1044(%ebp), %eax       #  70:     mul    t47 <- t44, t46
    movl    -1052(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1056(%ebp)      
    movl    -1056(%ebp), %eax       #  71:     add    t48 <- t47, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1060(%ebp)      
    movl    -1060(%ebp), %eax       #  72:     mul    t49 <- t48, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -1064(%ebp)      
    leal    boolArr3, %eax          #  73:     &()    t50 <- boolArr3
    movl    %eax, -1072(%ebp)      
    movl    -1072(%ebp), %eax       #  74:     param  0 <- t50
    pushl   %eax                   
    call    DOFS                    #  75:     call   t51 <- DOFS
    addl    $4, %esp               
    movl    %eax, -1076(%ebp)      
    movl    -1064(%ebp), %eax       #  76:     add    t52 <- t49, t51
    movl    -1076(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1080(%ebp)      
    movl    -1008(%ebp), %eax       #  77:     add    t53 <- t36, t52
    movl    -1080(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1084(%ebp)      
    movl    -1084(%ebp), %edi      
    leal    (%edi), %eax            #  78:     &()    t54 <- @t53
    movl    %eax, -1088(%ebp)      
    movl    -1088(%ebp), %eax       #  79:     param  2 <- t54
    pushl   %eax                   
    leal    boolArr4, %eax          #  80:     &()    t55 <- boolArr4
    movl    %eax, -1092(%ebp)      
    movl    $2, %eax                #  81:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr4, %eax          #  82:     &()    t56 <- boolArr4
    movl    %eax, -1096(%ebp)      
    movl    -1096(%ebp), %eax       #  83:     param  0 <- t56
    pushl   %eax                   
    call    DIM                     #  84:     call   t57 <- DIM
    addl    $8, %esp               
    movl    %eax, -1100(%ebp)      
    movl    $1, %eax                #  85:     mul    t58 <- 1, t57
    movl    -1100(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1104(%ebp)      
    movl    -1104(%ebp), %eax       #  86:     add    t59 <- t58, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1108(%ebp)      
    movl    $3, %eax                #  87:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr4, %eax          #  88:     &()    t60 <- boolArr4
    movl    %eax, -1116(%ebp)      
    movl    -1116(%ebp), %eax       #  89:     param  0 <- t60
    pushl   %eax                   
    call    DIM                     #  90:     call   t61 <- DIM
    addl    $8, %esp               
    movl    %eax, -1120(%ebp)      
    movl    -1108(%ebp), %eax       #  91:     mul    t62 <- t59, t61
    movl    -1120(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1124(%ebp)      
    movl    -1124(%ebp), %eax       #  92:     add    t63 <- t62, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1128(%ebp)      
    movl    $4, %eax                #  93:     param  1 <- 4
    pushl   %eax                   
    leal    boolArr4, %eax          #  94:     &()    t64 <- boolArr4
    movl    %eax, -1132(%ebp)      
    movl    -1132(%ebp), %eax       #  95:     param  0 <- t64
    pushl   %eax                   
    call    DIM                     #  96:     call   t65 <- DIM
    addl    $8, %esp               
    movl    %eax, -1136(%ebp)      
    movl    -1128(%ebp), %eax       #  97:     mul    t66 <- t63, t65
    movl    -1136(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1140(%ebp)      
    movl    -1140(%ebp), %eax       #  98:     add    t67 <- t66, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1144(%ebp)      
    movl    $5, %eax                #  99:     param  1 <- 5
    pushl   %eax                   
    leal    boolArr4, %eax          # 100:     &()    t68 <- boolArr4
    movl    %eax, -1148(%ebp)      
    movl    -1148(%ebp), %eax       # 101:     param  0 <- t68
    pushl   %eax                   
    call    DIM                     # 102:     call   t69 <- DIM
    addl    $8, %esp               
    movl    %eax, -1152(%ebp)      
    movl    -1144(%ebp), %eax       # 103:     mul    t70 <- t67, t69
    movl    -1152(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1160(%ebp)      
    movl    -1160(%ebp), %eax       # 104:     add    t71 <- t70, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1164(%ebp)      
    movl    -1164(%ebp), %eax       # 105:     mul    t72 <- t71, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -1168(%ebp)      
    leal    boolArr4, %eax          # 106:     &()    t73 <- boolArr4
    movl    %eax, -1172(%ebp)      
    movl    -1172(%ebp), %eax       # 107:     param  0 <- t73
    pushl   %eax                   
    call    DOFS                    # 108:     call   t74 <- DOFS
    addl    $4, %esp               
    movl    %eax, -1176(%ebp)      
    movl    -1168(%ebp), %eax       # 109:     add    t75 <- t72, t74
    movl    -1176(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1180(%ebp)      
    movl    -1092(%ebp), %eax       # 110:     add    t76 <- t55, t75
    movl    -1180(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1184(%ebp)      
    movl    -1184(%ebp), %edi      
    leal    (%edi), %eax            # 111:     &()    t77 <- @t76
    movl    %eax, -1188(%ebp)      
    movl    -1188(%ebp), %eax       # 112:     param  1 <- t77
    pushl   %eax                   
    leal    boolArr0, %eax          # 113:     &()    t78 <- boolArr0
    movl    %eax, -1192(%ebp)      
    movl    $2, %eax                # 114:     mul    t79 <- 2, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -1196(%ebp)      
    leal    boolArr0, %eax          # 115:     &()    t80 <- boolArr0
    movl    %eax, -1204(%ebp)      
    movl    -1204(%ebp), %eax       # 116:     param  0 <- t80
    pushl   %eax                   
    call    DOFS                    # 117:     call   t81 <- DOFS
    addl    $4, %esp               
    movl    %eax, -1208(%ebp)      
    movl    -1196(%ebp), %eax       # 118:     add    t82 <- t79, t81
    movl    -1208(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1212(%ebp)      
    movl    -1192(%ebp), %eax       # 119:     add    t83 <- t78, t82
    movl    -1212(%ebp), %ebx      
    addl    %ebx, %eax             
    movl    %eax, -1216(%ebp)      
    movl    -1216(%ebp), %edi      
    movzbl  (%edi), %eax            # 120:     param  0 <- @t83
    pushl   %eax                   
    call    foo                     # 121:     call   t84 <- foo
    addl    $12, %esp              
    movb    %al, -1217(%ebp)       
    movzbl  -1217(%ebp), %eax       # 122:     assign b2 <- t84
    movb    %al, b2                
    leal    boolArr4, %eax          # 123:     &()    t85 <- boolArr4
    movl    %eax, -1224(%ebp)      
    movl    $2, %eax                # 124:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr4, %eax          # 125:     &()    t86 <- boolArr4
    movl    %eax, -1228(%ebp)      
    movl    -1228(%ebp), %eax       # 126:     param  0 <- t86
    pushl   %eax                   
    call    DIM                     # 127:     call   t87 <- DIM
    addl    $8, %esp               
    movl    %eax, -1232(%ebp)      
    movl    $1, %eax                # 128:     mul    t88 <- 1, t87
    movl    -1232(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1236(%ebp)      
    movl    -1236(%ebp), %eax       # 129:     add    t89 <- t88, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1240(%ebp)      
    movl    $3, %eax                # 130:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr4, %eax          # 131:     &()    t90 <- boolArr4
    movl    %eax, -1248(%ebp)      
    movl    -1248(%ebp), %eax       # 132:     param  0 <- t90
    pushl   %eax                   
    call    DIM                     # 133:     call   t91 <- DIM
    addl    $8, %esp               
    movl    %eax, -1252(%ebp)      
    movl    -1240(%ebp), %eax       # 134:     mul    t92 <- t89, t91
    movl    -1252(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1256(%ebp)      
    movl    -1256(%ebp), %eax       # 135:     add    t93 <- t92, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1260(%ebp)      
    movl    $4, %eax                # 136:     param  1 <- 4
    pushl   %eax                   
    leal    boolArr4, %eax          # 137:     &()    t94 <- boolArr4
    movl    %eax, -1264(%ebp)      
    movl    -1264(%ebp), %eax       # 138:     param  0 <- t94
    pushl   %eax                   
    call    DIM                     # 139:     call   t95 <- DIM
    addl    $8, %esp               
    movl    %eax, -1268(%ebp)      
    movl    -1260(%ebp), %eax       # 140:     mul    t96 <- t93, t95
    movl    -1268(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -1272(%ebp)      
    movl    -1272(%ebp), %eax       # 141:     add    t97 <- t96, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -1276(%ebp)      
    movl    $5, %eax                # 142:     param  1 <- 5
    pushl   %eax                   
    leal    boolArr4, %eax          # 143:     &()    t98 <- boolArr4
    movl    %eax, -1280(%ebp)      
    movl    -1280(%ebp), %eax       # 144:     param  0 <- t98
    pushl   %eax                   
    call    DIM                     # 145:     call   t99 <- DIM
    addl    $8, %esp               
    movl    %eax, -1284(%ebp)      
    movl    -1276(%ebp), %eax       # 146:     mul    t100 <- t97, t99
    movl    -1284(%ebp), %ebx      
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         # 147:     add    t101 <- t100, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         # 148:     mul    t102 <- t101, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -36(%ebp)        
    leal    boolArr4, %eax          # 149:     &()    t103 <- boolArr4
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         # 150:     param  0 <- t103
    pushl   %eax                   
    call    DOFS                    # 151:     call   t104 <- DOFS
    addl    $4, %esp               
    movl    %eax, -44(%ebp)        
    movl    -36(%ebp), %eax         # 152:     add    t105 <- t102, t104
    movl    -44(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -1224(%ebp), %eax       # 153:     add    t106 <- t85, t105
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    -52(%ebp), %edi        
    leal    (%edi), %eax            # 154:     &()    t107 <- @t106
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         # 155:     param  2 <- t107
    pushl   %eax                   
    leal    boolArr2, %eax          # 156:     &()    t108 <- boolArr2
    movl    %eax, -60(%ebp)        
    movl    $2, %eax                # 157:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr2, %eax          # 158:     &()    t109 <- boolArr2
    movl    %eax, -64(%ebp)        
    movl    -64(%ebp), %eax         # 159:     param  0 <- t109
    pushl   %eax                   
    call    DIM                     # 160:     call   t110 <- DIM
    addl    $8, %esp               
    movl    %eax, -72(%ebp)        
    movl    $1, %eax                # 161:     mul    t111 <- 1, t110
    movl    -72(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -76(%ebp)        
    movl    -76(%ebp), %eax         # 162:     add    t112 <- t111, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    $3, %eax                # 163:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr2, %eax          # 164:     &()    t113 <- boolArr2
    movl    %eax, -84(%ebp)        
    movl    -84(%ebp), %eax         # 165:     param  0 <- t113
    pushl   %eax                   
    call    DIM                     # 166:     call   t114 <- DIM
    addl    $8, %esp               
    movl    %eax, -88(%ebp)        
    movl    -80(%ebp), %eax         # 167:     mul    t115 <- t112, t114
    movl    -88(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -92(%ebp)        
    movl    -92(%ebp), %eax         # 168:     add    t116 <- t115, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -96(%ebp)        
    movl    -96(%ebp), %eax         # 169:     mul    t117 <- t116, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -100(%ebp)       
    leal    boolArr2, %eax          # 170:     &()    t118 <- boolArr2
    movl    %eax, -104(%ebp)       
    movl    -104(%ebp), %eax        # 171:     param  0 <- t118
    pushl   %eax                   
    call    DOFS                    # 172:     call   t119 <- DOFS
    addl    $4, %esp               
    movl    %eax, -108(%ebp)       
    movl    -100(%ebp), %eax        # 173:     add    t120 <- t117, t119
    movl    -108(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -116(%ebp)       
    movl    -60(%ebp), %eax         # 174:     add    t121 <- t108, t120
    movl    -116(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %edi       
    leal    (%edi), %eax            # 175:     &()    t122 <- @t121
    movl    %eax, -124(%ebp)       
    movl    -124(%ebp), %eax        # 176:     param  1 <- t122
    pushl   %eax                   
    leal    boolArr3, %eax          # 177:     &()    t123 <- boolArr3
    movl    %eax, -128(%ebp)       
    movl    $2, %eax                # 178:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr3, %eax          # 179:     &()    t124 <- boolArr3
    movl    %eax, -132(%ebp)       
    movl    -132(%ebp), %eax        # 180:     param  0 <- t124
    pushl   %eax                   
    call    DIM                     # 181:     call   t125 <- DIM
    addl    $8, %esp               
    movl    %eax, -136(%ebp)       
    movl    $1, %eax                # 182:     mul    t126 <- 1, t125
    movl    -136(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -140(%ebp)       
    movl    -140(%ebp), %eax        # 183:     add    t127 <- t126, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -144(%ebp)       
    movl    $3, %eax                # 184:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr3, %eax          # 185:     &()    t128 <- boolArr3
    movl    %eax, -148(%ebp)       
    movl    -148(%ebp), %eax        # 186:     param  0 <- t128
    pushl   %eax                   
    call    DIM                     # 187:     call   t129 <- DIM
    addl    $8, %esp               
    movl    %eax, -152(%ebp)       
    movl    -144(%ebp), %eax        # 188:     mul    t130 <- t127, t129
    movl    -152(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -160(%ebp)       
    movl    -160(%ebp), %eax        # 189:     add    t131 <- t130, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -164(%ebp)       
    movl    $4, %eax                # 190:     param  1 <- 4
    pushl   %eax                   
    leal    boolArr3, %eax          # 191:     &()    t132 <- boolArr3
    movl    %eax, -168(%ebp)       
    movl    -168(%ebp), %eax        # 192:     param  0 <- t132
    pushl   %eax                   
    call    DIM                     # 193:     call   t133 <- DIM
    addl    $8, %esp               
    movl    %eax, -172(%ebp)       
    movl    -164(%ebp), %eax        # 194:     mul    t134 <- t131, t133
    movl    -172(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -176(%ebp)       
    movl    -176(%ebp), %eax        # 195:     add    t135 <- t134, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -180(%ebp)       
    movl    -180(%ebp), %eax        # 196:     mul    t136 <- t135, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -184(%ebp)       
    leal    boolArr3, %eax          # 197:     &()    t137 <- boolArr3
    movl    %eax, -188(%ebp)       
    movl    -188(%ebp), %eax        # 198:     param  0 <- t137
    pushl   %eax                   
    call    DOFS                    # 199:     call   t138 <- DOFS
    addl    $4, %esp               
    movl    %eax, -192(%ebp)       
    movl    -184(%ebp), %eax        # 200:     add    t139 <- t136, t138
    movl    -192(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -196(%ebp)       
    movl    -128(%ebp), %eax        # 201:     add    t140 <- t123, t139
    movl    -196(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -204(%ebp)       
    movl    -204(%ebp), %edi       
    movzbl  (%edi), %eax            # 202:     param  0 <- @t140
    pushl   %eax                   
    call    foo                     # 203:     call   t141 <- foo
    addl    $12, %esp              
    movb    %al, -205(%ebp)        
    movzbl  -205(%ebp), %eax        # 204:     assign b3 <- t141
    movb    %al, b3                
    leal    boolArr1, %eax          # 205:     &()    t142 <- boolArr1
    movl    %eax, -212(%ebp)       
    movl    -212(%ebp), %eax        # 206:     param  2 <- t142
    pushl   %eax                   
    leal    boolArr4, %eax          # 207:     &()    t143 <- boolArr4
    movl    %eax, -216(%ebp)       
    movl    $2, %eax                # 208:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr4, %eax          # 209:     &()    t144 <- boolArr4
    movl    %eax, -220(%ebp)       
    movl    -220(%ebp), %eax        # 210:     param  0 <- t144
    pushl   %eax                   
    call    DIM                     # 211:     call   t145 <- DIM
    addl    $8, %esp               
    movl    %eax, -224(%ebp)       
    movl    $1, %eax                # 212:     mul    t146 <- 1, t145
    movl    -224(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -228(%ebp)       
    movl    -228(%ebp), %eax        # 213:     add    t147 <- t146, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -232(%ebp)       
    movl    $3, %eax                # 214:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr4, %eax          # 215:     &()    t148 <- boolArr4
    movl    %eax, -236(%ebp)       
    movl    -236(%ebp), %eax        # 216:     param  0 <- t148
    pushl   %eax                   
    call    DIM                     # 217:     call   t149 <- DIM
    addl    $8, %esp               
    movl    %eax, -240(%ebp)       
    movl    -232(%ebp), %eax        # 218:     mul    t150 <- t147, t149
    movl    -240(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -248(%ebp)       
    movl    -248(%ebp), %eax        # 219:     add    t151 <- t150, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -252(%ebp)       
    movl    $4, %eax                # 220:     param  1 <- 4
    pushl   %eax                   
    leal    boolArr4, %eax          # 221:     &()    t152 <- boolArr4
    movl    %eax, -256(%ebp)       
    movl    -256(%ebp), %eax        # 222:     param  0 <- t152
    pushl   %eax                   
    call    DIM                     # 223:     call   t153 <- DIM
    addl    $8, %esp               
    movl    %eax, -260(%ebp)       
    movl    -252(%ebp), %eax        # 224:     mul    t154 <- t151, t153
    movl    -260(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -264(%ebp)       
    movl    -264(%ebp), %eax        # 225:     add    t155 <- t154, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -268(%ebp)       
    movl    $5, %eax                # 226:     param  1 <- 5
    pushl   %eax                   
    leal    boolArr4, %eax          # 227:     &()    t156 <- boolArr4
    movl    %eax, -272(%ebp)       
    movl    -272(%ebp), %eax        # 228:     param  0 <- t156
    pushl   %eax                   
    call    DIM                     # 229:     call   t157 <- DIM
    addl    $8, %esp               
    movl    %eax, -276(%ebp)       
    movl    -268(%ebp), %eax        # 230:     mul    t158 <- t155, t157
    movl    -276(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -280(%ebp)       
    movl    -280(%ebp), %eax        # 231:     add    t159 <- t158, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -284(%ebp)       
    movl    -284(%ebp), %eax        # 232:     mul    t160 <- t159, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -292(%ebp)       
    leal    boolArr4, %eax          # 233:     &()    t161 <- boolArr4
    movl    %eax, -296(%ebp)       
    movl    -296(%ebp), %eax        # 234:     param  0 <- t161
    pushl   %eax                   
    call    DOFS                    # 235:     call   t162 <- DOFS
    addl    $4, %esp               
    movl    %eax, -300(%ebp)       
    movl    -292(%ebp), %eax        # 236:     add    t163 <- t160, t162
    movl    -300(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -304(%ebp)       
    movl    -216(%ebp), %eax        # 237:     add    t164 <- t143, t163
    movl    -304(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -308(%ebp)       
    movl    -308(%ebp), %edi       
    leal    (%edi), %eax            # 238:     &()    t165 <- @t164
    movl    %eax, -312(%ebp)       
    movl    -312(%ebp), %eax        # 239:     param  1 <- t165
    pushl   %eax                   
    leal    boolArr2, %eax          # 240:     &()    t166 <- boolArr2
    movl    %eax, -316(%ebp)       
    movl    $2, %eax                # 241:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr2, %eax          # 242:     &()    t167 <- boolArr2
    movl    %eax, -320(%ebp)       
    movl    -320(%ebp), %eax        # 243:     param  0 <- t167
    pushl   %eax                   
    call    DIM                     # 244:     call   t168 <- DIM
    addl    $8, %esp               
    movl    %eax, -324(%ebp)       
    movl    $1, %eax                # 245:     mul    t169 <- 1, t168
    movl    -324(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -328(%ebp)       
    movl    -328(%ebp), %eax        # 246:     add    t170 <- t169, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -336(%ebp)       
    movl    $3, %eax                # 247:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr2, %eax          # 248:     &()    t171 <- boolArr2
    movl    %eax, -340(%ebp)       
    movl    -340(%ebp), %eax        # 249:     param  0 <- t171
    pushl   %eax                   
    call    DIM                     # 250:     call   t172 <- DIM
    addl    $8, %esp               
    movl    %eax, -344(%ebp)       
    movl    -336(%ebp), %eax        # 251:     mul    t173 <- t170, t172
    movl    -344(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -348(%ebp)       
    movl    -348(%ebp), %eax        # 252:     add    t174 <- t173, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -352(%ebp)       
    movl    -352(%ebp), %eax        # 253:     mul    t175 <- t174, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -356(%ebp)       
    leal    boolArr2, %eax          # 254:     &()    t176 <- boolArr2
    movl    %eax, -360(%ebp)       
    movl    -360(%ebp), %eax        # 255:     param  0 <- t176
    pushl   %eax                   
    call    DOFS                    # 256:     call   t177 <- DOFS
    addl    $4, %esp               
    movl    %eax, -364(%ebp)       
    movl    -356(%ebp), %eax        # 257:     add    t178 <- t175, t177
    movl    -364(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -368(%ebp)       
    movl    -316(%ebp), %eax        # 258:     add    t179 <- t166, t178
    movl    -368(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -372(%ebp)       
    movl    -372(%ebp), %edi       
    movzbl  (%edi), %eax            # 259:     param  0 <- @t179
    pushl   %eax                   
    call    foo                     # 260:     call   t180 <- foo
    addl    $12, %esp              
    movb    %al, -377(%ebp)        
    movzbl  -377(%ebp), %eax        # 261:     assign b4 <- t180
    movb    %al, b4                
    leal    boolArr1, %eax          # 262:     &()    t181 <- boolArr1
    movl    %eax, -384(%ebp)       
    movl    -384(%ebp), %eax        # 263:     param  2 <- t181
    pushl   %eax                   
    leal    boolArr1, %eax          # 264:     &()    t182 <- boolArr1
    movl    %eax, -388(%ebp)       
    movl    $2, %eax                # 265:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr1, %eax          # 266:     &()    t183 <- boolArr1
    movl    %eax, -392(%ebp)       
    movl    -392(%ebp), %eax        # 267:     param  0 <- t183
    pushl   %eax                   
    call    DIM                     # 268:     call   t184 <- DIM
    addl    $8, %esp               
    movl    %eax, -396(%ebp)       
    movl    $1, %eax                # 269:     mul    t185 <- 1, t184
    movl    -396(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -400(%ebp)       
    movl    -400(%ebp), %eax        # 270:     add    t186 <- t185, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -404(%ebp)       
    movl    -404(%ebp), %eax        # 271:     mul    t187 <- t186, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -408(%ebp)       
    leal    boolArr1, %eax          # 272:     &()    t188 <- boolArr1
    movl    %eax, -412(%ebp)       
    movl    -412(%ebp), %eax        # 273:     param  0 <- t188
    pushl   %eax                   
    call    DOFS                    # 274:     call   t189 <- DOFS
    addl    $4, %esp               
    movl    %eax, -416(%ebp)       
    movl    -408(%ebp), %eax        # 275:     add    t190 <- t187, t189
    movl    -416(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -424(%ebp)       
    movl    -388(%ebp), %eax        # 276:     add    t191 <- t182, t190
    movl    -424(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -428(%ebp)       
    movl    -428(%ebp), %edi       
    leal    (%edi), %eax            # 277:     &()    t192 <- @t191
    movl    %eax, -432(%ebp)       
    movl    -432(%ebp), %eax        # 278:     param  1 <- t192
    pushl   %eax                   
    leal    boolArr1, %eax          # 279:     &()    t193 <- boolArr1
    movl    %eax, -436(%ebp)       
    movl    $2, %eax                # 280:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr1, %eax          # 281:     &()    t194 <- boolArr1
    movl    %eax, -440(%ebp)       
    movl    -440(%ebp), %eax        # 282:     param  0 <- t194
    pushl   %eax                   
    call    DIM                     # 283:     call   t195 <- DIM
    addl    $8, %esp               
    movl    %eax, -444(%ebp)       
    movl    $1, %eax                # 284:     mul    t196 <- 1, t195
    movl    -444(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -448(%ebp)       
    movl    -448(%ebp), %eax        # 285:     add    t197 <- t196, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -452(%ebp)       
    movl    -452(%ebp), %eax        # 286:     mul    t198 <- t197, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -456(%ebp)       
    leal    boolArr1, %eax          # 287:     &()    t199 <- boolArr1
    movl    %eax, -460(%ebp)       
    movl    -460(%ebp), %eax        # 288:     param  0 <- t199
    pushl   %eax                   
    call    DOFS                    # 289:     call   t200 <- DOFS
    addl    $4, %esp               
    movl    %eax, -472(%ebp)       
    movl    -456(%ebp), %eax        # 290:     add    t201 <- t198, t200
    movl    -472(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -476(%ebp)       
    movl    -436(%ebp), %eax        # 291:     add    t202 <- t193, t201
    movl    -476(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -480(%ebp)       
    movl    -480(%ebp), %edi       
    movzbl  (%edi), %eax            # 292:     param  0 <- @t202
    pushl   %eax                   
    call    foo                     # 293:     call   t203 <- foo
    addl    $12, %esp              
    movb    %al, -481(%ebp)        
    movzbl  -481(%ebp), %eax        # 294:     assign b5 <- t203
    movb    %al, b5                
    leal    boolArr2, %eax          # 295:     &()    t204 <- boolArr2
    movl    %eax, -488(%ebp)       
    movl    $2, %eax                # 296:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr2, %eax          # 297:     &()    t205 <- boolArr2
    movl    %eax, -492(%ebp)       
    movl    -492(%ebp), %eax        # 298:     param  0 <- t205
    pushl   %eax                   
    call    DIM                     # 299:     call   t206 <- DIM
    addl    $8, %esp               
    movl    %eax, -496(%ebp)       
    movl    $1, %eax                # 300:     mul    t207 <- 1, t206
    movl    -496(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -500(%ebp)       
    movl    -500(%ebp), %eax        # 301:     add    t208 <- t207, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -504(%ebp)       
    movl    $3, %eax                # 302:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr2, %eax          # 303:     &()    t209 <- boolArr2
    movl    %eax, -508(%ebp)       
    movl    -508(%ebp), %eax        # 304:     param  0 <- t209
    pushl   %eax                   
    call    DIM                     # 305:     call   t210 <- DIM
    addl    $8, %esp               
    movl    %eax, -516(%ebp)       
    movl    -504(%ebp), %eax        # 306:     mul    t211 <- t208, t210
    movl    -516(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -520(%ebp)       
    movl    -520(%ebp), %eax        # 307:     add    t212 <- t211, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -524(%ebp)       
    movl    -524(%ebp), %eax        # 308:     mul    t213 <- t212, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -528(%ebp)       
    leal    boolArr2, %eax          # 309:     &()    t214 <- boolArr2
    movl    %eax, -532(%ebp)       
    movl    -532(%ebp), %eax        # 310:     param  0 <- t214
    pushl   %eax                   
    call    DOFS                    # 311:     call   t215 <- DOFS
    addl    $4, %esp               
    movl    %eax, -536(%ebp)       
    movl    -528(%ebp), %eax        # 312:     add    t216 <- t213, t215
    movl    -536(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -540(%ebp)       
    movl    -488(%ebp), %eax        # 313:     add    t217 <- t204, t216
    movl    -540(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -544(%ebp)       
    movl    -544(%ebp), %edi       
    leal    (%edi), %eax            # 314:     &()    t218 <- @t217
    movl    %eax, -548(%ebp)       
    movl    -548(%ebp), %eax        # 315:     param  2 <- t218
    pushl   %eax                   
    leal    boolArr2, %eax          # 316:     &()    t219 <- boolArr2
    movl    %eax, -552(%ebp)       
    movl    $2, %eax                # 317:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr2, %eax          # 318:     &()    t220 <- boolArr2
    movl    %eax, -560(%ebp)       
    movl    -560(%ebp), %eax        # 319:     param  0 <- t220
    pushl   %eax                   
    call    DIM                     # 320:     call   t221 <- DIM
    addl    $8, %esp               
    movl    %eax, -564(%ebp)       
    movl    $1, %eax                # 321:     mul    t222 <- 1, t221
    movl    -564(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -568(%ebp)       
    movl    -568(%ebp), %eax        # 322:     add    t223 <- t222, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -572(%ebp)       
    movl    $3, %eax                # 323:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr2, %eax          # 324:     &()    t224 <- boolArr2
    movl    %eax, -576(%ebp)       
    movl    -576(%ebp), %eax        # 325:     param  0 <- t224
    pushl   %eax                   
    call    DIM                     # 326:     call   t225 <- DIM
    addl    $8, %esp               
    movl    %eax, -580(%ebp)       
    movl    -572(%ebp), %eax        # 327:     mul    t226 <- t223, t225
    movl    -580(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -584(%ebp)       
    movl    -584(%ebp), %eax        # 328:     add    t227 <- t226, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -588(%ebp)       
    movl    -588(%ebp), %eax        # 329:     mul    t228 <- t227, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -592(%ebp)       
    leal    boolArr2, %eax          # 330:     &()    t229 <- boolArr2
    movl    %eax, -596(%ebp)       
    movl    -596(%ebp), %eax        # 331:     param  0 <- t229
    pushl   %eax                   
    call    DOFS                    # 332:     call   t230 <- DOFS
    addl    $4, %esp               
    movl    %eax, -604(%ebp)       
    movl    -592(%ebp), %eax        # 333:     add    t231 <- t228, t230
    movl    -604(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -608(%ebp)       
    movl    -552(%ebp), %eax        # 334:     add    t232 <- t219, t231
    movl    -608(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -612(%ebp)       
    movl    -612(%ebp), %edi       
    leal    (%edi), %eax            # 335:     &()    t233 <- @t232
    movl    %eax, -616(%ebp)       
    movl    -616(%ebp), %eax        # 336:     param  1 <- t233
    pushl   %eax                   
    leal    boolArr2, %eax          # 337:     &()    t234 <- boolArr2
    movl    %eax, -620(%ebp)       
    movl    $2, %eax                # 338:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr2, %eax          # 339:     &()    t235 <- boolArr2
    movl    %eax, -624(%ebp)       
    movl    -624(%ebp), %eax        # 340:     param  0 <- t235
    pushl   %eax                   
    call    DIM                     # 341:     call   t236 <- DIM
    addl    $8, %esp               
    movl    %eax, -628(%ebp)       
    movl    $1, %eax                # 342:     mul    t237 <- 1, t236
    movl    -628(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -632(%ebp)       
    movl    -632(%ebp), %eax        # 343:     add    t238 <- t237, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -636(%ebp)       
    movl    $3, %eax                # 344:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr2, %eax          # 345:     &()    t239 <- boolArr2
    movl    %eax, -640(%ebp)       
    movl    -640(%ebp), %eax        # 346:     param  0 <- t239
    pushl   %eax                   
    call    DIM                     # 347:     call   t240 <- DIM
    addl    $8, %esp               
    movl    %eax, -648(%ebp)       
    movl    -636(%ebp), %eax        # 348:     mul    t241 <- t238, t240
    movl    -648(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -652(%ebp)       
    movl    -652(%ebp), %eax        # 349:     add    t242 <- t241, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -656(%ebp)       
    movl    -656(%ebp), %eax        # 350:     mul    t243 <- t242, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -660(%ebp)       
    leal    boolArr2, %eax          # 351:     &()    t244 <- boolArr2
    movl    %eax, -664(%ebp)       
    movl    -664(%ebp), %eax        # 352:     param  0 <- t244
    pushl   %eax                   
    call    DOFS                    # 353:     call   t245 <- DOFS
    addl    $4, %esp               
    movl    %eax, -668(%ebp)       
    movl    -660(%ebp), %eax        # 354:     add    t246 <- t243, t245
    movl    -668(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -672(%ebp)       
    movl    -620(%ebp), %eax        # 355:     add    t247 <- t234, t246
    movl    -672(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -676(%ebp)       
    movl    -676(%ebp), %edi       
    movzbl  (%edi), %eax            # 356:     param  0 <- @t247
    pushl   %eax                   
    call    foo                     # 357:     call   t248 <- foo
    addl    $12, %esp              
    movb    %al, -677(%ebp)        
    movzbl  -677(%ebp), %eax        # 358:     assign b6 <- t248
    movb    %al, b6                
    leal    boolArr4, %eax          # 359:     &()    t249 <- boolArr4
    movl    %eax, -684(%ebp)       
    movl    $2, %eax                # 360:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr4, %eax          # 361:     &()    t250 <- boolArr4
    movl    %eax, -692(%ebp)       
    movl    -692(%ebp), %eax        # 362:     param  0 <- t250
    pushl   %eax                   
    call    DIM                     # 363:     call   t251 <- DIM
    addl    $8, %esp               
    movl    %eax, -696(%ebp)       
    movl    $1, %eax                # 364:     mul    t252 <- 1, t251
    movl    -696(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -700(%ebp)       
    movl    -700(%ebp), %eax        # 365:     add    t253 <- t252, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -704(%ebp)       
    movl    $3, %eax                # 366:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr4, %eax          # 367:     &()    t254 <- boolArr4
    movl    %eax, -708(%ebp)       
    movl    -708(%ebp), %eax        # 368:     param  0 <- t254
    pushl   %eax                   
    call    DIM                     # 369:     call   t255 <- DIM
    addl    $8, %esp               
    movl    %eax, -712(%ebp)       
    movl    -704(%ebp), %eax        # 370:     mul    t256 <- t253, t255
    movl    -712(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -716(%ebp)       
    movl    -716(%ebp), %eax        # 371:     add    t257 <- t256, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -720(%ebp)       
    movl    $4, %eax                # 372:     param  1 <- 4
    pushl   %eax                   
    leal    boolArr4, %eax          # 373:     &()    t258 <- boolArr4
    movl    %eax, -724(%ebp)       
    movl    -724(%ebp), %eax        # 374:     param  0 <- t258
    pushl   %eax                   
    call    DIM                     # 375:     call   t259 <- DIM
    addl    $8, %esp               
    movl    %eax, -728(%ebp)       
    movl    -720(%ebp), %eax        # 376:     mul    t260 <- t257, t259
    movl    -728(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -736(%ebp)       
    movl    -736(%ebp), %eax        # 377:     add    t261 <- t260, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -740(%ebp)       
    movl    $5, %eax                # 378:     param  1 <- 5
    pushl   %eax                   
    leal    boolArr4, %eax          # 379:     &()    t262 <- boolArr4
    movl    %eax, -744(%ebp)       
    movl    -744(%ebp), %eax        # 380:     param  0 <- t262
    pushl   %eax                   
    call    DIM                     # 381:     call   t263 <- DIM
    addl    $8, %esp               
    movl    %eax, -748(%ebp)       
    movl    -740(%ebp), %eax        # 382:     mul    t264 <- t261, t263
    movl    -748(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -752(%ebp)       
    movl    -752(%ebp), %eax        # 383:     add    t265 <- t264, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -756(%ebp)       
    movl    -756(%ebp), %eax        # 384:     mul    t266 <- t265, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -760(%ebp)       
    leal    boolArr4, %eax          # 385:     &()    t267 <- boolArr4
    movl    %eax, -764(%ebp)       
    movl    -764(%ebp), %eax        # 386:     param  0 <- t267
    pushl   %eax                   
    call    DOFS                    # 387:     call   t268 <- DOFS
    addl    $4, %esp               
    movl    %eax, -768(%ebp)       
    movl    -760(%ebp), %eax        # 388:     add    t269 <- t266, t268
    movl    -768(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -772(%ebp)       
    movl    -684(%ebp), %eax        # 389:     add    t270 <- t249, t269
    movl    -772(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -780(%ebp)       
    movl    -780(%ebp), %edi       
    leal    (%edi), %eax            # 390:     &()    t271 <- @t270
    movl    %eax, -784(%ebp)       
    movl    -784(%ebp), %eax        # 391:     param  2 <- t271
    pushl   %eax                   
    leal    boolArr4, %eax          # 392:     &()    t272 <- boolArr4
    movl    %eax, -788(%ebp)       
    movl    $2, %eax                # 393:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr4, %eax          # 394:     &()    t273 <- boolArr4
    movl    %eax, -792(%ebp)       
    movl    -792(%ebp), %eax        # 395:     param  0 <- t273
    pushl   %eax                   
    call    DIM                     # 396:     call   t274 <- DIM
    addl    $8, %esp               
    movl    %eax, -796(%ebp)       
    movl    $1, %eax                # 397:     mul    t275 <- 1, t274
    movl    -796(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -800(%ebp)       
    movl    -800(%ebp), %eax        # 398:     add    t276 <- t275, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -804(%ebp)       
    movl    $3, %eax                # 399:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr4, %eax          # 400:     &()    t277 <- boolArr4
    movl    %eax, -808(%ebp)       
    movl    -808(%ebp), %eax        # 401:     param  0 <- t277
    pushl   %eax                   
    call    DIM                     # 402:     call   t278 <- DIM
    addl    $8, %esp               
    movl    %eax, -812(%ebp)       
    movl    -804(%ebp), %eax        # 403:     mul    t279 <- t276, t278
    movl    -812(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -816(%ebp)       
    movl    -816(%ebp), %eax        # 404:     add    t280 <- t279, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -824(%ebp)       
    movl    $4, %eax                # 405:     param  1 <- 4
    pushl   %eax                   
    leal    boolArr4, %eax          # 406:     &()    t281 <- boolArr4
    movl    %eax, -828(%ebp)       
    movl    -828(%ebp), %eax        # 407:     param  0 <- t281
    pushl   %eax                   
    call    DIM                     # 408:     call   t282 <- DIM
    addl    $8, %esp               
    movl    %eax, -832(%ebp)       
    movl    -824(%ebp), %eax        # 409:     mul    t283 <- t280, t282
    movl    -832(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -836(%ebp)       
    movl    -836(%ebp), %eax        # 410:     add    t284 <- t283, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -840(%ebp)       
    movl    $5, %eax                # 411:     param  1 <- 5
    pushl   %eax                   
    leal    boolArr4, %eax          # 412:     &()    t285 <- boolArr4
    movl    %eax, -844(%ebp)       
    movl    -844(%ebp), %eax        # 413:     param  0 <- t285
    pushl   %eax                   
    call    DIM                     # 414:     call   t286 <- DIM
    addl    $8, %esp               
    movl    %eax, -848(%ebp)       
    movl    -840(%ebp), %eax        # 415:     mul    t287 <- t284, t286
    movl    -848(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -852(%ebp)       
    movl    -852(%ebp), %eax        # 416:     add    t288 <- t287, 0
    movl    $0, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -856(%ebp)       
    movl    -856(%ebp), %eax        # 417:     mul    t289 <- t288, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -860(%ebp)       
    leal    boolArr4, %eax          # 418:     &()    t290 <- boolArr4
    movl    %eax, -868(%ebp)       
    movl    -868(%ebp), %eax        # 419:     param  0 <- t290
    pushl   %eax                   
    call    DOFS                    # 420:     call   t291 <- DOFS
    addl    $4, %esp               
    movl    %eax, -872(%ebp)       
    movl    -860(%ebp), %eax        # 421:     add    t292 <- t289, t291
    movl    -872(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -876(%ebp)       
    movl    -788(%ebp), %eax        # 422:     add    t293 <- t272, t292
    movl    -876(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -880(%ebp)       
    movl    -880(%ebp), %edi       
    leal    (%edi), %eax            # 423:     &()    t294 <- @t293
    movl    %eax, -884(%ebp)       
    movl    -884(%ebp), %eax        # 424:     param  1 <- t294
    pushl   %eax                   
    leal    boolArr4, %eax          # 425:     &()    t295 <- boolArr4
    movl    %eax, -888(%ebp)       
    movl    $2, %eax                # 426:     param  1 <- 2
    pushl   %eax                   
    leal    boolArr4, %eax          # 427:     &()    t296 <- boolArr4
    movl    %eax, -892(%ebp)       
    movl    -892(%ebp), %eax        # 428:     param  0 <- t296
    pushl   %eax                   
    call    DIM                     # 429:     call   t297 <- DIM
    addl    $8, %esp               
    movl    %eax, -896(%ebp)       
    movl    $1, %eax                # 430:     mul    t298 <- 1, t297
    movl    -896(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -900(%ebp)       
    movl    -900(%ebp), %eax        # 431:     add    t299 <- t298, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -904(%ebp)       
    movl    $3, %eax                # 432:     param  1 <- 3
    pushl   %eax                   
    leal    boolArr4, %eax          # 433:     &()    t300 <- boolArr4
    movl    %eax, -916(%ebp)       
    movl    -916(%ebp), %eax        # 434:     param  0 <- t300
    pushl   %eax                   
    call    DIM                     # 435:     call   t301 <- DIM
    addl    $8, %esp               
    movl    %eax, -920(%ebp)       
    movl    -904(%ebp), %eax        # 436:     mul    t302 <- t299, t301
    movl    -920(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -924(%ebp)       
    movl    -924(%ebp), %eax        # 437:     add    t303 <- t302, 3
    movl    $3, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -928(%ebp)       
    movl    $4, %eax                # 438:     param  1 <- 4
    pushl   %eax                   
    leal    boolArr4, %eax          # 439:     &()    t304 <- boolArr4
    movl    %eax, -932(%ebp)       
    movl    -932(%ebp), %eax        # 440:     param  0 <- t304
    pushl   %eax                   
    call    DIM                     # 441:     call   t305 <- DIM
    addl    $8, %esp               
    movl    %eax, -936(%ebp)       
    movl    -928(%ebp), %eax        # 442:     mul    t306 <- t303, t305
    movl    -936(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -940(%ebp)       
    movl    -940(%ebp), %eax        # 443:     add    t307 <- t306, 4
    movl    $4, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -944(%ebp)       
    movl    $5, %eax                # 444:     param  1 <- 5
    pushl   %eax                   
    leal    boolArr4, %eax          # 445:     &()    t308 <- boolArr4
    movl    %eax, -948(%ebp)       
    movl    -948(%ebp), %eax        # 446:     param  0 <- t308
    pushl   %eax                   
    call    DIM                     # 447:     call   t309 <- DIM
    addl    $8, %esp               
    movl    %eax, -952(%ebp)       
    movl    -944(%ebp), %eax        # 448:     mul    t310 <- t307, t309
    movl    -952(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -960(%ebp)       
    movl    -960(%ebp), %eax        # 449:     add    t311 <- t310, 5
    movl    $5, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -964(%ebp)       
    movl    -964(%ebp), %eax        # 450:     mul    t312 <- t311, 1
    movl    $1, %ebx               
    imull   %ebx                   
    movl    %eax, -968(%ebp)       
    leal    boolArr4, %eax          # 451:     &()    t313 <- boolArr4
    movl    %eax, -972(%ebp)       
    movl    -972(%ebp), %eax        # 452:     param  0 <- t313
    pushl   %eax                   
    call    DOFS                    # 453:     call   t314 <- DOFS
    addl    $4, %esp               
    movl    %eax, -976(%ebp)       
    movl    -968(%ebp), %eax        # 454:     add    t315 <- t312, t314
    movl    -976(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -980(%ebp)       
    movl    -888(%ebp), %eax        # 455:     add    t316 <- t295, t315
    movl    -980(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -984(%ebp)       
    movl    -984(%ebp), %edi       
    movzbl  (%edi), %eax            # 456:     param  0 <- @t316
    pushl   %eax                   
    call    foo                     # 457:     call   t317 <- foo
    addl    $12, %esp              
    movb    %al, -985(%ebp)        
    movzbl  -985(%ebp), %eax        # 458:     assign b7 <- t317
    movb    %al, b7                

l_test10_exit:
    # epilogue
    addl    $1272, %esp             # remove locals
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

    # scope: test10
b0:                                 # <bool>
    .skip    1
b1:                                 # <bool>
    .skip    1
b2:                                 # <bool>
    .skip    1
b3:                                 # <bool>
    .skip    1
b4:                                 # <bool>
    .skip    1
b5:                                 # <bool>
    .skip    1
b6:                                 # <bool>
    .skip    1
b7:                                 # <bool>
    .skip    1
boolArr0:                           # <array 5 of <bool>>
    .long    1
    .long    5
    .skip    5
    .align   4
boolArr1:                           # <array 5 of <array 5 of <bool>>>
    .long    2
    .long    5
    .long    5
    .skip   25
    .align   4
boolArr2:                           # <array 5 of <array 5 of <array 5 of <bool>>>>
    .long    3
    .long    5
    .long    5
    .long    5
    .skip  125
    .align   4
boolArr3:                           # <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>
    .long    4
    .long    5
    .long    5
    .long    5
    .long    5
    .skip  625
    .align   4
boolArr4:                           # <array 5 of <array 5 of <array 5 of <array 5 of <array 5 of <bool>>>>>>
    .long    5
    .long    5
    .long    5
    .long    5
    .long    5
    .long    5
    .skip 3125



    # end of global data section
    #-----------------------------------------

    .end
##################################################
