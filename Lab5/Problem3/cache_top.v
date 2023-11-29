module cache_top (
    input [31:0] pdata_in,
    input [15:0] paddress,
    input [7:0] sysdata_in,
    input clk, pstrobe, prw,
    output [31:0] pdata_out,
    output [15:0] sysaddress,
    output [7:0] sysdata_out,
    output pready, sysrw, sysstrobe
);

wire [7:0] data_in_tag, data_in_cache, data_out_cache, index, data_out_tag;
wire [1:0] byte, byte_ctr;
wire en, rw;

tag_ram tag_ram_instance(
    .data_in(data_in_tag),
    .index(index),
    .rw(rw),
    .clk(clk),
    .en(en),
    .data_out(data_out_tag)
);

cache_ram cache_ram_instance(
    .data_in(data_in_cache),
    .index(index),
    .byte (byte_ctr),
    .rw(rw),
    .clk(clk),
    .en(en),
    .data_out(data_out_cache)
);

control control_instance(
    .pdata_in(pdata_in),
    .paddress(paddress),
    .sysdata_in(sysdata_in),
    .tag_ram_in(data_out_tag),
    .cache_ram_in(data_out_cache),
    .clk(clk),
    .pstrobe(pstrobe),
    .prw(prw),
    .pdata_out(pdata_out),
    .sysaddress(sysaddress),
    .sysdata_out(sysdata_out),
    .index(index),
    .tag_ram_out(data_in_tag),
    .cache_ram_out(data_in_cache),
    .byte (byte),
    .byte_ctr(byte_ctr),
    .pready(pready),
    .sysrw(sysrw),
    .sysstrobe(sysstrobe),
    .en(en),
    .rw(rw)
);

endmodule