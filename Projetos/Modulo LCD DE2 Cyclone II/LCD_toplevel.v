module LCD_test (LCD_DATA, LCD_RW, LCD_RS, LCD_ON, LCD_BLON, CLOCK_27, KEY, LEDR);

    reg [31:0] data;
    reg selectCD;
    reg enableWriting;
    

    inout wire [7:0] LCD_DATA;
    output wire LCD_RW;
    output wire LCD_RS;
    output wire LCD_ON;
    output wire LCD_BLON;
    output wire [17:0] LEDR;
    wire LCDAvailable;

    reg comecou;

    input wire CLOCK_27;
    input wire [3:0] KEY;
    wire rst;

    assign rst = KEY[0];
    assign LEDR [17:2] = 16'b0;
    assign LEDR[0] = LCDAvailable;
    assign LEDR[1] = rst;

    LCD lcd (
        .data(data),
        .selectCD(selectCD),
        .clk(CLOCK_27),
        .rst(rst),
        .LCD_DATA(LCD_DATA),
        .LCD_RW(LCD_RW),
        .LCD_RS(LCD_RS),
        .LCD_ON(LCD_ON),
        .LCD_BLON(LCD_BLON),
        .enableWriting(enableWriting),
        .LCD_Available(LCDAvailable)
    );


    always @(posedge CLOCK_27 or posedge rst) begin
        if (rst) begin
            selectCD <= 1'b1;
            enableWriting <= 1'b0;
            data <= " UIU";
            comecou <= 1'b0;
        end
        else begin
            
            if (LCDAvailable) begin
                if (!comecou) enableWriting <= 1'b1;
                else enableWriting <= 1'b0;
            end


        end
    end



endmodule
