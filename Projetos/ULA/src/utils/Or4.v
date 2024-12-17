

module Or4 (R, A, B, C, D);

    input wire A, B, C, D;
    output wire R;

    wire saidaOr1;
    wire saidaOr2;

    or OR1 (saidaOr1, A, B);
    or OR2 (saidaOr2, C, D);
    or OR3 (R, saidaOr1, saidaOr2);




endmodule