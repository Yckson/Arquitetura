`timescale 1ns / 1ps

module Processor_testbench;

    reg clk;
    reg reset;
    wire [31:0] instruction;
    wire [31:0] PC;
    wire [31:0] nextPC;

    wire regDst, branch, memRead, memToReg, memWrite, ALUSrc, regWrite, jump;
    wire [1:0] ALUop;

    Processor dut (
        .clk(clk),
        .reset(reset)
    );

    assign instruction = dut.instruction;

    assign regDst = dut.ControlUnit.regDst;
    assign branch = dut.ControlUnit.branch;
    assign memRead = dut.ControlUnit.memRead;
    assign memToReg = dut.ControlUnit.memToReg;
    assign memWrite = dut.ControlUnit.memWrite;
    assign ALUSrc = dut.ControlUnit.ALUSrc;
    assign regWrite = dut.ControlUnit.regWrite;
    assign ALUop = dut.ControlUnit.ALUop;
    assign jump = dut.ControlUnit.jump;
    assign PC = dut.PC;
    assign nextPC = dut.waitingPCAddr;

    genvar iter1;
    genvar iter2;
    integer iter3;

    for (iter1 = 0; iter1 < 32; iter1 = iter1 + 1) begin : Banco_de_Registradores
        wire [31:0] registrador;
        assign registrador = dut.regBank.registers[iter1];
    end
    for (iter2 = 0; iter2 < 256; iter2 = iter2 + 1) begin : Memoria_de_Dados
        wire [31:0] data;
        assign data = dut.RAM.memory[iter2];
    end


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, Processor_testbench);

        
        // Initialize clock and reset
        clk = 0;
        reset = 1;

        $readmemb("./Assembly/programbin.bin", dut.instMem0.memory, 0, 17);

        for (iter3 = 18; iter3 < 256; iter3 = iter3 + 1) begin
            dut.instMem0.memory[iter3] = 32'b0;
        end

        #10 reset = 0;

        // Run the clock for a few cycles
        repeat (200) begin
            clk = ~clk;
            #10;
        end

        

        $finish;
    end

    

endmodule
