.data
vek:.word 4,5,2,2,1,6,7,9,5,10
size:.word 10
a:.word 0
nyrad:.asciiz"\n"
space:.asciiz" "
.text
.globl main


main:
la $a0,vek #a0=vek
lw $a1,a #a1=0
lw $a3,size #a3=size
addi $a2,$a3,-1 #a2=size-1=9
subu $sp, $sp,32 #aktiveringsblock
sw $ra, 28($sp) #aterhoppadress
sw $a0,24($sp) #parametern vek sparas i stacken
sw $a1,20($sp) #parametern lower sparas i stacken
sw $a2,16($sp) #parametern size-1 sparas i stacken
lw $a0,24($sp)
move $a1,$a3



jal skriv
li $v0,4
la $a0,nyrad
syscall
lw $a0,24($sp)
lw $a1,20($sp)
lw $a2,16($sp)
jal quicksort #anrop till subrutin
lw $a0,24($sp)
move $a1,$a3
lw $a1,size
jal skriv #anrop till subrutin
addiu $sp,$sp,32
li $v0,10 #exit
syscall
.globl skriv
skriv:
move $t0,$a0
li $t1,0 #i=0


L1:
bge $t1,$a1,L2
sll $t2,$t1,2 #i*4
add $t2,$t0,$t2 #t2= vek + i*4
lw $t3,0($t2) #$s2=vek[i]
li $v0,1
move $a0,$t3
syscall
li $v0,4
la $a0,space
syscall
addi $t1,$t1,1



j L1
L2:
jr $ra
.globl partition
partition:
subu $sp, $sp,32#aktiveringsblock
sw $ra,28($sp) #aterhoppadress
sw $a0,24($sp) #parametern vek sparas i stacken
sw $a1,20($sp) #parametern lower sparas i stacken
sw $a2,16($sp) #parametern size-1 sparas i stacken
sll $t1,$a1,2
add $t1, $a0, $t1
addi $t2,$a1,1
sw $t1, 12($sp) #(4*i)+vek laggs i stacken
sw $t2,8($sp) #lower finns i stacken nu



l3:
w1:
lw $t1,24($sp)
lw $t2,20($sp)
lw $t3,16($sp)
lw $t4,12($sp) #vek+(i*4)
lw $t4,0($t4) #t4=pivot
lw $t5,8($sp) #lower
sll $t0, $t5,2
add $t0, $t1, $t0
lw $t0, 0($t0)
bgt $t0,$t4,w2
# if !(vek[lower] <= pivot ) || !(lower <= upper) ga till w2
bgt $t5,$t3,w2
addi $t5, $t5,1
sw $t5,8($sp)


j w1
w2:
lw $t5,8($sp)
sll $t6,$t3,2
add $t6,$t1,$t6
lw $t6, 0($t6)
bgt $t5, $t3, if #!(lower <= upper) till if
bge $t4,$t6,if #!(vek[upper] > pivot) till if
addi $t3,$t3,-1
sw $t3,16($sp)
j w2


if:
lw $t3,16($sp) #upper
bgt $t5,$t3,leave #lower>upper
sll $t6,$t3,2
add $t6,$t1,$t6
lw $t8,0($t6) #vek[upper]
sll $t0,$t5,2
add $t0,$t1,$t0
lw $t7,0($t0) #temp=v[lower]
sw $t8,0($t0) #vek[upper]=vek[lower]
sw $t7,0($t6) #temp=vek[upper]
addi $t3, $t3,-1 #upper-1
sw $t3,16($sp) #spara upper
addi $t5,$t5,1 #lower+1
sw $t5,8($sp) # spara lower


leave:
lw $t3,16($sp) #upper
lw $t5,8($sp) #lower
ble $t5, $t3,l3 #lower<=upper till l3
sll $t6,$t3,2
sll $t0,$t5,2
add $t6,$t1,$t6 #vek+(4*upper)
add $t0,$t1,$t0 #vek+(4*lower)



add $t8,$t4,$zero
lw $t4,12($sp) #ladda adressen i $t4(pivot)
lw $t7,0($t6) #vek[upper]=temp
sw $t8,0($t6) #pivot=vek[upper]
sw $t7,0($t4) # spara temp i $t4(pivot)
move $v0,$t3 #upper till v0
lw $ra,28($sp)
addiu $sp,$sp,32
jr $ra


.globl quicksort
quicksort:
subu $sp,$sp,32 #prolog
sw $ra,28($sp) #prolog
sw $a0,24($sp) #prolog
sw $a1,20($sp) #prolog
sw $a2,16($sp) #prolog
sw $s2,12($sp)
sw $s1,8($sp)
sw $s0,4($sp)
lw $s1,16($sp) #b=size-1
lw $s0,20($sp) #a=0
bge $s0,$s1,ut #!(a<b) till ut
lw $a0,24($sp) #hamta adressen for att skicka den till parition senare
lw $a1,20($sp)
lw $a2,16($sp)


jal partition
move $s2,$v0 #s2=k
lw $a0,24($sp) #hamta adressen for att skicka den till parition senare
lw $a1,20($sp) #a0=0
addi $a2,$s2,-1 #k-1


jal quicksort
lw $a2,16($sp)
lw $a0,24($sp) #hamta adressen for att skicka den till partition
addi $s2,$s2,1 #k+1
move $a1, $s2


jal quicksort
ut:
lw $ra,28($sp) #epilog
lw $s2,12($sp)
lw $s1,8($sp)
lw $s0,4($sp)
addu $sp,$sp,32 #epilog
jr $ra

