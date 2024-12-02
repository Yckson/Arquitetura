/*
    * somador4bits_tb.v
    *
    *  Created on: 1 de december de 2024

    Testbench para o somador4bits.v

    1) Realize a simulação exaustiva (todos as combinações de valores de A e B). Quanto
    tempo levou a simulação?
    2) Realize a simulação randomizada. Como garantir que a implementação está correta?
    
*/

`timescale 1ns / 100ps // DEFINE A UNIDADE DE TEMPO


module somador4bits_tb;

    reg [3:0] A, B;
    wire [4:0] Y;

    //INSTÂNCIA DO DUT (DESIGN UNDER TEST)

    somador4bits somador (.num1(A), .num2(B), .resultado(Y));


    //--------------------------------------------------------
    //BLOCO DE TESTES ------------

    initial begin
        $dumpfile("waveform_somador4bit.vcd"); //Criação do arquivo para o GTKWave
        $dumpvars(0, somador4bits_tb);


        $monitor("Time=%0d: a=%b b=%b y=%b", $time, A, B, Y); //Monitora automaticamente mudanças em variáveis.


        //SEÇÃO DE ESTÍMULOS -------
        
        $display("Testbench started");
        //Gerando todas as combinações possíveis
        for (integer i = 0; i < 16; i = i + 1) begin
            A = i[3:0];
            for (integer j = 0; j < 16; j = j + 1) begin
                B = j[3:0];
                #100; //Gera um atraso de 100 unidades
            end
        end

    end

endmodule

