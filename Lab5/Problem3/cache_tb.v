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
        $display("TESTING CACHE DESIGN...");
        $display("Memory has been innitialized for this test via initial begin for testing purposes");
        $display("---------------------------------------------------------------");
        clk = 0;
        pstrobe= 0;
        #1000

        pstrobe= 1'b1;
        prw= 1'b1;


        paddress= 16'h0010;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #600
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("note, delay of 600 as data had to be fetched from memmory");
        $display;

        pstrobe= 1'b1;
        paddress= 16'h0020;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #600
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("note, delay of 600 as data had to be fetched from memmory");
        $display;

        pstrobe= 1'b1;
        paddress= 16'h0031;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #600
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("note, delay of 600 as data had to be fetched from memmory");
        $display;

        pstrobe= 1'b1;
        paddress= 16'h0080;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #600
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("note, delay of 600 as data had to be fetched from memmory");
        $display;

        pstrobe= 1'b1;
        paddress= 16'h0051;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #600
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("note, delay of 600 as data had to be fetched from memmory");
        $display;

        pstrobe= 1'b1;
        paddress= 16'h0057;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #600
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("note, delay of 600 as data had to be fetched from memmory");
        $display;

        pstrobe= 1'b1;
        paddress= 16'h0058;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #600
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("note, delay of 600 as data had to be fetched from memmory");
        $display;

        pstrobe= 1'b1;
        paddress= 16'h0059;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #600
        $display("Data Out: %h,          Timestamp:%d", pdata_out, $time);
        $display("note, delay of 600 as data had to be fetched from memmory");
        $display;

        pstrobe= 1'b1;
        paddress= 16'h0057;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #100
        $display("Data Out: %h          Timestamp:%d", pdata_out, $time);
        $display("NOTE: DELAY OF ONLY 100 AS CACHE HIT!!!!!!!!!");
        $display();

        pstrobe= 1'b1;
        paddress= 16'h0051;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #100
        $display("Data Out: %h,          Timestamp:%d", pdata_out, $time);
        $display("NOTE: DELAY OF ONLY 100 AS CACHE HIT!!!!!!!!!");       
        $display;



    $display("TESTING WRITE");
        pstrobe= 1'b1;
        prw= 1'b0;
        paddress= 16'h0099;
        pdata_in= 32'ha1b2c3d4;
        #100
        pstrobe= 1'b0;
        $display("Address WRITE: %h          Timestamp:%d", paddress[7:0], $time);
        #800
        $display("Data In: %h,          Timestamp:%d", pdata_in, $time);
        $display;
        
        prw= 1'b1;
        pstrobe= 1'b1;
        paddress= 16'h0099;
        #100
        pstrobe= 1'b0;
        $display("Address Request: %h          Timestamp:%d", paddress[7:0], $time);
        #100
        $display("Data Out: %h,          Timestamp:%d", pdata_out, $time);
        $display("NOTE: DELAY OF ONLY 100 AS CACHE HIT!!!!!!!!! as we just wrote there");       
        $display("SINCE WRRITE OPPERARTION WRITES TO CACHE AS WELL, also stored in memory");


        $stop;



    end


    always #50 clk=~clk;

endmodule 