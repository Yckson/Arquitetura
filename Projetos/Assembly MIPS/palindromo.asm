    #   Função que determina se uma string é um palíndromo. Você deve desconsiderar todos caracteres que não sejam letras.
    #   Tanto faz maiúsculas e minúsculas.
    #   A chamada palindromo('Socorram-me, subi no Onibus em Marrocos!'), por exemplo, deve retornar TRUE.

    #   Matéria: Programação Funcional. Nível da questão: Difícil



.data

frase:                  .space  101                                                 # Reserva 101 Bytes de espaço na memória (100 caracteres + '\0')
msg0:                   .asciiz "========== Verificador de Parindromo ==========\n" # Mensagem de saudação
msg1:                   .asciiz "Digite uma frase (100 letras): "                   # Mensagems de solicitação de entrada
TRUE:                   .asciiz "\nTRUE"                                            # Texto de saída positiva
FALSE:                  .asciiz "\nFALSE"                                           # Texto de saída negativa



.text
                        .globl  main


main:

    #   >>>Mensagem de saudação---------

    la      $a0,                msg0                                                # Carrega o endereço da primeira mensagem de saudação
    li      $v0,                4                                                   # Prepara para mostrar uma string no terminal

    syscall                                                                         # Mostra a mensagem no terminal

    #   -----------------------------


    #   >>>Mensagem de solicitação---------

    la      $a0,                msg1                                                # Carrega o endereço da primeira mensagem de saudação
    li      $v0,                4                                                   # Prepara para mostrar uma string no terminal

    syscall                                                                         # Mostra a mensagem no terminal

    #   -----------------------------------

    #   Leitura do possível palíndromo ------
    la      $s0,                frase                                               # Carrega o endereço da memória no registrador
    move    $a0,                $s0                                                 # Indica o endereço de entrada do usuário
    li      $a1,                101                                                 # Indica o tamanho do buffer
    li      $v0,                8                                                   # Especifica a função de leitura de string

    syscall                                                                         # Lê uma string do terminal

    # ---------------------------------------

    #O endereço da frase está em $s0
    #Precisamos encontrar o caractere \n
    #Além disso, precisamos remover os caracteres indesejados. Após o uppercase, manteremos somente os caracteres entre
    #'A' e 'Z'

    li      $t0,                '\n'                                                # $t0 é o caractere que queremos encontrar
    li      $s1,                0                                                   # $s1 é o tamanho da string informada
    li      $t3,                'a'                                                 # Char code da letra 'a'
    li      $t4,                'z'                                                 # Char code da letra 'z'
    move    $t1,                $s0                                                 # Copia o endereço do primeiro caractere da frase
    li      $t5,                'A'                                                 # Charcode de 'A'
    li      $t6,                'Z'                                                 # Charcode de 'Z'
    move    $t7,                $s0                                                 # Salva a posição correta do caractere


str_find_end:

    #$t2 =  $s0[x]
    lb      $t2,                0($t1)                                              # Pega o caractere da string na posição $t1
    beq     $t2,                $t0,    END_str_find_end                            # Se encontrar o \n, para o loop. Senão...

    blt     $t2,                $t3,    after_uppercase                             # Se $t2 < 97, ele não precisa ser convertido. Senão, faz a próxima verificação
    bgt     $t2,                $t4,    after_uppercase                             # Se $t2 > 122, ^^^^^^^^^^^. Senão, ele converte para caixa alta

    subi    $t2,                $t2,    32                                          # Converte usando a tabela ASCII de caracteres

after_uppercase:

    blt     $t2,                $t5,    remover_caractere                           # Se for um caractere antes de 'A', não salva o caractere
    bgt     $t2,                $t6,    remover_caractere                           # Se for um caractere depois de 'Z', não salva o caractere

    sb      $t2,                0($t7)                                              # Substitui o caractere na memória pelo novo em caixa alta
    addi    $t7,                $t7,    1                                           # Atualiza a nova posição da string final
    addi    $s1,                $s1,    1                                           # Aumenta o tamanho da string em 1

