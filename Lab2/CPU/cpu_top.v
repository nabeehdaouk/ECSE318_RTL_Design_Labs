module cpu_top (
    input reset,
    input disable_cpu_clock,
    input clr_mem,
    input read_write,
    input mem_en,
    input main_clk,
    input [11:0] address,
    input [31:0] data_in,
    output [31:0] data_out 
);

    wire [31:0] data_to_cpu;
    wire [31:0] data_to_mem;
    
    memory memory_instance(
        .clk(main_clk),
        .address(address),
        .mem_en(mem_en),
        .read_write(read_write),
        .data_in(data_to_mem),
        .clr_mem(clr_mem),
        .data_out(data_to_cpu)
    );
    
    
    cpu cpu_instance(
        .clk_in(main_clk),
        .reset(reset),
        .data_in(data_to_cpu),
        .data_out(data_to_mem),
        .address(address),
        .read_write(read_write),
        .mem_en(mem_en)
    );


endmodule