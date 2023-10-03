module memory_tb();
    localparam clk_period = 10;
    
    reg clk;
    reg [11:0] address;
    reg mem_en;
    reg read_write;
    reg [31:0] data_in;
    wire [31:0] data_out;

memory memory_instance(
    .clk(clk),
    .address(address),
    .mem_en(mem_en),
    .read_write(read_write),
    .data_in(data_in),
    .data_out(data_out)
);
    
    // Clock generation
    always begin
        #5 clk = ~clk;
    end
    
    
    initial begin
       clk = 1'b0;
       address = 12'h000;
       mem_en = 1'b0;
       read_write = 1'b0;
       data_in = 32'h0000000;
       #clk_period;
       
       // Writing data value to memory
       mem_en = 1'b1;
       read_write = 1'b1;
       address = 12'h000;
       data_in = 32'hF0F0F0F0;
       #clk_period;
       
       // Reading data value
       mem_en = 1'b1;
       read_write = 1'b0;
       address = 12'h000;
       #clk_period;
       
       $display("data_in: %h matches data_out: %h", data_in, data_out);
       
    end
    
endmodule