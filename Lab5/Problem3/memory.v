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
        //{mem[{val10[13:0], 2'b00}], mem[{val10[13:0], 2'b01}], mem[{val10[13:0], 2'b10}], mem[{val10[13:0], 2'b11}]}= 32'haabbccdd;
        mem[{val10[13:0], 2'b11}]= 8'haa;
        mem[{val10[13:0], 2'b10}]= 8'hbb;
        mem[{val10[13:0], 2'b01}]= 8'hcc;
        mem[{val10[13:0], 2'b00}]= 8'hdd;
        
        mem[{val20[13:0], 2'b11}]= 8'h11;
        mem[{val20[13:0], 2'b10}]= 8'h22;
        mem[{val20[13:0], 2'b01}]= 8'h33;
        mem[{val20[13:0], 2'b00}]= 8'h44;
        
        mem[{val31[13:0], 2'b11}]= 8'h99;
        mem[{val31[13:0], 2'b10}]= 8'h88;
        mem[{val31[13:0], 2'b01}]= 8'h11;
        mem[{val31[13:0], 2'b00}]= 8'h33;

 
    end

    always @ (posedge clk)
    begin
        if (sysstrobe|~sysstrobe) begin
            case(sysrw)
                read: begin
                    sysdata_out <= mem[sysaddress];
                end
                write: begin
                    mem[sysaddress] <= sysdata_in;
                end
            endcase
        end
    end
endmodule