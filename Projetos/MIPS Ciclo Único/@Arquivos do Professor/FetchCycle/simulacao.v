`timescale 1ns/1ns
`include "Add4.v"
`include "FetchUnit.v"
`include "MemoriaDeInstrucoes.v"

module Simulacao;

    reg clk;
    reg reset;
    wire [31:0] instrucao;

    // Instancia o módulo FetchUnit
    FetchUnit unidade_fetch (
        .clk(clk),
        .reset(reset),
        .instrucao(instrucao)
    );

    // Gera o clock
    always #5 clk = ~clk;

    initial begin
        // Inicializa sinais
        clk = 0;
        reset = 0;  // Desabilita o reset. No comeco, PC desconhecido.
        #10
        reset = 1;  // Reseta o PC
        #20
        reset = 0;  // Volta a Habilitar o PC, e comeca a buscar instrucao

        // Executa alguns ciclos de clock para verificar o fetch
        #100;
        $finish;
    end

    // Monitora as instruções buscadas
    always @(posedge clk) begin
        $display("PC: %d, Instrução: %h", unidade_fetch.pc, instrucao);
    end
    
    // Bloco para inicializar o dump de formas de onda
    // em um VCD para ver no GTK Wave.
    initial begin
        $dumpfile("fetch_cycle.vcd"); // Nome do arquivo de saída
        $dumpvars(0, Simulacao);    // Registrar todas as variáveis deste módulo
    end

endmodule
