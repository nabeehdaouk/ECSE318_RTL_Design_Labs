module ssp (
    input psel, pwrite, clr_b, pclk, ssp_fss_in, ssp_rxd, ssp_clk_in,
    input [7:0] pwdata,
    
    output ssptxintr, ssprxintr, ssp_oe_b, ssp_fss_out, ssp_txd, ssp_clk_out,
    output [7:0] prdata

);


    wire [7:0] txdata, rxdata;
    wire t_flag_empty, t_flag_full, r_flag_empty, r_flag_full, inc_ptr, read_en;

    assign ssptxintr = t_flag_empty;
    assign ssprxintr = r_flag_full;

    TransmitLogic TransmitLogic_instance(
        .TxData(txdata),
        .pclk(pclk),
        .clr_b(~clr_b), //make active low
        .flag_empty(t_flag_empty),
        .ssp_fss_out(ssp_fss_out),
        .ssp_oe_b(ssp_oe_b),
        .ssp_txd(ssp_txd),
        .ssp_clk_out(ssp_clk_out),
        .inc_ptr(inc_ptr)
    );
    
    ReceiveLogic ReceiveLogic_instance(
        .RxData(rxdata),
        .read_en(read_en),
        .clr_b(~clr_b),
        .flag_full(r_flag_full),
        .ssp_fss_in(ssp_fss_in),
        .ssp_rxd(ssp_rxd),
        .ssp_clk_in(ssp_clk_in)
    );

    TxFIFO TxFIFO_instance(
        .psel(psel),
        .pwrite(pwrite),
        .clr_b(~clr_b),
        .pclk(pclk),
        .inc_ptr(inc_ptr),
        .pwdata(pwdata),
        .txdata(txdata),
        .flag_empty(t_flag_empty),
        .flag_full(t_flag_full)
    );

    RxFIFO RxFIFO_instance(
        .psel(psel),
        .pwrite(pwrite),
        .clr_b(~clr_b),
        .pclk(pclk),
        .read_en(read_en),
        .rxdata(rxdata),
        .prdata(prdata),
        .flag_empty(r_flag_empty),
        .flag_full(r_flag_full)
    );

endmodule