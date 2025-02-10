module DataMemory(
    input wire clk,                // Clock
    input wire MemRead,            // Sinal de leitura
    input wire MemWrite,           // Sinal de escrita
    input wire [31:0] address,     // Endereço de memória
    input wire [31:0] writeData,   // Dados a serem escritos
    output wire [31:0] readData    // Dados lidos
);

    // Memória de dados (256 palavras de 32 bits)
    reg [31:0] memory [255:0];

    // Inicializa a memória para simulação (opcional)
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'b0; // Inicializa com zero
        end
    end

    // Leitura combinacional
    assign readData = (MemRead) ? memory[address[9:2]] : 32'b0;

    // Escrita combinacional
    always @(*) begin
        if (MemWrite) begin
            memory[address[9:2]] = writeData; // Escreve na memória
        end
    end

endmodule
