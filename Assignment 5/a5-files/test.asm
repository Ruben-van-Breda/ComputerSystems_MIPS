.data

hexbits: .word	0x3f,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71 
	.text
	
main:   li	$t1, 0x7f10
        li	$t2, 0xf
loop:
        sll     $t3, $t2, 4
        la	$t4, jumptable
	addu	$t4, $t4, $t3
	jalr    $t4
        addi 	$t2, $t2, -1
        andi 	$t2, $t2, 0xf
        j loop

jumptable:
d0:	li $t4,0x3f
        sw $t4,0($t1)
        jr $ra
        nop
d1:	li $t4,0x06
        sw $t4,0($t1)
        jr $ra
        nop
d2:	li $t4,0x5B
        sw $t4,0($t1)
        jr $ra
        nop
d3:	li $t4,0x4f
        sw $t4,0($t1)
        jr $ra
        nop
d4:	li $t4,0x66
        sw $t4,0($t1)
        jr $ra
        nop
d5:	li $t4,0x6d
        sw $t4,0($t1)
        jr $ra
        nop
d6:	li $t4,0x7d
        sw $t4,0($t1)
        jr $ra
        nop
d7:	li $t4,0x07
        sw $t4,0($t1)
        jr $ra
        nop        
d8:	li $t4,0x7f
        sw $t4,0($t1)
        jr $ra
        nop
d9:	li $t4,0x6f
        sw $t4,0($t1)
        jr $ra
        nop
da:	li $t4,0x77
        sw $t4,0($t1)
        jr $ra
        nop
db:	li $t4,0x7c
        sw $t4,0($t1)
        jr $ra
        nop
dc:	li $t4,0x39
        sw $t4,0($t1)
        jr $ra
        nop
dd:	li $t4,0x5e
        sw $t4,0($t1)
        jr $ra
        nop
de:	li $t4,0x79
        sw $t4,0($t1)
        jr $ra
        nop
df:	li $t4,0x71
        sw $t4,0($t1)
        jr $ra
        nop     
