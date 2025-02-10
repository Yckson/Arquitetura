`timescale 1ns/1ns
`include "ALU.v"
`include "Registradores.v"
`include "SignalExtend.v"
`include "Adder32.v"
`include "ShiftLeft2.v"

module Simulacao;

    // Entradas para os módulos
    reg [31:0] pcPlus4;                // Contador de programa (PC)
    reg [15:0] offset;            // Offset de 16 bits da instrução BEQ
    reg [31:0] reg1, reg2;        // Valores dos registradores comparados
    wire [31:0] signExtendedOffset; // Offset estendido
    wire [31:0] shiftedOffset;    // Offset deslocado à esquerda
    wire [31:0] branchAddress;    // Endereço de branch
    wire zero;                    // Resultado da comparação (ALU)
    wire [31:0] aluResult;        // Resultado da ALU

    // Instanciação dos módulos
    SignExtend signExtend (
        .in(offset),
        .out(signExtendedOffset)
    );

    ShiftLeft2 shiftLeft (
        .in(signExtendedOffset),
        .out(shiftedOffset)
    );

    Adder32 adder (
        .a(pcPlus4),
        .b(shiftedOffset),
        .sum(branchAddress)
    );

    ALU alu (
        .A(reg1),
        .B(reg2),
        .ALUOperation(4'b0110), // Subtração para verificar igualdade
        .ALUResult(aluResult),
        .Zero(zero)
    );

    // Simulação
    initial begin
        // Geração do VCD
        $dumpfile("typeBEQ.vcd");
        $dumpvars(0, Simulacao);

        // Inicializa valores
        pcPlus4 = 32'd100;          // PC inicial
        offset = 16'd4;        // Offset da instrução (4 palavras -> deslocamento 16 bytes)
        reg1 = 32'd15;         // Valor do registrador 1
        reg2 = 32'd10;         // Valor do registrador 2 (igual ao reg1 para gerar o branch)

        #10;
        if(zero)
            $display("Branch Taken: %b, Branch Address: %d", zero, branchAddress);
        else
            $display("Branch Taken: %b, Branch Address: %d", zero, pcPlus4);


        // Caso onde os registradores não são iguais
        reg1 = 32'd10;         // Muda reg1 para um valor diferente
        #10;
        if(zero)
            $display("Branch Taken: %b, Branch Address: %d", zero, branchAddress);
        else
            $display("Branch Taken: %b, Branch Address: %d", zero, pcPlus4);

        // Finaliza a simulação
        #20;
        $finish;
    end

endmodule
