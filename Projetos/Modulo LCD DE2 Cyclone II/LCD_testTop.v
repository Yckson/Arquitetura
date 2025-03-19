//`timescale 1us/1ns

module LCD_testbench2 (LCD_DATA, LCD_RW, LCD_RS, LCD_ON, LCD_BLON, LCD_EN, CLOCK_50, SW, LEDR);

  // Sinais de estímulo para o módulo LCD
  reg  [31:0] data;
  reg         selectCD;
  reg         enableWriting;
  reg         clk;
  reg         rst;

  // Sinais do fake driver para simular o comportamento interno do LCD
  // reg  [7:0]  fake_LCD_data;
  // reg         fake_driver_enable;
  // integer     busy_counter;

  // Declaramos LCD_DATA como tri0 para que, quando não for dirigido pelo módulo,
  // ele assuma o valor default 0 (busy flag baixo)
  inout wire [7:0] LCD_DATA;
  input [17:0] SW;

  output wire LCD_RW;
  output wire LCD_RS;
  output wire LCD_ON;
  output wire LCD_BLON;
  output wire [17:0] LEDR;
  wire LCD_Available;
  // (Opcional) Se seu módulo LCD tiver um sinal de enable de LCD, pode ser conectado
  output wire LCD_EN;

  assign clk = CLOCK_50;
  assign rst = SW[17];
  assign LEDR[17] = SW[17];
  assign LEDR[16:0] = 17'b0;



  // Instanciação do módulo LCD (Unidade Sob Teste)
  LCD uut (
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
    .LCD_Available(LCD_Available),
    .LCD_EN(LCD_EN)
  );

  // ---------------------------------------------------------------
  // Bloco Fake LCD: simula a resposta interna do HD44780U
  // Quando o módulo coloca LCD_DATA em tri-state (modo leitura) 
  // (ou seja, LCD_RW == 1), o fake driver injeta um valor com busy flag alto
  // durante 3 ciclos e depois libera (busy flag 0).
  // ---------------------------------------------------------------

  //from testbench

  //initial begin
  //  fake_LCD_data = 8'h80;  // busy flag alto (bit7 = 1)
  //  fake_driver_enable = 0;
  //  busy_counter = 0;
  //end

  // always @(posedge clk) begin
  //   if (LCD_RW == 1'b1) begin
  //     // Ativa o driver fake quando o módulo está em modo leitura
  //     fake_driver_enable <= 1'b1;
  //     if (busy_counter < 3)
  //       busy_counter <= busy_counter + 1;
  //     else
  //       fake_LCD_data <= 8'h00;  // Após 3 ciclos, busy flag desativa
  //   end else begin
  //     fake_driver_enable <= 1'b0;
  //     busy_counter <= 0;
  //     fake_LCD_data <= 8'h80; // Prepara para nova simulação de busy
  //   end
  // end

  // Se o módulo não estiver dirigindo o barramento, o fake driver assume.

  // ---------------------------------------------------------------
  // Gerador de clock: período de 10 us
  // ---------------------------------------------------------------
  // initial begin
  //   clk = 0;
  //   forever #5 clk = ~clk;  // #5 equivale a 5 us, totalizando 10 us de período
  // end

  // ---------------------------------------------------------------
  // Máquina de Estados do Testbench para sequenciar os estímulos
  // ---------------------------------------------------------------
  // Definindo os estados:
  localparam INIT             = 0;
  localparam WAIT_AVAIL       = 1;
  localparam SEND_FIRST       = 2;
  localparam WAIT_FIRST_DONE  = 3;
  localparam SEND_SECOND      = 4;
  localparam WAIT_SECOND_DONE = 5;
  localparam SEND_THIRD       = 6;
  localparam WAIT_THIRD_DONE  = 7;
  localparam WAIT_FIRST_PROCESSING = 8;
  localparam WAIT_SECOND_PROCESSING = 9;
  localparam WAIT_THIRD_PROCESSING = 10;
  localparam FINISH           = 11;
  

  reg [4:0] test_state;
  reg [15:0] delay_counter;  // Contador para gerar atrasos se necessário

  // Máquina de estados síncrona
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      test_state    <= INIT;
      data          <= 32'b0;
      selectCD      <= 1;         // 1 indica escrita de dados
      enableWriting <= 0;
      delay_counter <= 0;
    end else begin
      case (test_state)
        INIT: begin
          // Aguarda alguns ciclos após o reset para estabilização
          if (delay_counter < 5) begin
            delay_counter <= delay_counter + 1;
            enableWriting <= 0;
          end else begin
            delay_counter <= 0;
            test_state <= WAIT_AVAIL;
          end
        end

        WAIT_AVAIL: begin
          // Aguarda LCD_Available ficar 1
          if (LCD_Available == 1)
            test_state <= SEND_FIRST;
        end

        SEND_FIRST: begin
          // Envia "HELL"
          data <= "HELL";  // Literal empacotado (MSB = 'H')
          enableWriting <= 1;
          test_state <= WAIT_FIRST_DONE;
        end

        WAIT_FIRST_DONE: begin
          // Desativa o enableWriting e aguarda LCD_Available
          enableWriting <= 0;
          if (LCD_Available == 1)
            test_state <= WAIT_FIRST_PROCESSING;
        end

        WAIT_FIRST_PROCESSING: begin
            if (LCD_Available == 0) begin // Processamento iniciado
                test_state <= WAIT_FIRST_AVAIL;
            end
        end

        SEND_SECOND: begin
          // Envia "O WI"
          data <= "O WI";
          enableWriting <= 1;
          test_state <= WAIT_SECOND_DONE;
        end

        WAIT_SECOND_DONE: begin
          enableWriting <= 0;
          if (LCD_Available == 1)
            test_state <= SEND_THIRD;
        end

        SEND_THIRD: begin
          // Envia "LL! " (com espaço, se desejar)
          data <= "LL! ";
          enableWriting <= 1;
          test_state <= WAIT_THIRD_DONE;
        end

        WAIT_THIRD_DONE: begin
          enableWriting <= 0;
          if (LCD_Available == 1)
            test_state <= FINISH;
        end

        FINISH: begin
          // Aguarda alguns ciclos antes de terminar a simulação
          // if (delay_counter < 10)
          //   delay_counter <= delay_counter + 1;
          // else
            //$finish;
        end

        default: test_state <= INIT;
      endcase
    end
  end

  // ---------------------------------------------------------------
  // Inicialização do reset (apenas para o testbench)
  // ---------------------------------------------------------------
  // initial begin
  //   $dumpfile("LCD_testbench2.vcd");
  //   $dumpvars(0, LCD_testbench2);
  //   rst = 1;
  //   #20;
  //   rst = 0;
  // end

endmodule
