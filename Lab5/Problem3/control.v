module control (
    input [31:0] pdata_in,
    input [15:0] paddress,
    input [7:0] sysdata_in, tag_ram_in, cache_ram_in,
    input clk, pstrobe, prw,
    output reg [31:0] pdata_out,
    output reg [15:0] sysaddress,
    output reg [7:0] sysdata_out, index, tag_ram_out, cache_ram_out,
    output reg [1:0] byte,
    output reg pready, sysrw, sysstrobe, en, rw
);
    parameter read  = 1'b1, write = 1'b0;

    reg [1:0] byte_ctr = 2'b00;

    always @ (posedge clk)
    begin
        if (pstrobe) begin
            en <= 1'b1;
            index <= paddress[9:2];
            rw <= read;
            case (prw)
                read: begin
                    if({paddress[15:10], paddress[1:0]} == tag_ram_in) begin
                        pdata_out <= cache_ram_in;
                        pready <= 1'b1;
                    end else begin
                        sysaddress <= paddress;
                        sysstrobe <= 1'b1;
                        sysrw <= read;
                        pready <= 1'b0;
                        if (sysstrobe) begin
                            sysstrobe <= 1'b0;
                            rw <= write;
                            cache_ram_out <= sysdata_in;
                            byte <= paddress[1:0];
                            tag_ram_out <= {paddress[15:10], paddress[1:0]};
                            pready <= 1'b1;
                        end
                    end
                end
                write: begin
                    rw <= write;
                    tag_ram_out <= {paddress[15:10], paddress[1:0]};
                    sysrw <= 1'b0;
                    sysaddress <= paddress;
                    if(byte_ctr == 2'b00)  begin
                    sysdata_out <= pdata_in[7:0];
                    cache_ram_out <= pdata_in[7:0];
                    byte_ctr <= byte_ctr + 1'b1;
                end
                if(byte_ctr == 2'b01)  begin
                    sysdata_out <= pdata_in[15:8];
                    cache_ram_out <= pdata_in[15:8];
                    byte_ctr <= byte_ctr + 1'b1;
                end
                if(byte_ctr == 2'b10)  begin
                    sysdata_out <= pdata_in[23:16];
                    cache_ram_out <= pdata_in[23:16];
                    byte_ctr <= byte_ctr + 1'b1;
                end
                if(byte_ctr == 2'b11)  begin
                    sysdata_out <= pdata_in[31:24];
                    cache_ram_out <= pdata_in[31:24];
                    byte_ctr <= 2'b00;                   
                    end 
                end
            endcase
        end else begin
        end
    end
endmodule