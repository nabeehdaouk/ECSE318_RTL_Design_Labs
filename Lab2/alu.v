module alu(
    input [15:0] A,
    input [15:0] B,
    input [4:0] alu_code,
    output reg [15:0] C
);
    wire [15:0] c; //output of 16-bit Adder Module

    //Arithmatic Opperations
    localparam add= 5'b00_000; //A+B=>C    signed addition
    localparam addu=5'b00_001; //A+B=>C    unsigned addition
    localparam sub= 5'b00_010; //A-B=>C    signed subtraction
    localparam subu=5'b00_011; //A-B=>C    unsigned subtraction
    localparam inc= 5'b00_100; //A+1=>C    signed increment
    localparam dec= 5'b00_101; //A-1=>C   signed decrement

    //Logic Opperations
    localparam and_opp= 5'b01_000; //A AND B
    localparam or_opp=  5'b01_001; //A OR B
    localparam xor_opp= 5'b01_010; //A XOR B
    localparam not_opp= 5'b01_100; //NOT A

    //Shift Opperations0
    localparam sll= 5'b10_000; //logic left shift A by the amount of B[3:0]
    localparam srl= 5'b10_001; //logic right shift A by the amount of B[3:0]
    localparam sla= 5'b10_010; //arithmetic left shift A by the amount of B[3:0]
    localparam sra= 5'b10_011; //arithmetic right shift A by the amount of B[3:0]

    //Set Condition Opperations
    localparam sle= 5'b11_000; //if A <= B then C(15:0) = <0...0001>
    localparam slt= 5'b11_001; //if A < B then C(15:0) = <0...0001>
    localparam sge= 5'b11_010; //if A >= B then C(15:0) = <0...0001>
    localparam sgt= 5'b11_011; //if A > B then C(15:0) = <0...0001>
    localparam seq= 5'b11_100; //if A = B then C(15:0) = <0...0001>
    localparam sne= 5'b11_101; //if A != B then C(15:0) = <0...0001>

//Comb

adder adder_instance(
    .A(A),
    .B(B),
    .CODE(alu_code[2:0]),
    .coe(1'b0), //ActiveLow
    .C(c),
    .vout(vout), //no connection for now
    .cout(cout)  //no connection for now
);
    always @(*)
    begin: ALU
        case(alu_code)
            add: C=c;
            addu:C=c;
            sub: C=c;
            subu:C=c;
            inc: C=c;
            dec: C=c;

            and_opp: C= A & B;
            or_opp: C= A | B;
            xor_opp: C= A ^ B;
            not_opp: C= ~A;

            sll: C= A<<B[3:0];
            srl: C= A>>B[3:0];
            sla: C= A<<<B[3:0];
            sra: C= A>>>B[3:0];

            sle: C= (A<=B)?1'h1:1'h0;
            slt: C= (A<B)?1'h1:1'h0;
            sge: C= (A>=B)?1'h1:1'h0;
            sgt: C= (A>B)?1'h1:1'h0;
            seq: C= (A==B)?1'h1:1'h0;
            sne: C= (A!=B)?1'h1:1'h0;

            default: C=1'h0;
        endcase
    end
endmodule