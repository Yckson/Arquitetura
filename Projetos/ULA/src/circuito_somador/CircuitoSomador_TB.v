`timescale 1ps/1ps



module CircuitoSomador_TB();

    //Variáveis de estímulo ----------------------
    reg signed [2:0] A, B;
    reg select;
    wire [2:0] Cout, COMPLEMENTOout;
    wire signed [2:0] R;

    integer i, j, k;
    reg signed [2:0] somaEsperada;

    //--------------------------------------------

    //Instância do DUT ----------------------------------------------------------------------------------------------

    CircuitoSomador CISO_1 (.A(A[0]), 
                            .B(B[0]), 
                            .Cin(1'b0), 
                            .COMPLEMENTOin(1'b1), 
                            .select(select), 
                            .R(R[0]), 
                            .Cout(Cout[0]), 
                            .COMPLEMENTOout(COMPLEMENTOout[0])
                            );

    CircuitoSomador CISO_2 (.A(A[1]), 
                            .B(B[1]), 
                            .Cin(Cout[0]), 
                            .COMPLEMENTOin(COMPLEMENTOout[0]), 
                            .select(select), 
                            .R(R[1]), 
                            .Cout(Cout[1]), 
                            .COMPLEMENTOout(COMPLEMENTOout[1])
                            );
    
    CircuitoSomador CISO_3 (.A(A[2]), 
                            .B(B[2]), 
                            .Cin(Cout[1]), 
                            .COMPLEMENTOin(COMPLEMENTOout[1]), 
                            .select(select), 
                            .R(R[2]), 
                            .Cout(Cout[2]), 
                            .COMPLEMENTOout(COMPLEMENTOout[2])
                            );

    //----------------------------------------------------------------------------------------------------------------

    //Gerador de estímulos e monitoramento ------------

    initial begin
        $dumpfile("CircuitoSomador_OUTPUT.vcd");
        $dumpvars;

        $monitor("Tempo: %0t | SELECT = %d | A = %d | B = %d | Soma = %d | Soma Esperada = %d", 
                  $time, select, A, B, R, somaEsperada);

        for (i = 0; i < 2; i = i + 1) begin
            select = i[0];

            for (j = 0; j < 8; j = j + 1) begin
                A = j[2:0];

                for (k = 0; k < 8; k = k + 1) begin
                
                    B = k[2:0];

                    somaEsperada = (select == 1) ? A + (~B + 1) : A + B;
                    #10;

                    if (somaEsperada !== R) $display("Tempo: %0t Erro! Soma = %d | Soma Esperada = %d", $time, R, somaEsperada);

                
                end

            end

            $display("\n----------------------------------------------------------------------------\n");
        end

        $finish;
    end



endmodule