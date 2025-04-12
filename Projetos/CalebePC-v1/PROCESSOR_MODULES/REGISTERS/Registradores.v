

module Registradores(
    input wire [4:0] ReadRegister1,  // Endereço do registrador para leitura 1
    input wire [4:0] ReadRegister2,  // Endereço do registrador para leitura 2
    input wire [4:0] WriteRegister,  // Endereço do registrador para escrita
    input wire [31:0] WriteData,     // Dados a serem escritos
    input wire RegWrite,             // Habilitação de escrita
    input wire clk,                  // Clock
    input wire reset, // Reset
    input wire [4:0] selectRegisterDebug,                
    output wire [31:0] ReadData1,    // Dados lidos do registrador 1
    output wire [31:0] ReadData2,     // Dados lidos do registrador 2
    output wire [31:0] LCD_REGISTER, // Registrador LCD
    output wire [31:0] selectRegisterDebugData // Dados do registrador selecionado para debug
);

    // Banco de registradores: 32 registradores de 32 bits
    reg [31:0] registers [31:0];    

    // Inicialização dos registradores (opcional, apenas para simulação)
    integer i;
    integer j;

    // Leitura combinacional
    assign ReadData1 = registers[ReadRegister1];
    assign ReadData2 = registers[ReadRegister2];
    assign LCD_REGISTER = registers[32'd2]; // Registrador LCD
    assign selectRegisterDebugData = registers[selectRegisterDebug]; // Dados do registrador selecionado para debug

    // Escrita síncrona
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            registers[0]  <= 32'b0;
            registers[1]  <= 32'b0;
            registers[2]  <= 32'b0;
            registers[3]  <= 32'b0;
            registers[4]  <= 32'b0;
            registers[5]  <= 32'b0;
            registers[6]  <= 32'b0;
            registers[7]  <= 32'b0;
            registers[8]  <= 32'b0;
            registers[9]  <= 32'b0;
            registers[10] <= 32'b0;
            registers[11] <= 32'b0;
            registers[12] <= 32'b0;
            registers[13] <= 32'b0;
            registers[14] <= 32'b0;
            registers[15] <= 32'b0;
            registers[16] <= 32'b0;
            registers[17] <= 32'b0;
            registers[18] <= 32'b0;
            registers[19] <= 32'b0;
            registers[20] <= 32'b0;
            registers[21] <= 32'b0;
            registers[22] <= 32'b0;
            registers[23] <= 32'b0;
            registers[24] <= 32'b0;
            registers[25] <= 32'b0;
            registers[26] <= 32'b0;
            registers[27] <= 32'b0;
            registers[28] <= 32'b0;
            registers[29] <= 32'b0;
            registers[30] <= 32'b0;
            registers[31] <= 32'b0;

        end else if (clk) begin
            if (RegWrite && WriteRegister != 5'b0) // Verifica se a escrita está habilitada e se o registrador não é $zero
                registers[WriteRegister] <= WriteData;  // Escreve no registrador
        end
        
    end

endmodule
