module TransRecLogic_tb ();

    reg [7:0] TxData;
    reg pclk, clr_b, t_empty, r_full;
    wire [7:0] RxData;
    wire read_en, inc_ptr, ssp_oe_b;

    TransRecLogic TransRecLogic_instance(
        .TxData(TxData),
        .pclk(pclk),
        .clr_b(clr_b),
        .t_empty(t_empty),
        .r_full(r_full),
        .RxData(RxData),
        .read_en(read_en),
        .inc_ptr(inc_ptr),
        .ssp_oe_b(ssp_oe_b)
    );



    initial begin
        pclk = 1'b0;
        clr_b = 1'b1;
        #20
        clr_b = 1'b0;
        t_empty = 1'b0;
        r_full = 1'b0;

        #20
        TxData = 8'ha8;
        #250

        TxData = 8'hfa;
        #750
        t_empty = 1'b1;
        #500;
    end

    always @ (posedge read_en)
    begin
    $display("%h",RxData);
    end

    always #5 pclk = ~pclk;

endmodule

