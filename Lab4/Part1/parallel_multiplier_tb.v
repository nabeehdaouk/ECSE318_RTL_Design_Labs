module parallel_multiplier_tb;
    reg [3:0] x;
    reg [3:0] y;
    wire [7:0] p;

parallel_multiplier parallel_multiplier_instance(
    .x(x),
    .y(y),
    .p(p)
);


    initial begin
        
        $display("Testing Multiplication Functionality for 2*6 Below:");
        x = 4'b0010;
        y = 4'b0110;
        #100    $display("Multiplicand: %b *  Multiplier:%b   =  Product:%b", x, y, p);
                $display("Multiplicand: %d *  Multiplier:%d   =  Product:%d", x, y, p);
        
         $display;
         $display("Testing Multiplication Functionality for 12*3 Below:");
        x = 4'b1100;
        y = 4'b0011;
        #100    $display("Multiplicand: %b *  Multiplier:%b   =  Product:%b", x, y, p);
        $display("Multiplicand: %d *  Multiplier:%d   =  Product:%d", x, y, p);
        
         $display;
         $display("ACTIVATING DASHED PATH, Question 1c:");
         $display("Testing Multiplication Functionality for 12*3 Below:");
        x = 4'b1101;
        y = 4'b1101;
        #100    $display("Multiplicand: %b *  Multiplier:%b   =  Product:%b", x, y, p);
                $display("Multiplicand: %d *  Multiplier:%d   =  Product:%d", x, y, p);
        $stop;
    end
    
endmodule