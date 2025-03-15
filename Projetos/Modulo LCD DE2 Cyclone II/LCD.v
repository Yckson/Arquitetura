module LCD (data, selectCD, clk, rst, LCD_DATA, LCD_RW, LCD_RS, LCD_ON, LCD_BLON, enableWriting, LCD_Available);

    input wire [31:0] data;
    input wire selectCD;
    input wire enableWriting;
    input wire clk;
    input wire rst;

    output wire [7:0] LCD_DATA;
    output wire LCD_RW;
    output wire LCD_RS;
    output wire LCD_ON;
    output wire LCD_BLON;
    output wire LCD_Available;


    reg select_ReadOrWrite;
    reg enableNext;
    reg select_CommandOrData;
    reg powerON;
    reg backlightON;
    reg actualLine;
    reg LCDAvailable;
    reg [31:0] localData;

    //Pin assignments

    assign LCD_DATA = currCmd;
    assign LCD_RW = select_ReadOrWrite;
    assign LCD_RS = select_CommandOrData;
    assign LCD_ON = powerON;
    assign LCD_BLON = backlightON;
    assign LCD_Available = LCDAvailable;


    //For the FSA ---------------------------------------------------------------------

    reg [3:0] currState;
    reg [7:0] delayClocks;
    reg [7:0] currCmd;
    reg [3:0] nextState;

    parameter initState1 = 4'd0;
    parameter initStateCommand = 4'd1;
    parameter initState2 = 4'd2;
    parameter byte0 = 4'd4;
    parameter byte1 = 4'd5;
    parameter byte2 = 4'd6;
    parameter byte3 = 4'd7;
    parameter waitingState = 4'd8;
    parameter PULSE_HIGH = 4'd14;
    parameter resetState = 4'd15;

    

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            currState <= resetState;
            enableNext <= 1'b0;
        end

        else begin
            case (currState)
                initState1: begin
                    enableNext <= 1'b0;
                    currCmd <= 8'h0C;
                    select_CommandOrData <= 1'b0;


                    localData <= 32'b0;

                    currState <= PULSE_HIGH;
                    nextState <= waitingState;
                    LCDAvailable <= 1'b0;

                end

                initState2: begin
                    enableNext <= 1'b0;
                    currCmd <= 8'h00;
                    localData <= data;
                    currState <= PULSE_HIGH;
                    nextState <= (selectCD) ? byte0 : initStateCommand;
                    LCDAvailable <= 1'b0;


                end

                byte0: begin
                    enableNext <= 1'b0;
                    select_CommandOrData <= 1'b1;
                    if (localData[31:24] == "\n") begin
                        actualLine <= ~actualLine;
                        currCmd <= 8'h00;
                    end
                    else begin
                        currCmd <= localData[31:24];

                    end
                    
                    currState <= PULSE_HIGH;
                    nextState <= byte1;

                end
                byte1: begin
                    enableNext <= 1'b0;
                    select_CommandOrData <= 1'b1;
                    if (localData[23:16] == "\n") begin
                        actualLine <= ~actualLine;
                        currCmd <= 8'h00;
                    end
                    else begin
                        currCmd <= localData[23:16];

                    end
                    
                    currState <= PULSE_HIGH;
                    nextState <= byte2;

                end
                byte2: begin
                    enableNext <= 1'b0;
                    select_CommandOrData <= 1'b1;
                    if (localData[15:8] == "\n") begin
                        actualLine <= ~actualLine;
                        currCmd <= 8'h00;
                    end
                    else begin
                        currCmd <= localData[15:8];

                    end
                    
                    currState <= PULSE_HIGH;
                    nextState <= byte3;

                end
                byte3: begin
                    enableNext <= 1'b0;
                    select_CommandOrData <= 1'b1;
                    if (localData[7:0] == "\n") begin
                        actualLine <= ~actualLine;
                        currCmd <= 8'h00;
                    end
                    else begin
                        currCmd <= localData[7:0];

                    end
                    
                    currState <= PULSE_HIGH;
                    nextState <= waitingState;

                end

                waitingState: begin
                    enableNext <= 1'b0;
                    currCmd <= 8'h00;
                    select_CommandOrData <= 1'b0;
                    currState <= (enableWriting) ? initState2 : waitingState;
                    LCDAvailable <= 1'b1;
                end

                resetState: begin
                    select_ReadOrWrite <= 1'b0;
                    select_CommandOrData <= 1'b0;
                    powerON <= 1'b1;
                    delayClocks <= 8'b0;
                    backlightON <= 1'b1;
                    currCmd <= 8'h38;
                    LCDAvailable <= 1'b0;

                    currState <= PULSE_HIGH;
                    nextState <= initState1;
                    enableNext <= 1'b0;
                    
                end

                PULSE_HIGH: begin
                    
                    enableNext <= 1'b1;
                    currState <= nextState;


                end

                default: begin
                    
                    currState <= resetState;

                end
            endcase

        end
    end

    //--------------------------------------------------------


endmodule