module traffic_fsm_tb;

    reg clock, reset, Sa, Sb;

    wire Ga, Ya, Ra, Gb, Yb, Rb;

    traffic_fsm traffic_fsm_instance(
        .clock(clock),
        .reset(reset),
        .Sa(Sa),
        .Sb(Sb),
        .Ga(Ga),
        .Ya(Ya),
        .Ra(Ra),
        .Gb(Gb),
        .Yb(Yb),
        .Rb(Rb)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        // Initialize inputs
        reset = 1;
        Sa = 0;
        Sb = 0;

        #10 reset = 0;

        // Test case 1: A street is active
        #20 Sa = 1;
        #200 Sa = 0;

        // Test case 2: B street becomes active
        #20 Sb = 1;
        #50 Sb = 0;

        // Test case 3: B street extended green cycle
        #20 Sb = 1;
        #150 Sb = 0;

        // Test case 4: A street is active again
        #20 Sa = 1;
        #200 Sa = 0;

        // End simulation
        #10 $stop;
    end

endmodule