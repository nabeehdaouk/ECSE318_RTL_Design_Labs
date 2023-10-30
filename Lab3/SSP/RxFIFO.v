module RxFIFO (
    input psel, pwrite, clr_b, pclk, read_en,
    input [7:0] rxdata,
    output reg [7:0] prdata,
    output reg flag_empty, flag_full
);

    reg [2:0] w_ptr, r_ptr; // [2] is the phase counter, [1:0] is the FIFO location counter
    reg [7:0] mem [3:0]; // Storage locations in FIFO
    reg read_en_prev;

    localparam write_mode = 1'b1;
    localparam read_mode = 1'b0;
    localparam read_enabled = 1'b1;
    localparam read_disabled = 1'b0;

    initial begin
        w_ptr = 3'b000;
        r_ptr = 3'b000;
    end

    always @ (psel)
    begin
        r_ptr <= (psel)? r_ptr + 1'b1 : r_ptr + 1'b0;
    end

    always @ (*)
    begin
        flag_empty = (w_ptr == r_ptr)? 1'b1 : 1'b0;
        flag_full = ((w_ptr[1:0] == r_ptr[1:0]) && (w_ptr[2] != r_ptr[2]))? 1'b1 : 1'b0;
    end

    always @ (posedge (pclk | clr_b))
    begin
        read_en_prev<= read_en;
        if(clr_b == 1'b1) begin
            mem[0] <= 8'b00000000;
            mem[1] <= 8'b00000000;
            mem[2] <= 8'b00000000;
            mem[3] <= 8'b00000000;
            w_ptr[2:0] <= 3'b000;
            r_ptr[2:0] <= 3'b000;
        end else begin
            case (pwrite)
                write_mode:
                begin
                end
                read_mode:
                begin
                    case(read_en && (read_en != read_en_prev))
                        read_enabled:
                        begin
                            if(flag_full == 1'b0) begin
                                mem[w_ptr[1:0]] <= rxdata;
                                w_ptr = w_ptr + 1'b1;
                            end  else begin // don't write if flag_full set high
                            end
                            prdata <= mem[r_ptr[1:0]];
                        end
                        read_disabled:
                        begin
                            prdata <= mem[r_ptr[1:0]];
                        end
                    endcase
                end
            endcase
        end
    end
endmodule