module test_prog_ones_tb ();
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
        $display("------------------------------------------------------------------------------------------------------------");
        $display("PROGRAMING MODE");
        $display("PROGRAMING NUMBER OF ONES TEST PROGRAM...");
        $display("  INST, SRC, DEST");
        $display("  -> LD MEM0 REG3");
        $display("  -> CMP REG3 REG4");
        $display("  -> STR REG4 MEM1");
        // PROGRAM MODE: 
        data_in = 32'b0011_0_0_00_000000000000_000000000010; //BRANCH ALWAYS to adrs 2
        address = 12'h000;
        #20
        
        data_in = 32'b0001_1_0_00_000000000000_000000001111; //LD MEM0 REGf
        address = 12'h00c;
        #20

        data_in = 32'b0010_0_1_00_000000000011_000000000000; //STR 32'h00000111 MEM0
        read_write = 1'b1;
        address = 12'h001;
        #20

        data_in = 32'b0001_1_0_00_000000000000_000000000000; //LD MEM0 REG0
        address = 12'h002;
        #20

        data_in = 32'b0001_1_0_00_000000010000_000000000010; //LD MEM16 REG2
        address = 12'h003;
        #20

        data_in = 32'b0111_1_0_00_000000010001_000000000000; //SHF REG0 left 1
        address = 12'h004;
        #20

        data_in = 32'b0011_0_1_01_000000000101_000000001101; //BRANCH if ZERO to adrs 13
        address = 12'h005;
        #20

        data_in = 32'b0011_0_0_11_000000000110_000000001010; //BRANCH if CARRY to adrs 10
        address = 12'h006;
        #20

        data_in = 32'b0011_0_0_00_000000000111_000000000100; //BRANCH ALWAYS to adrs 4
        address = 12'h007;
        #20

        data_in = 32'b0101_1_0_00_000000000001_000000000010; //ADD #1 REG2, result in 2
        read_write = 1'b1;
        address = 12'h00a;
        #20

        data_in = 32'b0011_0_0_00_000000001010_000000000100; //BRANCH ALWAYS to adrs 4
        address = 12'h00b;
        #20

        data_in = 32'b0010_0_1_00_000000000010_000000000001; //STR REG2 MEM1
        address = 12'h00e;
        #20

        data_in = 32'b1001_0_0_00_000000000000_000000000000; //HLT program

        data_in = 32'h00000111; // data value, also NOP
        address = 12'h000;
        #20


        $display("RUNNING NUMBER OF ONES TEST PROGRAM...");
        // RUN PROGRAM IN CPU
        cpu_en=1'b1;
        reset= 1'b1;
        #20
        reset= 1'b0;

        #1300


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
        $display("*****************************");
        $display("CHECKING MEMORY VALUE AT LOCATION 1");
        $display("EXPECTED VALUE OF 3");
        //CHECK MEMORY VALUE AT LOCATION 1
        read_write = 1'b0;
        address = 12'h001;
        #20
        $display("read_out_data in hex: %h", read_out_data);
        $display("read_out_data in dec: %d", read_out_data);
        $display("------------------------------------------------------------------------------------------------------------");






        $stop();

    end





endmodule