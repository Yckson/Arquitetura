

module And4 (R, A, B, C, D);

    input wire A, B, C, D;
    output wire R;

    wire saidaAnd1;
    wire saidaAnd2;

    and AND1 (saidaAnd1, A, B);
    and AND2 (saidaAnd2, C, D);
    and AND3 (R, saidaAnd1, saidaAnd2);




endmodule