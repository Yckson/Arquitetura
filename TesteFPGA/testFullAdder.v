

module testFullAdder ();

    wire [3:0] numA;
    wire [3:0] numB;
    wire [1:0] carryOut;
    wire [4:0] resultado;

    FullAdder add0 (.A(numA[0]), B.(numB[0]), .Cin(1'b0), resultado[0], carryOut[0]);

    FullAdder add0 (.A(numA[1]), B.(numB[1]), .Cin(carryOut[0]), resultado[1], carryOut[1]);

    FullAdder add0 (.A(numA[2]), B.(numB[2]), .Cin(carryOut[1]), resultado[2], carryOut[2]);

    FullAdder add0 (.A(numA[3]), B.(numB[3]), .Cin(carryOut[2]), resultado[3], resultado[4]);


endmodule