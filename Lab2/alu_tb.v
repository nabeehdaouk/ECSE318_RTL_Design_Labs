module alu_tb;
    reg [15:0] A, B;
    reg [4:0] CODE;
    reg coe;
    wire vout, cout;
    wire [15:0] C;

    reg [4:0] operation_list [0:19];
    reg [7:0] operation_names[0:19]; // Added this line to store operation names
    integer i;

    localparam add= 5'b00_000;
    localparam addu=5'b00_001;
    localparam sub= 5'b00_010;
    localparam subu=5'b00_011;
    localparam inc= 5'b00_100;
    localparam dec= 5'b00_101;

    localparam and_opp= 5'b01_000;
    localparam or_opp=  5'b01_001;
    localparam xor_opp= 5'b01_010;
    localparam not_opp= 5'b01_100;

    localparam sll= 5'b10_000;
    localparam srl= 5'b10_001;
    localparam sla= 5'b10_010;
    localparam sra= 5'b10_011;

    localparam sle= 5'b11_000;
    localparam slt= 5'b11_001;
    localparam sge= 5'b11_010;
    localparam sgt= 5'b11_011;
    localparam seq= 5'b11_100;
    localparam sne= 5'b11_101;

    alu alu_instance(
        .A(A),
        .B(B),
        .alu_code(CODE),
        .coe(coe),
        .C(C),
        .vout(vout),
        .cout(cout)
    );

    initial begin
        operation_list[0]  = add;     operation_names[0] = "add";
        operation_list[1]  = addu;    operation_names[1] = "addu";
        operation_list[2]  = sub;     operation_names[2] = "sub";
        operation_list[3]  = subu;    operation_names[3] = "subu";
        operation_list[4]  = inc;     operation_names[4] = "inc";
        operation_list[5]  = dec;     operation_names[5] = "dec";
        operation_list[6]  = and_opp; operation_names[6] = "and";
        operation_list[7]  = or_opp;  operation_names[7] = "or";
        operation_list[8]  = xor_opp; operation_names[8] = "xor";
        operation_list[9]  = not_opp; operation_names[9] = "not";
        operation_list[10] = sll;     operation_names[10] = "sll";
        operation_list[11] = srl;     operation_names[11] = "srl";
        operation_list[12] = sla;     operation_names[12] = "sla";
        operation_list[13] = sra;     operation_names[13] = "sra";
        operation_list[14] = sle;     operation_names[14] = "sle";
        operation_list[15] = slt;     operation_names[15] = "slt";
        operation_list[16] = sge;     operation_names[16] = "sge";
        operation_list[17] = sgt;     operation_names[17] = "sgt";
        operation_list[18] = seq;     operation_names[18] = "seq";
        operation_list[19] = sne;     operation_names[19] = "sne";

        for (i = 0; i < 20; i = i + 1) begin
            //Inputs
            A = 16'hA00A;
            B = 16'h1004;
            coe = 1'b0;
            $display("_________________________________________________________________________________________________________________________________________________");
            CODE = operation_list[i];
            case(CODE)
                add: $display("Testing operation:       ADD=%b    //A+B=>C    signed addition ", CODE);
                addu: $display("Testing operation:      ADDU=%b   //A+B=>C    unsigned addition", CODE);
                sub: $display("Testing operation:       SUB=%b    //A-B=>C    signed subtraction", CODE);
                subu: $display("Testing operation:      SUBU=%b   //A-B=>C    unsigned subtraction", CODE);
                inc: $display("Testing operation:       INC=%b    //A+1=>C    signed increment", CODE);
                dec: $display("Testing operation:       DEC=%b   //A-1=>C   signed decrement  ", CODE);
                and_opp: $display("Testing operation:   AND=%b   //A AND B",CODE);
                or_opp: $display("Testing operation:    OR =%b   //A OR B ",CODE);
                xor_opp: $display("Testing operation:   XOR=%b   //A XOR B", CODE);
                not_opp: $display("Testing operation:   NOT=%b   //NOT A  ",CODE);
                sll: $display("Testing operation:       SLL=%b   //logic left shift A by the amount of B[3:0]     ", CODE);
                srl: $display("Testing operation:       SRL=%b   //logic right shift A by the amount of B[3:0]    ", CODE);
                sla: $display("Testing operation:       SLA=%b   //arithmetic left shift A by the amount of B[3:0]", CODE);
                sra: $display("Testing operation:       SRA=%b   //arithmetic right shift A by the amount of B[3:0]", CODE);
                sle: $display("Testing operation:       SLE=%b   //if A <= B then C(15:0) = <0...0001>", CODE);
                slt: $display("Testing operation:       SLT=%b   //if A < B then C(15:0) = <0...0001> ", CODE);
                sge: $display("Testing operation:       SGE=%b   //if A >= B then C(15:0) = <0...0001>", CODE);
                sgt: $display("Testing operation:       SGT=%b   //if A > B then C(15:0) = <0...0001> ", CODE);
                seq: $display("Testing operation:       SEQ=%b   //if A = B then C(15:0) = <0...0001> ", CODE);
                sne: $display("Testing operation:       SNE=%b   //if A != B then C(15:0) = <0...0001>", CODE);
            endcase
            $display("-------------------------------------------------------------------------------------------------------------------------------------------------|");
            #100 $display("hex           INPUTS: A:%h                  B:%h                  CarryOutEn_L:%b      |   OUTPUTS: C:%h                   vout:%b   cout:%b  |", $signed(A), $signed(B),coe ,$signed(C), vout, cout);
                 $display("bin           INPUTS: A:%b      B:%b      CarryOutEn_L:%b      |   OUTPUTS: C:%b       vout:%b   cout:%b  |", $signed(A), $signed(B),coe ,$signed(C), vout, cout);
                 $display("dec(signed)   INPUTS: A:%d                B:%d                CarryOutEn_L:%b      |   OUTPUTS: C:%d                 vout:%b   cout:%b  |", $signed(A), $signed(B),coe ,$signed(C), vout, cout);
                 $display("dec(unsigned) INPUTS: A: %d                B: %d                CarryOutEn_L:%b      |   OUTPUTS: C: %d                 vout:%b   cout:%b  |", A, B,coe ,C, vout, cout);
                 
        end
    end

endmodule
