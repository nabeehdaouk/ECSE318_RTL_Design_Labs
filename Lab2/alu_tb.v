module alu_tb;
    reg [15:0] A, B;
    reg [4:0] CODE;
    reg coe;
    wire vout, cout;
    wire [15:0] C;

    reg [4:0] operation_list [0:19];
    integer i;

    localparam add= 5'b00_000; //A+B=>C    signed addition
    localparam addu=5'b00_001; //A+B=>C    unsigned addition
    localparam sub= 5'b00_010; //A-B=>C    signed subtraction
    localparam subu=5'b00_011; //A-B=>C    unsigned subtraction
    localparam inc= 5'b00_100; //A+1=>C    signed increment
    localparam dec= 5'b00_101; //A-1=>C   signed decrement

    localparam and_opp= 5'b01_000; //A AND B
    localparam or_opp=  5'b01_001; //A OR B
    localparam xor_opp= 5'b01_010; //A XOR B
    localparam not_opp= 5'b01_100; //NOT A

    localparam sll= 5'b10_000; //logic left shift A by the amount of B[3:0]
    localparam srl= 5'b10_001; //logic right shift A by the amount of B[3:0]
    localparam sla= 5'b10_010; //arithmetic left shift A by the amount of B[3:0]
    localparam sra= 5'b10_011; //arithmetic right shift A by the amount of B[3:0]

    localparam sle= 5'b11_000; //if A <= B then C(15:0) = <0...0001>
    localparam slt= 5'b11_001; //if A < B then C(15:0) = <0...0001>
    localparam sge= 5'b11_010; //if A >= B then C(15:0) = <0...0001>
    localparam sgt= 5'b11_011; //if A > B then C(15:0) = <0...0001>
    localparam seq= 5'b11_100; //if A = B then C(15:0) = <0...0001>
    localparam sne= 5'b11_101; //if A != B then C(15:0) = <0...0001>

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
        operation_list[0]  = add;
        operation_list[1]  = addu;
        operation_list[2]  = sub;
        operation_list[3]  = subu;
        operation_list[4]  = inc;
        operation_list[5]  = dec;
        operation_list[6]  = and_opp;
        operation_list[7]  = or_opp;
        operation_list[8]  = xor_opp;
        operation_list[9]  = not_opp;
        operation_list[10] = sll;
        operation_list[11] = srl;
        operation_list[12] = sla;
        operation_list[13] = sra;
        operation_list[14] = sle;
        operation_list[15] = slt;
        operation_list[16] = sge;
        operation_list[17] = sgt;
        operation_list[18] = seq;
        operation_list[19] = sne;
        
        

        for (i = 0; i < 20; i = i + 1) begin
            CODE = operation_list[i];
            $display("Testing operation: CODE=%b", CODE);
            $display("Testing All Adder Functionality for inputs 0000 and 0001 Below:");
            A = 16'h0000;
            B = 16'h0001;
            coe = 1'b0;
            #100 $display("CODE: %b coe: %b A: %h + B: %h = C: %h vout: %b cout: %b", CODE, coe, $signed(A), $signed(B), $signed(C), vout, cout);
            $display("CODE: %b coe: %d A: %d + B: %d = C: %d vout: %d cout: %d", CODE, coe, $signed(A), $signed(B), $signed(C), vout, cout);
            $display;
        end
    end

endmodule
