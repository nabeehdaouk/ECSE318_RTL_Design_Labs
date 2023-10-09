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
    
    localparam test_number= 32'haaaa1111;

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
        $display();
        $display("VALUES IN MEM:");
        $display("hX000  -> test_number");
        $display("hX001  -> 0");
        $display();
        $display("PROGRAM:");
        $display("ADRS ->  INST, SRC, DEST");
        $display("hX004  -> LD MEM0 REG0");
        $display("hX005  -> LD MEM1 REG2");
        $display("hX006  -> SHF Left1 REG0");
        $display("hX007  -> BRANCH NO CARRY ADRS_11");
        $display("hX008  -> ADD IMED_1 REG2");
        $display("hX009  -> ADD IMED_0 REG0");
        $display("hX00a  -> BRANCH ZERO ADRS_12");
        $display("hX00b  -> BRANCH ALWAYS ADRS_6");
        $display("hX00c  -> STR REG2 MEM1");
        $display("hX00d  -> HLT");
        
        
        
        // PROGRAM MODE: 
        
        read_write = 1'b1;
    
        data_in = test_number; //SNumberStored to count 
        address = 12'h000;
        #20

        data_in = 0; //SNumberStored to count 
        address = 12'h001;
        #20

        data_in = 32'b0001_1_0_00_000000000000_000000000000; //LD MEM0 REG0
        address = 12'h004;
        #20

        data_in = 32'b0001_1_0_00_000000000001_000000000010; //LD MEM1 REG2
        address = 12'h005;
        #20

        data_in = 32'b0111_1_0_00_000000010001_000000000000; //SHF Left1 REG0
        address = 12'h006;
        #20

        data_in = 32'b0011_0110_000000001011_000000000000; //BRANCH if NO CARRY to adrs 11
        address = 12'h007;
        #20

        data_in = 32'b0101_1_0_00_000000000001_000000000010; //ADD #1 REG2, result in REG2
        address = 12'h008;
        #20

        data_in = 32'b0101_1_0_00_000000000000_000000000000; //ADD #0 REG0, result in REG0, PSR refclects REG0
        address = 12'h009;
        #20


        data_in = 32'b0011_0101_000000001100_000000000000; //BRANCH if ZERO to adrs 12
        address = 12'h00a;
        #20

        data_in = 32'b0011_0000_000000000110_000000000000; //BRANCH ALWAYS to adrs 6
        address = 12'h00b;
        #20

        data_in = 32'b0010_0_1_00_000000000010_000000000001; //STR REG2 MEM1
        address = 12'h00c;
        #20

        data_in = 32'b1000_0_0_00_000000000000_000000000000; //HLT program
        address = 12'h00d;
        #20
//-----------------DATA_STORRED--------------------------------------------------


        $display("RUNNING NUMBER OF ONES TEST PROGRAM...");
        // RUN PROGRAM IN CPU
        cpu_en=1'b1;
        reset= 1'b1;
        #20
        reset= 1'b0;

        #80000


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
        $display("**********************************************************");
        $display("CHECKING MEMORY VALUE AT LOCATION 1, WHERE RESUlt IS STORED");
        $display("NUMBER OF 1's IN %b", test_number);
        $display("**********************************************************");
        //CHECK MEMORY VALUE AT LOCATION 1
        read_write = 1'b0;
        address = 12'h001;
        #20
        $display("read_out_data in bin: %b", read_out_data);
        $display("read_out_data in hex: %h", read_out_data);
        $display("read_out_data in dec: %d", read_out_data);
        $display("------------------------------------------------------------------------------------------------------------");






        $stop();

    end





endmodule