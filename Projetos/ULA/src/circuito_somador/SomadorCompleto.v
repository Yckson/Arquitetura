//Implementação do módulo do Somador Completo





module SomadorCompleto (A, B, Cin, R, Cout);

    //Declaração das portas -----------
    input wire A, B, Cin;
    output wire R, Cout;

    //---------------------------------

    //Fios internos intermediários ----
    wire soma_ms1;
    wire cout_ms1;

    wire cout_ms2;

    //---------------------------------

    //Lógica estrutural ----------------------------------------------
    MeioSomador ms1 (.A(A), .B(B), .R(soma_ms1), .Cout(cout_ms1));
    MeioSomador ms2 (.A(soma_ms1), .B(Cin), .R(R), .Cout(cout_ms2));

    or OR1 (Cout, cout_ms2, cout_ms1);

    //----------------------------------------------------------------

    //Fim do módulo


endmodule

