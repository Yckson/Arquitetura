`timescale 1ns / 1ps

module Registradores(
    input wire [4:0] ReadRegister1,  // Endereço do registrador para leitura 1
    input wire [4:0] ReadRegister2,  // Endereço do registrador para leitura 2
    input wire [4:0] WriteRegister,  // Endereço do registrador para escrita
    input wire [31:0] WriteData,     // Dados a serem escritos
    input wire RegWrite,             // Habilitação de escrita
    input wire clk,                  // Clock
    input wire reset,                // Reset
    output wire [31:0] ReadData1,    // Dados lidos do registrador 1
    output wire [31:0] ReadData2     // Dados lidos do registrador 2
);

    // Banco de registradores: 32 registradores de 32 bits
    reg [31:0] registers [31:0];    

    // Inicialização dos registradores (opcional, apenas para simulação)
    integer i;
    integer j;

    // Leitura combinacional
    assign ReadData1 = registers[ReadRegister1];
    assign ReadData2 = registers[ReadRegister2];

    // Escrita síncrona
    always @(posedge clk, posedge reset) begin
        if ((RegWrite && WriteRegister != 5'b0) && clk) begin
            registers[WriteRegister] <= WriteData;  // Escreve no registrador
        end
        if (reset) begin
            for (j = 0; j < 32; j = j + 1) begin
                registers[j] = 32'b0;
            end
        end
    end

endmodule
