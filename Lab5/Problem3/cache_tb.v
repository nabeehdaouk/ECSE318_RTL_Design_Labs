module cache_tb();

    reg clk, pstrobe, prw;
    reg [15:0] paddress;
    reg [31:0] pdata_in;

    wire pready;
    wire [31:0] pdata_out;

    wire sysstrobe, sysrw;
    wire [15:0] sysaddress;
    wire [7:0] sysdata_out, sysdata_in;


    cache cache_instance(
        .pdata_in(pdata_in),
        .paddress(paddress),
        .sysdata_in(sysdata_in),
        .clk(clk),
        .pstrobe(pstrobe),
        .prw(prw),
        .pdata_out(pdata_out),
        .sysaddress(sysaddress),
        .sysdata_out(sysdata_out),
        .pready(pready),
        .sysrw(sysrw),
        .sysstrobe(sysstrobe)
    );


    memory memory_instance(
        .sysaddress(sysaddress),
        .sysdata_in(sysdata_out),
        .sysstrobe(sysstrobe),
        .sysrw(sysrw),
        .clk(clk),
        .sysdata_out(sysdata_in)
    );


    initial begin
        clk = 0;
        pstrobe= 0;
        #1000

        pstrobe= 1'b1;
        prw= 1'b1;
        
        
        paddress= 16'h0010;
        #100
        pstrobe= 1'b0;
        #600
        $display("%h", pdata_out);
        
        pstrobe= 1'b1;
        paddress= 16'h0020;
        #100
        pstrobe= 1'b0;
        #600
        $display("%h", pdata_out);

        pstrobe= 1'b1;
        paddress= 16'h0031;
        #100
        pstrobe= 1'b0;
        #600
        $display("%h", pdata_out);
        
         pstrobe= 1'b1;
        paddress= 16'h0010;
        #100
        pstrobe= 1'b0;
        #300
        $display("%h", pdata_out);








        $stop;



    end


    always #50 clk=~clk;

endmodule 