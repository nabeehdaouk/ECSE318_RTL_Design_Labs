module memory (
    input [15:0] sysaddress,
    input [7:0] sysdata_in,
    input sysstrobe, sysrw, clk,
    output reg [7:0] sysdata_out
);
    reg [7:0] mem [65535:0];

    parameter read = 1'b1, write = 1'b0;
    parameter val10= 16'h0010;
    parameter val20= 16'h0020;
    parameter val31= 16'h0031;



    initial begin //for testing ‘10’,’20’,31,’80’,'51','57','58','59', '57', '51'
        mem[val10[15:2]]= 32'haabbccdd;
        mem[val20[15:2]]= 32'h11223344;
        mem[val31[15:2]]= 32'h55667788;
    end

    always @ (posedge clk)
    begin
        if (sysstrobe) begin
            case(sysrw)
                read: begin
                    sysdata_out <= mem[sysaddress[15:2]];
                end
                write: begin
                    mem[sysaddress[15:2]] <= sysdata_in;
                end
            endcase
        end
    end
endmodule