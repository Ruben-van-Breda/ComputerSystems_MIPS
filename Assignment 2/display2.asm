	.data
screen: .space 524288

	.include "font8x8.inc"
	
	.text
	.globl main
main:
	li $a0, 'O' #code of character
	li $a1, 0 #X
	li $a2, 0 #Y
	li $a3, 0x00ffffff # white
	jal putchar
	
	li $v0, 10
	syscall
	
putchar:

	li $s0,0   # i=0
	
	
keep_looping:
	li $s1, 10 # s1 = 0
	
	li $t0,100  #x
	li $t1,100  #y
	add $t0, $t0 ,$s0 #t0 += $s0
	
	li $t2,0x10010000 # base address of display
	
	sll $t3,$t1,11 # y*2048 = (y*512)*4
	sll $t4,$t0,2  # x*4

	add $t2,$t2,$t3
	add $t2,$t2,$t4


	li $t6,0x00ffffff
	sw $t6,0($t2) # write to bitmap display
	
	bge $s0,$t1, exit_loop # not i<10
	
	addi $s0,$s0,1 # i++
	j keep_looping

exit_loop:	
	li $v0,10
	syscall	
			
.globl setpixel 
setpixel:
	la $t0, 0x10010000 # $t0 = base address 
	sll $t1, $a1, 9 # $t1 = Y*512
	add $t1, $t1, $a0 # $t1 = Y*512+X
	sll $t1, $t1, 2 # $t1 = (Y*512+X)*4
	add $t1, $t1, $t0 # $t1 = (Y*512+X)*4+base address 
	sw $a2, 0($t1)# set color of the pixel (X,Y)
	jr $ra



