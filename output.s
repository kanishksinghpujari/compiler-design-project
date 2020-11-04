.globl| main:
	la $t0 vars
	lw $a0 4($t0)
	sw $a0 0($sp)
	addiu $sp $sp -4
	la $t0 vars
	lw $a0 8($t0)
	lw $t0 4($sp)
	addiu $sp $sp  4
	add $a0 $t0 $a0
	la $t0 vars
	sw $a0 0($t0)
