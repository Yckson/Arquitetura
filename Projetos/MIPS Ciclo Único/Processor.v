

module Processor (clk, reset);

    //Para saida e entrada de dados
    input wire clk, reset;
    //-----------------------------------------

    wire [31:0] instruction;
    output wire [1:0] ALUop;
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
    

    reg [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] jumpAddr_mid;
    wire [31:0] beqOrPCPlus4;
    wire [31:0] waitingPCAddr;



    assign ReadRegister1 = instruction[25:21];
    assign ReadRegister2 = instruction[20:16];
    assign jumpIMM = instruction[25:0];
    assign PCSrc = branch && ALUZero;
    
    
    InstructionMemory instMem0 (.addr(PC), .instruction(instruction));

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
                         .jump(jump)
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
                           .clk(clk),
                           .reset(reset)
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

    DataMemory RAM (.clk(clk),
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



    always @(posedge clk, posedge reset) begin

        if (reset)
            PC <= 32'b0;
        else
            PC <= waitingPCAddr;

    end

    always @(posedge clk) begin
        $display("PC: %d", PC);
    end




    








    

    








endmodule;