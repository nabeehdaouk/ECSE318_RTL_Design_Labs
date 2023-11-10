module bit_ser_add_tb ();
    reg A, B, clk, clr_n,set_n;
    wire [8:0] result;

    bit_ser_add bit_ser_add_instance(
        .clk(clk),
        .A(A),
        .B(B),
        .clr_n(clr_n),
        .set_n(set_n),
        .result(result)
    );

    initial begin
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

        $display("%d", result);
        $stop;
    end

    always
    #5 clk = ~clk;

endmodule