module LCD_test (LCD_DATA, LCD_RW, LCD_RS, LCD_ON, LCD_BLON, CLOCK_50, KEY, LEDR);

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

    input wire CLOCK_50;
    input wire [3:0] KEY;
    wire rst;

    assign rst = KEY[0];
    assign LEDR [17:1] = 17'b0;
    assign LEDR[0] = LCDAvailable;

    LCD lcd (
        .data(data),
        .selectCD(selectCD),
        .clk(CLOCK_50),
        .rst(rst),
        .LCD_DATA(LCD_DATA),
        .LCD_RW(LCD_RW),
        .LCD_RS(LCD_RS),
        .LCD_ON(LCD_ON),
        .LCD_BLON(LCD_BLON),
        .enableWriting(enableWriting),
        .LCD_Available(LCDAvailable)
    );


    always @(posedge CLOCK_50 or posedge rst) begin
        if (rst) begin
            selectCD <= 1'b1;
            enableWriting <= 1'b0;
            data <= " UIU";
        end
        else begin
            
            enableWriting <= 1'b1;

        end
    end



endmodule
