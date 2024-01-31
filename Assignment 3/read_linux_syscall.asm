	.text
	.globl main
main:	
	li $t0,0xffff0000 # RCR
	li $t1,0xffff0004 # RDR
	
	li $t4,0xffff0008 # TCR
	li $t5,0xffff000C # TDR
	
keepWaiting:
	lw $t2,0($t0)
	beq $t2,$zero,keepWaiting
	
	lw $a0,0($t1)
	
keepWaiting2:
	lw $t2,0($t4)
	beq $t2,$zero,keepWaiting2
	
	sw $a0,0($t5)
	
	j keepWaiting
