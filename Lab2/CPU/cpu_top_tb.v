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
        data_in = 32'b0001_1_0_00_000000000111_000000000011; //LD MEM7 REG3
        read_write = 1'b1;
        address = 12'h001;
        #20

        data_in = 32'b0001_1_0_00_000000001000_000000000100; //LD MEM8 REG4
        read_write = 1'b1;
        address = 12'h002;
        #20

//        data_in = 32'b0101_0_0_00_000000000011_000000000100; //ADD REG3 REG4, result in 4
//        read_write = 1'b1;
//        address = 12'h003;
//        #20

        data_in = 32'h00000000; //NOP
        read_write = 1'b1;
        address = 12'h004;
        #20

//        data_in = 32'b1001_0_0_00_000000000011_000000000011; //CMP REG4, result in 4
//        read_write = 1'b1;
//        address = 12'h005;
//        #20

        data_in = 32'b0111_0_0_00_000000000101_000000001011; //SHF REG11 by 5, result in REG11
        read_write = 1'b1;
        address = 12'h005;
        #20

        data_in = 32'b0111_0_0_00_100000000101_000000001011; //SHF REG11 by -5, result in REG11
        read_write = 1'b1;
        address = 12'h005;
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
        
        #1000


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