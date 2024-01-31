# Ruben van Breda - 19200704

		.data 
screen: .space 524288

	.include "font8x8.inc"
	.text
	.globl main
main:
	li $a0,'0'
	li $a1,0 # X
	li $a2,0 # Y
	li $a3,0x00ffffff
	jal putch
	li $v0,10
	syscall
			
# Subroutine that draws the glyph of the character on the MARS bitmap display
# code is specified in $a0 
# the upper left corner of the glyph is to be drawn at coordinates X=$a1, Y=$a2 
# and color specified in $a3

putch:
	li $s0, 0   # i=0
	li $s1, 8 # col counter 
	li $s2, 128
	la $t3, font8x8  # pointer to file
	
	li $a0, 'V'	# character code we want to print
	
	sll $a0, $a0, 3 # * 8
	add $t3, $a0, $t3 # offset
	j keep_looping

keep_looping:	
	
	
	bge $s0,8, exit_loop  # not i<8
	
	lbu  $t4, 0($t3) # load one row / byte

	li $v0,1      # print(i)
	move $a0,$t4
	syscall
	
	li $a0,'\n' 
	li $v0,11  
	syscall              #    print('\n'); 
	
	
	bgt $s1, $zero, innerloop
	li $s1 , 8
	
	addiu $t3,$t3, 1
	addi $s0,$s0,1 # s0++
	addi $a2, $a2, 1 # y ++
	
	j keep_looping
	
	
innerloop: #loop thru bits of byte
	

	and $t7, $s2, $t4 # GET FIRST BIT
	
	
	# if $t7 != 0 then display
	beq $t7, 0 , dont_draw
	jal setpixel
		
	# finish a row 
	
	dont_draw:
	
	
	sll $t4, $t4, 1 # shift left
	add $s1, $s1, -1 # s1 --
	add $a1, $a1, 1 # x ++
	
	
	bgt $s1, $zero, innerloop
	addi $a1, $a1, -8 # RESET X BACK TO 0
	j keep_looping
	


setpixel:
	la $t0, 0x10010000 # $t0 = base address 
	sll $t1, $a2, 9 # $t1 = Y*512 
	add $t1, $t1, $a1 # $t1 = Y*512+X
	sll $t1, $t1, 2 # $t1 = (Y*512+X)*4
	add $t1, $t1, $t0 # $t1 = (Y*512+X)*4+base address 
	sw $a3, 0($t1)# set color of the pixel (X,Y)
	jr $ra	
	
	
exit_loop:	
	li $v0,10
	syscall