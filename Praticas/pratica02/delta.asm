.data 
    msg1: .asciiz "\nDigite o valor do coeficiente A: " # Tamanho == 35 bytes
    msg2: .asciiz "\nDigite o valor do coeficiente B: "
    msg3: .asciiz "\nDigite o valor do coeficiente C: "



.text
.globl main

main:

    #Digite o valor do coeficiente A: 
    la $a0, msg1
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $t0, $v0

    #--------------------------------


    #Digite o valor do coeficiente B:
    la $a0, msg2
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $t1, $v0

    #---------------------------------

    #Digite o valor do coeficiente C:

    la $a0, msg3
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $t2, $v0

    #----------------------------------

    #Cálculo b² - 4 * a * c

    mult $t1, $t1 # b * b
    mflo $t1 # salvando valor de b² em $t1

    mult $t0, $t2 # a * c
    mflo $t2 # salvando a * c em $t2

    li $t3, 4 # armazena o valor 4 no em $t3
    mult $t2, $t3 # multiplica o valor de $t2 por 4
    mflo $t3 # salvando 4 * $t2 em $t3

    sub $s0, $t1, $t3

    #---------------------------------------------

    #Mostrando resultado --------------------------

    move $a0, $s0
    li $v0, 1

    syscall

    #-------------------------------------------------

    #Saindo ------------------------------------------

    li $v0, 10
    syscall
