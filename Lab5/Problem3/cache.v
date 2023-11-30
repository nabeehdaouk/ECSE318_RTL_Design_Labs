module cache (
    input [31:0] pdata_in,
    input [15:0] paddress,
    input [7:0] sysdata_in,
    input clk, pstrobe, prw,
    output reg [31:0] pdata_out,
    output reg [15:0] sysaddress,
    output reg [7:0] sysdata_out,
    output reg pready, sysrw, sysstrobe
);

    reg [5:0] tag_ram[255:0];
    reg [31:0] cache_ram[255:0];
    reg byte0, byte1, byte2, byte3, done;

    parameter read = 1'b1, write = 1'b0;

    always @ (posedge clk)
    begin
        case (prw)
            read:  begin
                if(pstrobe) begin
                    pready <= 1'b0;
                    if (paddress[15:10] == tag_ram[paddress[9:2]]) begin
                        pdata_out <= cache_ram[paddress[9:2]];
                    end else begin
                        sysrw <= 1'b1;
                        sysstrobe <= 1'b1;
                        sysaddress <= {paddress[13:0], 2'b00}; //set byte bits to pull first byte
                    end
                end
                if (sysstrobe) begin
                    sysstrobe <= 1'b0;
                    byte0 <= 1'b1;
                    byte1 <= 1'b0;
                    byte2 <= 1'b0;
                    byte3 <= 1'b0;
                    done <= 1'b0;
                end
                if (byte0) begin
                    //cache_ram[paddress[9:2]][7:0] <= sysdata_in;
                    tag_ram[paddress[9:2]] <= paddress[15:10];
                    byte0 <= 1'b0;
                    byte1 <= 1'b1;
                    byte2 <= 1'b0;
                    byte3 <= 1'b0;
                    sysaddress <= {paddress[13:0], 2'b01};
                end
                if (byte1) begin
                    cache_ram[paddress[9:2]][7:0] <= sysdata_in;
                    byte0 <= 1'b0;
                    byte1 <= 1'b0;
                    byte2 <= 1'b1;
                    byte3 <= 1'b0;
                    sysaddress <= {paddress[13:0], 2'b10};
                end
                if (byte2) begin
                    cache_ram[paddress[9:2]][15:8] <= sysdata_in;
                    byte0 <= 1'b0;
                    byte1 <= 1'b0;
                    byte2 <= 1'b0;
                    byte3 <= 1'b1;
                    sysaddress <= {paddress[13:0], 2'b11};
                end
                if (byte3) begin
                    cache_ram[paddress[9:2]][23:16] <= sysdata_in;
                    byte0 <= 1'b0;
                    byte1 <= 1'b0;
                    byte2 <= 1'b0;
                    byte3 <= 1'b0;
                    done <= 1'b1;
                end
                if (done) begin
                    cache_ram[paddress[9:2]][31:24] <= sysdata_in;
                    pdata_out <= {sysdata_in, cache_ram[paddress[9:2]][23:0]};
                    done <= 1'b0;
                    pready <= 1'b1;
                end
            end
            write: begin

            end
        endcase
    end
endmodule