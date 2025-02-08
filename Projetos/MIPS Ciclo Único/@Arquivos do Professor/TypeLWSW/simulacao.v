`timescale 1ns/1ns
`include "ALU.v"
`include "Registradores.v"
`include "SignalExtend.v"
`include "DataMemory.v"

module Simulacao;

    // Entradas e sinais
    reg clk;
    reg [31:0] instruction;           // Instrução lw/sw
    reg RegWrite, MemRead, MemWrite;  // Controle de registradores e memória
    reg [4:0] WriteRegister, ReadRegister1, ReadRegister2;
    reg [31:0] WriteData;

    // Saídas e sinais intermediários
    wire [31:0] ReadData1, ReadData2;   // Dados lidos do RegisterFile
    wire [31:0] signExtendedOffset;    // Offset estendido
    wire [31:0] ALUResult;             // Endereço calculado pela ALU
    wire Zero;
    wire [31:0] memoryReadData;        // Dados lidos da memória

    // Instanciação dos módulos
    SignExtend signExtend (
        .in(instruction[15:0]),
        .out(signExtendedOffset)
    );

    Registradores regfile (
        .ReadRegister1(ReadRegister1),
        .ReadRegister2(ReadRegister2),
        .WriteRegister(WriteRegister),
        .WriteData(WriteData),
        .RegWrite(RegWrite),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    ALU alu (
        .A(ReadData1),
        .B(signExtendedOffset),
        .ALUOperation(4'b0010), // Soma para calcular o endereço efetivo
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    DataMemory datamemory (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(ALUResult),
        .writeData(ReadData2),
        .readData(memoryReadData)
    );

    // Simulação
    initial begin
        // Geração do VCD
        $dumpfile("typeLWSW.vcd");
        $dumpvars(0, Simulacao);

        // Inicializa sinais
        clk = 0;
        instruction = 32'b0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;

        // Simula a instrução lw $t1, 4($t2)
        #10;
        instruction = 32'b100011_00010_00001_0000_0000_0000_0100; // lw $t1, 4($t2)
        ReadRegister1 = 5'b00010;  // $t2
        WriteRegister = 5'b00001; // $t1
        RegWrite = 1;
        MemRead = 1;

        // Simula a instrução sw $t1, 8($t2)
        #20;
        instruction = 32'b101011_00010_00001_0000_0000_0000_1000; // sw $t1, 8($t2)
        MemRead = 0;
        MemWrite = 1;

        // Finaliza simulação
        #30;
        $finish;
    end

    // Geração de clock
    always #5 clk = ~clk;

endmodule
