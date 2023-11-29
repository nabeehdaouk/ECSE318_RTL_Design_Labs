module cache_ram (
    input [7:0]data_in,
    input [7:0] index,
    input [1:0] byte,
    input rw, clk, en,
    output reg [7:0]data_out
);

    reg  [31:0] cache[255:0];
    parameter read  = 1'b1, write = 1'b0;
    
    always @ (negedge clk)
    if (en) begin
        case(rw)
            read: begin
        case(byte)
                        2'b00: begin
                            data_out <= cache[index][7:0];
                        end
                        2'b01: begin
                            data_out <= cache[index][15:8];

                        end
                        2'b10: begin
                            data_out <= cache[index][23:16];

                        end
                        2'b11: begin
                            data_out <= cache[index][31:24];
                        end
                    endcase
            end
            write: begin
                case(byte)
                        2'b00: begin
                            cache[index][7:0] <=data_in;
                        end
                        2'b01: begin
                            cache[index][15:8] <=data_in;

                        end
                        2'b10: begin
                            cache[index][23:16] <=data_in;

                        end
                        2'b11: begin
                            cache[index][31:24] <=data_in;
                        end
                    endcase
            end
        endcase
    end
endmodule