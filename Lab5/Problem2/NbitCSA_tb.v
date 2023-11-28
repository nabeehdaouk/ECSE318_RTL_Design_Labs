module NBitCSA_tb;

  reg [19:0] A, B;
  reg Cin;
  wire [19:0] Sum;
  wire Cout;

  NBitCSA #(20) uut ( //TESTING WITH 20 BITS
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Cout(Cout)
  );

  initial begin
    // Test case 1
    A = 20'h8ABCD;
    B = 20'h41234;
    Cin = 0;
    #10; 
    $display("Test Case 1: A=%h, B=%h, Cin=%b, Sum=%h, Cout=%b", A, B, Cin, Sum, Cout);
    $display("Test Case 1: A=%d, B=%d, Cin=%d, Sum=%d, Cout=%d", A, B, Cin, Sum, Cout);
    $display;

    // Test case 2
    A = 20'hFFFFF;
    B = 20'h00001;
    Cin = 1;
    #10; 
    $display("Test Case 2: A=%h, B=%h, Cin=%b, Sum=%h, Cout=%b", A, B, Cin, Sum, Cout);
    $display("Test Case 2: A=%d, B=%d, Cin=%d, Sum=%d, Cout=%d", A, B, Cin, Sum, Cout);
    

 

    $stop; // End simulation
  end

endmodule
