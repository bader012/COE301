.data
msg1: .asciiz "Enter the number of elements in the array: "
msg2: .asciiz "Enter array elements:\n"
msg3: .asciiz "\n\nThe sorted array is: "
msg4: .asciiz "\n\nThe average is "
msg5: .asciiz "\nThe highest is "
msg6: .asciiz "\nThe lowest is "
msg7: .asciiz "The sorted array is:"
newLine: .asciiz "\n"
array: .float 32

#==============================
# $s0 --> Number of elements
# $s1 --> Adress of the array
# $s2 --> Average
# $s3 --> Highest
# $s4 --> Lowest
#==============================
.text
la $s1 array
#msg1 --------------------------------
la $a0 msg1
li $v0 4
syscall

# read number of elements ------------
li $v0 5
syscall
move $s0 $v0

#msg2 --------------------------------
la $a0 msg2
li $v0 4
syscall


# reading the elements ----------------
move $t0 $s0 # --> counter 
la $t1 array # --> address
li $t2 0     # --> total value

readLoop:
li $v0 6
syscall

# Storing the element ------------------
swc1 $f0 0($t1)
add.s $f2 $f2 $f0
subi $t0 $t0 1
addi $t1 $t1 4

bnez $t0 readLoop



# sorting --------------------------------------------------
# $a0 --> the address
# $a1 --> the number of elements

move $a0 $s1
subi $a1 $s0 1 # Number of comparison
li $t0 0 # 0 -> unsorted | 1 -> sorted

while:
bnez $t0 doneSorting
beqz $a1 doneSorting 
li $t0 1 # status = Sorted
	li $t1 0 # counter
	forLoop:
		lwc1 $f8 0($a0)
		lwc1 $f10 4($a0)
		c.lt.s	$f8, $f10
		bc1f endIf
		swc1 $f8 4($a0)
		swc1 $f10 0($a0)
		li $t0 0
		endIf:
	addi $a0 $a0 4
	addi $t1 $t1 1
	blt $t1 $a1 forLoop
move $a0 $s1
subi $a1 $a1 1
j while
doneSorting:







move $t0 $s0
move $t1 $s1


la $a0 msg7
li $v0 4
syscall
printLoop:


# printing the element ------------------

la $a0 newLine
li $v0 4
syscall

lwc1 $f12 0($t1)
li $v0 2
syscall


subi $t0 $t0 1
addi $t1 $t1 4

bnez $t0 printLoop


# print the average --------------------
la $a0 msg4
li $v0 4
syscall


# calculate the average ----------------
# Number of elements
mtc1 $s0 $f4
# Convert number of elements from integer to singal floating point
cvt.s.w	$f4, $f4
# Divide total by number of elements
div.s $f6 $f2 $f4 
# print the value of the average
mov.s $f12 $f6
li $v0 2
syscall


# Print the highest ------------------
la $a0 msg5
li $v0 4
syscall

lwc1 $f12 0($s1)

li $v0 2
syscall

# Print the Lowest ------------------
la $a0 msg6
li $v0 4
syscall

sll $t0 $s0 2
add $t1 $s1 $t0
subi $t1 $t1 4
lwc1 $f12 0($t1)

li $v0 2
syscall