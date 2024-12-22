`timescale 1ps/1ps







module ULA_TB();

    //Variáveis de estímulo -------------------------------------
    reg signed [31:0] A, B;
    reg [2:0] func;

    wire signed [31:0] R;
    wire pinV;
    reg signed [31:0] saidaEsperada;

    integer seed;
    integer randomN;
    reg erro;

    //-----------------------------------------------------------

    //Instância do DUT ------------------------------------------

    ULA UnidadeLogicaAritmetica (
        .A(A),
        .B(B),
        .func(func),
        .R(R),
        .pinV(pinV)
    );

    //-----------------------------------------------------------


    initial begin

        seed = 1234;
        erro = 0;

        $dumpfile("ULA_OUTPUT.vcd");
        $dumpvars;

        
        $display("\t| Iniciando etapa de testes: SEED = %0d |", seed);

        
        $display("%0t | Testes para o circuito somador ------------------------------------------", $time);

        A = 0;
        B = 0;
        func = 3'b0;
        saidaEsperada = A + B;

        #10;

        $display("%0t | Caso base A = %0d + B = %0d : Saida esperada = %0d | Saida obtida = %0d | pinV = %0b",
                  $time, A, B, saidaEsperada, R, pinV);

        if (saidaEsperada != R) begin
            $display("Erro! ^^^^^^");
            erro = 1;
        end
        
         
        
        A = {32{1'b1}};
        B = {32{1'b1}};
        saidaEsperada = A + B;

        #10;

        $display("%0t | Caso extremo A = %0d + B = %0d : Saida esperada = %0d | Saida obtida = %0d | pinV = %0b",
                  $time, A, B, saidaEsperada, R, pinV);

        if (saidaEsperada != R) begin
            $display("Erro! ^^^^^^");
            erro = 1;
        end

        A = 0;
        B = 0;
        func = 3'b001;
        saidaEsperada = A - B;
        
        #10;

        $display("%0t | Caso base A = %0d - B = %0d : Saida esperada = %0d | Saida obtida = %0d | pinV = %0b",
                  $time, A, B, saidaEsperada, R, pinV);

        if (saidaEsperada != R) begin
            $display("Erro! ^^^^^^");
            erro = 1;
        end

        A = {32{1'b1}};
        B = {32{1'b1}};
        saidaEsperada = A - B;

        #10;

        $display("%0t | Caso extremo A = %0d - B = %0d : Saida esperada = %0d | Saida obtida = %0d | pinV = %0b",
                  $time, A, B, saidaEsperada, R, pinV);

        if (saidaEsperada != R) begin
            $display("Erro! ^^^^^^");
            erro = 1;
        end

        $display("\n%0t | Secao de testes aleatorios ----------", $time);

        repeat (10) begin
            A = $urandom(seed);
            B = $urandom(seed);
            func = $urandom_range(0, 1);

            saidaEsperada = (func === 3'b0) ? A + B : A - B;

            #10;

            if (func === 3'b0 ) begin
                $display("%0t | Caso aleatorio A = %0d + B = %0d : Saida esperada = %0d | Saida obtida = %0d | pinV = %0b",
                          $time, A, B, saidaEsperada, R, pinV);
            end

            else begin
                $display("%0t | Caso aleatorio A = %0d - B = %0d : Saida esperada = %0d | Saida obtida = %0d | pinV = %0b",
                          $time, A, B, saidaEsperada, R, pinV);
            end

            
            
            if (saidaEsperada != R) begin
                $display("Erro! ^^^^^^");
                erro = 1;
            end

        
        end

        $display("---------------------------------------------------------------------------------------");
        $display("%0t | Testes para o circuito AND ------------------------------------------", $time);

        $display("\n%0t | Secao de testes aleatorios ----------", $time);

        repeat (10) begin
            A = $urandom(seed);
            B = $urandom(seed);
            func = 3'b010;

            saidaEsperada = A&B;

            #10;

            $display("%0t | Caso aleatorio A = %0b AND B = %0b : Saida esperada = %0b | Saida obtida = %0b",
                  $time, A, B, saidaEsperada, R);
            
            if (saidaEsperada != R) begin
                $display("Erro! ^^^^^^");
                erro = 1;
            end
            

        
        end

        $display("---------------------------------------------------------------------------------------");
        $display("%0t | Testes para o circuito OR ------------------------------------------", $time);

        $display("\n%0t | Secao de testes aleatorios ----------", $time);

        repeat (10) begin
            A = $urandom(seed);
            B = $urandom(seed);
            func = 3'b011;

            saidaEsperada = A | B;

            #10;

            $display("%0t | Caso aleatorio A = %0b OR B = %0b : Saida esperada = %0b | Saida obtida = %0b",
                  $time, A, B, saidaEsperada, R);
            
            if (saidaEsperada != R) begin
                $display("Erro! ^^^^^^");
                erro = 1;
            end

        
        end

        $display("---------------------------------------------------------------------------------------");
        $display("%0t | Testes para o circuito XNOR ------------------------------------------", $time);

        $display("\n%0t | Secao de testes aleatorios ----------", $time);

        repeat (10) begin
            A = $urandom(seed);
            B = $urandom(seed);
            func = 3'b100;

            saidaEsperada = ~(A ^ B);

            #10;

            $display("%0t | Caso aleatorio A = %0b XNOR B = %0b : Saida esperada = %0b | Saida obtida = %0b",
                  $time, A, B, saidaEsperada, R);
            
            if (saidaEsperada != R) begin
                $display("Erro! ^^^^^^");
                erro = 1;
            end

        
        end

        $display("---------------------------------------------------------------------------------------");
        $display("%0t | Testes para o circuito NOT A ------------------------------------------", $time);

        $display("\n%0t | Secao de testes aleatorios ----------", $time);
        
        repeat (10) begin
            A = $urandom(seed);
            func = 3'b101;

            saidaEsperada = ~A;

            #10;

            $display("%0t | Caso aleatorio NOT A = %0b : Saida esperada = %0b | Saida obtida = %0b",
                  $time, A, saidaEsperada, R);
            
            if (saidaEsperada != R) begin
                $display("Erro! ^^^^^^");
                erro = 1;
            end

        
        end

        $display("---------------------------------------------------------------------------------------");
        $display("%0t | Testes para o circuito PASS THROUGH A ------------------------------------------", $time);

        $display("\n%0t | Secao de testes aleatorios ----------", $time);

        repeat (10) begin
            A = $urandom(seed);
            func = 3'b110;

            saidaEsperada = A;

            #10;

            $display("%0t | Caso aleatorio PASS THROUGH A = %0b : Saida esperada = %0b | Saida obtida = %0b",
                  $time, A, saidaEsperada, R);
            
            if (saidaEsperada != R) begin
                $display("Erro! ^^^^^^");
                erro = 1;
            end

        
        end

        $display("---------------------------------------------------------------------------------------");
        $display("%0t | Testes para o circuito NOT B ------------------------------------------", $time);

        $display("\n%0t | Secao de testes aleatorios ----------", $time);

        repeat (10) begin
            B = $urandom(seed);
            func = 3'b111;

            saidaEsperada = ~B;

            #10;

            $display("%0t | Caso aleatorio NOT B = %0b : Saida esperada = %0b | Saida obtida = %0b",
                  $time, B, saidaEsperada, R);
            
            if (saidaEsperada != R) begin
                $display("Erro! ^^^^^^");
                erro = 1;
            end

        
        end


        if (erro) $display("----------Testes concluidos com erro! Rever descricao do hardware.----------");
        else $display("----------Testes concluidos com sucesso!----------");


        $finish;

        



    end





endmodule