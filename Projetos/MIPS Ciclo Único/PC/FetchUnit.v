module FetchUnit(
    input wire clk,                 // Clock
    input wire reset,               // Reset para inicializar o PC
    output wire [31:0] instruction    // Instrução buscada da memória
);

    // Registrador do PC
    reg [31:0] pc;

    // Fios para conexão entre módulos
    wire [31:0] incremented_pc;

    // Instancia o módulo Add4 para incrementar o PC
    Add4 increment (
        .in(pc),
        .out(incremented_pc)
    );

    // Instancia o módulo InstructionMemory para buscar instruções
    InstructionMemory memoria (
        .addr(pc),
        .instruction(instruction)
    );

    // Lógica do PC: Incrementa ou reseta
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializa o PC no reset
            pc <= 32'b0;            
        end else begin
            // Atualiza o PC com o próximo endereço
            pc <= incremented_pc;  
        end
    end

endmodule
