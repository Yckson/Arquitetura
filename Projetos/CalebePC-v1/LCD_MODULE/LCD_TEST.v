module LCD_TEST (
    input wire [3:0] KEY,
    input wire [17:0] SW,
    input wire CLOCK_27,
    output wire [7:0] LCD_DATA,
    output wire LCD_RW,
    output wire LCD_EN,
    output wire LCD_RS,
    output wire LCD_ON,
    output wire LCD_BLON,
    output wire [7:0] LEDG,
    output wire [17:0] LEDR
);

    reg [7:0] data;
    reg enable;
    reg canInit;
    reg [7:0] LEDGreg; // LED output for debugging
    wire [7:0] LCD_STATE;
    wire busy;
    wire clk;
    wire rst;

    assign clk = CLOCK_27; // Clock input from CLOCK_27
    assign rst = ~KEY[0]; // Reset input from KEY[0]
    assign LEDG = LEDGreg; // LED output for debugging
    assign LCD_BLON = 1'b1; // Backlight on
    

    LCD_CONTROLLER lcd_controller (
        .E(enable),
        .DATA(data),
        .clk(clk),
        .rst(rst),
        .LCD_DATA(LCD_DATA),
        .busy(busy),
        .LCD_RW(LCD_RW),
        .LCD_EN(LCD_EN),
        .LCD_RS(LCD_RS),
        .LCD_ON(LCD_ON),
        .LEDR(LEDR), // Connect LEDR to the LCD controller
        .LCD_STATE(LCD_STATE) // Connect LCD state to the controller
    );

    // Máquina de estados para escrever "HELLO WILL"
    parameter IDLE = 4'd0;
    parameter WRITE_H = 4'd1;
    parameter WRITE_E = 4'd2;
    parameter WRITE_L1 = 4'd3;
    parameter WRITE_L2 = 4'd4;
    parameter WRITE_O = 4'd5;
    parameter WRITE_SPACE = 4'd6;
    parameter WRITE_W = 4'd7;
    parameter WRITE_I = 4'd8;
    parameter WRITE_L3 = 4'd9;
    parameter WRITE_L4 = 4'd10;
    parameter DONE = 4'd11;
    parameter WAIT1 = 4'd12; // Wait for busy signal
    parameter WAIT2 = 4'd13; // Wait for busy signal

    parameter NOT_BUSY = 8'd4;

    reg [3:0] state;
    reg [3:0] next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= WRITE_H; // Start with the first state
            data <= 8'b0;
            enable <= 1'b0;
            LEDGreg <= 8'b0; // Reset LED output
            canInit <= 1'b1; // Enable initialization
        end else if (clk && canInit) begin
            case (state)
                WRITE_H: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        state <= WAIT1; // wait for busy signal
                        next_state <= WRITE_E;
                        data <= 8'h48; // 'H'
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b00000010; // STATE WRITE_H
                end
                WRITE_E: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= WRITE_L1; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        data <= 8'h45; // 'E'
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b0000011; // STATE WRITE_E
                end
                WRITE_L1: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= WRITE_L2; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        data <= 8'h4C; // 'L'
                        
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b0000100; // STATE WRITE_L1
                end
                WRITE_L2: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= WRITE_O; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        
                        data <= 8'h4C; // 'L'
                        
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b000101; // STATE WRITE_L2
                end
                WRITE_O: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= WRITE_SPACE; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        data <= 8'h4F; // 'O'
                        
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b000110; // STATE WRITE_O
                end
                WRITE_SPACE: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= WRITE_W; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        data <= 8'h20; // ' '
                        
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b000111; // STATE WRITE_SPACE
                end
                WRITE_W: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= WRITE_I; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        data <= 8'h57; // 'W'
                        
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b001001; // STATE WRITE_W
                end
                WRITE_I: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= WRITE_L3; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        data <= 8'h49; // 'I'
                        
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b001010; // STATE WRITE_I
                end
                WRITE_L3: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= WRITE_L4; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        data <= 8'h4C; // 'L'
                        
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b001011; // STATE WRITE_L3
                end
                WRITE_L4: begin
                    if (LCD_STATE == NOT_BUSY) begin
                        next_state <= DONE; // Transition to the next state
                        state <= WAIT1; // wait for busy signal
                        data <= 8'h4C; // 'L'
                        enable <= 1'b1;
                    end
                    else begin
                        enable <= 1'b0;
                    end
                    LEDGreg <= 8'b001100; // STATE WRITE_L4
                end
                DONE: begin
                    enable <= 1'b0; // Finaliza a escrita
                    LEDGreg <= 8'b11111111; // STATE DONE
                end

                WAIT1: begin
                    state <= next_state; // Transition to the next state
                    LEDGreg <= 8'b10101010; // STATE WAIT1
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
