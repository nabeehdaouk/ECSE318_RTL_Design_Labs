module adder(
    input [15:0] A, B,
    input [2:0] CODE,
    input coe,
    output [15:0] C,
    output reg vout, cout
);

    reg cin; //set by opcode
    // CODE operation parameters
    localparam add= 3'b000; //A+B=>C    signed addition
    localparam addu=3'b001; //A+B=>C    unsigned addition
    localparam sub= 3'b010; //A-B=>C    signed subtraction
    localparam subu=3'b011; //A-B=>C    unsigned subtraction
    localparam inc= 3'b100; //A+1=>C    signed increment
    localparam dec= 3'b101; //A-1=>C   signed decrement

    // 
    reg [15:0] Ain, Bin;
    wire coutwire;

    cla16bit cla16bit_instance(
        .A(Ain),
        .B(Bin),
        .cin(cin),
        .SUM(C),
        .C_OUT(coutwire)
    );


    always @ (*) begin //A,B,coe,CODE, coutwire, cin synthesis
        case(CODE)
            add: begin
                cin = 1'b0;
                Ain = A;
                Bin = B ^ {16{cin}};
                cout = (~coe) ? coutwire : 1'b0;
                vout = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            addu: begin
                cin = 1'b0;
                Ain = A;
                Bin = B ^ {16{cin}};
                cout = (~coe) ? coutwire : 1'b0;
                vout = 1'b0;
            end

            sub: begin // Assuming A and B input in two's complement form
                cin = 1'b1;
                Ain = A;
                Bin = B ^ {16{cin}};
                cout = (~coe) ? coutwire : 1'b0;
                vout = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            subu: begin
                cin = 1'b1;
                Ain = A;
                Bin = B ^ {16{cin}};
                cout = (~coe) ? coutwire : 1'b0;
                vout = 1'b0;
            end

            inc: begin
                cin = 1'b0;
                Ain = A;
                Bin = 16'h0001 ^ {16{cin}};
                cout = (~coe) ? coutwire : 1'b0;
                vout = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            dec: begin
                cin = 1'b1;
                Ain = A;
                Bin = 16'h0001 ^ {16{cin}};
                cout = (~coe) ? coutwire : 1'b0;
                vout = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            default: begin
                cin = 1'b0;
                Ain = 16'h0000;
                Bin = 16'h0000;
                vout = 1'b0;
                cout = 1'b0;
                
            end
        endcase
    end

endmodule
