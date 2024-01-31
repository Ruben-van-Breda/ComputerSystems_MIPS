	.data
screen: .space 524288

	.include "font8x8.inc"

	
.text
	
	# for (i=0; i<10; i++)
	# { 
	#   print(i)
	# }
	
	li $s0,0   # i=0
	la $t3, font8x8  # pointer to file
	li $t5, 8 # col counter 
	li $t1, 8    # int row  = 10 

	li $a0, 'A'
	sll $a0, $a0, 3 # * 8
	add $t3, $a0, $t3 #offset
	
	li $s2, 128
	
keep_looping:	
	
	
	
	
	bge $s0,8, exit_loop  # not i<10
	
	lbu  $t4, 0($t3) # load one row / byte


	
	li $a0,'\n' 
	li $v0,11  
	syscall              #    print('\n'); 
	
	bgt $t5, $zero, print
	
	li $v0,1      # print(i)
	move $a0,$t4
	syscall
	
	li $t5 , 8
	addiu $t3,$t3, 4
	addi $s0,$s0,1 # i++
	j keep_looping
	
#q2 x = - 8
print: #loop thru bits of byte
	
	
#	lb $t7, 0($t4)
	and $t7, $s2, $t4 
	
	
	# if $t7 != 0 then display
	bne $t7, 0 , draw
	
	li $v0,1      # print(i)
	move $a0,$t7
	syscall
	
	#finish a row 
	
	sll $t4, $t4, 1 # shift left
	addi $t5, $t5, -1
	bgt $t5, $zero, print
	j keep_looping
	
draw:
	la $t0, 0x10010000 # $t0 = base address 
	sll $t1, $a1, 9 # $t1 = Y*512
	add $t1, $t1, $a0 # $t1 = Y*512+X
	sll $t1, $t1, 2 # $t1 = (Y*512+X)*4
	add $t1, $t1, $t0 # $t1 = (Y*512+X)*4+base address 
	sw $a2, 0($t1)# set color of the pixel (X,Y)
	jr $ra

exit_loop:	
	li $v0,10
	syscall