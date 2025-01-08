.data #Declaração de variáveis e constantes


.text #Código em assembly
.globl main #Porta de entrada do programa

main:
    #Todas as instruções do programa ficam aqui.

    li $v0, 5
    syscall

    add $t0, $v0, $zero

    li $v0, 5
    syscall

    add $t1, $v0, $zero
    
    add $s0, $t0, $t1

    move $a0, $s0
    li $v0, 1

    syscall
    

    li $v0, 10
    syscall
