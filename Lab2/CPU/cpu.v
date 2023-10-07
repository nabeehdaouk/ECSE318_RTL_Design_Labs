module cpu(
    input clk_in,
    input reset,
    input [31:0] data_in, //from mem
    output reg [31:0] data_out, //to mem
    output reg [11:0] address, //to mem
    output reg read_write, //to mem
    output reg mem_en //to mem

);

    reg [31:0] file_reg [15:0];
    reg [31:0] IR;
    reg [11:0] PC;
    reg [2:0] IC; //instruction counter, counts to 5 for Fetch, Decode, Execute, Memory, WriteBack

    reg [31:0] opperand1;
    reg [31:0] opperand2;
    reg [11:0] branch_address;
    reg branch_valid;
    reg clk_en;

    reg carry;
    reg [31:0] result;
    wire zro, neg, evn, par, cry;

    wire clk;



    localparam FETCH=     3'b000;
    localparam DECODE=    3'b001;
    localparam EXECUTE=   3'b010;
    localparam MEMORY=    3'b011;
    localparam WRITEBACK= 3'b100;

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
    localparam Positive= 4'b0111;

    localparam read_from_mem= 1'b0;
    localparam write_to_mem= 1'b1;

    psr psr_instance(
        .carry(carry),
        .result(result),
        .psr({zro, neg, evn, par, cry})
    );

    always @(negedge clk, reset)
    begin: Instruction_Counter
        if (reset == 1'b1)
            begin
                IC<= 3'b000;
            end else begin
            if (IC==3'b100)
                begin
                    IC<= 3'b000;
                end else begin
                IC<= IC+3'b001;
            end
        end
    end

    assign clk= (clk_en)? clk : 1'b0;


    //FETCH
    always @(posedge clk)
    begin
        case (IC)
            FETCH:
            begin
                if (reset == 1'b1)
                    begin
                        IR<=0;
                        clk_en<=1'b1;
                    end
                else
                    begin
                        IR <= data_in;
                        clk_en<=1'b1;
                    end
            end

            DECODE:
            begin
                if (reset == 1'b1)
                    begin
                        opperand1<= 0;
                        opperand2<= 0;
                        clk_en<=1'b1;
                    end
                else
                    begin
                        opperand1<=(IR[27])?{{20{1'b0}},IR[23:12]} : file_reg[IR[15:12]]; //source
                        opperand2<=(IR[26])?{32{1'b0}} : file_reg[IR[15:12]]; //dest
                        clk_en<=1'b1;
                    end
            end

            EXECUTE:
            begin
                if (reset == 1'b1)
                begin
                    mem_en<= 1'b0;
                    address <= {12{1'b0}};
                    result <= {32{1'b0}};
                    carry <= 1'b0;
                    branch_address <= {12{1'b0}};
                    branch_valid <= 1'b0;
                    clk_en<=1'b1;
                end
                begin
                    case (IR[31:28]) //opcode
                        NOP:
                        begin
                            mem_en<= 1'b0;
                            address <= {12{1'b0}};
                            result <= {32{1'b0}};
                            carry <= 1'b0;
                            branch_address <= {12{1'b0}};
                            branch_valid <= 1'b0;
                            clk_en<=1'b1;

                        end
                        LD:
                        begin
                            mem_en<= 1'b1;
                            read_write<= read_from_mem;
                            address <= IR[23:12]; //mem_source
                            result <= {32{1'b0}};
                            carry <= 1'b0;
                            branch_address <= 0;
                            branch_valid <= 0;
                            clk_en<=1'b1;
                        end
                        STR:
                        begin
                            mem_en<= 1'b1;
                            read_write<= write_to_mem;
                            address <= IR[11:0]; //mem_dest
                            result <= {32{1'b0}};
                            carry <= 1'b0;
                            branch_address <= 0;
                            branch_valid <= 0;
                            clk_en<=1'b1;
                        end
                        XOR:
                        begin
                            mem_en<= 1'b0;
                            result<= opperand1 ^ opperand2;
                            carry <= 1'b0;
                            branch_address <= {12{1'b0}};
                            branch_valid <= 1'b0;
                            clk_en<=1'b1;
                        end
                        ADD:
                        begin
                            mem_en<= 1'b0;
                            {carry, result} <= opperand1 + opperand2;
                            branch_address <= {12{1'b0}};
                            branch_valid <= 1'b0;
                            clk_en<=1'b1;
                        end
                        ROT:
                        begin

                        end
                        SHF:
                        begin

                        end
                        HLT:
                        begin
                            mem_en<= 1'b0;
                            address <= {12{1'b0}};
                            result <= {32{1'b0}};
                            carry <= 1'b0;
                            branch_address <= {12{1'b0}};
                            branch_valid <= 1'b0;
                            clk_en<=1'b0;
                        end
                        CMP:
                        begin
                            mem_en<= 1'b0;
                            result<= ~opperand1 + 1;
                            carry <= 1'b0;
                            branch_address <= {12{1'b0}};
                            branch_valid <= 1'b0;
                            clk_en<=1'b1;
                        end
                        BRA:
                        begin
                            result <= {32{1'b0}};
                            carry <= 1'b0;
                            case(IR[27:24])
                                Always: begin //always
                                    mem_en<= 1'b1;
                                    read_write<= read_from_mem;
                                    address <= IR[23:12]; //branch address
                                    branch_valid <= 1'b1;
                                end
                                Parity: begin //parity odd
                                    if (par == 1'b1)
                                    begin
                                        mem_en<= 1'b1;
                                        read_write<= read_from_mem;
                                        address <= IR[23:12]; //branch address
                                        branch_valid <= 1'b1;
                                    end
                                end
                                Even: begin //even
                                    if (evn == 1'b1)
                                    begin
                                        mem_en<= 1'b1;
                                        read_write<= read_from_mem;
                                        address <= IR[23:12]; //branch address
                                        branch_valid <= 1'b1;
                                    end
                                end
                                Carry: begin //carry
                                    if (cry == 1'b1)
                                    begin
                                        mem_en<= 1'b1;
                                        read_write<= read_from_mem;
                                        address <= IR[23:12]; //branch address
                                        branch_valid <= 1'b1;
                                    end
                                end
                                Negative: begin //neg
                                    if (neg == 1'b1)
                                    begin
                                        mem_en<= 1'b1;
                                        read_write<= read_from_mem;
                                        address <= IR[23:12]; //branch address
                                        branch_valid <= 1'b1;
                                    end
                                end
                                Zero: begin //zero
                                    if (zro == 1'b1)
                                    begin
                                        mem_en<= 1'b1;
                                        read_write<= read_from_mem;
                                        address <= IR[23:12]; //branch address
                                        branch_valid <= 1'b1;
                                    end
                                end
                                NoCarry: begin //no_carry
                                    if (cry == 1'b0)
                                    begin
                                        mem_en<= 1'b1;
                                        read_write<= read_from_mem;
                                        address <= IR[23:12]; //branch address
                                        branch_valid <= 1'b1;
                                    end
                                end
                                Positive: begin //pos
                                    if ((neg == 1'b0) && (zro == 1'b0))
                                    begin
                                        mem_en<= 1'b1;
                                        read_write<= read_from_mem;
                                        address <= IR[23:12]; //branch address
                                        branch_valid <= 1'b1;
                                    end
                                end
                                default: begin //default case is always, including when bit [27] is set
                                    mem_en<= 1'b1;
                                    read_write<= read_from_mem;
                                    address <= IR[23:12]; //branch address
                                    branch_valid <= 1'b1;
                                end
                            endcase

                        end
                        default:
                        begin
                            mem_en<= 1'b0;
                            address <= {12{1'b0}};
                            result <= {32{1'b0}};
                            carry <= 1'b0;
                            branch_address <= {12{1'b0}};
                            branch_valid <= 1'b0;
                            clk_en<=1'b1;
                        end
                    endcase
                end
            end

            MEMORY:
            begin
                if (reset ==1'b1)
                    begin

                    end
                else
                    begin



                    end


            end

            WRITEBACK:
            begin
                //ADD:
                //file_reg[IR[15:12]<= result;
                //PC to mem
                //INC PC or Load Jump from BRANCH
            end


        endcase

    end

endmodule
