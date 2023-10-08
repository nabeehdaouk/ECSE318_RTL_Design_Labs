module cpu_top_tb ();
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

        // Block program memory
        data_in = 32'b0001_1_0_00_000000000101_000000000011;
        read_write = 1'b1;
        address = 12'h001;
        #20

        data_in = 32'haaaaaaaa;
        read_write = 1'b1;
        address = 12'h005;
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