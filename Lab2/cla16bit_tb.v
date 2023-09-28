`timescale 1ps/1fs // Set timescale to 1 picosecond with 0 fs precision
module cla16bit_tb;

    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] s;
    wire c_out;
    reg c_in;

    cla16bit cla_instance(
        .A(a),
        .B(b),
        .SUM(s),
        .C_OUT(c_out)
    );
    initial begin
        $display("LONGEST PROPIGATION DELAY:");
        a = 16'h0001;
        b = 16'h0001;
        c_in= 1'b0;
        #500    $display("A: %b +  B:%b   (c_in=%b) =  Sum:%b   (c_out=%b) ", a, b, c_in, s, c_out);
        $display("A: %d +  B:%d   (c_in=%d) =  Sum:%d   (c_out=%d) ", $signed(a), $signed(b), c_in, $signed(s), c_out);
        $display;

        $display("Testing Addition Functionality:");
        a =16'hffff;
        b =16'h0001;
        c_in= 1'b0;
        #100    $display("A: %b +  B:%b   (c_in=%b) =  Sum:%b   (c_out=%b) ", a, b, c_in, s, c_out);
        $display("A: %d +  B:%d   (c_in=%d) =  Sum:%d   (c_out=%d) ", $signed(a), $signed(b), c_in, $signed(s), c_out);

        $display;

        $display("Testing Addition Functionality:");
        a =16'hdf32;
        b =16'h93b6;
        c_in= 1'b0;
        #100    $display("A: %b +  B:%b   (c_in=%b) =  Sum:%b   (c_out=%b) ", a, b, c_in, s, c_out);
        $display("A: %d +  B:%d   (c_in=%d) =  Sum:%d   (c_out=%d) ", $signed(a), $signed(b), c_in, $signed(s), c_out);

        $display;

        
    end

endmodule