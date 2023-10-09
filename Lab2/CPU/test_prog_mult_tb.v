module test_prog_mult_tb ();
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
        $display("PROGRAMING MULTIPLICATION TEST PROGRAM...");
        $display("ADRS  -> INST SRC DEST");
        $display("hX004 -> LD MEM0 REG0");
        $display("hX005 -> LD MEM1 REG1");
        $display("hX006 -> LD MEM2 REG2");
        $display("hX007 -> LD MEMf REGf");
        $display("hX008 -> ADD REG0 REG2");
        $display("hX009 -> ADD REGf REG1");
        $display("hX00a -> BRA ZERO ADRS00c");
        $display("hX00b -> BRA POS ADRS008");
        $display("hX00c -> STR REG2 MEM2");
        $display("hX00d -> HLT");
        
        // PROGRAM MODE: 
        data_in = 32'h0000000e; // data value for A
        address = 12'h000;
        #20

        data_in = 32'h0000000f; // data value for B
        address = 12'h001;
        #20
        
        data_in = 32'h00000000; // initialize product, LD into REG2
        address = 12'h002;
        #20

        data_in = 32'hffffffff; // -1 for decrementing B
        address = 12'h00f;
        #20
       
        data_in = 32'b0001_1_0_00_000000000000_000000000000; //LD MEM0 REG0
        read_write = 1'b1;
        address = 12'h004;
        #20
        
        data_in = 32'b0001_1_0_00_000000000001_000000000001; //LD MEM1 REG1
        address = 12'h005;
        #20

        data_in = 32'b0001_1_0_00_000000000010_000000000010; //LD MEM2 REG2
        address = 12'h006;
        #20

        data_in = 32'b0001_1_0_00_000000001111_000000001111; //LD MEMf REGf
        address = 12'h007;
        #20

        data_in = 32'b0101_0_0_00_000000000000_000000000010; //ADD REG0 REG2
        address = 12'h008;
        #20

        data_in = 32'b0101_0_0_00_000000001111_000000000001; //ADD REGf REG1
        address = 12'h009;
        #20

        data_in = 32'b0011_0_1_01_000000001100_000000000000; //BRANCH if ZERO to adrs c
        address = 12'h00a;
        #20

        data_in = 32'b0011_0_1_11_000000001000_000000000000; //BRANCH if POS to adrs 8
        address = 12'h00b;
        #20

        data_in = 32'b0010_0_1_00_000000000010_000000000010; //STR REG2 MEM2
        address = 12'h00c;
        #20

        data_in = 32'b1001_0_0_00_000000000000_000000000000; //HLT program
        address = 12'h00d;
        #20
        

        $display("RUNNING MULTIPLICATION TEST PROGRAM...");
        // RUN PROGRAM IN CPU
        cpu_en=1'b1;
        reset= 1'b1;
        #20
        reset= 1'b0;

        #10000


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
        $display("CHECKING MEMORY VALUE AT LOCATION F3");
        $display("MULTIPLIED 14 * 15, EXP RES: 210");
        //CHECK MEMORY VALUE AT LOCATION 2
        read_write = 1'b0;
        address = 12'h002;
        #20
        $display("read_out_data in bin: %b", read_out_data);
        $display("read_out_data in hex:             %h", read_out_data);
        $display("read_out_data in dec:        %d", read_out_data);
        $display("------------------------------------------------------------------------------------------------------------");






        $stop();

    end

endmodule