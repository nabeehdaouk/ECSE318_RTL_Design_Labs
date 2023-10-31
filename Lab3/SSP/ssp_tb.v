module ssp_tb ();

    reg psel, pwrite, clr_b, pclk;
    reg [7:0] pwdata;
    wire [7:0] prdata;
    wire ssptxintr, ssprxintr, sspoe_b;



    ssp ssp_instance(
        .psel(psel),
        .pwrite(pwrite),
        .clr_b(clr_b),
        .pclk(pclk),
        .pwdata(pwdata),
        .ssptxintr(ssptxintr),
        .ssprxintr(ssprxintr),
        .sspoe_b(sspoe_b),
        .prdata(prdata)
    );

    initial begin
    pclk = 1'b0;
    clr_b = 1'b1;
    psel = 1'b0;
    #20

    clr_b = 1'b0;
    #10

    #10 pwrite = 1'b1;
    pwdata = 8'h00;
    #10
    psel = 1'b1;
    #10

    psel = 1'b0;
    #10
    pwdata = 8'hd3;
    #10
    psel = 1'b1;
    #10
    
    psel = 1'b0;
    #10
    pwdata = 8'ha7;
    #10
    psel = 1'b1;
    #10

    psel = 1'b0;
    #10
    pwdata = 8'hff;
    #10
    psel = 1'b1;
    #10

    psel = 1'b0;
    #400

    pwrite = 1'b0;
    #1500

    #10 psel = 1'b1;
    #5 $display(prdata);
    
    #10 psel = 1'b0;
    #10 psel = 1'b1;
    #5 $display(prdata);

    #10 psel = 1'b0;
    #10 psel = 1'b1;
    #5 $display(prdata);
    
    #10 psel = 1'b0;
    #10 psel = 1'b1;
    #5 $display(prdata);
end


always #5 pclk = ~pclk; 


endmodule