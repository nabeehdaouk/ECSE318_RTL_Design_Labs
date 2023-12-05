module cla16bit (
    input [15:0] A,      // 16-bit input A
    input [15:0] B,      // 16-bit input B
    input cin,          
    output [15:0] SUM,   // 16-bit sum output
    output C_OUT         // Carry-out
);

// Internal wires for the generate (G) and propagate (P) signals
wire [15:0] G; 
wire [15:0] P; 

// Internal wires for the carry-in signals
wire [16:0] C; 

// Calculate the generate and propagate signals
generate
    genvar i;
    for (i = 0; i < 16; i = i + 1) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end
endgenerate

// Ccarry-in signals
assign C[0] = cin; // Initial carry-in is 0
generate
    for (i = 0; i < 16; i = i + 1) begin
        assign C[i+1] = G[i] | (P[i] & C[i]);
    end
endgenerate

// sum output
assign SUM[0] = A[0] ^ B[0] ^ C[0];
generate
    for (i = 0; i < 15; i = i + 1) begin
        assign SUM[i+1] = A[i+1] ^ B[i+1] ^ C[i+1];
    end
endgenerate

// the final carry bit
assign C_OUT = C[16];


endmodule