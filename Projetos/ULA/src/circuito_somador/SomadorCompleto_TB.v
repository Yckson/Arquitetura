`timescale 1ps/1ps



module SomadorCompleto_TB ();
    //Variáveis de estimulo --------------
    reg A, B, Cin;
    wire R, Cout;

    integer i, j, k, somaEsperada;

    //------------------------------------


    //Instância do DUT--------------------

    SomadorCompleto sm (.A(A), .B(B), .Cin(Cin), .R(R), .Cout(Cout));

    //------------------------------------


    //Geração de estimulos e monitoramento ----------------------------

    initial begin
        $dumpfile("SomadorCompleto_OUT.vcd");
        $dumpvars;

        somaEsperada = 0;

        $monitor("Tempo = %0t | A = %b | B = %b | Cin = %b | R = %b | Cout = %b | somaEsperda = %b %b",
        $time, A, B, Cin, R, Cout, somaEsperada[1], somaEsperada[0]);

        for (i = 0; i < 2; i = i + 1) begin
            A = i[0];
            for (j = 0; j < 2; j = j + 1) begin
                B = j[0];
                for (k = 0; k < 2; k = k + 1) begin
                    Cin = k[0];
                    somaEsperada = A + B + Cin;
                    #10;
                    if (somaEsperada[0] != R || somaEsperada[1] != Cout)
                        $display("Erro: somaEsperada = %b %b | somaCalculada = %b%b", somaEsperada[1], somaEsperada[0], Cout, R);


                end
            
            end

        end

        $finish;
    end






endmodule