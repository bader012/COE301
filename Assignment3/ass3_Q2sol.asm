##################################################################################
####   Name: Yousef Khalid Majeed                                             ####
####   Name: Bader Abed Almazmumi                                             ####
####   ID :  201568070                                                        ####
####   ID :  201480600                                                        ####
####   Sec : 01                                                               ####
####   Assignment : 3                                                         ####
####   Question : 2                                                           ####
##################################################################################

################# Data segment #####################
.data
	msg1: .asciiz "Enter first integer: "
	msg2: .asciiz "Enter second integer: " 
	msg3: .asciiz "GCD of the two integers: "

################# Code segment #####################
.text
.globl main
	main: # main program entry
	
	
	la $a0, msg1
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $s0, $v0 # first integer
	
	
	la $a0, msg2
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $s1, $v0 # second integer
	
	
	la $a0, msg3
	li $v0, 4
	syscall
	
	
	move $a0, $s0     
	move $a1, $s1
	jal GCD       
	li $v0, 1
	syscall
	
	
	li $v0, 10
	syscall
	
	
	GCD: 
	bnez $a1, Else       # if (b != 0) goto Else
	move $v0, $a0	     # $v0 = a
	jr $ra
	Else: 
	addi $sp, $sp, -4    # allocate stack frame = 4 bytes
	sw $ra, ($sp)	     # save $ra
	move $t0, $a0	     # $t0 = a
	move $a0, $a1	     # $a0 = b
	divu $t0, $a0	     # a/b
	mfhi $a1             # a mod b = $a1 
	jal GCD	             # call GCD(b, a % b)
	lw $ra ($sp)	     # restore $ra
	addi $sp, $sp, 4     # free stack frame
	jr $ra
	
	
	
	
	
