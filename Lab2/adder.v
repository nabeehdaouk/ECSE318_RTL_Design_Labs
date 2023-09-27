module adder(
    input [15:0] A, B,
    input [2:0] CODE,
    input cin, coe,
    output [15:0] C,
    output wire vout, cout
);

    // CODE operation parameters
    localparam add = 3'b000;
    localparam addu = 3'b001;
    localparam sub = 3'b010;
    localparam subu = 3'b011;
    localparam inc = 3'b100;
    localparam dec = 3'b101;

    // Temporary storage for evaluating signed overflow
    reg [16:0] C_temp;


    always @ (*) begin
        case(CODE)
            add: begin
            C_temp[16:0] = {1'b0, A} + {1'b0, B};
            vout = (A[15] == B[15]) && (C_temp[16] != C_temp[15])
            C = C_temp[15:0];
            end
            addu: begin
            C = A + B + cin;
            end
            sub: begin // Assuming A and B input in two's complement form
            C_temp = A + B;
            vout = (A[15] == B[15]) && (C_temp[16] != C_temp[15]);
            C = C_temp[15:0];
            end
            subu: begin
            C = A - B;
            end
            inc: begin
            C_temp = A + 1'b1;
            vout = (A[15] == 1'b0) && (C_temp[16] == 1'b1);
            C = C_temp;
            end
            dec: begin
            C_temp = A - 1'b1;            
            vout = (A[15] == 1'b0) && (C_temp[16] == 1'b1);
            C = C_temp;
            end            
    endcase
end

endmodule
