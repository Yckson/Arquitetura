module InstructionMemory(
    input wire [31:0] addr,      // Endereço da instrução
    input wire reset,
    output wire [31:0] instruction // Instrução lida
);

    // Memória de instruções (256 palavras de 32 bits)
    reg [31:0] memory [255:0];

    // Leitura combinacional
    assign instruction = memory[addr[9:2]]; // Usar bits 9:2 para indexar (alinhado por palavra)

    always @(posedge reset) begin
        if (reset) begin
            // Inicialização da memória de instruções (opcional, apenas para simulação)
            memory[0] <= 32'b0;
            memory[1] <= 32'b0;
            memory[2] <= 32'b0;
            memory[3] <= 32'b00100000000000100000000001001000; //H
            memory[4] <= 32'b11111100000000000000000000000000;
            memory[5] <= 32'b0;
            memory[6] <= 32'b00100000000000100000000001000101; //E
            memory[7] <= 32'b11111100000000000000000000000000;
            memory[8] <= 32'b0;
            memory[9] <= 32'b00100000000000100000000001001100; //L
            memory[10] <= 32'b11111100000000000000000000000000;
            memory[11] <= 32'b0;
            memory[12] <= 32'b00100000000000100000000001001100; //L
            memory[13] <= 32'b11111100000000000000000000000000;
            memory[14] <= 32'b0;
            memory[15] <= 32'b00100000000000100000000001001111; //O
            memory[16] <= 32'b11111100000000000000000000000000;

            
            memory[17] <= 32'b0;
            memory[18] <= 32'b00100000000000100000000000100000; //' ' 
            memory[19] <= 32'b11111100000000000000000000000000;
            memory[20] <= 32'b0;
            memory[21] <= 32'b00100000000000100000000001010111; // W
            memory[22] <= 32'b11111100000000000000000000000000;
            memory[23] <= 32'b0;
            memory[24] <= 32'b00100000000000100000000001001001; // I
            memory[25] <= 32'b11111100000000000000000000000000;
            memory[26] <= 32'b0;
            memory[27] <= 32'b00100000000000100000000001001100; // L
            memory[28] <= 32'b11111100000000000000000000000000;
            memory[29] <= 32'b0;
            memory[30] <= 32'b00100000000000100000000001001100; // L
            memory[31] <= 32'b11111100000000000000000000000000;
            memory[32] <= 32'h2009000a;
            memory[33] <= 32'h2010002c;
            memory[34] <= 32'h01308820;
            memory[35] <= 32'b0;

            
            
        end
    end


endmodule
