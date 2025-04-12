
module regMUX (
    input wire [4:0] rt,
    input wire [4:0] rd,
    input wire regDst,
    output wire [4:0] wReg
);

    assign wReg = (regDst == 1'b1) ? rd : rt;

endmodule