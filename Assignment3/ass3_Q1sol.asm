##################################################################################
####   Name: Yousef Khalid Majeed                                             ####
####   Name: Bader Abed Almazmumi                                             ####
####   ID :  201568070                                                        ####
####   ID :  201480600                                                        ####
####   Sec : 01                                                               ####
####   Assignment : 3                                                         ####
####   Question : 1                                                           ####
##################################################################################


################# Data segment #####################
.data
errorMsg: .asciiz "Invalid Input!\n"
msg1: .asciiz "Enter the base of the input number: "
msg2: .asciiz "Enter a number in base "
msg3: .asciiz "Enter the base of the output number: "
msg4: .asciiz "The entered number in base "
msg4_1: .asciiz " is: "
table: .asciiz "0123456789ABCDEF"

enteredNumber: .space 32 #Assuming the entered value doesn't excede 32 bytes
outbutNumber:


#-------------------------------------------
# $s0 --> INPUT BASE
# $s1 --> OUTPUT BASE
# $s2 --> Address of the array of digits (INPUT).
# $s3 --> Address of the array of digits (OUTPUT).
# $s4 --> Dicemal Value.
#-------------------------------------------

################# Code segment #####################
.text
.globl main
main: # main program entry


la $s2 enteredNumber
la $s3 outbutNumber

# Print msg1  ============================================================================
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
# =======================================================================================

# Print msg2 ============================================================================
enteredNumberLoop:
li $v0 4
la $a0 msg2
syscall

li $v0 1
move $a0 $s0
syscall

li $v0 11
la $a0 ':'
syscall

li $v0 11
la $a0 ' '
syscall

li $v0 8
la $a0 enteredNumber
li $a1 32
syscall

# =======================================================================================

# Print msg3 ============================================================================
outputBaseLoop:
li $v0 4
la $a0 msg3
syscall

li $v0 5
syscall
move $s1 $v0

bgt $s1 16 ERORR_OUTPUT
blt $s1 2 ERORR_OUTPUT 
j endOutputBaseLoop

ERORR_OUTPUT:
li $v0 4
la $a0 errorMsg
syscall
j outputBaseLoop




endOutputBaseLoop:
# =======================================================================================

# Print msg4 ============================================================================
li $v0 4
la $a0 msg4
syscall

li $v0 1
move $a0 $s1
syscall

li $v0 4
la $a0 msg4_1
syscall
# =======================================================================================

move $a0 $s2
jal asciiToGivenBase


move $a0 $s2
move $a1 $v0
move $a2 $s0
jal givenBaseToDecimal


move $s4 $v0
move $a0 $s1
move $a1 $s4
move $a2 $s3
jal DecimalTogivenBase


li $v0, 10
syscall








# Converting From Ascii to Given Base ($s0) ============================================

# arguments 
#========================
# $a0 --> Address of the array of digits (INPUT).

# outputs
#========================
# $v0 --> Number of Digits.

# variables 
#========================
# $t0 --> Count Number of Digits.
# $t1 --> Hold The Digit.


asciiToGivenBase:
li $t0 0

whileLoop:
lb $t1 0($a0)
beq $t1 0x0a endWhileLoop
bgt $t1 0x60 charachter
bgt $t1 0x40 toLower

number:
subu $t1 $t1 0x30
j endIf

toLower:
addi $t1 $t1 0x20

charachter:
subu $t1 $t1 0x57
j endIf

endIf:
bge $t1, $s0,ERORR_enteredNumber 
sb $t1 0($a0)
addi $a0 $a0 1
addiu $t0 $t0 1

j whileLoop

endWhileLoop:

sb $zero 0($a0) # remove the 'a' 
addi $a0 $a0 -1
move $v0 $t0

jr $ra



ERORR_enteredNumber:
li $v0 4
la $a0 errorMsg
syscall
j enteredNumberLoop

# =======================================================================================

# Fumction to comvert from given base (r) to decimal (10)
#for(int i = 0 ; i < s2 ; i++)
#    for(int j = 0; j<i ; j++){
#    	t1 = t1 * S0
#	t4 = t4 + t1
#    }
#}

# arguments 
#========================
# $a0 --> Address of the array of digits (INPUT).
# $a1 --> Number of Digits.
# $a2 --> Input Base.

# outputs
#========================
# $v0 --> Decimal Value.

# variables 
#========================
# $t0 --> Counter for OuterLoop.
# $t1 --> Counter for InnerLoop.
# $t2 --> Hold the digit.
# $t3 --> Total Decimal Value.

givenBaseToDecimal:

add $a0 $a0 $a1
addi $a0 $a0 -1
li $t0 0 # Counter i
decimalLoop:
beq $t0 $a1 endDecimalLoop
lb $t2 0($a0)
li $t1 0 # Counter j
	powerLoop:
	beq $t1 $t0 endPowerLoop
	mul $t2 $t2 $a2
	addi $t1 $t1 1
	j powerLoop
	endPowerLoop:
addu $t3 $t3 $t2
addi $a0 $a0 -1
addi $t0 $t0 1
j decimalLoop
endDecimalLoop:
move $v0 $t3
jr $ra





















# Fumction to comvert from decimal (10) to any given base (R)

# arguments 
#========================
# $a0 --> Output base 
# $a1 --> Dicemal value
# $a2 --> Output Address

# output 
#========================
# $v0 --> number of digits 


#move $a0 $s1
#move $a1 $s4
#move $a2 $s3

DecimalTogivenBase:

li $t0 0 # reminder
li $t1 0 # count number of digits to print it later


toGivenBaseLoop:
divu $a1 $s1
mfhi $t0
sb $t0 0($a2)
mflo $a1
addi $a2 $a2 1
addi $t1 $t1 1
bnez $a1 toGivenBaseLoop



# Fumction to print an array of digits
# arguments ($a1 --> number of digits; $a2 --> Output Address)
move $a1 $t1 		#$a1 --> number of digits
move $a2 $s3		#$a2 --> Output Address
addu $a2 $a2 $a1	#$a2 --> address + number of digits
subi $a2 $a2 1

printLoop: 
lb $t0, 0($a2)

# Converting number into in $a0 to hex character
la $t1 table
addu $t1 $t1 $t0
lb $a0 0($t1)
# Print the character result in a0
li $v0 11 # Load the system call number
syscall
addi $a2 $a2 -1
addi $a1 $a1 -1
bnez $a1 printLoop

jr $ra	
	

	
#########################
	
	










