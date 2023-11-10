module bit_ser_add_tb ();
    reg A, B, clk, clr_n,set_n;
    wire [8:0] result;
    wire serial_result;

    bit_ser_add bit_ser_add_instance(
        .clk(clk),
        .A(A),
        .B(B),
        .clr_n(clr_n),
        .set_n(set_n),
        .result(result),
        .serial_result(serial_result)
    );
    

    initial begin
        //PROBLEM 1: A=7 and B=3
        //A=00000111, B=00000011
        clk = 1'b0;
        clr_n = 1'b0;
        set_n = 1'b1;
        #15
        clr_n = 1'b1;

        A = 1'b1;
        B = 1'b1;
        #10

        A = 1'b1;
        B = 1'b1;
        #10

        A = 1'b1;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10
        set_n = 1'b0;
        #90
        $display("------------------------------------------------");
        $display("Testing 7+3:");
        $display();
        $display("Binary Result: %b", result);
        $display("Decimal Result: %d", result);
        $display("------------------------------------------------");


        //PROBLEM 2: A=6 and B=4, 
        //A=00000110, B=00000100

        clr_n = 1'b0;
        set_n = 1'b1;
        #15
        clr_n = 1'b1;

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b1;
        B = 1'b0;
        #10

        A = 1'b1;
        B = 1'b1;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10
        set_n = 1'b0;
        #90
        $display("------------------------------------------------");
        $display("Testing 6+4:");
        $display();
        $display("Binary Result: %b", result);
        $display("Decimal Result: %d", result);
        $display("------------------------------------------------");


        //PROBLEM 3:  A=94 and B=27
        // Setting A to 94 (binary: 01011110) LSB first
        // Setting B to 27 (binary: 00011011) LSB first

        clr_n = 1'b0;
        set_n = 1'b1;
        #15
        clr_n = 1'b1;

        A = 1'b0;
        B = 1'b1;
        #10

        A = 1'b1;
        B = 1'b1;
        #10

        A = 1'b1;
        B = 1'b0;
        #10

        A = 1'b1;
        B = 1'b1;
        #10

        A = 1'b1;
        B = 1'b1;
        #10

        A = 1'b0;
        B = 1'b0;
        #10

        A = 1'b1;
        B = 1'b0;
        #10

        A = 1'b0;
        B = 1'b0;
        #10
        set_n = 1'b0;
        #90
        $display("------------------------------------------------");
        $display("Testing 94+27:");
        $display();
        $display("Binary Result: %b", result);
        $display("Decimal Result: %d", result);
        $display("------------------------------------------------");
        
        $stop;
    end

    always
    #5 clk = ~clk;

endmodule