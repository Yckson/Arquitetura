module Adder32(
    input wire [31:0] a,           // Operando A
    input wire [31:0] b,           // Operando B
    output wire [31:0] sum         // Resultado da soma
);

    assign sum = a + b;            // Soma A + B

endmodule
