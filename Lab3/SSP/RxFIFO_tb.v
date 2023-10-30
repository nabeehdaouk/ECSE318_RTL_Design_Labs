module RxFIFO_tb ();

    reg psel, pwrite, clr_b, pclk, read_en;
    reg [7:0] pwdata;
    wire flag_empty, flag_full;
    wire [7:0] txdata;



    RxFIFO RxFIFO_instance(
        .psel(psel),
        .pwrite(pwrite),
        .clr_b(clr_b),
        .pclk(pclk),
        .read_en(read_en),
        .rxdata(pwdata),
        .prdata(txdata),
        .flag_empty(flag_empty),
        .flag_full(flag_full)
    );

    initial begin
        psel= 1'b0;
        pclk = 0;
        clr_b = 1'b1;
        clr_b = 1'b0;
        psel = 1'b0;
        pwrite = 1'b0;

        #20
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display("START");

        read_en = 1'b1;
        pwdata = 8'ha2;


        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        read_en = 1'b0;

        #50
        read_en = 1'b1;
        pwdata = 8'hc3;

        #50
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();
        read_en = 1'b0;

        #50
        read_en = 1'b1;
        pwdata = 8'hff;

        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();
        read_en = 1'b0;

        #50
        read_en = 1'b1;
        pwdata = 8'hcc;

        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();
        
        


        //Read time! 


        read_en = 0;
        psel= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        psel= 0;
        #1

        psel= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        psel= 0;
        #1

        //write again 

        read_en = 1'b1;
        pwdata = 8'hbb;


        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        read_en = 1'b0;

        #50
        read_en = 1'b1;
        pwdata = 8'h12;

        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();
        read_en = 1'b0;
        
         #50
        read_en = 1'b1;
        pwdata = 8'h37;

        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        read_en = 1'b0;

        //read all out
        read_en = 1'b0;
        psel= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        psel= 0;
        #1

        psel= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        psel= 0;
        #1
        psel= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        psel= 0;
        #1

        psel= 1;
        #10
        $display("tx_data: %h", txdata);
        $display("full: %b | empty: %b", flag_full, flag_empty);
        $display();

        psel= 0;
        #1


        $stop;

    end

    always begin
        #5 pclk = ~pclk;
    end


endmodule