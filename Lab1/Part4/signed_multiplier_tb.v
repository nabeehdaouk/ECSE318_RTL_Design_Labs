`timescale 1ps/1fs // Set timescale to 1 nanosecond with 1 picosecond precision

module signed_multiplier_tb(

);
    reg [4:0] mcand, mplier; 
    wire [9:0] p;

    signed_multiplier signed_multiplier_instance(
        .mcand_in(mcand),
        .mplier_in(mplier),
        .p(p)
    );

    initial begin
        $display("Test multiplication problem 1:");
        mcand = -5'b01010;
        mplier = 5'b00100;
        #100    $display("Multiplicand: %b *  Multiplier:%b = Product:%b", $signed(mcand), $signed(mplier), $signed(p));
        $display("Multiplicand: %d *  Multiplier:%d = Product: %d", $signed(mcand), $signed(mplier), $signed(p));
        $display;
        
        $display("Test multiplication problem 2:");
        mcand = 5'b01011;
        mplier = -5'b00011;
        #100    $display("Multiplicand: %b *  Multiplier:%b = Product:%b", $signed(mcand), $signed(mplier), $signed(p));
        $display("Multiplicand: %d *  Multiplier: %d = Product: %d", $signed(mcand), $signed(mplier), $signed(p));       
        $display;
        
        $display("Test multiplication problem 3:");
        mcand = -5'b01010;
        mplier = -5'b01011;
        #100    $display("Multiplicand: %b *  Multiplier:%b = Product:%b", $signed(mcand), $signed(mplier), $signed(p));
        $display("Multiplicand: %d *  Multiplier: %d = Product: %d", $signed(mcand), $signed(mplier), $signed(p));       
        $display;
        
        
       
    end

endmodule