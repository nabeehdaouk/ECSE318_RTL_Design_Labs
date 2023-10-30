module TransmitLogic_tb();
	
	reg [7:0] TxData;
	reg pclk, clr_b, flag_empty, flag_full;
	wire ssp_fss_out, ssp_oe_b, ssp_txd, ssp_clk_out, inc_ptr;
	
	
	
	TransmitLogic TransmitLogic_instance(
	    .TxData(TxData),
	    .pclk(pclk),
	    .clr_b(clr_b),
	    .flag_empty(flag_empty),
	    .flag_full(flag_full),
	    .ssp_fss_out(ssp_fss_out),
	    .ssp_oe_b(ssp_oe_b),
	    .ssp_txd(ssp_txd),
	    .ssp_clk_out(ssp_clk_out),
	    .inc_ptr(inc_ptr)
	);
	
	initial begin
	pclk = 0;
	clr_b= 1; 
	#20
	clr_b=0;
	
	TxData= 8'b11001010;
	flag_empty= 0;
	flag_full= 0;
	
#60
    TxData= 8'b10101011;
    flag_empty= 0;
    #600
	
    
    
$stop;
	
end

always #5 pclk<= ~pclk;

always #20 $display( ssp_txd, "          ",ssp_fss_out );
	
	
endmodule
