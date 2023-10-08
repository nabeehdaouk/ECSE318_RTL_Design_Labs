module branch_tb ();
    reg main_clk;
    reg reset;
    reg cpu_en;
    reg clr_mem;
    reg read_write;
    reg mem_en;
    reg [11:0] address;
    reg [31:0] data_in;
    wire [31:0] read_out_data;

    cpu_top cpu_top_instance(
        .reset(reset),
        .cpu_en(cpu_en),
        .main_clk(main_clk),
        .clr_mem(clr_mem),
        .read_write(read_write),
        .mem_en(mem_en),
        .address(address),
        .data_in(data_in),
        .read_out_data(read_out_data)
    );

    always begin
        #10 main_clk = ~main_clk;
    end

    initial begin
        // cpu disable
        cpu_en = 1'b0;

        // reset 
        reset = 1'b1;
        clr_mem = 1'b1;
        #20

        // initialize system
        clr_mem = 1'b0;
        reset = 1'b0;
        main_clk = 1'b0;
        data_in = 32'h00000000;
        cpu_en = 1'b0;
        mem_en = 1'b1;
        #20

        // BRANCH always at PC = 12'h003
        //data_in = 32'b0011_0_0_10_000000000111_000000001111; // BRANCH to PC = 12'h00f
        //read_write = 1'b1;
        //address = 12'h003;
        //#20

        // BRANCH if POS; should  BRANCH
        data_in = 32'b0011_0_1_11_000000000111_000000010101; // BRANCH to PC = 12'h00f
        read_write = 1'b1;
        address = 12'h003;
        #20

        data_in = 32'h0000000a; //data value
        read_write = 1'b1;
        address = 12'h007;
        #20

        data_in = 32'h000000ff; //data value
        read_write = 1'b1;
        address = 12'h008;
        #20

        // run cpu
        cpu_en=1'b1;
        reset= 1'b1;
        #20
        reset= 1'b0;
        
        #200



        //        data_in = 32'h76543210;
        //        read_write = 1'b1;
        //        address = 12'h003;
        //        #20
        //
        //        // Check memory values
        //        read_write = 1'b0;
        //        address = 12'h001;
        //        #20
        //        $display("read_out_data: %h", read_out_data);
        //        
        //
        //        read_write = 1'b0;
        //        address = 12'h002;
        //        #20
        //        $display("read_out_data: %h", read_out_data);
        //        
        //
        //        read_write = 1'b0;
        //        address = 12'h003;
        //        #20
        //        $display("read_out_data: %h", read_out_data);

        $stop();

    end





endmodule