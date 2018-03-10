.data 
msg1: .asciiz "Enter the base of the input number: "
msg2: .asciiz "Enter a number in base " 
msg3: .asciiz "\nEnter the base of the output number: "
msg4: .asciiz "\nThe entered number in base " 
msg5: .asciiz "is: " 
string: 

.text


	#la $a0, msg1
	#li $v0, 4
	#syscall

	#li $v0, 5
	#syscall
	#move $s0, $v0 # input base
	
	
	la $a0, msg2
	li $v0, 4
	syscall


	la $a0, string
	la $a1, 32
	li $v0, 8
	syscall
	

	li $t2, 0
	li $t1 0 
	loop:

	lb $t0, 0($a0)
	beq $t0, 0x0a, endloop 
	blt $t0, 0x40, minus30
	subi $t0, $t0, 0x51
	subi $t0, $t0, 6
	j loop1
	minus30: 
	subi $t0, $t0, 0x30
	loop1: 
	add $a0, $a0, 1
	sb $t0, 0($sp)
	addi $t1 $t1 1
	addiu $sp, $sp,1
	j loop
	
	endloop:
	li $a0,0
	subi $sp, $sp,1
	li $t3, 0
	loop2:
	lb $a0, 0($sp)
	#######################
	li $v0, 1
	syscall
	#######################
	subiu $sp, $sp, 1
	addi $t3, $t3, 1
	bne $t3, $t1, loop2

	
	li $v0, 10
	syscall
	
	
#--------------------------------------------
# compute x raised to the y where 
#x is in $a0 and y is in $a1
# return value in $v0
#--------------------------------------------
   pow:
   # save return address on stack
   addi $sp, $sp, -4  
   sw $ra, 15($sp)


   # if y == 0 then return 1.0
   bne $a1, $zero, pow_elif
   li $v0, 1
   j pow_return    

   # else check if y is even
pow_elif:
   andi $t6, $a1, 1
   bne $t6, $zero, pow_else
   srl $a1, $a1, 1
   jal pow
   mul $v0, $v0, $v0
   j pow_return

   # else y must be odd
pow_else:
   addi $a1, $a1, -1
   jal pow
   mul $v0, $a0, $v0   

pow_return:
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   jr $ra
