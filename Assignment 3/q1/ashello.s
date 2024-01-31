# Pure assembly language program for Linux running on MIPS

	.data
hello:	.ascii "Hello"

	.text
	.globl __start        # Default entry point
__start:
	li $a0, 1             # Standard output (fd=1)
    #file descriptor: 0 - output , 1 - input , 2 - error
    # https://android.googlesource.com/kernel/mediatek/+/refs/heads/android-mediatek-sprout-3.4-kitkat-mr2/arch/mips/include/asm/unistd.h
    
	la $a1, hello         # address of the string
	li $a2, 5             # number of bytes to write
	li $v0, 4004          # write() syscall
	syscall
	nop
	nop
	
	li $a0,0              # exit code
	li $v0, 4001          # exit() syscall
    syscall
	# no return
