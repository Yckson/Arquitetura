//Implementação do módulo do Meio Somador





module MeioSomador (A, B, R, Cout);

    //Declaração das Portas ----
    input wire A, B;
    output wire R, Cout;

    //--------------------------

    //Lógica estrutural --------
    
    xor XOR1 (R, A, B);
    and AND1 (Cout, A, B);

    //--------------------------



    //Fim do módulo


endmodule;