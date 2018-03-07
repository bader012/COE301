##################################################################################
####   Name: Yousef Khalid Majeed                                             ####
####   Name: Bader Abed Almazmumi                                             ####
####   ID :  201568070                                                        ####
####   ID :  201480600                                                        ####
####   Sec : 01                                                               ####
####   Assignment : 2                                                         ####
##################################################################################


#	$s0 --> rows
#	$s1 --> cols
#	$s2 --> array adress
#       $s3 --> sum of a raw
#       $s4 --> sum of a column
.data
enterNumberOfRows: .asciiz "Enter number of rows: "
enterNumberOfColumns: .asciiz "Enter number of columns: "
msg1: .asciiz "Enter an array of "
msg2: .asciiz " integers:\n"
menuText: "\n\nSelect one of the following functions:\n1. Print the Entered Array.\n2. Print Sum of a Row.\n3. Print Sum of a Column.\n4. Print Rows Sum.\n5. Print Columns Sum.\n6. Exit the program.\n"
cases: .word case0, case1, case2, case3, case4, case5
newLine:  .asciiz "\n"
msg3: .asciiz "Enter a row number:"
msg4: .asciiz "Array of "
msg5: .asciiz " integers is:\n"
msg6: .asciiz "Enter a column number:"
msg7: .asciiz "Sum of row number "
msg8: .asciiz "Sum of column number "
msg9: .asciiz " is: "
array: 


.text

#Ask the user to enter a number of rows
la $a0, enterNumberOfRows
li $v0, 4
syscall

li $v0, 5
syscall
move $s0, $v0

#Ask the user to enter a number of columns
la $a0, enterNumberOfColumns
li $v0, 4
syscall

li $v0, 5
syscall
move $s1, $v0

#Ask the user to enter RxC matrix of integers 
# Printing messgae for reading the array
	la $a0, msg1
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall
	
	li $a0,'x'
	li $v0, 11
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall
	
	la $a0, msg2
	li $v0, 4
	syscall


#reading RxC matrix of integers into an array
	la $s2, array
	li $t0, 0 #row counter
	li $t1, 0 #cols counter
	move $t2, $s2
enterRowElementsLoop:

	enterColmnsElementsLoop:
	
	li $v0, 5
	syscall
	
	
	move $t3, $v0
	sb $t3, 0($t2)
	addiu $t2, $t2, 1	

	
	addiu $t1, $t1, 1
	blt $t1, $s1 enterColmnsElementsLoop
	li $t1, 0

	addiu $t0, $t0, 1
	blt $t0, $s0, enterRowElementsLoop
	




	doWhile:
	#print the menu
	la $a0, menuText
	li $v0, 4
	syscall



	li $v0, 5
	syscall

	subiu $t0, $v0, 1
	bltz $t0, end	# if $t0 < 0, go to default 
	li $t1, 5 		# maximum number of cases (0,1)
	bgt $t0, $t1, end	# if $t0 > $t1, go to default

	la $t2, cases		# Load the address of cases array to $t2
	sll $t0, $t0, 2		#($t0*4) to calculate the offset of the chosen case in the array
	addu $t2, $t2, $t0	# add the offset to the address of cases array
	lw $t3, 0($t2)		# load the chosen case’s address to $t3
	jr $t3			# jump to the chosen case’s address


	case0:
	la $a0, msg4
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall
	
	li $a0,'x'
	li $v0, 11
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall
	
	la $a0, msg5
	li $v0, 4
	syscall
	
 	move $a0, $s2 # $a0 = address of array 
	move $a1, $s0 # $a2 = numOfRows
	move $a2, $s1 # $a2 = numberOfColumn
	jal printA
	j doWhile

	case1:
	# Getting index Row 
	la $a0, msg3
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a2, $v0 # row to be summed
	move $a0, $s2 # $a0 = address of array 
 	move $a1, $s1 # $a1 = numberOfColumn
 	jal RSum
 	la $a0, msg7
	li $v0, 4
	syscall
	
	move $a0, $a2
	li $v0, 1
	syscall
	
	la $a0, msg9
	li $v0, 4
	syscall
	
	move $a0, $s3
	li $v0, 1
	syscall
	j doWhile
	
	

	case2:
 	# Getting index Column 
	la $a0, msg6
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a3, $v0 # column to be summed
	move $a0, $s2 # $a0 = address of array 
 	move $a2, $s0 # $a1 = numberOfRows
 	move $a1, $s1 # $a2 = numberOfColumns
 	
 	jal CSum
 	la $a0, msg8
	li $v0, 4
	syscall
	
	move $a0, $a3
	li $v0, 1
	syscall
	
	la $a0, msg9
	li $v0, 4
	syscall
	
	move $a0, $s4
	li $v0, 1
	syscall
	j doWhile

	case3:
	move $a0, $s2 # $a0 = address of array 
 	move $a1, $s0 # $a1 = numberOfRows
 	move $a2, $s1 # $a2 = numberOfColumns
 	jal ArrayRowSum
	j doWhile

case4:
 li $a0 5
 li $v0 1
 syscall
j doWhile

# Close the program
case5:
li $v0, 10
syscall


	# A procedure that receives in $a0 the address of an array,
	# in $a1 the number of rows, and in $a2 the number of columns
	# and displays the array.
    printA:
	move $t0, $a0
	
	NR:
	move $t1, $a2
	
	NC:
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	
	li $v0, 11
	la $a0, ' '
	syscall
	
	addi $t0, $t0, 1
	addi $t1, $t1, -1
	bnez $t1, NC
	
	li $v0, 4  	 # system call code for printing string = 4
	la $a0, newLine    # load address of string to be printed into $a0
	syscall 
	
	addi $a1, $a1, -1
	bnez $a1, NR
	jr $ra
	
	
	# A procedure that receives in $a0 the address of an array,
	# in $a1 the number of columns, and in $a2 the index of the row to be summed
	# and that computes the sum of a given row..
	RSum:
	# Compute starting address of the row index
	mul $t0, $a1, $a2
	add $t0, $t0, $a0
	li $t4, 0
	
	RSumHelper:
	lb $t3, 0($t0)
	addu $t4, $t4, $t3 
	addi $t0, $t0, 1
	addi $a1, $a1, -1
	bnez $a1, RSumHelper
	
	move $s3, $t4
	jr $ra
	
	
	# A procedure that receives in $a0 the address of an array,
	# in $a1 the number of rows, and in $a2 the number of columns, 
	# and in $a3 the index of the column to be summed,
	# and that computes the sum of a given coulmn..
	CSum:
	# Compute starting address of the column index
	add $t0, $a0, $a3 
	li $t4, 0 
	
	CSumHelper:
	lb $t3, 0($t0)
	addu $t4, $t4, $t3 
	add $t0, $t0, $a2
	addi $a1, $a1, -1
	bnez $a1, CSumHelper
	
	move $s4, $t4
	jr $ra
	
	# A procedure that receives in $a0 the address of an array,
	# in $a1 the number of rows, and in $a2 the number of columns, 
	# and that displays the sums of all rows in the array 
	# based on using RSum procedure.
	ArrayRowSum:
	mul $t1, $a1,$a2
	move $t0, $a0
	ArrayRowSumHelper:
	
	lb $t3, 0($t0)
	addu $t4, $t4, $t3 
	addi $t0, $t0, 1
	addi $t1, $t1, -1
	bnez $t1,ArrayRowSumHelper
	
	
	
	move $a0, $t4
	li $v0, 1
	syscall
	
	jr $ra


end:




