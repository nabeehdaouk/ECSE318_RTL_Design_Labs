module ReceiveLogic(
    output reg [7:0] RxData,
    output reg read_en,
    input clr_b, flag_empty, flag_full,
    input ssp_fss_in, ssp_rxd, ssp_clk_in
);

    reg [7:0] data;
    reg [3:0] ctr;

    initial begin
        ctr = 4'b0000;
    end

    always @ (posedge ssp_clk_in)
    begin
        if (clr_b == 1'b1)
        begin
            ctr <= 4'b0000;
            data <= 8'b00000000;
            end
        if (((ssp_fss_in == 1'b0) && (ctr > 4'b1000)) || (ssp_fss_in == 1'b1))
            begin
                if(ssp_fss_in == 1'b1)
                    begin
                        ctr <= 4'b1110;
                        data[7] <= ssp_rxd;
                    end else if((ssp_fss_in == 1'b0) && (ctr > 4'b1000))
                begin
                    data[ctr[2:0]] <= ssp_rxd;
                    ctr <= ctr - 1'b1;
                end
                begin end
            end
        else begin // do nothing
        end
    end
    always @ (posedge ssp_clk_in)
    begin
        if (ctr == 4'b1000)
        begin
            RxData <= data;
            read_en <= 1'b1;
        end
        if (read_en == 1'b1)
        begin
            read_en <= 1'b0;
        end
    end
endmodule
