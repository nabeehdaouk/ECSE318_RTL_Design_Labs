module memory (
    input [15:0] sysaddress,
    input [7:0] sysdata_in,
    input sysstrobe, sysrw, clk,
    output reg [7:0] sysdata_out
);
    reg [31:0] mem [16383:0];

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
                    case(sysaddress[1:0])
                        2'b00: begin
                            sysdata_out <= mem[sysaddress[15:2]][7:0];
                        end
                        2'b01: begin
                            sysdata_out <= mem[sysaddress[15:2]][15:8];

                        end
                        2'b10: begin
                            sysdata_out <= mem[sysaddress[15:2]][23:16];

                        end
                        2'b11: begin
                            sysdata_out <= mem[sysaddress[15:2]][31:24];
                        end
                    endcase
                end
                write: begin
                    case(sysaddress[1:0])
                        2'b00: begin
                            mem[sysaddress[15:2]][7:0] <= sysdata_in;
                        end
                        2'b01: begin
                            mem[sysaddress[15:2]][15:8] <= sysdata_in;
                        end
                        2'b10: begin
                            mem[sysaddress[15:2]][23:16] <= sysdata_in;
                        end
                        2'b11: begin
                            mem[sysaddress[15:2]][31:24] <= sysdata_in;
                        end
                    endcase
                end
            endcase
        end else begin
        end
    end
endmodule