        .data
# Reserva espaço para 10 palavras (10 x 4 = 40 bytes), que ficará dentro do limite de 256 palavras
fib:        .space 40
# Armazena o endereço de 'fib' (este valor será resolvido pelo montador)
fib_addr:   .word fib

        .text
        .globl main
main:
        # Carrega o endereço base de 'fib' em $t5
        lw     $t5, fib_addr    # $t5 <- endereço de fib

        # Inicializa os dois primeiros números de Fibonacci:
        addi   $t1, $zero, 0    # $t1 <- 0 (primeiro termo)
        addi   $t2, $zero, 1    # $t2 <- 1 (segundo termo)

        # Armazena os dois primeiros valores em memória:
        sw     $t1, 0($t5)      # fib[0] <- 0
        sw     $t2, 4($t5)      # fib[1] <- 1

        # Configura o contador: já temos 2 números; faltam 8 para completar 10
        addi   $t0, $zero, 8    # $t0 <- número de iterações restantes (8)
        addi   $t3, $zero, 2    # $t3 <- índice para armazenamento (começa em 2)

loop:
        # Calcula o próximo número: $t4 = $t1 + $t2
        add    $t4, $t1, $t2

        # Calcula o deslocamento em bytes para a posição: offset = índice * 4
        # Como não temos shift, fazemos:
        add    $t6, $t3, $t3    # $t6 = 2 * índice
        add    $t6, $t6, $t6    # $t6 = 4 * índice

        # Calcula o endereço de armazenamento: endereço = base + offset
        add    $t7, $t5, $t6

        # Armazena o valor calculado na posição correta
        sw     $t4, 0($t7)

        # Atualiza os registradores para a próxima iteração:
        add    $t1, $t2, $zero  # $t1 <- antigo $t2
        add    $t2, $t4, $zero  # $t2 <- novo valor (fib atual)

        addi   $t0, $t0, -1     # Decrementa o contador de iterações
        addi   $t3, $t3, 1      # Incrementa o índice de armazenamento

        # Se o contador chegar a zero, encerra o loop
        beq    $t0, $zero, end_loop

        j      loop

end_loop:
        # Loop infinito (final do programa)
        j      end_loop
