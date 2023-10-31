module ssp (
    input psel, pwrite, clr_b, pclk,
    input [7:0] pwdata,
    output ssptxintr, ssprxintr, sspoe_b,
    output [7:0] prdata

);


    wire [7:0] txdata, rxdata;
    wire t_flag_empty, t_flag_full, r_flag_empty, r_flag_full, inc_ptr, read_en;

    assign ssptxintr = t_flag_empty;
    assign ssprxintr = r_flag_full;

    TransRecLogic TransRecLogic_instance(
        .TxData(txdata),
        .pclk(pclk),
        .clr_b(clr_b),
        .t_empty(t_flag_empty),
        .r_full(r_flag_full),
        .RxData(rxdata),
        .read_en(read_en),
        .inc_ptr(inc_ptr),
        .ssp_oe_b(sspoe_b)
    );

    TxFIFO TxFIFO_instance(
        .psel(psel),
        .pwrite(pwrite),
        .clr_b(clr_b),
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
        .clr_b(clr_b),
        .pclk(pclk),
        .read_en(read_en),
        .rxdata(rxdata),
        .prdata(prdata),
        .flag_empty(r_flag_empty),
        .flag_full(r_flag_full)
    );

endmodule