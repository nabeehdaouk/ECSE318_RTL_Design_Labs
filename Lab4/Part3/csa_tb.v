`timescale 1ps/1fs // Set timescale to 1 nanosecond with 1 picosecond precision

module csa_tb(

);
    reg [7:0] a, b, c, d, e, f, g, h, i, j;
    wire [17:0] s;

    csa csa_instance(
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .s(s)
    );

    initial begin
        $display("Test addition problem 1:");
        a = 'd11;
        b = 'd2;
        c = 'd13;
        d = 'd4;
        e = 'd5;
        f = 'd6;
        g = 'd7;
        h = 'd8;
        i = 'd9;
        j = 'd10;
        #100    $display("A: %b +  B:%b + C:%b + D:%b + E:%b + F:%b + G:%b + H:%b + I:%b + J:%b = Sum:%b", a, b, c, d, e, f, g, h, i, j, s);
        $display("A: %d +  B:%d + C:%d + D:%d + E:%d + F:%d + G:%d + H:%d + I:%d + J:%d = Sum:%d", a, b, c, d, e, f, g, h, i, j, s);
        $display;
        $display("Test addition problem 2:");
        a = 'd3;
        b = 'd14;
        c = 'd5;
        d = 'd6;
        e = 'd7;
        f = 'd8;
        g = 'd19;
        h = 'd10;
        i = 'd0;
        j = 'd0;
        #100    $display("A: %b +  B:%b + C:%b + D:%b + E:%b + F:%b + G:%b + H:%b + I:%b + J:%b = Sum:%b", a, b, c, d, e, f, g, h, i, j, s);
        $display("A: %d +  B:%d + C:%d + D:%d + E:%d + F:%d + G:%d + H:%d + I:%d + J:%d = Sum:%d", a, b, c, d, e, f, g, h, i, j, s);
        $display;
        $display("Test additional example:");
        a = 'd30;
        b = 'd22;
        c = 'd19;
        d = 'd126;
        e = 'd5;
        f = 'd92;
        g = 'd69;
        h = 'd44;
        i = 'd1;
        j = 'd10;
        #100    $display("A: %b +  B:%b + C:%b + D:%b + E:%b + F:%b + G:%b + H:%b + I:%b + J:%b = Sum:%b", a, b, c, d, e, f, g, h, i, j, s);
        $display("A: %d +  B:%d + C:%d + D:%d + E:%d + F:%d + G:%d + H:%d + I:%d + J:%d = Sum:%d", a, b, c, d, e, f, g, h, i, j, s);
        $display;
        $display("Test additional example:");
        a = 'd255;
        b = 'd255;
        c = 'd255;
        d = 'd255;
        e = 'd255;
        f = 'd255;
        g = 'd255;
        h = 'd255;
        i = 'd255;
        j = 'd254;
        #100    $display("A: %b +  B:%b + C:%b + D:%b + E:%b + F:%b + G:%b + H:%b + I:%b + J:%b = Sum:%b", a, b, c, d, e, f, g, h, i, j, s);
        $display("A: %d +  B:%d + C:%d + D:%d + E:%d + F:%d + G:%d + H:%d + I:%d + J:%d = Sum:%d", a, b, c, d, e, f, g, h, i, j, s);
    end

endmodule : csa_tb
