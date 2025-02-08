

module memMUX (memToReg, readData, ALUData, writeData);

    input wire memToReg;
    input wire [31:0] readData;
    input wire [31:0] ALUData;
    
    output wire [31:0] writeData;


    assign writeData = (memToReg == 1'b1) ? readData : ALUData;

endmodule;