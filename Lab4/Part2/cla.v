`timescale 1ps/1fs // Set timescale to 1 nanosecond with 1 picosecond precision
module cla(
	input [3:0] a, 
	input [3:0]b,
	input c_in,
	output [3:0] s,
	output c_out
);

wire [3:0] prop;
wire [3:0] g; 
wire [3:0] carry_o;

assign #10 g= a & b;
assign #10 prop= a ^ b;

assign #20 carry_o[0]= (c_in & prop[0]) | g[0]; //#20 delay bc 2 gates for assign statment, each w #10 delay
assign #20 carry_o[1]= (carry_o[0] & prop[1]) | g[1];
assign #20 carry_o[2]= (carry_o[1] & prop[2]) | g[2];
assign #20 carry_o[3]= (carry_o[2] & prop[3]) | g[3];

assign #10  s[0]= c_in ^ prop[0];
assign #10  s[1]= carry_o[0] ^ prop[1];
assign #10  s[2]= carry_o[1] ^ prop[2];
assign #10  s[3]= carry_o[2] ^ prop[3];
assign c_out= carry_o[3];

endmodule : cla
