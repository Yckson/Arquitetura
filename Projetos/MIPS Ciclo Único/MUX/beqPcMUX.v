

module beqPcMUX (PCSrc, nextPC, beqPC, PCAddress);

    input wire PCSrc;
    input wire [31:0] nextPC;
    input wire [31:0] beqPC;

    output wire [31:0] PCAddress;


    assign PCAddress = (PCSrc) ? beqPC : nextPC;



endmodule;