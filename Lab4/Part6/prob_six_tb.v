module prob_six_tb(
);
	
	
	reg E;
	reg W;
	reg clk= 1'b0;
	wire struct_out;
	wire behav_out;
	
	prob_six_struct prob_six_struct_instance(
	    .out1(struct_out),
	    .clk(clk),
	    .E(E),
	    .W(W)
	);
	
	prob_six_behav prob_six_behav_instance(
	    .out1(behav_out),
	    .clk(clk),
	    .E(E),
	    .W(W)
	);
	
	
	initial begin
	    $display("NOTE: This is a Moore Machine, so we ecpect output to reflect the state");
	   $display("        Output is only expected to be asserted when we are in S0");
	   $display("STATE=q2q1");
	   
	   
	    $display;
        $display("Start in S0::");
        E = 1'b0;
        W = 1'b0;
        #100    
        $display("E: %b       W:%b       BEHAVIORAL_OUT:%b      STRUCTURAL_OUT:%b", E,W,behav_out, struct_out);
        $display;
        
         $display("Transition to S1");
        E = 1'b1;
        W = 1'b0;
        #100    
        $display("E: %b       W:%b       BEHAVIORAL_OUT:%b      STRUCTURAL_OUT:%b", E,W,behav_out, struct_out);
        $display;
        
         $display("Transition to S2");
        E = 1'b1;
        W = 1'b1;
        #100    
        $display("E: %b       W:%b       BEHAVIORAL_OUT:%b      STRUCTURAL_OUT:%b", E,W,behav_out, struct_out);
        $display;
        
         $display("Transition to S3");
        E = 1'b0;
        W = 1'b1;
        #100    
        $display("E: %b       W:%b       BEHAVIORAL_OUT:%b      STRUCTURAL_OUT:%b", E,W,behav_out, struct_out);
        $display;
        
        $display("Transition Back to S0");
        E = 1'b0;
        W = 1'b0;
        #100    
        $display("E: %b       W:%b       BEHAVIORAL_OUT:%b      STRUCTURAL_OUT:%b", E,W,behav_out, struct_out);
        $display;
        
        $stop;
    end
    
    always #5 clk = ~clk;
    
endmodule : prob_six_tb
