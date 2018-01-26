.data
array:	.word	0x61707865, 0x3320646E, 0x79622D32, 0x6B206574
							.word	0x79ffb088,	0xfa11cc82,	0xf9a9baad,	0xbb629754
							.word 0xf5965531,	0x917a363d,	0x7a673c4f,	0x65c12667	
							.word 0x00000001,	0x00000000,	0x855f416a,	0x2fbc070a	
orig: .word	0x61707865, 0x3320646E, 0x79622D32, 0x6B206574
							.word	0x79ffb088,	0xfa11cc82,	0xf9a9baad,	0xbb629754
							.word 0xf5965531,	0x917a363d,	0x7a673c4f,	0x65c12667	
							.word 0x00000001,	0x00000000,	0x855f416a,	0x2fbc070a	
len:			.word	16
hdr:			.ascii	"\nExample program to encrypt using"
							.asciiz	" chacha20\n\n"
newLine:	.asciiz	"\n"
Li:     .byte 0x01  # i = 0
Lround: .byte 0x14 #19, i.e. number of rounds
Lsize: .byte 0x04
# ­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
#  text/code segment
#  The main procedure to be named "main".
.text
main:
#  This program will use pointers.
#  Display header
#  Uses print string system call
la	$a0, hdr
li	$v0, 4
syscall # print header
# ­­­­­

la	$s0, array # set $s0 addr of array
lb $s1, Li #store value of i
lb $s2, Lround #store limit of i
li $s6, 0
lw $s7, len

Loop: bgt $s1, $s2, EXIT #if $s1 <= maximum $s2,continue
addi $s6, $s0, 0 #store copy of array address
andi $t8, $s1, 1 #If loop index is even, $t8=0, else 1
beq $t8, 1, Lcalc #If loop index is odd, jump to Lcalc
li $t9, 5 #first diagonal
add $t9, $t9, $t9
add $t9, $t9, $t9
add $t5, $t9, $s6 #address of array[5]
add $t6 , $t9, $t9
add $t6, $t6, $s6 #address of array[10]
add $t7, $t9, $t9
add $t7, $t7, $t9
add $t7, $t7, $s6 #address of array[15]

lw $t0, 0($s6) #get array[0]
lw $t1, 0($t5) #get array[5]
lw $t2, 0($t6) #get array[10]
lw $t3, 0($t7) #get array[15]

addu $t0, $t0, $t1 #begin quarter round operations
xor $t3, $t3, $t0
sll $t3, $t3, 16
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 12
addu $t0, $t0, $t1
xor $t3, $t3, $t0
sll $t3, $t3, 8
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 7

sw $t0, 0($s6) #store at array[0]
sw $t1, 0($t5) #store at array[5]
sw $t2, 0($t6) #store at array[10]
sw $t3, 0($t7) #store at array[15]

li $s6, 1 #second diagonal, second quarter round
add $s6, $s6, $s6
add $s6, $s6, $s6
add $s6, $s6, $s0 #address of array[1]
li $t5, 6
add $t5, $t5, $t5
add $t5, $t5, $t5
add $t5, $t5, $s0 #address of array[6]
li $t6, 11
add $t6, $t6, $t6
add $t6, $t6, $t6
add $t6, $t6, $s0 #address of array[11]
li $t7, 12
add $t7, $t7, $t7
add $t7, $t7, $t7
add $t7, $t7, $s0 #address of array[12]

lw $t0, 0($s6) #get array[1]
lw $t1, 0($t5) #get array[6]
lw $t2, 0($t6) #get array[11]
lw $t3, 0($t7) #get array[12]

addu $t0, $t0, $t1 #begin quarter round operations
xor $t3, $t3, $t0
sll $t3, $t3, 16
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 12
addu $t0, $t0, $t1
xor $t3, $t3, $t0
sll $t3, $t3, 8
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 7

sw $t0, 0($s6) #store at array[1]
sw $t1, 0($t5) #store at array[6]
sw $t2, 0($t6) #store at array[11]
sw $t3, 0($t7) #store at array[12]

