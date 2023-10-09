module cpu_top (
    input main_clk, 
    input reset, //For CPU programming
    input cpu_en, //For CPU programming
    input clr_mem, //For CPU programming
    input read_write, //For CPU programming
    input mem_en, //For CPU programming
    input [11:0] address, //For CPU programming
    input [31:0] data_in, //For CPU programming
    output [31:0] read_out_data //For CPU test validation
);

    wire [31:0] data_to_cpu; //For CPU operation with memory, intercepted for CPU validation
    wire [31:0] data_to_mem; //For CPU operation with memory
    wire [11:0] address_cpu_mem; //For CPU operation with memory
    wire clr_mem_cpu; //For CPU operation with memory
    wire mem_en_cpu; //For CPU operation with memory
    wire read_write_cpu; //For CPU operation with memory
    wire gated_clk; //For CPU operation with memory
    wire [11:0] gated_address; //For CPU operation with memory
    wire [31:0] gated_data_to_mem; //For CPU operation with memory
    wire gated_clr_mem; //For CPU operation with memory
    wire gated_read_write; //For CPU operation with memory
    wire gated_mem_en; //For CPU operation with memory
   




    assign gated_clk= (cpu_en)? main_clk: 1'b0; 
    assign gated_address= (cpu_en)? address_cpu_mem: address;
    assign gated_data_to_mem= (cpu_en)? data_to_mem: data_in;
    assign gated_clr_mem= (cpu_en)? clr_mem_cpu: clr_mem; 
    assign gated_read_write= (cpu_en)? read_write_cpu: read_write; 
    assign gated_mem_en= (cpu_en)? mem_en_cpu: mem_en;
    assign read_out_data= data_to_cpu; 

    memory memory_instance(
        .clk(main_clk),
        .address(gated_address),
        .mem_en(gated_mem_en),
        .read_write(gated_read_write),
        .data_in(gated_data_to_mem),
        .clr_mem(gated_clr_mem),
        .data_out(data_to_cpu)
    );


    cpu cpu_instance(
        .clk_in(gated_clk),
        .reset(reset),
        .data_in(data_to_cpu),
        .data_out(data_to_mem),
        .address(address_cpu_mem),
        .read_write(read_write_cpu),
        .mem_en(mem_en_cpu),
        .clr_mem(clr_mem_cpu)
    );


endmodule