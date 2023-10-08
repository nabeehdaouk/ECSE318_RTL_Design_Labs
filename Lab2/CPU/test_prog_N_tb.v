module test_prog_N_tb ();
    reg main_clk;
    reg reset;
    reg cpu_en;
    reg clr_mem;
    reg read_write;
    reg mem_en;
    reg [11:0] address;
    reg [31:0] data_in;
    wire signed [31:0] read_out_data;

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

        read_write = 1'b1;

        // PROGRAM MODE: 
        data_in = 32'b0001_1_0_00_000000000000_000000000011; //LD MEM0 REG3
        address = 12'h001;
        #20

        data_in = 32'b1001_0_0_00_000000000011_000000000100; //CMP REG3, result in REG4
        address = 12'h002;
        #20

        //STR
        data_in = 32'b0010_0_1_00_000000000100_000000000001; // STR REG4 MEM1
        address = 12'h003;
        #20


        data_in = 32'h00000006; // data value, also NOP
        address = 12'h000;
        #20


        // RUN PROGRAM IN CPU
        cpu_en=1'b1;
        reset= 1'b1;
        #20
        reset= 1'b0;

        #600


        //CHECK MEMORY VALUE
        
         // cpu disable
        cpu_en = 1'b0;

        // reset 
        reset = 1'b1;
        #20

        // initialize system
        clr_mem = 1'b0;
        reset = 1'b0;
        main_clk = 1'b0;
        data_in = 32'h00000000;
        cpu_en = 1'b0;
        mem_en = 1'b1;
        #20
$display("------------------------------------------------------------------------------------------------------------");
 $display("CHECKIG MEMORY VALUE AT LOCATION 1");
 $display("EXPECTED VALUE OF -6 (2s comp of 6");
  //CHECK MEMORY VALUE AT LOCATION 1
        read_write = 1'b0;
        address = 12'h001;
        #20
        $display("read_out_data: %h", read_out_data);
        $display("read_out_data: %d", read_out_data);
$display("------------------------------------------------------------------------------------------------------------");






        $stop();

    end





endmodule