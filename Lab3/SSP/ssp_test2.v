module ssp_test2;
    reg clock, clear_b, pwrite, psel;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire sspoe_b, tx_to_rx, clk_wire, fss_wire, ssptxintr, ssprxintr;

    initial 
    begin
        //$monitor($time," clock = %b, data_in = %b, data_out = %b", clock, data_in, data_out);
        clock = 1'b0;
        clear_b = 1'b0;
        psel = 1'b1;
        @(posedge clock);
        #1;
        @(posedge clock);
                data_in = 8'b11111111; //8'hFF, dummy data. should not enter into SSP.
        #1;
                clear_b = 1'b1;
        #15     pwrite = 1'b1;
                data_in = 8'b10010100; //8'h94
        #40     data_in = 8'b00001111; //8'h0F
        #40     data_in = 8'b01010001; //8'h51
        #40     data_in = 8'b00100100; //8'h24
        // Remaining data attempts to enter a full T FIFO, so T interrupt prevents remaining data from entering SSP
        #40     data_in = 8'b01100111; //8'h67
        #40     data_in = 8'b11110011; //8'hF3
        #40     data_in = 8'b10110110; //8'hB6
        #40     data_in = 8'b10000100; //8'b84
        #30     psel = 1'b0;
        #870    psel = 1'b1;
                pwrite = 1'b0;
        #80     pwrite = 1'b1;
        #40     psel = 1'b0;
        #3600   pwrite = 1'b0;
        psel = 1'b1;
        #20 $display("data_out: %b", data_out);
        #40 $display("data_out: %b", data_out);
        #40 $display("data_out: %b", data_out);
        #40 $display("data_out: %b", data_out);
        $stop;
    end
    
    always 
        #20 clock = ~clock;

// serial output from SSP is looped back to the serial input.

    ssp ssp2 (.pclk(clock), .clr_b(clear_b), .psel(psel), .pwrite(pwrite), .ssp_clk_in(clk_wire), .ssp_fss_in(fss_wire), .ssp_rxd(tx_to_rx), .pwdata(data_in), .prdata(data_out), .ssp_clk_out(clk_wire), .ssp_fss_out(fss_wire), .ssp_txd(tx_to_rx), .ssp_oe_b(sspoe_b), .ssptxintr(ssptxintr), .ssprxintr(ssprxintr));

endmodule