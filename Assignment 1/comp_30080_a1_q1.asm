         .data                            # data goes in data segment
D1:      .word    1,2,4                   # data stored in words
D2:      .word    5,6,8
D3:      .word    0,0,0 
         .text                            # code goes in text segment
         .globl   main                    # must be global symbol
main:    la       $t0, D1                 # load address pseudo-instruction
         la       $t1, D2
         la       $t2, D3             
         lw       $t3, 0($t0)
         lw       $t4, 0($t1)
         add      $t3, $t3, $t4
         sw       $t3, 0($t2)
         #
         li       $v0, 10                 # system call for exit
         syscall                          # Exit!
