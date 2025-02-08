

module inconJMUX (jump, jumpAddr, beqPC, PCAddress);

    input wire jump;
    input wire [31:0] jumpAddr;
    input wire [31:0] beqPC;

    output wire [31:0] PCAddress;


    assign PCAddress = (jump) ? jumpAddr : beqPC;



endmodule;