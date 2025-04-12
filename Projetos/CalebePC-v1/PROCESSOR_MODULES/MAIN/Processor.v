

module Processor (clk, reset, LCD_INPUT_BUS, LCD_STATE, canWriteAgain, PC_debug, OpDebug, selectRegisterDebug, selectRegisterDebugData);

    //Para saida e entrada de dados
    input wire clk;
    input wire reset;
    input wire [4:0] selectRegisterDebug; // Select register for debug
    output wire [31:0] PC_debug;
    output wire [5:0] OpDebug;
    output wire [31:0] selectRegisterDebugData; // Data from the selected register for debug

    reg clock = 1'b0; // Clock signal for the processor
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clock <= 1'b0; // Reset the clock signal
            clockCounter <= 32'b0;
        end else begin
            if (DELAY_CLK <= 32'd30000) begin
                DELAY_CLK <= DELAY_CLK + 1;
            end else if (clockCounter < 255) begin
                clock <= ~clock;
                clockCounter <= clockCounter + 1;
                DELAY_CLK <= 32'b0;
            end
        end
    end

    assign PC_debug = PC; // Debugging output for the current PC value
    assign OpDebug = instruction[31:26]; // Debugging output for the opcode
    //-----------------------------------------

    //PARA O LCD ------------------------------

    output wire [9:0] LCD_INPUT_BUS;
    output wire canWriteAgain;
    input wire [7:0] LCD_STATE;
    reg [31:0] DELAY_CLK; // Delay for LCD clock
    reg [31:0] clockCounter;

    wire [31:0] LCD_DATA;

    wire ENABLE_LCD;
    reg ENABLE_LCDreg;
    reg canWriteAgainReg = 1'b0; // Initialize to 0

    assign LCD_INPUT_BUS = {ENABLE_LCDreg, LCD_DATA[7:0], reset};
    assign canWriteAgain = canWriteAgainReg; // Output the canWriteAgain signal

    //------------------------------------------

    //PARA O Display de 7 bits ------------------------------


    //-------------------------------------------

    wire [31:0] instruction;
    wire [3:0] ALUOperation;
    wire regDst;
    wire branch;
    wire memRead;
    wire memToReg;
    wire memWrite;
    wire ALUSrc;
    wire regWrite;
    wire PCSrc;
    wire jump;
    wire [1:0] ALUop;
    wire [31:0] ALUinputB;
    wire [31:0] ALUResult;
    wire [4:0] ReadRegister1; 
    wire [4:0] ReadRegister2;
    wire [4:0] WriteRegister;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] signExtended;
    wire ALUZero;
    wire [31:0] extendedShifted;
    wire [31:0] branchAddr;
    wire [31:0] RAMOut;
    wire [31:0] writeData;
    wire [25:0] jumpIMM;


    

    reg [31:0] PC = 32'b0; 
    wire [31:0] nextPC;
    wire [31:0] jumpAddr_mid;
    wire [31:0] beqOrPCPlus4;
    wire [31:0] waitingPCAddr;



    assign ReadRegister1 = instruction[25:21];
    assign ReadRegister2 = instruction[20:16];
    assign jumpIMM = instruction[25:0];
    assign PCSrc = branch && ALUZero;


    //Estados da máquina de estados

    parameter IDLE =                8'd0;
    parameter INIT =                8'd1;
    parameter LETTER =              8'd2;

    parameter WAIT =                8'd255;


    reg [7:0] STATE;
    reg [7:0] NEXT_STATE;
    
    
    InstructionMemory instMem0 (.addr(PC), .instruction(instruction), .reset(reset));

    Add4 ADD4_0 (.in(PC), .out(nextPC));
    
    Control ControlUnit (.opCode(instruction[31:26]),
                         .regDst(regDst),
                         .branch(branch),
                         .memRead(memRead),
                         .memToReg(memToReg),
                         .memWrite(memWrite),
                         .ALUSrc(ALUSrc),
                         .regWrite(regWrite),
                         .ALUop(ALUop),
                         .jump(jump),
                         .enable_lcd(ENABLE_LCD)
                         );

    regMUX mux0 (.rt(instruction[20:16]),
                 .rd(instruction[15:11]),
                 .regDst(regDst),
                 .wReg(WriteRegister)
                );

    Registradores regBank (.ReadRegister1(ReadRegister1),
                           .ReadRegister2(ReadRegister2),
                           .WriteRegister(WriteRegister),
                           .WriteData(writeData),
                           .RegWrite(regWrite),
                           .ReadData1(ReadData1),
                           .ReadData2(ReadData2),
                           .clk(clock),
                           .reset(reset),
                           .LCD_REGISTER(LCD_DATA),
                            .selectRegisterDebug(selectRegisterDebug), // Select register for debug
                            .selectRegisterDebugData(selectRegisterDebugData) // Data from the selected register for debug
                           );

    ALUControl ALUControlUnit (.ALUop(ALUop),
                               .funct(instruction[5:0]),
                               .ALUOperation(ALUOperation)
                               );

    
    SignalExtend sigExt0 (.in(instruction[15:0]), .out(signExtended));

    ALUMUX mux1 (.regData(ReadData2),
                 .instantData(signExtended),
                 .ALUSrc(ALUSrc),
                 .ALUData(ALUinputB)
                 );

    ALU ALU0 (.A(ReadData1),
              .B(ALUinputB),
              .ALUOperation(ALUOperation),
              .ALUResult(ALUResult),
              .Zero(ALUZero)
              );

    ShiftLeft2 shift0 (.in(signExtended), .out(extendedShifted));

    Adder32 adder32_0 (.a(nextPC),
                       .b(extendedShifted),
                       .sum(branchAddr));

    beqPcMUX mux2 (.PCSrc(PCSrc),
                   .nextPC(nextPC),
                   .beqPC(branchAddr),
                   .PCAddress(beqOrPCPlus4)
                   );

    //Lembrar de colocar o waitingPCAddr no PC com always

    DataMemory RAM (.clk(clock),
                    .MemRead(memRead),
                    .MemWrite(memWrite),
                    .address(ALUResult),
                    .writeData(ReadData2),
                    .readData(RAMOut)
                    );

    memMUX mux3 (.memToReg(memToReg),
                 .readData(RAMOut),
                 .ALUData(ALUResult),
                 .writeData(writeData)
                 );

    ShiftLeft2 shift1 (.in({6'b0, jumpIMM}),
                       .out(jumpAddr_mid)
                       );



    inconJMUX mux4 (.jump(jump),
                    .jumpAddr({nextPC[31:28], jumpAddr_mid[27:0]}),
                    .beqPC(beqOrPCPlus4),
                    .PCAddress(waitingPCAddr)
                    );

    



    always @(posedge clock or posedge reset) begin

        if (reset)
            PC <= 32'b0;
        else
            PC <= waitingPCAddr;

    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            STATE <= IDLE;
        end
        else if (clock) begin
            case (STATE)
                IDLE: begin
                    if (ENABLE_LCD) begin
                        STATE <= LETTER;
                        ENABLE_LCDreg <= 1'b1; // Enable the LCD
                        canWriteAgainReg <= 1'b1; // Indicate that the LCD can write again
                    end else begin
                        ENABLE_LCDreg <= 1'b0; // Disable the LCD
                        canWriteAgainReg <= 1'b0; // Indicate that the LCD cannot write
                    end
                end

                LETTER: begin
                    // Initialize the LCD data and control signals
                    // Example: using the lower 8 bits of the output data register
                    
                    // Transition to WAIT state after initialization
                    canWriteAgainReg <= 1'b0; // Indicate that the LCD can write again
                    ENABLE_LCDreg <= 1'b0; // Disable the LCD
                    STATE <= IDLE;
                    
                end

                WAIT: begin
                    if (LCD_STATE == 8'd4) begin
                        
                        STATE <= IDLE; // Transition back to IDLE or another state as needed
                        
                    end
                end

                default: begin
                    // Default case to handle unexpected states
                    STATE <= IDLE;
                end
            endcase
        end
    end
endmodule