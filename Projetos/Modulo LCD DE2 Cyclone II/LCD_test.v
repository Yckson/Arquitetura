module LCD_test;

    reg [31:0] data;
    reg selectCD;
    reg enableWriting;
    reg clk;
    reg rst;

    wire [7:0] LCD_DATA;
    wire LCD_RW;
    wire LCD_RS;
    wire LCD_ON;
    wire LCD_BLON;
    wire LCDAvailable;

    LCD lcd (
        .data(data),
        .selectCD(selectCD),
        .clk(clk),
        .rst(rst),
        .LCD_DATA(LCD_DATA),
        .LCD_RW(LCD_RW),
        .LCD_RS(LCD_RS),
        .LCD_ON(LCD_ON),
        .LCD_BLON(LCD_BLON),
        .enableWriting(enableWriting),
        .LCD_Available(LCDAvailable)
    );

    

    initial begin

        $dumpfile("LCD_test.vcd");
        $dumpvars(0, LCD_test);
        // Initialize signals
        clk = 0;
        rst = 1;
        selectCD = 1;
        enableWriting = 0;
        data = 32'b0;

        // Reset the LCD
        #10 rst = 0;

        wait (LCDAvailable);

        // Write "HELLO WILL!" to the LCD
        #10 data = "HELL";
        enableWriting = 1;
        #10 enableWriting = 0;
        wait (LCDAvailable);

        #10 data = "O WI";
        enableWriting = 1;
        #10 enableWriting = 0;
        wait (LCDAvailable);

        #10 data = "LL!";
        enableWriting = 1;
        #10 enableWriting = 0;
        wait (LCDAvailable);

        #300 $finish;
    end

    initial begin
        #10;
        forever begin
            #5 clk = ~clk;
        end
    end

endmodule
