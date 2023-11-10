module divider_tb;
    reg [3:0] dividend;
    reg [3:0] divisor;
    wire [3:0] quotient;
    wire [3:0] remainder;

divider divider_instance(
    .dividend(dividend),
    .divisor_in(divisor),
    .quotient(quotient),
    .remainder(remainder)
);

    initial begin
        
        $display("Testing Division Functionality for 6/2 Below:");
        dividend = 4'b0110;
        divisor = 4'b0010;
        #100    $display("Dividend: %b /  Divisor: %b   =  Quotient:%b and Remainder: %b", dividend, divisor, quotient, remainder);
                $display("Dividend: %d /  Divisor: %d   =  Quotient:%d and Remainder: %d", dividend, divisor, quotient, remainder);
        
        $display;
        $display("Testing Division Functionality for 7/2 Below:");
        
        
        dividend = 4'b0111;
        divisor = 4'b0010;
        #100    $display("Dividend: %b /  Divisor: %b   =  Quotient: %b and Remainder: %d", dividend, divisor, quotient, remainder);
                $display("Dividend: %d /  Divisor: %d   =  Quotient: %d and Remainder: %d", dividend, divisor, quotient, remainder);
        
        $stop;
    end
    
endmodule