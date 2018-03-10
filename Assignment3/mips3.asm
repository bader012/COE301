.data 


.text



 addi $s6,$zero, 2 # default Value for num 1 (the number)
 addi $s7,$zero, 4 # default Value for num 2 (the power)

######################################################
#first way to compute the power of number
 beq $s7, $zero, L1 #if $s7 and 0 are equal jump to L1
 

 add $t2, $zero, $s6  #store value of s6 into t2
 addi $t0, $zero, 1  #initialize t0 register to 1

 beq $s7, $t0, L2 #if $s7 and 1 are equal jump to L2

 loop3:
 
 addi $t0, $t0, 1 # increment value stored in t0 register
 mul $t2, $t2, $s6 # multiply values stored in t2 and s6 register, placed result in t2 register
 blt $t0, $s7, loop3 # if t0 less than s7 then go to loop.

 j L3

 L1: 
 addi $t2, $zero, 1 #store 1 into t2...number to power of 0

 j L3

 L2:
 add $t2, $zero, $s6 #store s6 into t2...number to power of 1

 L3:

 addi $v0, $zero, 1
 add $a0, $zero, $t2
 syscall #Print ans
 
#######################################################################
#second way to compute the power of number
#--------------------------------------------
# compute x raised to the y where 
#x is in $a0 and y is in $a1
# return value in $v0
#--------------------------------------------
 move $a0, $s6
 move $a1, $s7
 jal pow 
 
 
 move $a0, $v0
 li $v0, 1
 syscall
 
 li $v0, 10
 syscall
 
 
 
 
 pow:
   # save return address on stack
   addi $sp, $sp, -4  
   sw $ra, 0($sp)

   # if y == 0 then return 1.0
   bne $a1, $zero, pow_elif
   li $v0, 1
   j pow_return    

   # else check if y is even
pow_elif:
   andi $t0, $a1, 1
   bne $t0, $zero, pow_else
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
 
 
