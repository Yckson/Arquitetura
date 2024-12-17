`timescale 1ps/1ps



module MeioSomador_TB();

    //Variáveis Estimulo
    reg num1;
    reg num2;
    wire soma;
    wire Cout;
    integer i, j, somaEsperada;
    //------------------



    //Instância do DUT -------------

    MeioSomador dut (.A(num1), .B(num2), .R(soma), .Cout(Cout));

    //------------------------------
    

    //Gerador de estímulos -----------------
    
    initial begin
        $dumpfile("MeioSomador_OUT.vcd"); 
        $dumpvars;
        $monitor("Tempo=%0t A=%b B=%b R=%b Cout=%b",$time, num1, num2, soma, Cout);

        for (i = 0; i < 2; i = i+1) begin
            num1 = i[0];
            for (j = 0; j < 2; j = j + 1) begin
                num2 = j[0];
                #10;
                somaEsperada = num1 + num2;
                if (soma !== somaEsperada[0] || Cout !== somaEsperada[1]) begin
                    $display("Erro: Resultado inesperado --> R = %b | Cout = %b, SomaEsperada = %b", soma, Cout, somaEsperada);
                end
            end
        end
        $finish;
    end

    




endmodule