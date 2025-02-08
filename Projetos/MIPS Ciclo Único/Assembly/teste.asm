.data


.text

main:
addi $t1, $zero, 5
addi $t2, $zero, 10
beq $t1, $t2, escreve_sete
j escreve_oito
escreve_sete:
addi $s0, $zero, 7
j fim
escreve_oito:
addi $s0, $zero, 8
j fim
fim:

#fim


