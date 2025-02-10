`timescale 1ns/1ns
`include "ALU.v"
`include "Registradores.v"

module Simulacao;
    // Entradas para o Register File
    reg [4:0] ReadRegister1, ReadRegister2, WriteRegister;
    reg [31:0] WriteData;
    reg RegWrite;

    // Saídas do Register File
    wire [31:0] ReadData1, ReadData2;

    // Entradas para a ALU
    reg [3:0] ALUOperation;

    // Saídas da ALU
    wire [31:0] ALUResult;
    wire Zero;

    // Instancia o Register File
    Registradores regfile (
        .ReadRegister1(ReadRegister1),
        .ReadRegister2(ReadRegister2),
        .WriteRegister(WriteRegister),
        .WriteData(WriteData),
        .RegWrite(RegWrite),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Instancia a ALU
    ALU alu (
        .A(ReadData1),
        .B(ReadData2),
        .ALUOperation(ALUOperation),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );
   
    integer i;
    // Simulação
    initial begin
        $dumpfile("typeR.vcd");    // Nome do arquivo VCD
        $dumpvars(0, Simulacao);        // Monitora o módulo "Simulacao" e seus sub modulos
        
        // preciso incluir a linha que segue para também
        // monitorar os registradores internos do regfile    
        for (i = 0; i < 32; i = i + 1) begin
            $dumpvars(1, Simulacao.regfile.registers[i]); // Monitora cada registrador
        end
        
        // Inicializa valores
        RegWrite = 0;
        WriteRegister = 0;
        WriteData = 0;
        ReadRegister1 = 0;
        ReadRegister2 = 0;
        ALUOperation = 4'b0000;

        // Escreve no registrador 1
        #10;
        RegWrite = 1;
        WriteRegister = 5'b00001;
        WriteData = 32'd10; // Escreve 10 no registrador 1

        // Escreve no registrador 2
        #10;
        WriteRegister = 5'b00010;
        WriteData = 32'd20; // Escreve 20 no registrador 2

        // Lê os registradores
        #10;
        RegWrite = 0;
        ReadRegister1 = 5'b00001;
        ReadRegister2 = 5'b00010;

        // Realiza operação de soma
        #10;
        ALUOperation = 4'b0010; // Soma (10 + 20)

        // Realiza operação de subtração
        #10;
        ALUOperation = 4'b0110; // Subtração (10 - 20)

        // Realiza operação AND
        #10;
        ALUOperation = 4'b0000; // AND

        // Verifica o sinal Zero
        #10;
        ALUOperation = 4'b0110; // Subtração com resultado zero

        $finish;
    end

    // Monitora o resultado
    initial begin
        $monitor("Time: %0d, ReadData1: %d, ReadData2: %d, ALUResult: %d, Zero: %b",
            $time, ReadData1, ReadData2, ALUResult, Zero);
    end
endmodule
