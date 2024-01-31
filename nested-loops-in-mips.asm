#  The following program prints
#       
#      ####
#      ####
#      ####
#
#  Algorithm in a C-like language:
#
#    t0 = 3;
#    // loop 1:
#    do {   
#       t1 = 4;
#       // loop 2:
#       do {
#          print('#');  
#          t1=t1-1;   
#       } while (t1>0);
#       print('\n');      // move to the next line
#       t0=t0-1;
#    } while (t0>0);
#    exit();
#

	.text

	li $t0,3             # t0 = 3;
loop1:                       # do {
	li $t1,4             #    t1 = 4;
loop2:                       #    do {
        li $a0,'#'           
	li $v0,11  
	syscall              #       print('#');
	addi $t1,$t1,-1      #       t1=t1-1;  
	bgt $t1,$zero,loop2  # 	  } while (t1>0);
        li $a0,'\n'
	li $v0,11  
	syscall              #    print('\n');       // move to the next line
        addi $t0,$t0,-1      #    t0=t0-1;  
	bgt $t0,$zero,loop1  # } while (t0>0);
	li $v0,10
	syscall              # exit(); 