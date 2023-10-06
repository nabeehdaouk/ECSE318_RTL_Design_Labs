module psr (
    input carry,
    input [31:0] result,
    output reg [4:0] psr

);


    always @ (result) begin
        psr[0] <= carry ? 1'b1 : 1'b0; // Carry
        psr[1] <= ^ result == 1 ? 1'b1 : 1'b0; // Parity
        psr[2] <= result % 2 == 0 ? 1'b1 : 1'b0; // Even
        psr[3] <= result[31] == 1'b1 ? 1'b1 : 1'b0; // Negative
        psr[4] <= result == 0 ? 1'b1 : 1'b0; // Zero
    end
endmodule