remover_caractere:

    addi    $t1,                $t1,    1                                           # Vai para a próxima posição da string digitada

    j       str_find_end                                                            # Reinicia o loop


END_str_find_end:

    li      $t0,                '\0'                                                # Salva o valor do caractere \0 de fim de linha
    sb      $t0,                0($t7)                                              # Posiciona um caractere de fim de texto \0 no final da string


    #IDEIA A PARTIR DAQUI ----------------------------------------
    #Perceba que agora todos os caracteres da palavra estão em maiúsculo. Isto é, o charcode de todos os caracteres devem estar entre 65 (A) e 90 (Z).
    #A ideia é então pegar a frase e ir "comendo pelas beiradas". Exemplo: arra -> xrrx -> xxxx -> retorna TRUE no terminal

    move    $a0,                $s0                                                 # Passa uma cópia do endereço do primeiro caractere da string como argumento
    subi    $t1,                $s1,    1                                           # Pega a última posição da string
    add     $a1,                $t1,    $s0                                         # Passa o endereço do último caractere da string como argumento

    jal     func_palindromo                                                         # Chama a função recursiva de palíndromo

    move    $s2,                $v0                                                 # Pegando o retorno da função

    bne     $s2,                $zero,  eh_palindromo                               # Se $s2 != 0 (ou seja, é palindromo) faz um salto para mostrar a mensagem "TRUE". Senão...
    la      $a0,                FALSE                                               # Carrega a palavra "FALSE"
    j       mostrar_resultado                                                       # Pula para a parte de mostrar o resultado

eh_palindromo:

    la      $a0,                TRUE                                                # Carrega a palavra "TRUE"

mostrar_resultado:

    li      $v0,                4                                                   # Configura a operação de mostrar uma string no terminal
    syscall                                                                         # Mostra o resultado final



end:

    li      $v0,                10                                                  # Prepara o programa para ser finalizado
    syscall                                                                         # Finaliza o programa






    #Essa função aplica uma ideia de recursão em calda. É uma técnica de programação que permite escrever algoritmos iterativos de forma recursiva.
    #Esse tipo de recursão não exige o armazenamento do estado do processamento após a chamada recursiva.

func_palindromo:
    subi    $sp,                $sp,    4                                           # Abre espaço na pilha
    sw      $ra,                0($sp)                                              # Guarda o endereço de retorno na pilha

    bgt     $a1,                $a0,    recursivo_palindromo                        # Caso base : $a1 <= $a0. Recursividade: em recursivo_palindromo
    li      $v0,                1                                                   # Se for um palíndromo, a função retorna 1

    lw      $ra,                0($sp)                                              # Recupera o endereço de retorno da função
    addi    $sp,                $sp,    4                                           # Libera o espaço alocado na pilha
    jr      $ra                                                                     # Encerra a execução da recursividade

recursivo_palindromo:                                                               #>>>Recursividade da função

    lb      $t1,                0($a0)                                              # Carrega o caractere na posição $a0
    lb      $t2,                0($a1)                                              # Carrega o caractere na posição $a1
    bne     $t1,                $t2,    diferente                                   #Verifica se os caracteres são diferentes. Se não forem...

    addi    $a0,                $a0,    1                                           # Atualiza o argumento acumulador 1 #2147479548 2147479544
    subi    $a1,                $a1,    1                                           # Atualiza o argumento acumulador 2

    jal     func_palindromo                                                         #  Chamada recursiva da função

    lw      $ra,                0($sp)                                              # Recupera o endereço da chamada anterior da função
    addi    $sp,                $sp,    4                                           # Libera o espaço na pilha

    jr      $ra                                                                     # Retorna para a chamada anterior


diferente:
    li      $v0,                0                                                   # Se não for um palíndromo, a função retorna 0

    addi    $sp,                $sp,    4                                           # Libera o espaço na pilha

    jr      $ra                                                                     # Encerra a execução da recursividade
