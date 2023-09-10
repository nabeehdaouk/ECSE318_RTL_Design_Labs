module parallel_multiplier(
    input [3:0] x,
    input [3:0] y,
    output [7:0] p
);
    wire [4:0] s_out_x0;
    wire [3:0] c_out_x0;
    wire [4:0] s_out_x1;
    wire [3:0] c_out_x1;
    wire [4:0] s_out_x2;
    wire [3:0] c_out_x2;
    wire [4:0] s_out_x3;
    wire [3:0] c_out_x3;
    wire [3:0] ab_x0;
    wire [3:0] ab_x1;
    wire [3:0] ab_x2;
    wire [3:0] ab_x3;
    wire [4:0] CI;
    genvar i;

assign {s_out_x0[4], s_out_x1[4], s_out_x2[4], s_out_x3[4], CI[0]}= 5'b00000;

    for (i = 0; i < 4; i = i + 1) begin
        assign ab_x0[i] = y[i] & x[0];
        assign {c_out_x0[i], s_out_x0[i]}= ab_x0[i]; //no sum  or carry out from prev
        
        assign ab_x1[i] = y[i] & x[1];
        assign {c_out_x1[i], s_out_x1[i]}= ab_x1[i]+c_out_x0[i]+s_out_x0[i+1];
        
        assign ab_x2[i] = y[i] & x[2];
        assign {c_out_x2[i], s_out_x2[i]}= ab_x2[i]+c_out_x1[i]+s_out_x1[i+1];
        
        assign ab_x3[i] = y[i] & x[3];
        assign {c_out_x3[i], s_out_x3[i]}= ab_x3[i]+c_out_x2[i]+s_out_x2[i+1];
        
        assign {CI[i+1], p[i+3]}=c_out_x3[i] + s_out_x3[i+1] +CI[i];
        
        assign p[0]= s_out_x0[0];
        assign p[1]= s_out_x1[0];
        assign p[2]= s_out_x2[0];
        assign p[3]= s_out_x3[0];
        
    end



endmodule : parallel_multiplier
