//Unidade Lógica Aritmética -- Finalmente!




module ULA (A, B, func, R, pinV);

    input wire signed [31:0] A, B;
    input wire [2:0] func;

    output wire signed [31:0] R;
    output wire pinV;


    wire [31:0] CoutSOMA, CoutCOMP;

    genvar i;
    
    generate
        
        for (i = 0; i < 32; i = i + 1) begin : BUS_BLOCK
            
            if (i < 1) begin
                BitSlice BSn (.An(A[i]), 
                              .Bn(B[i]), 
                              .func(func), 
                              .CinSOMA(1'b0), 
                              .CinCOMP(1'b1), 
                              .CoutSOMA(CoutSOMA[i]),
                              .CoutCOMP(CoutCOMP[i]),
                              .Rn(R[i])
                              );
            end
            else begin
                BitSlice BSn (.An(A[i]), 
                              .Bn(B[i]), 
                              .func(func), 
                              .CinSOMA(CoutSOMA[i-1]), 
                              .CinCOMP(CoutCOMP[i-1]), 
                              .CoutSOMA(CoutSOMA[i]),
                              .CoutCOMP(CoutCOMP[i]),
                              .Rn(R[i])
                              );
            
            end

        end

    endgenerate

    assign pinV = CoutSOMA;

endmodule