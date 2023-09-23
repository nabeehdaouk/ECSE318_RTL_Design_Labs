module divider(
    input [3:0] dividend,
    input [3:0] divisor_in,
    output [3:0] quotient,
    output [3:0] remainder
);

    wire [4:0] int_divisor;

    wire [5:0] b_in3;
    wire [5:0] b_in2;
    wire [5:0] b_in1;
    wire [5:0] b_in0;

    wire [4:0] d4;
    wire [4:0] d3;
    wire [4:0] d2;
    wire [4:0] d1;
    wire [4:0] d0;



    assign {b_in3[0], b_in2[0], b_in1[0], b_in0[0]}= 4'b0000;
    assign int_divisor = {1'b0, divisor_in[3:0]};
    assign {d4[0], d3[0], d2[0], d1[0]} = dividend[3:0];
    assign d4[4:1] = 4'b0000;


generate
    genvar i;

    for (i = 0; i < 5; i = i + 1) begin // level 3
        bit_sub bit_sub_instanceppp(
            .y(int_divisor[i]),
            .x(d4[i]),
            .b_i(b_in3[i]),
            .os(b_in3[5]),
            .b_o(b_in3[i+1]),
            .d(d3[i+1])
        );

    end
endgenerate
generate
    for (i = 0; i < 5; i = i + 1) begin // level 2
        bit_sub bit_sub_instance(
            .y(int_divisor[i]),
            .x(d3[i]),
            .b_i(b_in2[i]),
            .os(b_in2[5]),
            .b_o(b_in2[i+1]),
            .d(d2[i+1])
        );

    end
endgenerate
generate
    
    for (i = 0; i < 5; i = i + 1) begin // level 1
        bit_sub bit_sub_instance(
            .y(int_divisor[i]),
            .x(d2[i]),
            .b_i(b_in1[i]),
            .os(b_in1[5]),
            .b_o(b_in1[i+1]),
            .d(d1[i+1])
        );

    end
endgenerate
generate
    for (i = 0; i < 5; i = i + 1) begin // level 0
        bit_sub bit_sub_instance(
            .y(int_divisor[i]),
            .x(d1[i]),
            .b_i(b_in0[i]),
            .os(b_in0[5]),
            .b_o(b_in0[i+1]),
            .d(d0[i+1])
        );

    end
endgenerate
    assign quotient[3:0] = ~{b_in3[5], b_in2[5], b_in1[5], b_in0[5]};
    assign remainder[3:0] = d0[4:1];

endmodule

module bit_sub (
    input y, x, b_i, os,
    output b_o, d
);

    wire diff;
    full_sub full_sub_instance(
        .a(x),
        .b(y),
        .b_in(b_i),
        .diff(diff),
        .b_out(b_o)
    );

    assign d = os & x | ~(os) & diff;

endmodule

module full_sub (

    input a, b, b_in,
    output diff, b_out
);

    assign diff = a ^ b ^ b_in;
    assign b_out = ((~a) & b) | (((~a) + b) & b_in);

endmodule 


