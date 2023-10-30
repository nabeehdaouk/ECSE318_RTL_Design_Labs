module TransmitLogic(
    input [7:0] TxData,
    input pclk, clr_b, flag_empty,
    output reg ssp_fss_out,
    output reg ssp_oe_b, ssp_txd, ssp_clk_out, inc_ptr
);

    reg [7:0] data;
    reg data_read;
    reg [3:0] counter;

    initial begin
        ssp_clk_out= 1'b0;
        inc_ptr= 1'b0;
        counter = 4'b0000;
        ssp_oe_b =1'b1;
    end

    always @(posedge pclk)
    begin
        ssp_clk_out <= ~ssp_clk_out;
    end

    //assign ssp_fss_out = inc_ptr;

    always @(posedge ssp_clk_out, clr_b)
    begin
        if (clr_b ==1'b1)
            begin
                data <= 8'b0;
                counter <= 4'b0000;
                data_read<= 1'b0;
                inc_ptr<= 1'b0;
            end
        else begin
            if (inc_ptr ==1'b1)
                begin
                    inc_ptr<= 1'b0;
                    data_read <= 1'b0;
                    counter <= 4'b0000;
                end
            else if (inc_ptr == 1'b0)
            begin
                if ((data_read == 1'b0) && (flag_empty== 1'b0)) //empty chec
                    begin
                        data <= TxData;
                        data_read <= 1'b1;
                        ssp_fss_out<= 1'b1;
                    end
                else
                    begin
                        //do nothing
                    end
            end

        end
    end

    always @(posedge ssp_clk_out)
    begin
        if ((data_read ==1'b1) && (counter<4'b1000))
        begin
            ssp_txd <= data[7];
            data <= data<<1;
            counter<= counter +1'b1;
            ssp_fss_out<= counter==(4'b0000)?1'b0:ssp_fss_out;
        end
        if ((counter == 4'b1000) && (flag_empty == 1'b0) && (inc_ptr ==1'b0))
        begin
            inc_ptr<= 1'b1;
        end
    end


    always @(negedge ssp_clk_out)
    if (ssp_fss_out == 1'b1)
        begin
            ssp_oe_b <= 1'b0;
        end
    else
        begin
        ssp_oe_b<= (counter == 4'b1000)? 1'b1: 1'b0;
        end



endmodule
