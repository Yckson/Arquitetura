module SignalExtend(
    input wire [15:0] in,         // Campo de 16 bits a ser estendido
    output wire [31:0] out        // Resultado estendido para 32 bits
);

    assign out = {{16{in[15]}}, in}; // Extensão de sinal replicando o bit mais significativo

endmodule
