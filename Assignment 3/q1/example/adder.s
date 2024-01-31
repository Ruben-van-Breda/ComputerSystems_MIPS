	.text
	.globl adder # makes function visiable outside of this file
    .ent adder
adder:
    .frame $sp,0,$31 # stack
	addu $v0,$a0,$a1
	jr $31
	nop
	.end adder
	
