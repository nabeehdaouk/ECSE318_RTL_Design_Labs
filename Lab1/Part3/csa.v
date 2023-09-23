`timescale 1ps/1fs // Set timescale to 1 nanosecond with 1 picosecond precision
module csa(
    input [7:0] a, b, c, d, e, f, g, h, i, j,
    output [17:0] s
);

    wire [7:0] s8;
    wire [8:0] s9, c8;
    wire [9:0] s10, c9;
    wire [10:0] s11, c10;
    wire [11:0] s12, c11;
    wire [12:0] s13, c12;
    wire [13:0] s14, c13;
    wire [14:0] s15, c14;
    wire [15:0]      c15;


    NBitCSA #(
    .N(8)
    ) BitCSA_instance8(
        .A(a),
        .B(b),
        .C(c),
        .S(s8),
        .Carry(c8)
    );

    NBitCSA #(
    .N(9)
    ) BitCSA_instance9(
        .A({1'b0,s8}),
        .B(c8),
        .C({1'b0,d}),
        .S(s9),
        .Carry(c9)
    );

    NBitCSA #(
    .N(10)
    ) BitCSA_instance10(
        .A({1'b0,s9}),
        .B(c9),
        .C({2'b00,e}),
        .S(s10),
        .Carry(c10)
    );


    NBitCSA #(
    .N(11)
    ) BitCSA_instance11(
        .A({1'b0,s10}),
        .B(c10),
        .C({3'b000,f}),
        .S(s11),
        .Carry(c11)
    );

    NBitCSA #(
    .N(12)
    ) BitCSA_instance12(
        .A({1'b0,s11}),
        .B(c11),
        .C({4'b0000,g}),
        .S(s12),
        .Carry(c12)
    );

    NBitCSA #(
    .N(13)
    ) BitCSA_instance13(
        .A({1'b0,s12}),
        .B(c12),
        .C({5'b00000,h}),
        .S(s13),
        .Carry(c13)
    );

    NBitCSA #(
    .N(14)
    ) BitCSA_instance14(
        .A({1'b0,s13}),
        .B(c13),
        .C({6'b000000,i}),
        .S(s14),
        .Carry(c14)
    );


    NBitCSA #(
    .N(15)
    ) BitCSA_instance15(
        .A({1'b0,s14}),
        .B(c14),
        .C({7'b000000,j}),
        .S(s15),
        .Carry(c15)
    );
    
    assign s= s15 + c15;


endmodule : csa

module NBitCSA #(
    parameter N = 8 //default case
)(
    input [N-1:0] A, B, C,
    output [N-1:0] S,
    output [N:0] Carry
);

wire [N:0] Carry_bs;  // preshift

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : CSA_instance
            assign S[i] = A[i] ^ B[i] ^ C[i];
            assign Carry_bs[i] = A[i] & B[i] | A[i] & C[i] | B[i] & C[i];
        end
    endgenerate

  assign Carry[N:0] = {Carry_bs[N-1:0], 1'b0};

endmodule
