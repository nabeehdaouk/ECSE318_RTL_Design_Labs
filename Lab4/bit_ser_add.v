module bit_ser_add (
    input clk, A, B, clr_n, set_n,
    output reg [8:0] result
);

    reg carry_reg;
    reg [7:0] addend, augand;

    always @ (posedge clk)
    begin
        if (clr_n == 1'b0)
            begin
                carry_reg <= 1'b0;
                addend <= 8'b00000000;
                augand <= 8'b00000000;
                result <= 8'b00000000;
            end
        else if (set_n == 1'b1) // loading
            begin
                addend[7:0] <= {A, addend[7:1]};
                augand[7:0] <= {B, augand[7:1]};
            end
        else if (set_n == 1'b0) // operating
        begin
            carry_reg <= (addend[0] & augand[0]) | (augand[0] & carry_reg) | (addend[0] & carry_reg);
            augand[7:0] <= {1'b0, augand[7:1]};
            addend[7:0] <= {1'b0, addend[7:1]};
            result[8:0] <= {(addend[0] ^ augand[0] ^ carry_reg) , result[8:1]};

        end
    end
endmodule