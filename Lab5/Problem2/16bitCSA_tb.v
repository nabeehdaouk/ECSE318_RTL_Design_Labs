module SixteenBitCSA_tb;

  reg [15:0] A, B;
  reg Cin;
  wire [15:0] Sum;
  wire Cout;

  NBitCSA #(16) uut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Cout(Cout)
  );

  initial begin
    // Test case 1
    A = 16'hABCD;
    B = 16'h1234;
    Cin = 0;
    #10; // Allow some time for computation
    $display("Test Case 1: A=%h, B=%h, Cin=%b, Sum=%h, Cout=%b", A, B, Cin, Sum, Cout);
    $display("Test Case 1: A=%d, B=%d, Cin=%d, Sum=%d, Cout=%d", A, B, Cin, Sum, Cout);
    $display;

    // Test case 2
    A = 16'hFFFF;
    B = 16'h0001;
    Cin = 1;
    #10; // Allow some time for computation
    $display("Test Case 2: A=%h, B=%h, Cin=%b, Sum=%h, Cout=%b", A, B, Cin, Sum, Cout);
    $display("Test Case 2: A=%d, B=%d, Cin=%d, Sum=%d, Cout=%d", A, B, Cin, Sum, Cout);
    

    // Add more test cases as needed

    $stop; // End simulation
  end

endmodule
