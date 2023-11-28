module SixteenBitCSAv (
  input [15:0] A,
  input [15:0] B,
  input Cin,
  output [15:0] Sum,
  output Cout
);

  wire [3:0] carry_select; // 4 carry-out bits from the 4 n-bit adders
  wire [15:0] sum_0;
  wire [15:0] sum_1;
  wire [3:1] carry_0;
   wire [3:1] carry_1;

  // Create four instances of the n_bit_adder module with Cin
  n_bit_adder #(4) adder0 (
    .A(A[3:0]),
    .B(B[3:0]),
    .Cin(Cin),
    .Sum(Sum[3:0]),
    .Cout(carry_select[0])
  );



  n_bit_adder #(4) adder1_c0 (
    .A(A[7:4]),
    .B(B[7:4]),
    .Cin(1'b0), 
    .Sum(sum_0[7:4]),
    .Cout(carry_0[1])
  );
    n_bit_adder #(4) adder1_c1 (
    .A(A[7:4]),
    .B(B[7:4]),
    .Cin(1'b1), 
    .Sum(sum_1[7:4]),
    .Cout(carry_1[1])
  );



  n_bit_adder #(4) adder2_c0 (
    .A(A[11:8]),
    .B(B[11:8]),
    .Cin(1'b0), 
    .Sum(sum_0[11:8]),
    .Cout(carry_0[2])
  );
   n_bit_adder #(4) adder2_c1 (
    .A(A[11:8]),
    .B(B[11:8]),
    .Cin(1'b1), 
    .Sum(sum_1[11:8]),
    .Cout(carry_1[2])
  );

  n_bit_adder #(4) adder3_c0 (
    .A(A[15:12]),
    .B(B[15:12]),
    .Cin(1'b0),
    .Sum(sum_0[15:12]),
    .Cout(carry_0[3])
  );
    n_bit_adder #(4) adder3_c1 (
    .A(A[15:12]),
    .B(B[15:12]),
    .Cin(1'b1),
    .Sum(sum_1[15:12]),
    .Cout(carry_1[3])
  );

  // Generate the final 16-bit sum using multiplexers
  assign Sum[7:4]= (carry_select[0])? sum_1[7:4]:sum_0[7:4];
  assign Sum[11:8]= (carry_select[1])? sum_1[11:8]:sum_0[11:8];
  assign Sum[15:12]= (carry_select[2])? sum_1[15:12]:sum_0[15:12];
  
  assign carry_select[1]= carry_select[0]? carry_1[1]:carry_0[1];
  assign carry_select[2]= carry_select[1]? carry_1[2]:carry_0[2];
  assign carry_select[3]= carry_select[2]? carry_1[3]:carry_0[3];
  assign Cout= carry_select[3];

endmodule
