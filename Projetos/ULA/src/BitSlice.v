//Implementação do Bit Slice do livro do Uyemura




module BitSlice (An, Bn, func, CinSOMA, CinCOMP, CoutSOMA, CoutCOMP, Rn);


    //Declaração das portas ----------------------------  

    input wire An, Bn, CinSOMA, CinCOMP;
    input wire [2:0] func;

    output CoutSOMA, CoutCOMP, Rn;

    //--------------------------------------------------

    //Fios internos intermediários ---------------------

    wire [2:0] funcCOMPLEMENTO;
    wire [7:0] saidasAndsMux;

    wire R_Somador;
    wire R_AND;
    wire R_OR;
    wire R_XNOR;
    wire R_NOTA;
    wire R_NOTB;

    wire OR4_1;
    wire OR4_2;

    //--------------------------------------------------- 

    //Lógica estrutural ------------------------------------------------------------------------------- 



    //Complemento das entradas da função ---------------------------------------------------------

    not fCOMPLEMENTO_1(funcCOMPLEMENTO[0], func[0]);
    not fCOMPLEMENTO_2(funcCOMPLEMENTO[1], func[1]);
    not fCOMPLEMENTO_3(funcCOMPLEMENTO[2], func[2]);

    //--------------------------------------------------------------------------------------------


    //Circuito responsável pela soma -------------------------------------------------------------
    CircuitoSomador CS1(.A(An), 
                        .B(Bn), 
                        .Cin(CinSOMA), 
                        .COMPLEMENTOin(CinCOMP), 
                        .select(func[0]),
                        .R(R_Somador),
                        .Cout(CoutSOMA),
                        .COMPLEMENTOout(CoutCOMP)
                        );

    //--------------------------------------------------------------------------------------------

    //Circuito Lógico AND ------------------------------------------------------------------------

    and funcAND (R_AND, An, Bn);

    //--------------------------------------------------------------------------------------------

    //Circuito Lógico OR -------------------------------------------------------------------------

    or funcOR (R_OR, An, Bn);

    //--------------------------------------------------------------------------------------------

    //Circuito Lógico XOR ------------------------------------------------------------------------

    xnor funcXNOR (R_XNOR, An, Bn);

    //--------------------------------------------------------------------------------------------

    //Circuitos Lógicos NOT para An e Bn ---------------------------------------------------------
    
    not funcNOTA (R_NOTA, An);

    not funcNOTB (R_NOTB, Bn);

    //--------------------------------------------------------------------------------------------

    //Multiplexador 8:1 -------------------------------------------------------------------------------------

    And4 muxAND_0 (saidasAndsMux[0], funcCOMPLEMENTO[2], funcCOMPLEMENTO[1], funcCOMPLEMENTO[0], R_Somador);
    And4 muxAnd_1 (saidasAndsMux[1], funcCOMPLEMENTO[2], funcCOMPLEMENTO[1], func[0], R_Somador);
    And4 muxAnd_2 (saidasAndsMux[2], funcCOMPLEMENTO[2], func[1], funcCOMPLEMENTO[0], R_AND);
    And4 muxAnd_3 (saidasAndsMux[3], funcCOMPLEMENTO[2], func[1], func[0], R_OR);
    And4 muxAnd_4 (saidasAndsMux[4], func[2], funcCOMPLEMENTO[1], funcCOMPLEMENTO[0], R_XNOR);
    And4 muxAnd_5 (saidasAndsMux[5], func[2], funcCOMPLEMENTO[1], func[0], R_NOTA);
    And4 muxAnd_6 (saidasAndsMux[6], func[2], func[1], funcCOMPLEMENTO[0], An);
    And4 muxAnd_7 (saidasAndsMux[7], func[2], func[1], func[0], R_NOTB);

    Or4 muxOR_0 (OR4_1, saidasAndsMux[0], saidasAndsMux[1], saidasAndsMux[2], saidasAndsMux[3]);
    Or4 muxOR_1 (OR4_2, saidasAndsMux[4], saidasAndsMux[5], saidasAndsMux[6], saidasAndsMux[7]);

    or muxOR_2 (Rn, OR4_1, OR4_2);

    //-------------------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------------

    //Fim do módulo



endmodule