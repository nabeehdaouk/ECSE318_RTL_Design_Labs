module NBitCSAv #(
  parameter N = 16 // Default value for N is 4
)(
  input [15:0] A,
  input [15:0] B,
  input Cin,
  output [15:0] Sum,
  output Cout
);

  wire [(N/4):0] carry_select; // N carry-out bits from the N n-bit adders
  wire [N:0] sum_0;
  wire [N:0] sum_1;
  wire [(N/4):1] carry_0;
  wire [(N/4):1] carry_1;

  // Instantiate a 4-bit adder for the first 4 bits
  n_bit_adder #(4) adder_4bits (
    .A(A[3:0]),
    .B(B[3:0]),
    .Cin(Cin),
    .Sum(Sum[3:0]),
    .Cout(carry_select[0])
  );

  // Instantiate (N-4) n-bit adders for the remaining bits using a for loop
  genvar i;
  generate
    for (i = 1; i < (N/4); i = i + 1) begin : CSA_inst
      n_bit_adder #(4) adder_inst0 (
        .A(A[(4*i+3): (4*i)]),
        .B(B[(4*i+3): (4*i)]),
        .Cin(1'b0),
        .Sum(sum_0[(4*i+3): (4*i)]),
        .Cout(carry_0[i])
      );
       n_bit_adder #(4) adder_inst1 (
        .A(A[(4*i+3): (4*i)]),
        .B(B[(4*i+3): (4*i)]),
        .Cin(1'b1),
        .Sum(sum_1[(4*i+3): (4*i)]),
        .Cout(carry_1[i])
      );
    end
  endgenerate




for (i = 1; i < (N/4); i = i + 1) begin
  assign Sum[(4*i+3): (4*i)] = carry_select[i-1] ? sum_1[(4*i+3): (4*i)] : sum_0[(4*i+3): (4*i)];
  assign carry_select[i]= carry_select[i-1]? carry_1[i]:carry_0[i];
end
  assign Cout = carry_select[N/4-1];

endmodule
