//Implementação do módulo do Circuito Somador


module CircuitoSomador (A, B, Cin, COMPLEMENTOin, select, R, Cout, COMPLEMENTOout);

    //Declaração das portas ----------------------
    input wire A, B, Cin, COMPLEMENTOin, select;
    output wire R, Cout, COMPLEMENTOout;
    //--------------------------------------------

    //Fios internos intermediários ---------------

    wire B_complemento;

    //--------------------------------------------

    //Lógica estrutural ------------------------------------------------------------------------------------------

    Complemento2 COMP2_1 (.A(B), .Cin(COMPLEMENTOin), .select(select), .R(B_complemento), .Cout(COMPLEMENTOout));


    SomadorCompleto SOMA_1 (.A(A), .B(B_complemento), .Cin(Cin), .R(R), .Cout(Cout));

    //-------------------------------------------------------------------------------------------------------------
    

endmodule;

