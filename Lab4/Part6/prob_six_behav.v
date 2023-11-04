module prob_six_behav(
    output out,
    input clk,
    input E,
    input W
);

    reg q1 = 1'b0;
    reg q2 = 1'b0;
    
always @(posedge clk)
    begin
        q1<= E|(q1&~q2)|(q1&W);
        q2<= W|(q2&~q1)|(q2&E);
    end
    
assign out=(~q1)&(~q2);




endmodule : prob_six_behav