li $s6, 2 #third diagonal, third quarter round
add $s6, $s6, $s6
add $s6, $s6, $s6
add $s6, $s6, $s0 #address of array[2]
li $t5, 7
add $t5, $t5, $t5 #address of array[7]
add $t5, $t5, $t5
add $t5, $t5, $s0
li $t6, 8
add $t6, $t6, $t6
add $t6, $t6, $t6
add $t6, $t6, $s0 #address of array[8]
li $t7, 13
add $t7, $t7, $t7
add $t7, $t7, $t7
add $t7, $t7, $s0 #address of array[13]

lw $t0, 0($s6) #get array[2]
lw $t1, 0($t5) #get array[7]
lw $t2, 0($t6) #get array[8]
lw $t3, 0($t7) #get array[13]

addu $t0, $t0, $t1 #begin quarter round operations
xor $t3, $t3, $t0
sll $t3, $t3, 16
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 12
addu $t0, $t0, $t1
xor $t3, $t3, $t0
sll $t3, $t3, 8
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 7

sw $t0, 0($s6) #store at array[2]
sw $t1, 0($t5) #store at array[7]
sw $t2, 0($t6) #store at array[8]
sw $t3, 0($t7) #store at array[13]

li $s6, 3 #fourth diagonal, last quarter round
add $s6, $s6, $s6
add $s6, $s6, $s6
add $s6, $s6, $s0 #address of array[3]
li $t5, 4
add $t5, $t5, $t5
add $t5, $t5, $t5
add $t5, $t5, $s0 #address of array[4]
li $t6, 9
add $t6, $t6, $t6
add $t6, $t6, $t6
add $t6, $t6, $s0 #address of array[9]
li $t7, 14
add $t7, $t7, $t7
add $t7, $t7, $t7
add $t7, $t7, $s0 #address of array[14]

lw $t0, 0($s6) #get array[3]
lw $t1, 0($t5) #get array[4]
lw $t2, 0($t6) #get array[9]
lw $t3, 0($t7) #get array[14]

addu $t0, $t0, $t1 #begin quarter round operations
xor $t3, $t3, $t0
sll $t3, $t3, 16
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 12
addu $t0, $t0, $t1
xor $t3, $t3, $t0
sll $t3, $t3, 8
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 7

sw $t0, 0($s6) #store at array[3]
sw $t1, 0($t5) #store at array[4]
sw $t2, 0($t6) #store at array[9]
sw $t3, 0($t7) #store at array[14]

j Ldone #end round

Lcalc: li $s6, 0 #first column
add $s6, $s6, $s0 #address of array[0]
li $t5, 4
add $t5, $t5, $t5 
add $t5, $t5, $t5
add $t5, $t5, $s0 #address of array[4]
li $t6, 8
add $t6, $t6, $t6
add $t6, $t6, $t6
add $t6, $t6, $s0 #address of array[8]
li $t7, 12
add $t7, $t7, $t7
add $t7, $t7, $t7
add $t7, $t7, $s0 #address of array[12]

lw $t0, 0($s6) #get array[0]
lw $t1, 0($t5) #get array[4]
lw $t2, 0($t6) #get array[8]
lw $t3, 0($t7) #get array[12]

addu $t0, $t0, $t1 #begin quarter round operations
xor $t3, $t3, $t0
sll $t3, $t3, 16
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 12
addu $t0, $t0, $t1
xor $t3, $t3, $t0
sll $t3, $t3, 8
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 7

sw $t0, 0($s6) #store at array[0]
sw $t1, 0($t5) #store at array[4]
sw $t2, 0($t6) #store at array[8]
sw $t3, 0($t7) #store at array[12]

