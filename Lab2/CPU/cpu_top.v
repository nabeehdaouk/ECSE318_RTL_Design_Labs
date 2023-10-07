module cpu_top (
    input reset,
    input cpu_en,
    input main_clk,
    input clr_mem,
    input read_write,
    input mem_en,
    input [11:0] address,
    input [31:0] data_in,
    output [31:0] read_out_data
);

    wire [31:0] data_to_cpu;
    wire [31:0] data_to_mem;
    wire [11:0] address_cpu_mem;
    wire clr_mem_cpu;
    wire mem_en_cpu;
    wire read_write_cpu;

    wire gated_clk;
    wire gated_address;
    wire gated_data_to_mem;
    wire gated_clr_mem;
    wire gated_read_write;
    wire gated_mem_en;
    wire gated_data_to_cpu;




    assign gated_clk= (cpu_en)? main_clk: 1'b0;
    assign gated_address= (cpu_en)? address_cpu_mem: address;
    assign gated_data_to_mem= (cpu_en)? data_to_mem: data_in;
    assign gated_clr_mem= (cpu_en)? clr_mem_cpu: clr_mem;
    assign gated_read_write= (cpu_en)? read_write_cpu: read_write;
    assign gated_mem_en= (cpu_en)? mem_en_cpu: mem_en;
    assign gated_data_to_cpu= (cpu_en)? data_to_cpu: read_out_data;


    memory memory_instance(
        .clk(main_clk),
        .address(gated_address),
        .mem_en(gated_mem_en),
        .read_write(gated_read_write),
        .data_in(gated_data_to_mem),
        .clr_mem(gated_clr_mem),
        .data_out(gated_data_to_cpu)
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