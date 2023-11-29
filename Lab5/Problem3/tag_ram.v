module tag_ram (
    input [7:0]data_in,
    input [7:0] index,
    input rw, clk, en,
    output reg [7:0]data_out
);

    reg  [7:0] tag[255:0];
    parameter read  = 1'b1, write = 1'b0;
    
    always @ (negedge clk)
    if (en) begin
        case(rw)
            read: begin
                data_out <= tag[index];
            end
            write: begin
                tag[index] <= data_in;
            end
        endcase
    end
endmodule