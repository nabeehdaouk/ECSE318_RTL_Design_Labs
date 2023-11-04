`timescale 1ps/1fs // Set timescale to 1 nanosecond with 1 picosecond precision
module signed_multiplier(
    input[4:0] mcand_in,
    input [4:0] mplier_in,
    output [9:0] p
);
    wire [8:0] pp1 ;
    wire [8:0] pp2 ;
    wire [8:0] pp3 ;
    wire [8:0] pp4 ;
    wire [8:0] pp5 ;
    wire [4:0] mcand;
    wire [4:0] mplier;

    assign mcand = mplier_in[4] ? (~mcand_in[4:0] + 5'b00001) : mcand_in[4:0];
    assign mplier = mplier_in[4] ? (~mplier_in[4:0] + 5'b00001) : mplier_in[4:0];


    assign pp1 = mplier[0] ? {mcand[4], mcand[4], mcand[4], mcand[4], mcand[4:0]} : 9'b000000000;
    assign pp2 = mplier[1] ? {mcand[4], mcand[4], mcand[4], mcand[4:0], 1'b0} : 9'b000000000;
    assign pp3 = mplier[2] ? {mcand[4], mcand[4], mcand[4:0], 1'b0, 1'b0} : 9'b000000000;
    assign pp4 = mplier[3] ? {mcand[4], mcand[4:0], 1'b0, 1'b0, 1'b0} : 9'b000000000;
    assign pp5 = mplier[4] ? {mcand[4:0], 1'b0, 1'b0, 1'b0, 1'b0} : 9'b000000000;


    assign p[8:0] = pp1 + pp2 + pp3 + pp4 + pp5;
    assign p[9] = mcand[4] ^ mplier[4];


endmodule