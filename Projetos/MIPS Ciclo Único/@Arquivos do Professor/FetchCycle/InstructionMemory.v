module InstructionMemory(
    input wire [31:0] addr,      // Instruction address
    output wire [31:0] instruction // Read instruction
);

    // Instruction memory (256 words of 32 bits)
    reg [31:0] memory [255:0];

    // Memory initialization with some instructions
    integer i;
    initial begin
        memory[0] = 32'h20080001;  // addi $t0, $zero, 1
        memory[1] = 32'h20090002;  // addi $t1, $zero, 2
        memory[2] = 32'h01095020;  // add $t2, $t0, $t1
        memory[3] = 32'hAC0A0000;  // sw $t2, 0($zero)
        for (i = 4; i < 256; i = i + 1) begin
            memory[i] = 32'b0;      // Zero the rest of the memory
        end
    end

    // Combinational read
    assign instruction = memory[addr[9:2]]; // Use bits 9:2 to index (word-aligned)
endmodule
