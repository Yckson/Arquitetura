module Add4(
    input wire [31:0] in,        // Endereço atual do PC
    output wire [31:0] out       // Endereço incrementado
);
    assign out = in + 32'd4;     // Soma 4 ao valor de entrada
endmodule
