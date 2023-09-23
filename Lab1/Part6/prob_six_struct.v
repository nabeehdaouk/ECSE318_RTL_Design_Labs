module prob_six_struct(
    output out,
    input clk,
    input E,
    input W
);
    wire [5:0] b;
    wire q1;
    wire q2;
    
 and g1(b[0],q1, ~q2);
 and g2(b[1], q1, W);
 OR3 g3(b[2], E, b[0], b[1]);

 and g4(b[3],q2, ~q1);
 and g5(b[4], q2, E);
 OR3 g6(b[5], W, b[3], b[4]);
 
 d_flip_flop d_flip_flop_instance1(
     .Q(q1),
     .clk(clk),
     .D(b[2])
 );
  d_flip_flop d_flip_flop_instance2(
     .Q(q2),
     .clk(clk),
     .D(b[5])
 );
 and g7(out, ~q1, ~q2);



endmodule : prob_six_struct


// Define a D flip-flop module
module d_flip_flop(
    output reg Q= 1'b0,
    input clk,
    input D
);
    always @(posedge clk)
        Q <= D;
endmodule

module OR3(
    output out,
    inout a,
    input b,
    input c
);

assign out = a | b | c;
endmodule