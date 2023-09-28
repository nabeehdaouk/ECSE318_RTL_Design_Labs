module adder(
    input [15:0] A, B,
    input [2:0] CODE,
    input cin, coe,
    output [15:0] C,
    output reg vout, cout
);

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
        .SUM(C),
        .C_OUT(coutwire)
    );


    always @ (*) begin
        case(CODE)
            add: begin
                Ain = A;
                Bin = B;
                cout = (coe) ? coutwire : 1'b0;
                vout = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            addu: begin
                Ain = A;
                Bin = B;
                cout = (coe) ? coutwire : 1'b0;
                vout = 1'b0;
            end

            sub: begin // Assuming A and B input in two's complement form
                Ain = A;
                Bin = ~B + 1'b1;
                cout = (coe) ? coutwire : 1'b0;
                vout = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            subu: begin
                Ain = A;
                Bin = ~B + 1'b1;
                cout = (coe) ? coutwire : 1'b0;
                vout = 1'b0;
            end

            inc: begin
                Ain = A;
                Bin = 16'h0001;
                cout = (coe) ? coutwire : 1'b0;
                vout = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            dec: begin
                Ain = A;
                Bin = 16'hffff;
                cout = (coe) ? coutwire : 1'b0;
                vout = (Ain[15] == Bin[15]) && (C[15] != Ain[15]);
            end

            default: begin
                Ain = 16'h0000;
                Bin = 16'h0000;
                vout = 1'b0;
                cout = 1'b0;
                
            end
        endcase
    end

endmodule
