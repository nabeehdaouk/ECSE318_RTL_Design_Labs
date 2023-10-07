module memory_tb();

    reg clk;
    reg [11:0] address;
    reg mem_en;
    reg clr_mem;
    reg read_write;
    reg [31:0] data_in;
    wire [31:0] data_out;

    memory memory_instance(
        .clk(clk),
        .address(address),
        .mem_en(mem_en),
        .read_write(read_write),
        .data_in(data_in),
        .clr_mem(clr_mem),
        .data_out(data_out)
    );

    // Clock generation
    always begin
        #20 clk = ~clk;
    end


    initial begin
        clk = 1'b0;
        address = 12'h000;
        mem_en = 1'b0;
        clr_mem = 1'b0;
        read_write = 1'b0;
        data_in = 32'h0000000;
        $display("Initial Values:");
        $display("data_in: %h | data_out: %h", data_in, data_out);
        $display("\n");
        
        #1000;
        
        // Writing data value to memory
        mem_en = 1'b1;
        clr_mem = 1'b0;
        read_write = 1'b0;
        address = 12'h000;
        data_in = 32'hF0F0F0F0;
        #1000;
        $display("Pushing data_in:");
        $display("mem_en: %b | read_write: %b | data_in: %h", mem_en, read_write, data_in);
        $display("\n");
        
        
        #1000;
        
        // Reading data value
        mem_en = 1'b1;
        address = 12'h000;
        read_write = 1'b1;
        #1000;
        $display("Reading data_out:");
        $display("mem_en: %b | read_write: %b | data_out: %h", mem_en, read_write, data_out);
        $display("\n");
        
        #1000;
        
        mem_en = 1'b0;
        read_write = 1'b0;
        data_in = 32'ha10a1011;
        #1000;
        $display("Memory keeps data_out when mem_en is off:");
        $display("mem_en:%b | read_write: %b | new data_in: %h | data_out: %h", mem_en, read_write, data_in, data_out);
        $display("\n");
        
        
        #1000;
        
        mem_en = 1'b1;
        clr_mem = 1'b1;
        read_write = 1'b0;
        #1000;
        $display("Clearing Memory:");
        $display("clr_mem: %d | data_out: %h", clr_mem, data_out);




    end

endmodule