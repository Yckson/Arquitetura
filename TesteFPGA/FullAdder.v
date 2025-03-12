



module FullAdder (A, B, Cin, R, Cout);

    input wire A, B, Cin;
    output wire R, Cout;

    reg [1:0] intermediario;

    assign R = intermediario[0];
    assign Cout = intermediario[1];

    always @(*) begin
        intermediario = A + B + Cin;
    end

endmodule