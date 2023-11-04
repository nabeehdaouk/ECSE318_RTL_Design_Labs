`timescale 1ps/1fs // Set timescale to 1 picosecond with 0 fs precision
module cla_tb;
    
    reg [3:0] a;
    reg [3:0] b;
    reg c_in;
    wire [3:0] s;
    wire c_out;
    
   cla cla_instance(
       .a(a),
       .b(b),
       .c_in(c_in),
       .s(s),
       .c_out(c_out)
   );
   
   initial begin
   $display("LONGEST PROPIGATION DELAY:");
        a =4'b1111;
        b =4'b0001;
        c_in= 1'b1;
        #500    $display("A: %b +  B:%b   (c_in=%b) =  Sum:%b   (c_out=%b) ", a, b, c_in, s, c_out);
                $display("A: %d +  B:%d   (c_in=%d) =  Sum:%d   (c_out=%d) ", a, b, c_in, s, c_out);
        $display;
        
        $display("Testing Addition Functionality:");
        a =4'b0101;
        b =4'b0111;
        c_in= 1'b0;
        #100    $display("A: %b +  B:%b   (c_in=%b) =  Sum:%b   (c_out=%b) ", a, b, c_in, s, c_out);
                $display("A: %d +  B:%d   (c_in=%d) =  Sum:%d   (c_out=%d) ", a, b, c_in, s, c_out);
        
         $display;
         
          $display("Testing Addition Functionality:");
         a ='d4;
        b ='d3;
        c_in= 1'b1;
        #100    $display("A: %b +  B:%b   (c_in=%b) =  Sum:%b   (c_out=%b) ", a, b, c_in, s, c_out);
        $display("A: %d +  B:%d   (c_in=%d) =  Sum:%d   (c_out=%d) ", a, b, c_in, s, c_out);
        
        $display;
         
             $display("Testing Addition Functionality:");
         a ='d9;
        b ='d5;
        c_in= 1'b1;
        #100    $display("A: %b +  B:%b   (c_in=%b) =  Sum:%b   (c_out=%b) ", a, b, c_in, s, c_out);
        $display("A: %d +  B:%d   (c_in=%d) =  Sum:%d   (c_out=%d) ", a, b, c_in, s, c_out);
         
    end
    
    endmodule