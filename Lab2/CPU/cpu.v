module cpu(
    input clk,
    input reset,
    input [31:0] data_in,
    output [31:0] data_out,
    output [11:0] address
);

    reg [31:0] file_reg [15:0];
    reg [31:0] IR;
    reg [11:0] PC;
    reg [2:0] PSR;
    reg [2:0] IC; //instruction counter

    reg [31:0] opperand1;
    reg [31:0] opperand2;

    localparam FETCH=     3'b000;
    localparam DECODE=    3'b001;
    localparam EXECUTE=   3'b010;
    localparam MEMORY=    3'b011;
    localparam WRITEBACK= 3'b101;
    
    localparam NOP= 4'b0000;
    localparam LD=  4'b0001;
    localparam STR= 4'b0010;
    localparam BRA= 4'b0011;
    localparam XOR= 4'b0100;
    localparam ADD= 4'b0101;
    localparam ROT= 4'b0110;
    localparam SHF= 4'b0111;
    localparam HLT= 4'b1000;
    localparam CMP= 4'b1001;
    
    localparam Always= 4'b0000;
    localparam Parity=  4'b0001;
    localparam Even= 4'b0010;
    localparam Carry= 4'b0011;
    localparam Negative= 4'b0100;
    localparam Zero= 4'b0101;
    localparam NoCarry= 4'b0110;
    localparam Posotive= 4'b0111;
   



    //FETCH
    always @(posedge clk)
    begin
        case (IC)
            FETCH:
            begin
                if (reset)
                    begin IR<=0;
                    end
                else
                    begin
                        IR <= data_in;
                    end
            end

            DECODE:
            begin
                opperand1<=(IR[27])?{{20{1'b0}},IR[23:12]} : file_reg[IR[15:12]]; //source
                opperand2<=(IR[26])?{32{1'b0}} : file_reg[IR[15:12]]; //dest
            end

            EXECUTE:
            begin
                ADD:
                result<= opperand1+opperand2;
            end

            MEMORY:
            begin
                
            end

            WRITEBACK:
            begin
                ADD:
                file_reg[IR[15:12]<= result;
                    //PC to mem
                ]
            end


        endcase

    end

endmodule
