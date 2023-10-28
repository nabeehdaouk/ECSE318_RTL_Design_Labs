module TxFIFO_tb ();

    reg psel, pwrite, clr_b, pclk, inc_ptr;
    reg [7:0] pwdata;
    wire flag_empty, flag_full;
    wire [7:0] txdata;



    TxFIFO TxFIFO_instance(
        .psel(psel),
        .pwrite(pwrite),
        .clr_b(clr_b),
        .pclk(pclk),
        .inc_ptr(inc_ptr),
        .pwdata(pwdata),
        .txdata(txdata),
        .flag_empty(flag_empty),
        .flag_full(flag_full)
    );

    initial begin
        inc_ptr= 1'b0;
        pclk = 0;
        clr_b = 1'b1;
        clr_b = 1'b0;
        psel = 1'b1;
        #20
        $display("full: %b | empty: %b", flag_full, flag_empty);


        pwrite = 1'b1;
        pwdata = 8'ha2;


        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        pwrite = 1'b0;

        #50
        pwrite = 1'b1;
        pwdata = 8'hc3;

        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        pwrite = 1'b0;

        #50
        pwrite = 1'b1;
        pwdata = 8'hff;

        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        pwrite = 1'b0;

        #50
        pwrite = 1'b1;
        pwdata = 8'hcc;

        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);


        //Read time! 

        pwrite = 1'b0;
        inc_ptr= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        inc_ptr= 0;
        #1

        inc_ptr= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        inc_ptr= 0;
        #1
 //read again 
 
        pwrite = 1'b1;
        pwdata = 8'hbb;


        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        pwrite = 1'b0;

        #50
        pwrite = 1'b1;
        pwdata = 8'h12;

        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        pwrite = 1'b0;

//read all out
        pwrite = 1'b0;
        inc_ptr= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        inc_ptr= 0;
        #1

        inc_ptr= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        inc_ptr= 0;
        #1
    inc_ptr= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        inc_ptr= 0;
        #1

        inc_ptr= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        inc_ptr= 0;
        #1


        $stop;

    end

    always begin
        #5 pclk = ~pclk;
    end


endmodule