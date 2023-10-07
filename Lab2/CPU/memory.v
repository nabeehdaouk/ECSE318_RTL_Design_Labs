module memory(
    input clk,
    input [11:0] address,
    input mem_en,
    input read_write, //high indicates read in, low indicates write out
    input [31:0] data_in,
    input clr_mem,
    output reg [31:0] data_out
);
    integer i;
    localparam write_out_mem= 1'b0;
    localparam read_in_mem= 1'b1;
    reg [31:0] mem [4095:0];




    always @(posedge clk)
    begin
        if (clr_mem == 1'b1)
            begin
                for (i=0; i<4096; i=i+1)
                    begin
                        mem[i] = 32'h00000000;
                    end
            end
        else
            begin
                case(read_write)
                    write_out_mem:
                    begin
                        data_out <= mem_en ? mem[address]: {32{1'bZ}};
                    end
                    read_in_mem:
                    begin
                        mem[address] <= mem_en ? data_in: mem[address];
                    end
                    default:
                    begin //do nothing
                    end
                endcase
            end
    end

endmodule