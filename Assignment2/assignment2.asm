#	$s0 --> rows
#	$s1 --> cols
#	$s2 --> array adress

.data
enterNumberOfRows: .asciiz "Enter number of rows: "
enterNumberOfColumns: .asciiz "Enter number of columns: "
enterIntegersOfAnArray: "Enter an array of ROWs X COLs integers:\n"
menuText: "Select one of the following functions:\n1. Print the Entered Array.\n2. Print Sum of a Row.\n3. Print Sum of a Column.\n4. Print Rows Sum.\n5. Print Columns Sum.\n6. Exit the program.\n"
cases: .word case0, case1, case2, case3, case4, case5
array: 


.text
la $s2 array
#Ask the user to enter a number of rows
la $a0 enterNumberOfRows
li $v0 4
syscall

li $v0 5
syscall
move $s0 $v0

#Ask the user to enter a number of columns
la $a0 enterNumberOfColumns
li $v0 4
syscall

li $v0 5
syscall
move $s1 $v0

#Ask the user to enter RxC matrix of integers 
la $a0 enterIntegersOfAnArray
li $v0 4
syscall


#enter RxC matrix of integers into an array
li $t0 0 #row counter
li $t1 0 #cols counter
move $t2 $s2
enterRowElementsLoop:

	enterColmnsElementsLoop:
	
	li $v0 5
	syscall
	
	
	move $t3 $v0
	sb $t3 0($t2)
	addiu $t2 $t2 1	







	addiu $t1 $t1 1
	blt $t1 $s1 enterColmnsElementsLoop
	li $t1 0

addiu $t0 $t0 1
blt $t0 $s0 enterRowElementsLoop


#print the menu
la $a0 menuText
li $v0 4
syscall



li $v0 5
syscall

subiu $t0 $v0 1
bltz $t0 end	# if $t0 < 0, go to default 
li $t1 5 		# maximum number of cases (0,1)
bgt $t0 $t1 end	# if $t0 > $t1, go to default

la $t2 cases		# Load the address of cases array to $t2
sll $t0 $t0 2		#($t0*4) to calculate the offset of the chosen case in the array
addu $t2 $t2 $t0	# add the offset to the address of cases array
lw $t3 0($t2)		# load the chosen case’s address to $t3
jr $t3			# jump to the chosen case’s address


case0:
 li $a0 1
 li $v0 1
 syscall
j end

case1:
 li $a0 2
 li $v0 1
 syscall
j end

case2:
 li $a0 3
 li $v0 1
 syscall
j end

case3:
 li $a0 4
 li $v0 1
 syscall
j end

case4:
 li $a0 5
 li $v0 1
 syscall
j end

# Close the program
case5:
li $v0 10
syscall

end:
