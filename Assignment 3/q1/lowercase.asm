	.data
START: 	.double 65
	
	.text
	.globl main
	.globl lowercase
	
	.ent main

main:	
	li $t0,0xffff0000 # RCR
	li $t1,0xffff0004 # RDR
	la $t3, START

	
keepWaiting:
	lw $t2,0($t0)
	beq $t2,$zero,keepWaiting
	
	#bge $t2, $t3, lowercase
	li $v0, 8
	syscall
	
	jal lowercase
	
	
	j keepWaiting

lowercase:

	
	lw $a0,0($t1)
	li $v0,11
	syscall # print character
	j keepWaiting
