

module ALUControl (ALUop, funct, ALUOperation);

    input wire [1:0] ALUop;
    input wire [5:0] funct;
    output wire [3:0] ALUOperation;

    reg [3:0] funcaoIntermediaria;

    assign ALUOperation = funcaoIntermediaria;

    
    always @(*) begin
        case (ALUop)
        
        2'b00: funcaoIntermediaria = 4'b0010;
        2'b01: funcaoIntermediaria = 4'b0110;
        2'b10: begin
            case (funct[3:0]) 
                
                4'b0000: funcaoIntermediaria = 4'b0010;
                4'b0010: funcaoIntermediaria = 4'b0110;
                4'b0100: funcaoIntermediaria = 4'b0000;
                4'b0101: funcaoIntermediaria = 4'b0001;
                4'b1010: funcaoIntermediaria = 4'b0111;

            endcase
        end

        endcase
    end


endmodule;