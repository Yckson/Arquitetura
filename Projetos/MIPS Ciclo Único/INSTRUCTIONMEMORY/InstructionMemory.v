`timescale 1ns / 1ps

module InstructionMemory(
    input wire [31:0] addr,      // Endereço da instrução
    output wire [31:0] instruction // Instrução lida
);

    // Memória de instruções (256 palavras de 32 bits)
    reg [31:0] memory [255:0];

    integer i;

    // Leitura combinacional
    assign instruction = memory[addr[9:2]]; // Usar bits 9:2 para indexar (alinhado por palavra)


    initial begin
        
        
        //$display("\nINST MEMO ---\n");

        //$readmemb("programbin.bin", memory);
        
        //memory[0] = 32'b001000_00000_01001_0000000000000101; // addi $t1, $zero, 5 [0]
        //$display("\n%b", memory[0]);
        //addi $2, $0, 5
        //memory[1] = 32'b001000_00000_01010_0000000000000101; // addi $t2, $zero, 4 | 5 [4]
        //$display("\n%b", memory[1]);
        //add  $3, $1, $2
        //memory[2] = 32'b000100_01001_01010_0000000000000001; // beq $t1, $t2, escreve_sete [8]
        //$display("\n%b", memory[2]);

        //memory[3] = 32'b000010_00000000000000000000000110; // j escreve_oito [12]
        //$display("\n%b", memory[3]);

        //memory[4] = 32'b001000_00000_10000_0000000000000111; // addi $s0, $zero, 7 (escreve_sete)[16]
        //$display("\n%b", memory[4]);

        //memory[5] = 32'b000010_00000000000000000000001000; // j fim (escreve_sete) [20]
        //$display("\n%b", memory[5]);

        //memory[6] = 32'b001000_00000_10000_0000000000001000; // addi $s0, $zero, 8 (escreve_oito) [24]
        //$display("\n%b", memory[6]);

        //memory[7] = 32'b000010_00000000000000000000001000; // j fim (escreve_oito) [28]
        //$display("\n%b", memory[7]);

        //for (i = 18; i < 256; i = i + 1) begin
        //    memory[i] = 32'b0;
            //$display("\n%b", memory[i]);
        //end

    end


endmodule
