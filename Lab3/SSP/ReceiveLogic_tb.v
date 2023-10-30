module ReceiveLogic_tb();
	
	wire [7:0] RxData;
	wire read_en;
	reg pclk, clr_b, flag_empty, flag_full, ssp_fss_in, ssp_rxd, ssp_clk_in;
	
	
	
ReceiveLogic ReceiveLogic_instance(
    .RxData(RxData),
    .read_en(read_en),
    .clr_b(clr_b),
    .flag_full(flag_full),
    .ssp_fss_in(ssp_fss_in),
    .ssp_rxd(ssp_rxd),
    .ssp_clk_in(ssp_clk_in)
);
	
	initial begin
	flag_full= 1'b0;
	ssp_clk_in = 1'b1;
	clr_b= 1; 
	#21 
	clr_b=0;
	
	ssp_fss_in = 1'b1;
	#20
    ssp_fss_in = 1'b0;
	ssp_rxd= 1'b1;	
    #20
    ssp_rxd= 1'b0;
    #20
    ssp_rxd= 1'b1;  
    #20
    ssp_rxd= 1'b0;  
    #20
    ssp_rxd= 1'b1;  
    #20
    ssp_rxd= 1'b0;
    #20
    ssp_rxd= 1'b1;  
    #20
    ssp_rxd= 1'b0;
    #200

    ssp_fss_in = 1'b1;
    #20
    ssp_fss_in = 1'b0;
    ssp_rxd= 1'b0;  
    #20
    ssp_rxd= 1'b1;
    #20
    ssp_rxd= 1'b0;  
    #20
    ssp_rxd= 1'b1;  
    #20
    ssp_rxd= 1'b0;  
    #20
    ssp_rxd= 1'b1;
    #20
    ssp_rxd= 1'b0;  
    #20
    ssp_rxd= 1'b1;
    #300

$stop;
	
end

always #10 ssp_clk_in <= ~ssp_clk_in;

always #20 $display(RxData);
	
	
endmodule
