/*
    * somador4bits.v
    *
    *  Created on: 1 de december de 2024

    Implemente um módulo somador de 4 bits em Verilog, implemente seu testbench, e
    ealize a simulação usando Icarus Verilog e Gtkwave para visualizar as formas de onda.



*/


//Módudo somador de 4 bits

module somador4bits (num1, num2, resultado);

    //Indicando os tipos das portas e os tamanhos:
    input wire [3:0] num1, num2; //Dois números de entrada de no máximo 4 bits
    output wire [4:0] resultado; //Saída de 4+1 bits

    //-------------------------------------------------------------------
    //Comportamento do circuito:

    assign resultado = num1 + num2; //Associa a saída do somador com a soma dos dois números de entrada


endmodule