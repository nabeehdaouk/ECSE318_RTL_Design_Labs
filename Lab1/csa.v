`timescale 1ps/1fs // Set timescale to 1 nanosecond with 1 picosecond precision
module csa(
    input [7:0] a, b, c, d, e, f, g, h, i, j,
    output [16:0] s
);
  
    wire [8:0] s1_out;
    wire [9:0] s2_out;
    wire [10:0] s3_out;
    wire [11:0] s4_out;
    wire [12:0] s5_out;
    wire [13:0] s6_out;
    wire [14:0] s7_out;
    wire [15:0] s8_out;
    wire [16:0] s9_out;

    assign s1_out = a + b;
    assign s2_out = s1_out + c;
    assign s3_out = s2_out + d;
    assign s4_out = s3_out + e;
    assign s5_out = s4_out + f;
    assign s6_out = s5_out + g;
    assign s7_out = s6_out + h;
    assign s8_out = s7_out + i;
    assign s9_out = s8_out + j;
    assign s = s9_out;



endmodule : csa
