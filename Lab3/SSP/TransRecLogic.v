module TransRecLogic(
    input [7:0] TxData,
    input pclk, clr_b, t_empty, r_full,
    output [7:0] RxData,
    output read_en, inc_ptr, ssp_oe_b
);
wire ssp_fss_out_in;
wire ssp_txd;
wire ssp_clk_out; 

//transmit data fed back into recieve data at this level
TransmitLogic TransmitLogic_instance(
    .TxData(TxData),
    .pclk(pclk),
    .clr_b(clr_b),
    .flag_empty(t_empty),
    .ssp_fss_out(ssp_fss_out_in),
    .ssp_oe_b(ssp_oe_b),
    .ssp_txd(ssp_txd),
    .ssp_clk_out(ssp_clk_out),
    .inc_ptr(inc_ptr)
);

ReceiveLogic ReceiveLogic_instance(
    .RxData(RxData),
    .read_en(read_en),
    .clr_b(clr_b),
    .flag_full(r_full),
    .ssp_fss_in(ssp_fss_out_in),
    .ssp_rxd(ssp_txd),
    .ssp_clk_in(ssp_clk_out)
);


endmodule