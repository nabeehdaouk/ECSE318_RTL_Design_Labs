module ssp_tb ();

    reg psel, pwrite, clr_b, pclk;
    reg [7:0] pwdata;
    wire [7:0] prdata;
    wire ssptxintr, ssprxintr, sspoe_b;



    ssp ssp_instance(
        .psel(psel),
        .pwrite(pwrite),
        .clr_b(clr_b),
        .pclk(pclk),
        .pwdata(pwdata),
        .ssptxintr(ssptxintr),
        .ssprxintr(ssprxintr),
        .sspoe_b(sspoe_b),
        .prdata(prdata)
    );

    initial begin
    $display("This testbench will load 4 bytes of data into the SSP");
    $display("The transmit output of the SSP is connected to the \n serial input of the recieve side");
    $display("By toggeleing the correct signals, we can send data in, and \n expect paralell data to be returned to the processor");
    $display("This testbench will also monitor the interupt signals \n alert the signal trigger via the console");
        pclk = 1'b0;
        clr_b = 1'b1;
        psel = 1'b0;
        #20
        clr_b = 1'b0;
        #10
        #10 pwrite = 1'b1;

        $display("TRANSMITING DATA...");
        $display("SSP set in transmit mode");
        // Loading T FIFO data and transmitting
        pwdata = 8'h00;
        #10
        $display("TRANSMITING BYTE: %h = %b",pwdata,pwdata );
        psel = 1'b1;
        #10

        pwdata = 8'hd3;
        #10
        $display("TRANSMITING BYTE: %h = %b",pwdata,pwdata );
        pwdata = 8'ha7;
        #10
        $display("TRANSMITING BYTE: %h = %b",pwdata,pwdata );
        pwdata = 8'hff;
        #10
        $display("TRANSMITING BYTE: %h = %b",pwdata,pwdata );
        pwdata = 8'h12;
        #10
        $display("TRANSMITING BYTE: %h = %b",pwdata,pwdata );

        psel = 1'b0;
        #400

        // Receiving data
        pwrite = 1'b0;
        $display();
        $display("RECIEVING DATA...");
        $display("SSP set in recieve mode");
        #500 //time to serialize and then parallelize (unload and load FIFOs)

        // Pulling in and displaying data from R FIFO
        #10 psel = 1'b1;
        #10 $display("BYTE RECIEVED: %h = %b", prdata, prdata);
        #10 $display("BYTE RECIEVED: %h = %b", prdata, prdata);
        #10 $display("BYTE RECIEVED: %h = %b", prdata, prdata);
        #10 $display("BYTE RECIEVED: %h = %b", prdata, prdata);
        
        


        $stop;
    end


    always #5 pclk = ~pclk;
    
    always @(posedge ssptxintr)
    begin
        $display($time, "          SSPTX_INTR triggered (AKA: TxFIFO is EMPTY)");
    end
    
     always @(posedge ssprxintr)
    begin
        $display($time, "          SSPrX_INTR triggered (AKA: RxFIFO is FULL)");
        end


endmodule