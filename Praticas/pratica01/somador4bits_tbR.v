/*
    * somador4bits_tb.v
    *
    *  Created on: 1 de december de 2024

    Testbench para o somador4bits.v

    Funcionalidade de testes randomizados
    
*/

`timescale 1ns / 1ps // DEFINE A UNIDADE DE TEMPO


module somador4bits_tbR;

    reg [3:0] A, B;
    wire [4:0] Y;
    integer seed;
    integer somaObjetivo;

    //INSTÂNCIA DO DUT (DESIGN UNDER TEST)

    somador4bits somador (.num1(A), .num2(B), .resultado(Y));


    //--------------------------------------------------------
    //BLOCO DE TESTES ------------

    initial begin
        $dumpfile("waveform_somador4bitR.vcd"); //Criação do arquivo para o GTKWave
        $dumpvars(0, somador4bits_tbR);

        seed = 12430;
        somaObjetivo = 0;
        
        $monitor("Time=%0d: a=%b b=%b y=%b somaObjetivo=%b", $time, A, B, Y, somaObjetivo); //Monitora automaticamente mudanças em variáveis.


        //SEÇÃO DE ESTÍMULOS -------
        
        $display("Testbench comecou!");

        

        repeat (15) begin
            A = $urandom(seed);
            B = $urandom(seed);
            
            
            somaObjetivo = A + B;

            #10 //Para esperar o módulo do somador finalizar a soma

            if (somaObjetivo != Y) $display("Erro: somaObjetivo (%b) != Y (%b)", somaObjetivo[4:0], Y);

        end

        $finish
        

    end

endmodule

