module adder_tb ();
    reg a, b, cin;
    wire cout, sum;
    full_adder full_adder_instance(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    initial begin
    a=1'b1;
    b=1'b0;
    cin=1'b0;
    #10
    $display(sum, cout);
    end
    
    
    
endmodule    