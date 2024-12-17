//Implementação do complemento de 2 parcelado
//A porta select define se o circuito deve ou não converter para o formato complemento de 2.



module Complemento2 (A, Cin, select, R, Cout);

    //Declaração das portas -------------------
    input wire A, Cin, select;
    output wire R, Cout;
    //-----------------------------------------

    //Fios internos intermediários ------------

    wire A_negado;
    wire select_negado;
    wire A_complemento;

    wire output_AND1;
    wire output_AND2;

    //Logica Estrutural -----------------------

    not NOT1 (select_negado, select);
    not NOT2 (A_negado, A);

    MeioSomador ms (.A(A_negado), .B(Cin), .R(A_complemento), .Cout(Cout));

    

    and AND1 (output_AND1, select, A_complemento);
    and AND2 (output_AND2, select_negado, A);
    or  OR1  (R, output_AND1, output_AND2);



    
endmodule