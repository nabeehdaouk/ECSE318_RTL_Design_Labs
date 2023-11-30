module memory (
    input [15:0] sysaddress,
    input [7:0] sysdata_in,
    input sysstrobe, sysrw, clk,
    output reg [7:0] sysdata_out
);
    reg [7:0] mem [65535:0];

    parameter read = 1'b1, write = 1'b0;
    parameter val_10= 16'h0010;
    parameter val_20= 16'h0020;
    parameter val_31= 16'h0031;
    parameter val_80= 16'h0080;
    parameter val_51= 16'h0051;
    parameter val_57= 16'h0057;
    parameter val_58= 16'h0058;
    parameter val_59= 16'h0059;




    initial begin //for testing ‘10’,’20’,31,’80’,'51','57','58','59', '57', '51'
        //{mem[{val10[13:0], 2'b00}], mem[{val10[13:0], 2'b01}], mem[{val10[13:0], 2'b10}], mem[{val10[13:0], 2'b11}]}= 32'haabbccdd;
        mem[{val_10[13:0], 2'b11}]= 8'haa;
        mem[{val_10[13:0], 2'b10}]= 8'hbb;
        mem[{val_10[13:0], 2'b01}]= 8'hcc;
        mem[{val_10[13:0], 2'b00}]= 8'hdd;
                
        mem[{val_20[13:0], 2'b11}]= 8'h11;
        mem[{val_20[13:0], 2'b10}]= 8'h22;
        mem[{val_20[13:0], 2'b01}]= 8'h33;
        mem[{val_20[13:0], 2'b00}]= 8'h44;
                
        mem[{val_31[13:0], 2'b11}]= 8'h99;
        mem[{val_31[13:0], 2'b10}]= 8'h88;
        mem[{val_31[13:0], 2'b01}]= 8'h11;
        mem[{val_31[13:0], 2'b00}]= 8'h33;
                
        mem[{val_80[13:0], 2'b11}]= 8'hab;
        mem[{val_80[13:0], 2'b10}]= 8'hcd;
        mem[{val_80[13:0], 2'b01}]= 8'hef;
        mem[{val_80[13:0], 2'b00}]= 8'h01;
                
        mem[{val_51[13:0], 2'b11}]= 8'h12;
        mem[{val_51[13:0], 2'b10}]= 8'h34;
        mem[{val_51[13:0], 2'b01}]= 8'h56;
        mem[{val_51[13:0], 2'b00}]= 8'h78;
                
        mem[{val_57[13:0], 2'b11}]= 8'h67;
        mem[{val_57[13:0], 2'b10}]= 8'h89;
        mem[{val_57[13:0], 2'b01}]= 8'hab;
        mem[{val_57[13:0], 2'b00}]= 8'hcd;
        
        mem[{val_58[13:0], 2'b11}]= 8'ha1;
        mem[{val_58[13:0], 2'b10}]= 8'hb2;
        mem[{val_58[13:0], 2'b01}]= 8'hc3;
        mem[{val_58[13:0], 2'b00}]= 8'hd4;
                
        mem[{val_59[13:0], 2'b11}]= 8'h9a;
        mem[{val_59[13:0], 2'b10}]= 8'h8b;
        mem[{val_59[13:0], 2'b01}]= 8'h1c;
        mem[{val_59[13:0], 2'b00}]= 8'h3d;
                
                
        
        
        
        

 
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