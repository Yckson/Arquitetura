`timescale 1us / 1ns

module LCD_testbench;

  // Sinais de estímulo
  reg  [31:0] data;
  reg         selectCD;
  reg         enableWriting;
  reg         clk;
  reg         rst;

  reg [7:0] fake_LCD_data;
  reg       fake_driver_enable;
  integer   busy_counter;

  // Usamos "tri0" para LCD_DATA para que, quando não for dirigido pelo módulo,
  // ele tenha valor 0 (busy flag baixo).
  tri0 [7:0] LCD_DATA;  

  wire LCD_RW;
  wire LCD_RS;
  wire LCD_ON;
  wire LCD_BLON;
  wire LCD_Available;
  wire LCD_EN;

  

  // Instanciação do módulo LCD (unidade sob teste)
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


   initial begin
    fake_LCD_data = 8'h80;  // Busy flag alto (bit 7 = 1)
    fake_driver_enable = 0;
    busy_counter = 0;
  end

  // Esse bloco monitora LCD_RW e simula a operação interna do LCD.
  always @(posedge clk) begin
    if (LCD_RW == 1'b1) begin
      // Quando o módulo está em modo leitura, habilitamos o driver fake.
      fake_driver_enable <= 1'b1;
      // Inicia um contador para manter busy por, por exemplo, 3 ciclos.
      if (busy_counter < 3)
        busy_counter <= busy_counter + 1;
      else
        fake_LCD_data <= 8'h00;  // Após o atraso, busy flag desativa (bit7 = 0)
    end else begin
      fake_driver_enable <= 1'b0;
      busy_counter <= 0;
      fake_LCD_data <= 8'h80; // Prepara para nova simulação de busy
    end
  end


  // Gerador de clock: período de 10 ns
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Sequência de estímulo
  initial begin
    $dumpfile("LCD_testbench.vcd");
    $dumpvars(0, LCD_testbench);

    // Inicializa sinais
    rst = 1;
    data = 32'b0;
    selectCD = 1;       // Supondo que 1 indica escrita de dados (não comando)
    enableWriting = 0;

    // Mantenha reset por 20 ns
    #20;
    rst = 0;

    // Aguarda até que o módulo indique disponibilidade (LCD_Available alto)
    wait(LCD_Available == 1);

    // Primeira escrita: envia "HELL"
    #10;
    data = "HELL";      // Lembre que o literal é empacotado de MSB para LSB
    enableWriting = 1;
    #10;
    enableWriting = 0;

    // Aguarda a liberação para nova escrita
    wait(LCD_Available == 1);

    // Segunda escrita: envia "O WI"
    #10;
    data = "O WI";
    enableWriting = 1;
    #10;
    enableWriting = 0;

    wait(LCD_Available == 1);

    // Terceira escrita: envia "LL! " (com espaço, se desejar)
    #10;
    data = "LL! ";
    enableWriting = 1;
    #10;
    enableWriting = 0;

    wait(LCD_Available == 1);

    #2000 $finish;
  end

endmodule
