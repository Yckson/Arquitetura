`timescale 1ps/1ps


module Complemento2_TB();

    //Variáveis de estimulo -------------------
    reg [3:0] num;
    reg select;
    wire [3:0] saida;
    reg [3:0] saidaEsperada;
    wire [3:0] Cout;

    integer i, j;


    //Instância do DUT -------------------------

    Complemento2 c1 (.A(num[0]), .Cin(1'b1), .select(select), .R(saida[0]), .Cout(Cout[0]));
    Complemento2 c2 (.A(num[1]), .Cin(Cout[0]), .select(select), .R(saida[1]), .Cout(Cout[1]));
    Complemento2 c3 (.A(num[2]), .Cin(Cout[1]), .select(select), .R(saida[2]), .Cout(Cout[2]));
    Complemento2 c4 (.A(num[3]), .Cin(Cout[2]), .select(select), .R(saida[3]), .Cout(Cout[3]));

    //------------------------------------------

    //Geração de estímulos ---------------------

    initial begin
        $dumpfile("Complemento2_OUTPUT.vcd");
        $dumpvars;

        $monitor("Tempo: %0t | select = %b | Numero = %b | Numero complementado = %b | Saida Esperada = %b", 
        $time, select, num, saida, saidaEsperada);

        for (i = 0; i < 2; i = i + 1) begin
            select = i[0];
            for (j = 0; j < 16; j = j + 1) begin
                num = j[3:0];

                saidaEsperada = (i == 1) ? ~num + 1 : num;
                #10;

                if (saidaEsperada !== saida) begin
                    $display("Tempo: %0t Erro! Saida = %b | Saida esperada: %b", $time, saida, saidaEsperada);
                end


                
            end

        end

        $finish;

    end






endmodule