li $s6, 1 #second column, second quarter round
add $s6, $s6, $s6
add $s6, $s6, $s6
add $s6, $s6, $s0 #address of array[1]
li $t5, 5
add $t5, $t5, $t5 
add $t5, $t5, $t5
add $t5, $t5, $s0 #address of array[5]
li $t6, 9
add $t6, $t6, $t6
add $t6, $t6, $t6
add $t6, $t6, $s0 #address of array[9]
li $t7, 13
add $t7, $t7, $t7
add $t7, $t7, $t7
add $t7, $t7, $s0 #address of array[13]
 
lw $t0, 0($s6) #get array[1]
lw $t1, 0($t5) #get array[5]
lw $t2, 0($t6) #get array[9]
lw $t3, 0($t7) #get array[13]

addu $t0, $t0, $t1 #begin quarter round operations
xor $t3, $t3, $t0
sll $t3, $t3, 16
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 12
addu $t0, $t0, $t1
xor $t3, $t3, $t0
sll $t3, $t3, 8
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 7

sw $t0, 0($s6) #store at array[1]
sw $t1, 0($t5) #store at array[5]
sw $t2, 0($t6) #store at array[9]
sw $t3, 0($t7) #store at array[13]

li $s6, 2 #third column, third quarter round
add $s6, $s6, $s6
add $s6, $s6, $s6
add $s6, $s6, $s0 #address of array[2]
li $t5, 6
add $t5, $t5, $t5 
add $t5, $t5, $t5
add $t5, $t5, $s0 #address of array[6]
li $t6, 10
add $t6, $t6, $t6
add $t6, $t6, $t6
add $t6, $t6, $s0 #address of array[10]
li $t7, 14
add $t7, $t7, $t7
add $t7, $t7, $t7
add $t7, $t7, $s0 #address of array[14]

lw $t0, 0($s6) #get array[2]
lw $t1, 0($t5) #get array[6]
lw $t2, 0($t6) #get array[10]
lw $t3, 0($t7) #get array[14]

addu $t0, $t0, $t1 #begin quarter round operations
xor $t3, $t3, $t0
sll $t3, $t3, 16
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 12
addu $t0, $t0, $t1
xor $t3, $t3, $t0
sll $t3, $t3, 8
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 7

sw $t0, 0($s6) #store at array[2]
sw $t1, 0($t5) #store at array[6]
sw $t2, 0($t6) #store at array[10]
sw $t3, 0($t7) #store at array[14]

li $s6, 3 #fourth column, last quarter round
add $s6, $s6, $s6
add $s6, $s6, $s6
add $s6, $s6, $s0 #address of array[3]
li $t5, 7
add $t5, $t5, $t5 
add $t5, $t5, $t5
add $t5, $t5, $s0 #address of array[7]
li $t6, 11
add $t6, $t6, $t6
add $t6, $t6, $t6
add $t6, $t6, $s0 #address of array[11]
li $t7, 15
add $t7, $t7, $t7
add $t7, $t7, $t7
add $t7, $t7, $s0 #address of array[15]

lw $t0, 0($s6) #get array[3]
lw $t1, 0($t5) #get array[7]
lw $t2, 0($t6) #get array[11]
lw $t3, 0($t7) #get array[15]

addu $t0, $t0, $t1 #begin quarter round operations
xor $t3, $t3, $t0
sll $t3, $t3, 16
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 12
addu $t0, $t0, $t1
xor $t3, $t3, $t0
sll $t3, $t3, 8
addu $t2, $t2, $t3
xor $t1, $t1, $t2
sll $t1, $t1, 7

sw $t0, 0($s6) #store at array[3]
sw $t1, 0($t5) #store at array[7]
sw $t2, 0($t6) #store at array[11]
sw $t3, 0($t7) #store at array[15]

Ldone: addiu $s1, $s1, 1 #increment loop index
j Loop

EXIT: li $s4, 0
LPrint: bgt $s4, 15, QUIT #print elements of the final array
lw $t0, 0($s0)
li $v0, 1
move $a0, $t0
syscall
addi $s4, $s4, 1
addi $s0, $s0, 4
j LPrint


QUIT: li $v0, 10 #exit code 
syscall
