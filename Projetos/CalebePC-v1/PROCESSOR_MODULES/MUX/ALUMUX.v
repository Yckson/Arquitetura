

module ALUMUX (regData, instantData, ALUSrc, ALUData);

    input wire [31:0] regData;
    input wire [31:0] instantData;
    input wire ALUSrc;

    output wire [31:0] ALUData;



    assign ALUData = (ALUSrc == 1'b1) ? instantData : regData;

endmodule