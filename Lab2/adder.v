module adder(
    input [15:0] A, B,
    input [2:0] CODE,
    input  coe, //cin missing
    output reg [15:0] C,
    output reg vout, cout
);

    // CODE operation parameters
    localparam add= 3'b000; //A+B=>C    signed addition
    localparam addu=3'b001; //A+B=>C    unsigned addition
    localparam sub= 3'b010; //A-B=>C    signed subtraction
    localparam subu=3'b011; //A-B=>C    unsigned subtraction
    localparam inc= 3'b100; //A+1=>C    signed increment
    localparam dec= 3'b101; //A-1=>C   signed decrement

    // Temporary storage for evaluating signed overflow
    reg [16:0] C_temp;


    always @ (*) begin
        case(CODE)
            add: begin
            C_temp[16:0] = A + B;
            vout = (A[15] == B[15]) && (C_temp[15] != A[15]);
            {cout,C} = C_temp;
            end
            addu: begin
            {cout, C} = A + B;
            end
            sub: begin // Assuming A and B input in two's complement form
            C_temp[16:0] = A - B;
            vout = (A[15] == B[15]) && (C_temp[15] != A[15]);
            {cout,C} = C_temp;
            end
            subu: begin
            {cout, C} = A - B;
            end
            inc: begin
            C_temp = A + 1'b1;
            vout = (A[15] == 1'b0) && (C_temp[15] != A[15]);
            C = C_temp;
            end
            dec: begin
            C_temp = A - 1'b1;            
            vout = (A[15] == 1'b0) && (C_temp[15] != A[15]);
            C = C_temp;
            end
            default: begin
            vout = 1'b0;
            {cout, C} = {17{1'b0}};
            end
    endcase
end

endmodule
