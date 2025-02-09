`timescale 1ns / 1ps

module Processor_testbench;

    reg clk;
    reg reset;
    reg [31:0] regBankState [31:0];

    integer iterator;
    integer iterator2;

    Processor uut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("Processor_testbench.vcd");
        $dumpvars();

        for (iterator2 = 0; iterator2 < 32; iterator2 = iterator2 + 1) begin
            $dumpvars(1, regBankState[iterator2]);
        end

        for (iterator2 = 0; iterator2 < 256; iterator2 = iterator2 + 1) begin
            $dumpvars(1, Processor_testbench.uut.RAM.memory[iterator2]);
        end
        // Initialize clock and reset
        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Run the clock for a few cycles
        repeat (200) begin
            clk = ~clk;
            #10;
        end

        

        $finish;
    end

    always @(posedge clk) begin
        for (iterator = 0; iterator < 32; iterator = iterator + 1) begin
            regBankState[iterator] = Processor_testbench.uut.regBank.registers[iterator];
        end
    end

endmodule
