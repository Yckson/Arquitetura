`timescale 1ps/1ps



module BitSlice_TB();

    //Variáveis de estímulo ----------------------------------------

    reg A, B, CinSOMA, CinCOMP;
    reg [2:0] func;

    wire CoutSOMA, CoutCOMP, R;
    reg [1:0] resultadoEsperado;

    integer i, j, k;
 

    //--------------------------------------------------------------


    //Instância do DUT ---------------------------------------------

    BitSlice BS1 (.An(A),
                  .Bn(B),
                  .func(func),
                  .CinSOMA(CinSOMA),
                  .CinCOMP(CinCOMP),
                  .CoutSOMA(CoutSOMA),
                  .CoutCOMP(CoutCOMP),
                  .Rn(R)
                  );

    //--------------------------------------------------------------

    //Gerador de estímulos e monitoramento -----------------------------------------
    
    initial begin

        $dumpfile("BitSlice_OUTPUT.vcd");
        $dumpvars;

        CinSOMA = 1'b0;
        CinCOMP = 1'b1;


        for (i = 0; i < 8; i = i + 1) begin
            func = i[2:0]; //Selecionando a função
            $display("---------------------------------------------------------------------------------");

            for (j = 0; j < 2; j = j + 1) begin
                A = j[0]; //Valores para A

                for (k = 0; k < 2; k = k + 1) begin
                    B = k[0]; //Valores para B

                    case (func)

                        3'b000: begin
                            resultadoEsperado = A + B;
                        end
                        3'b001: begin
                            resultadoEsperado = A - B;
                        end
                        3'b010: begin
                            resultadoEsperado = A & B;
                        end
                        3'b011: begin
                            resultadoEsperado = A | B;
                        end
                        3'b100: begin
                            resultadoEsperado = ~(A ^ B);
                        end
                        3'b101: begin
                            resultadoEsperado = ~A;
                        end
                        3'b110: begin
                            resultadoEsperado = A;
                        end

                        3'b111: begin
                            resultadoEsperado = ~B;
                        end

                    endcase

                    #20;

                    if (func == 0) begin
                        $display("Tempo: %0t | A = %b | B = %b | Cout = %b | R = %b | Esperado = %b",
                                  $time, A, B, CoutSOMA, R, resultadoEsperado);
                        if (resultadoEsperado !== {CoutSOMA, R}) begin
                            $display("Erro: Cout == %b & R == %b !== resultadoEsperado == %B", CoutSOMA, R, resultadoEsperado);
                        end
                    end
                    else begin 
                        $display("Tempo: %0t | A = %b | B = %b | R = %b | Esperado = %b",
                                  $time, A, B, R, resultadoEsperado[0]);
                        if (resultadoEsperado[0] !== R) begin
                            $display("Erro: R == %b !== resultadoEsperado == %B", R, resultadoEsperado[0]);
                        end
                    end
                
                    
                end

            end

        end





    end





endmodule