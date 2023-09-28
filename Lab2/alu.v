module alu(
    input signed [15:0] A,
    input signed [15:0] B,
    input [4:0] alu_code,
    input coe,
    output reg signed [15:0] C,
    output reg vout, cout
);
    wire [15:0] c; //output of 16-bit Adder Module
    wire vout_wire;
    wire cout_wire;

    //Arithmatic Opperations
    localparam add= 5'b00_000;              //A+B=>C    signed addition
    localparam addu=5'b00_001;              //A+B=>C    unsigned addition
    localparam sub= 5'b00_010;              //A-B=>C    signed subtraction
    localparam subu=5'b00_011;              //A-B=>C    unsigned subtraction
    localparam inc= 5'b00_100;              //A+1=>C    signed increment
    localparam dec= 5'b00_101;              //A-1=>C   signed decrement

    //Logic Opperations
    localparam and_opp= 5'b01_000;           //A AND B
    localparam or_opp=  5'b01_001;           //A OR B
    localparam xor_opp= 5'b01_010;           //A XOR B
    localparam not_opp= 5'b01_100;           //NOT A

    //Shift Opperations0
    localparam sll= 5'b10_000;              //logic left shift A by the amount of B[3:0]
    localparam srl= 5'b10_001;              //logic right shift A by the amount of B[3:0]
    localparam sla= 5'b10_010;              //arithmetic left shift A by the amount of B[3:0]
    localparam sra= 5'b10_011;              //arithmetic right shift A by the amount of B[3:0]

    //Set Condition Opperations
    localparam sle= 5'b11_000;              //if A <= B then C(15:0) = <0...0001>
    localparam slt= 5'b11_001;              //if A < B then C(15:0) = <0...0001>
    localparam sge= 5'b11_010;              //if A >= B then C(15:0) = <0...0001>
    localparam sgt= 5'b11_011;              //if A > B then C(15:0) = <0...0001>
    localparam seq= 5'b11_100;              //if A = B then C(15:0) = <0...0001>
    localparam sne= 5'b11_101;              //if A != B then C(15:0) = <0...0001>

    //Comb

    adder adder_instance(
        .A(A),
        .B(B),
        .CODE(alu_code[2:0]),
        .coe(coe), //ActiveLow
        .C(c),
        .vout(vout_wire), //no connection for now
        .cout(cout_wire) //no connection for now
    );
    always @(*)
    begin: ALU
        case(alu_code)
            add: begin
                C=c;
                vout=vout_wire;
                cout=cout_wire;
            end
            addu:begin
                C=c;
                vout=vout_wire;
                cout=cout_wire;
            end
            sub: begin
                C=c;
                vout=vout_wire;
                cout=cout_wire;
            end
            subu:begin
                C=c;
                vout=vout_wire;
                cout=cout_wire;
            end
            inc: begin
                C=c;
                vout=vout_wire;
                cout=cout_wire;
            end
            dec: begin
                C=c;
                vout=vout_wire;
                cout=cout_wire;
            end

            and_opp: begin
                C= A & B;
                vout=1'b0;
                cout=1'b0;
                end
            or_opp: begin
                C= A | B;
                vout=1'b0;
                cout=1'b0;
                end
            xor_opp: begin
                C= A ^ B;
                vout=1'b0;
                cout=1'b0;
                end
            not_opp: begin
                C= ~A;
                vout=1'b0;
                cout=1'b0;
            end
            
            
            
            sll: begin
                C= A<<B[3:0];
                vout=1'b0;
                cout=1'b0;
                end
            srl: begin
                C= A>>B[3:0];
                vout=1'b0;
                cout=1'b0;
                end
            sla: begin
                C= A<<<B[3:0];
                vout=1'b0;
                cout=1'b0;
                end
            sra: begin
                C= A>>>B[3:0];
                vout=1'b0;
                cout=1'b0;
            end
            
            
            
            sle: begin
                C= (A<=B)?16'h0001:16'h0000;
                vout=1'b0;
                cout=1'b0;
                end
            slt: begin
                C= (A<B)?16'h0001:16'h0000;
                vout=1'b0;
                cout=1'b0;
                end
            sge: begin
                C= (A>=B)?16'h0001:16'h0000;
                vout=1'b0;
                cout=1'b0;
                end
            sgt: begin
                C= (A>B)?16'h0001:16'h0000;
                vout=1'b0;
                cout=1'b0;
                end
            seq: begin C= (A==B)?16'h0001:16'h0000;
                vout=1'b0;
                cout=1'b0;
                end
            sne: begin
                C= (A!=B)?16'h0001:16'h0000;
                vout=1'b0;
                cout=1'b0;
                end

            default: begin
                C=16'h0000;
                vout=1'b0;
                cout=1'b0;
                end
        endcase
    end
endmodule