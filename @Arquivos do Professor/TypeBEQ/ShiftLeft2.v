module ShiftLeft2(
    input wire [31:0] in,          // Entrada de 32 bits
    output wire [31:0] out         // Saída deslocada
);

    assign out = in << 2;          // Desloca à esquerda em 2 bits

endmodule
