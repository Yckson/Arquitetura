module ALU(
    input wire [31:0] A,           // Operando 1
    input wire [31:0] B,           // Operando 2
    input wire [3:0] ALUOperation, // Código da operação ALU
    output reg [31:0] ALUResult,   // Resultado da ALU
    output wire Zero               // Sinal Zero (ativo quando ALUResult é 0)
);

    // Define o comportamento da ALU
    always @(*) begin
        case (ALUOperation)
            4'b0000: ALUResult = A & B;          // AND
            4'b0001: ALUResult = A | B;          // OR
            4'b0010: ALUResult = A + B;          // Soma
            4'b0110: ALUResult = A - B;          // Subtração
            4'b0111: ALUResult = (A < B) ? 1 : 0; // SLT (Set Less Than)
            4'b1100: ALUResult = ~(A | B);       // NOR
            default: ALUResult = 32'b0;          // Operação inválida
        endcase
    end

    // Define o sinal Zero
    assign Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;

endmodule
