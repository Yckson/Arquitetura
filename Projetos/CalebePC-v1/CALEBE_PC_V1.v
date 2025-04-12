module CALEBE_PC_V1 (
    input wire CLOCK_27,
    input wire [17:0] SW,
    output wire [7:0] LCD_DATA,
    output wire LCD_RW,
    output wire LCD_EN,
    output wire LCD_RS,
    output wire LCD_ON,
    output wire LCD_BLON,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [17:0] LEDR,
    output wire [8:0] LEDG
);

wire [31:0] PCdebug;
wire [5:0] OpDebug;

wire [9:0] LCD_INPUT_BUS;
wire [7:0] LCD_OUTPUT_BUS;
wire [7:0] LCD_STATE;
wire LCD_canWriteAgain;

wire E;
wire [7:0] LCD_DATABUS;
wire LCD_RESET;
wire clk;
wire reset;
wire [4:0] DISPLAY_7_BIT_CHOICE;
wire [31:0] selectRegisterDebugData; // Data from the selected register for debug

assign E = LCD_INPUT_BUS[9];
assign LCD_DATABUS = LCD_INPUT_BUS[8:1];
assign LCD_RESET = LCD_INPUT_BUS[0];
assign LCD_BLON = 1'b1; // Backlight on
assign reset = SW[17]; // Reset signal from switch SW[0]
assign LEDR[17] = reset; // For debugging, show reset state on LEDR[17]
assign LEDG[7:0] = LCD_STATE; // Indicate LCD state on LEDR[1]
assign LEDR[8] = E;
assign LEDR[16:9] = PCdebug[7:0]; // Display lower 8 bits of PC on LEDR
//assign LEDR[6] = LCD_canWriteAgain;
//assign LEDG[0] = E;
//assign LEDG[7:2] = OpDebug;
//assign LEDG[8] = (selectRegisterDebugData == 32'b0) ? 1'b1 : 1'b0; // Indicate if selected register is zero

assign LEDR[7:0] = DISPLAY_7_BIT_CHOICE; // Display selected register on LEDG
assign LEDG[8] = E; // Indicate if its time to write to the LCD


assign DISPLAY_7_BIT_CHOICE = SW[4:0]; // Display lower 4 bits of PC on 7-segment display



Processor CALEBEPC (
    .clk(CLOCK_27),
    .reset(reset),
    .LCD_INPUT_BUS(LCD_INPUT_BUS),
    .LCD_STATE(LCD_STATE),
    .PC_debug(PCdebug),
    .OpDebug(OpDebug),
    .canWriteAgain(LCD_canWriteAgain), // canWriteAgain signal
    .selectRegisterDebug(DISPLAY_7_BIT_CHOICE), // Select register for debug
    .selectRegisterDebugData(selectRegisterDebugData) // Data from the selected register for debug

);

LCD_CONTROLLER LCD (
    .E(E),
    .DATA(LCD_DATABUS),
    .clk(CLOCK_27),
    .rst(LCD_RESET),
    .LCD_DATA(LCD_DATA),
    .LCD_RW(LCD_RW),
    .LCD_EN(LCD_EN),
    .LCD_RS(LCD_RS),
    .LCD_ON(LCD_ON),
    .LCD_STATE(LCD_STATE),
    .canWriteAgain(LCD_canWriteAgain) // canWriteAgain signal
);

SEG7_LUT seg7_0 (.in(selectRegisterDebugData[3:0]), .out(HEX0)); // Display lower 4 bits on 7-segment display
SEG7_LUT seg7_1 (.in(selectRegisterDebugData[7:4]), .out(HEX1)); 
SEG7_LUT seg7_2 (.in(selectRegisterDebugData[11:8]), .out(HEX2));
SEG7_LUT seg7_3 (.in(selectRegisterDebugData[14:11]), .out(HEX3));  



    
endmodule