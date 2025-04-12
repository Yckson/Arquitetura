
module LCD_CONTROLLER (
    input wire E,
    input wire [7:0] DATA,
    input wire clk,
    input wire rst,
    input wire canWriteAgain,

    
    output [7:0] LCD_DATA,
    output wire LCD_RW,
    output wire LCD_EN,
    output wire LCD_RS,
    output wire LCD_ON,
    output wire [7:0] LCD_STATE
);

// STATE machine STATEs ---------------

parameter INIT =                8'd1;
parameter INIT2 =               8'd2;
parameter INIT3 =               8'd3;
parameter WAITING_STATE =       8'd4;
parameter WRITE_BYTE_STATE =    8'd5;
parameter PULSE_HIGH =          8'd6;
parameter PULSE_LOW =           8'd7;

// ------------------------------------


reg [7:0] safeDATA;

reg regLCD_EN;
reg regLCD_ON;

reg regRS;
reg regRW;


reg [7:0] regData;
reg [7:0] STATE;
reg [7:0] NEXT_STATE;

reg [31:0] DELAY;
reg E_sync;

reg hasWrited; // Flag to indicate if data has been written

assign LCD_EN = regLCD_EN;
assign LCD_ON = regLCD_ON;

assign LCD_RW = regRW;
assign LCD_RS = regRS;
assign LCD_DATA = regData;
assign LCD_STATE = STATE; // Output the current state for debugging

// assign LEDR = 8'b0; // For debugging, set to 0


always @(posedge clk or posedge rst) begin
    if (rst) E_sync <= 1'b0;
    else E_sync <= E;
end

always @(posedge canWriteAgain) begin
    
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        DELAY <= 8'b0; // Clear delay register
        safeDATA <= 32'b0; // Clear safeDATA register
        regLCD_EN <= 1'b0; // Clear enable signal
        regLCD_ON <= 1'b1; // Set LCD ON signal
        regRS <= 1'b1; // Command mode
        regData <= 8'h38; // Function set command (8-bit, 2 lines, 5x7 dots) 
        regRW <= 1'b0; // Write mode
        STATE <= PULSE_HIGH; // Initialize state to INIT
        NEXT_STATE <= INIT; // Initialize next state to INIT
        hasWrited <= 1'b0; // Reset the flag to indicate data has not been written

    end else if (clk) begin

        if (canWriteAgain) begin
            hasWrited <= 1'b0; // Reset the flag when canWriteAgain is high
        end

        case (STATE)
            INIT: begin
                regRS <= 1'b0; // Command mode
                regRW <= 1'b0; // Write mode
                regData <= 8'h0C; // Display ON, cursor OFF command
                safeDATA <= 8'b0; // Clear safeDATA to avoid latching old data

                NEXT_STATE <= INIT2; // Next state after INIT
                STATE <= PULSE_HIGH; // Transition to PULSE_HIGH state
            end

            INIT2: begin
                regRS <= 1'b0; // Command mode
                regRW <= 1'b0; // Write mode
                regData <= 8'h06; // Entry mode set command (Increment cursor, NO shift) 

                NEXT_STATE <= INIT3; // Next state after INIT2
                STATE <= PULSE_HIGH; // Transition to PULSE_HIGH state
            end

            INIT3: begin
                regRS <= 1'b0; // Command mode
                regRW <= 1'b0; // Write mode
                regData <= 8'h01; // Clear display command

                NEXT_STATE <= WAITING_STATE; // Next state after INIT3
                STATE <= PULSE_HIGH; // Transition to PULSE_HIGH state
            end

            WAITING_STATE: begin
                
                regRS <= 1'b0; // Command mode
                regRW <= 1'b0; // Write mode

                regData <= 8'b0; // Store the data to be written in safeDATA register
                safeDATA <= DATA; // Store the data to be written in safeDATA register


                if (E && !hasWrited) begin // If E is high, transition to WRITE_BYTE_STATE
                    STATE <= WRITE_BYTE_STATE; // Next state after WAITING_STATE
                    hasWrited <= 1'b1; // Set the flag to indicate data has been written
                end


            end

            WRITE_BYTE_STATE: begin
                regRS <= 1'b1; // Data mode
                regRW <= 1'b0; // Write mode
                regData <= safeDATA; // Load the data to be written from safeDATA register
                
                //regData <= safeDATA;

                STATE <= PULSE_HIGH; // Transition to PULSE_HIGH state
                NEXT_STATE <= WAITING_STATE; // Next state after WRITE_BYTE_STATE

            end

            PULSE_HIGH: begin
                regLCD_EN <= 1'b1; // Set enable signal high
                if (DELAY < 32'd30000) begin
                    DELAY <= DELAY + 1'b1; // Increment delay counter
                end else begin
                    DELAY <= 8'b0; // Reset delay counter
                    STATE <= PULSE_LOW; // Transition to PULSE_LOW state
                end
            end

            PULSE_LOW: begin
                regLCD_EN <= 1'b0; // Set enable signal low
                if (DELAY < 32'd30000 ) begin
                    DELAY <= DELAY + 1'b1; // Increment delay counter
                end
                else begin
                    DELAY <= 32'b0; // Reset delay counter
                    STATE <= NEXT_STATE; // Transition to the next state
                end
            end

            default: begin
                STATE <= INIT; // Default state to INIT
            end
        
        endcase
    end
end






    
endmodule