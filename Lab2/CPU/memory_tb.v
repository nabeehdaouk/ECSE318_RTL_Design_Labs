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
        #10 clk = ~clk;
    end


    initial begin
        clk = 1'b0;
        address = 12'h000;
        mem_en = 1'b0;
        clr_mem = 1'b0;
        read_write = 1'b1;
        data_in = 32'h0000000;
        
        #100;
        $display("Initial Values:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        // Writing data value to memory address 000
        mem_en = 1'b1;
        clr_mem = 1'b0;
        read_write = 1'b1;
        address = 12'h000;
        data_in = 32'hF0F0F0F0;
        #100;
        $display("Pushing data_in to address 12'h000:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        
        #100;
        
        // Writing data value to address 101
        mem_en = 1'b1;
        clr_mem = 1'b0;
        read_write = 1'b1;
        address = 12'h001;
        data_in = 32'h01010101;
        #100;
        $display("Pushing data_in to address 12'h101:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        #100
       
        // Writing data value to memory address 002
        mem_en = 1'b1;
        clr_mem = 1'b0;
        read_write = 1'b1;
        address = 12'h002;
        data_in = 32'habcdabcd;
        #100;
        $display("Pushing data_in to address 12'h000:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        
        #100;
        
        // Writing data value to address 003
        mem_en = 1'b1;
        clr_mem = 1'b0;
        read_write = 1'b1;
        address = 12'h003;
        data_in = 32'h2e2e2e2e;
        #100;
        $display("Pushing data_in to address 12'h101:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n"); 
        // Reading data value adress 000
        mem_en = 1'b1;
        address = 12'h000;
        read_write = 1'b0;
        #100;
        $display("Reading data_out at address 000:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        #100;
        
        // Reading data value adress 001
        mem_en = 1'b1;
        address = 12'h001;
        read_write = 1'b0;
        #100;
        $display("Reading data_out at address 101:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        #100;
        
        // Reading data value adress 002
        mem_en = 1'b1;
        address = 12'h002;
        read_write = 1'b0;
        #100;
        $display("Reading data_out at address 000:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        #100;
        
        // Reading data value adress 003
        mem_en = 1'b1;
        address = 12'h003;
        read_write = 1'b0;
        #100;
        $display("Reading data_out at address 101:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        #100;
        
        
        mem_en = 1'b0;
        read_write = 1'b0;
        data_in = 32'ha10a1011;
        #100;
        $display("Memory shows high z data_out when mem_en is off:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        #100
          
        mem_en = 1'b1;
        read_write = 1'b0;
        data_in = 32'ha10a1011;
        #1000;
        $display("Memory saves previous data_out when mem_en is turned back on:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);
        $display("\n");
        
        
        #100;
        
        mem_en = 1'b1;
        clr_mem = 1'b1;
        read_write = 1'b0;
        
        #1000;
        read_write = 1'b0;
        $display("Clearing Memory:");
        $display("mem_en: %b | clr_mem: %b | read_write: %b | address: %h | data_in: %h | data_out: %h", mem_en, clr_mem, read_write, address, data_in, data_out);




    end

endmodule