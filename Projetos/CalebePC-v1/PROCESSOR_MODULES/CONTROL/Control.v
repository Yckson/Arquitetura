module Control (opCode, regDst, branch, memRead, memToReg, ALUop, memWrite, ALUSrc, regWrite, jump, enable_lcd);

    input wire [5:0] opCode;

    output wire regDst, branch, memRead, memToReg, memWrite, ALUSrc, regWrite, jump;
    output wire [1:0] ALUop;
    output wire enable_lcd;

    reg r_regDst, r_branch, r_memRead, r_memToReg, r_memWrite, r_ALUSrc, r_regWrite, r_jump, r_enable_lcd;
    reg [1:0] r_ALUop;

    assign regDst = r_regDst;
    assign branch = r_branch;
    assign memRead = r_memRead;
    assign memToReg = r_memToReg;
    assign memWrite = r_memWrite;
    assign ALUSrc = r_ALUSrc;
    assign regWrite = r_regWrite;
    assign ALUop = r_ALUop;
    assign jump = r_jump;
    assign enable_lcd = r_enable_lcd;



    always @(opCode) begin
        case (opCode)

            //R-type
            6'b000000: begin
                r_regDst <= 1'b1;
                r_ALUSrc <= 1'b0;
                r_memToReg <= 1'b0;
                r_regWrite <= 1'b1;
                r_memRead <= 1'b0;
                r_memWrite <= 1'b0;
                r_branch <= 1'b0;
                r_jump <= 1'b0;
                r_ALUop <= 2'b10;
                r_enable_lcd <= 1'b0;
            end
            
            //Load
            6'b100011: begin
                r_regDst <= 1'b0;
                r_ALUSrc <= 1'b1;
                r_memToReg <= 1'b1;
                r_regWrite <= 1'b1;
                r_memRead <= 1'b1;
                r_memWrite <= 1'b0;
                r_branch <= 1'b0;
                r_ALUop <= 2'b00;
                r_jump <= 1'b0;
                r_enable_lcd <= 1'b0;
            end

            //Store
            6'b101011: begin
                r_regDst <= 1'b0;
                r_ALUSrc <= 1'b1;
                r_memToReg <= 1'b0;
                r_regWrite <= 1'b0;
                r_memRead <= 1'b0;
                r_memWrite <= 1'b1;
                r_branch <= 1'b0;
                r_ALUop <= 2'b00;
                r_jump <= 1'b0;
                r_enable_lcd <= 1'b0;
            end

            //Branch
            6'b000100: begin
                r_regDst <= 1'b0;
                r_ALUSrc <= 1'b0;    
                r_memToReg <= 1'b0;
                r_regWrite <= 1'b0;
                r_memRead <= 1'b0;
                r_memWrite <= 1'b0;
                r_branch <= 1'b1;
                r_ALUop <= 2'b01;
                r_jump <= 1'b0;
                r_enable_lcd <= 1'b0;
            end

            //Inconditional Jump
            6'b000010: begin
                r_regDst <= 1'b0;
                r_ALUSrc <= 1'b0;
                r_memToReg <= 1'b0;
                r_regWrite <= 1'b0;
                r_memRead <= 1'b0;
                r_memWrite <= 1'b0;
                r_branch <= 1'b0;
                r_ALUop <= 2'b00;
                r_jump <= 1'b1;
                r_enable_lcd <= 1'b0;
            end

            //Addi  
            6'b001000: begin
                r_regDst <= 1'b0;
                r_ALUSrc <= 1'b1;
                r_memToReg <= 1'b0;
                r_regWrite <= 1'b1;
                r_memRead <= 1'b0;
                r_memWrite <= 1'b0;
                r_branch <= 1'b0;
                r_ALUop <= 2'b00;
                r_jump <= 1'b0;
                r_enable_lcd <= 1'b0;
            end

            6'b111111: begin
                r_regDst <= 1'b0;
                r_ALUSrc <= 1'b0;
                r_memToReg <= 1'b0;
                r_regWrite <= 1'b0;
                r_memRead <= 1'b0;
                r_memWrite <= 1'b0;
                r_branch <= 1'b0;
                r_jump <= 1'b0;
                r_ALUop <= 2'b00;
                r_enable_lcd <= 1'b1;
            end

            //Undefined
            default: begin
                r_regDst <= 1'b0;
                r_ALUSrc <= 1'b0;
                r_memToReg <= 1'b0;
                r_regWrite <= 1'b0;
                r_memRead <= 1'b0;
                r_memWrite <= 1'b0;
                r_branch <= 1'b0;
                r_jump <= 1'b0;
                r_ALUop <= 2'b00;
                r_enable_lcd <= 1'b0;
            end
        endcase
    end

endmodule