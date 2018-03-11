.data 
errorMsg: .asciiz "Invalid Input!\nPlease enter a base within the range(2 - 16)!\n"
msg1: .asciiz "Enter the base of the input number: "
msg2: .asciiz "Enter a number in base " 
msg3: .asciiz "Enter the base of the output number: "
msg4: .asciiz "The entered number in base " 
msg5: .asciiz " is: " 
msg6: .asciiz ": "
table: .asciiz "0123456789ABCDEF"
enteredNumber:
 


.text
	#Input Base
	inputBaseLoop:
	li $v0 4
	la $a0 msg1
	syscall

	li $v0 5
	syscall
	move $s0 $v0

	bgt $s0 16 ERORR_INPUT
	blt $s0 2 ERORR_INPUT 
	j endInputBaseLoop


	ERORR_INPUT:
	li $v0 4
	la $a0 errorMsg
	syscall

	j inputBaseLoop



	endInputBaseLoop:
	
	
	# number in the input base
	la $a0, msg2
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall
	
	la $a0, msg6
	li $v0, 4
	syscall

	la $a0, enteredNumber  # number in the input base
	la $a1, 100
	li $v0, 8
	syscall    
	

	#li $t2, 0
	
	
	
	li $t1, 0
	loop:
	lb $t0, 0($a0)
	beq $t0, 0x0a, endloop 
	blt $t0, 0x40, minus30
	
	# convert from ascii to the given base ( 10 - 15 )
	jal tolower
	subi $t0, $t0, 0x57 
	j loop1
	
	# convert from ascii to given base ( 0 - 9 )
	minus30: 
	subi $t0, $t0, 0x30
	
	loop1: 
	sb $t0, 0($sp)
	add $a0, $a0, 1
	addi $t1 $t1 1
	addiu $sp, $sp,-1
	j loop
	
	endloop:
	
	
	
	
	
	li $a0,0
	addi $sp, $sp,1
	li $t3, 0
	loop2:
	lb $t4, 0($sp)
	#######################
	move $a0, $s0
	move $a1, $t3
	jal power
	mul $t5, $t4, $s4
	addu $t6, $t6, $t5
	#######################
	addiu $sp, $sp, 1
	addi $t3, $t3, 1
	bne $t3, $t1, loop2
	

	
	reenter1:
	la $a0, msg3
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $s1, $v0 # output base
	bgt $s1, 16, reenter1
	blt $s1, 2, reenter1
	
	la $a0, msg4
	li $v0, 4
	syscall
	
	
	move $a0, $s1
	li $v0, 1
	syscall
	
	
	la $a0, msg5
	li $v0, 4
	syscall
	#########################
	
	
	
	
	
	li $t7, 0
	loop5:
	divu $t6, $s1
	mfhi $s5
	mflo $t6
	sb $s5, 0($sp)
	addi $sp, $sp, -1
	addi $t7, $t7,1
	bnez $t6, loop5

	addi $sp, $sp, 1
	loop6: 
	lb $a0, 0($sp)

	# Converting number into in $a0 to hex character
	la $t1, table
	addu $t1, $t1, $a0
	lb $t1, 0($t1)
	move $a0, $t1
	# Print the character result in a0
	li $v0, 11 # Load the system call number
	syscall
	
	subi $t7, $t7, 1
	addi $sp, $sp, 1
	bnez $t7, loop6
	
	
	
	
	
	
	#########################
	
	
	li $v0, 10
	syscall
	
	
	
tolower:	# $t0 = parameter ch
  blt   $t0, 'A', else	# branch if $a0 < 'A'
  bgt   $t0, 'Z', else	# branch if $a0 > 'Z'
  addi  $t0, $t0, 32	# 'a' – 'A' == 32
  jr    $ra	# return to caller
else:
  move  $t0, $t0	# $v0 = ch
  jr    $ra	# return to caller

	
	
#--------------------------------------------
# compute x raised to the y where 
#x is in $a0 and y is in $a1
# return value in $v0
#--------------------------------------------
  #first way to compute the power of number
power:
 beq $a1, $zero, L1 #if $s7 and 0 are equal jump to L1

 add $s4, $zero, $a0  #store value of s6 into t2
 addi $t0, $zero, 1  #initialize t0 register to 1

 beq $a1, $t0, L2 #if $s7 and 1 are equal jump to L2

 loop3:
 
 addi $t0, $t0, 1 # increment value stored in t0 register
 mul $s4, $s4, $a0 # multiply values stored in t2 and s6 register, placed result in t2 register
 blt $t0, $a1, loop3 # if t0 less than s7 then go to loop.

 j L3

 L1: 
 addi $s4, $zero, 1 #store 1 into t2...number to power of 0

 j L3

 L2:
 add $s4, $zero, $a0 #store s6 into t2...number to power of 1

 L3:
 jr $ra
