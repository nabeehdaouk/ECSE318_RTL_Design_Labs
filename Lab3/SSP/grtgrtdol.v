module grtgrtdol_tb ();

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

        // Loading T FIFO data and transmitting
        pwdata = 8'h00;
        #10
        psel = 1'b1;

        #10     pwdata = 8'b00000000; //8'h00
        #10     pwdata = 8'b00111001; //8'h39
        #10     pwdata = 8'b10011101; //8'h9D
        #10     pwdata = 8'b01110100; //8'h74

        pwrite = 1'b0;
        #2000

        pwrite = 1'b1;
        #2500

        #10     pwdata = 8'b10001111; //8'h8F
        #10     pwdata = 8'b10110001; //8'bB1
        #10     pwdata = 8'b01010101; //8'b55

        psel = 1'b0;
        #400

        // Receiving data
        pwrite = 1'b0;
        #2000

        // Pulling in and displaying data from R FIFO
        #10 psel = 1'b1;
        #10 $display(prdata);

        #10 $display(prdata);

        #10 $display(prdata);

        #10 $display(prdata);

        #10 $display(prdata);
        $stop;
    end


    always #5 pclk = ~pclk;


endmodule