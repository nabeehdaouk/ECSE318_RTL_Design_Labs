module FreeCell(
    input clk,
    input [3:0] source, dest,
    output reg win, illegal
);
    localparam s=2'b00; //spade
    localparam c=2'b01; //club
    localparam h=2'b10; //heart
    localparam d=2'b11; //diomond

    localparam ace   = 4'b0001;
    localparam two   = 4'b0010;
    localparam three = 4'b0011;
    localparam four  = 4'b0100;
    localparam five  = 4'b0101;
    localparam six   = 4'b0110;
    localparam seven = 4'b0111;
    localparam eight = 4'b1000;
    localparam nine  = 4'b1001;
    localparam ten   = 4'b1010;
    localparam jack  = 4'b1011;
    localparam queen = 4'b1100;
    localparam king  = 4'b1101;

    integer i;

    reg [5:0] tableau[7:0][21:0];
    reg [3:0] home_cells[3:0]; // Array to store home cells used as COUNTRER S,C,H,D
    reg [5:0] free_cells[3:0]; // Array to store free cell card


    always @(posedge clk) begin
        casez({source, dest})
            ({4'b0???, 4'b0???}): //col to col
            begin
                if (((tableau[dest[2:0]][0][3:0]==((tableau[source[2:0]][0][3:0]) +1'b1)) && (tableau[dest[2:0]][0][5] != tableau[source[2:0]][0][5])) || ((tableau[dest[2:0]][0] == 6'b000000)))
                    begin//IF card denominations are 1 apart AND NOT the same color, OR dest is empty
                        tableau[dest[2:0]][0]<= tableau[source[2:0]][0];

                        for (i = 21; i > 0; i = i - 1) begin
                            tableau[dest[2:0]][i] <= tableau[dest[2:0]][i-1];
                        end

                        for (i = 0; i < 21; i = i + 1) begin
                            tableau[source[2:0]][i] <= tableau[source[2:0]][i+1];
                        end

                        illegal<= 1'b0;
                    end else begin
                    illegal<= 1'b1;
                end
            end


            ({4'b0???, 4'b10??}): //col to free_cell
            begin
                if (free_cells[dest[1:0]] == 6'b000000)
                    begin//IF dest is OPEN/free
                        free_cells[dest[1:0]]<= tableau[source[2:0]][0];
                        for (i = 0; i < 21; i = i + 1) begin
                            tableau[source[2:0]][i] <= tableau[source[2:0]][i+1];
                        end
                        illegal<= 1'b0;
                    end
                else
                    begin
                        illegal<= 1'b1;
                    end
            end

            ({4'b0???, 4'b11??}): //col to home_cell
            begin
                case ((tableau[source[2:0]][0][5:4]))////sort each card into its own home cell stack IF denomination is 1 above, free cell used as counter
                    s:
                    begin
                        if (home_cells[s]==((tableau[source[2:0]][0][3:0]) - 1'b1))
                            begin
                                home_cells[s]<= home_cells[s]+1'b1;
                                for (i = 0; i < 21; i = i + 1) begin
                                    tableau[source[2:0]][i] <= tableau[source[2:0]][i+1];
                                end
                                illegal<= 1'b0;
                            end
                        else
                            begin illegal<= 1'b1;
                            end
                    end

                    c:
                    begin
                        if (home_cells[c]==((tableau[source[2:0]][0][3:0]) - 1'b1))
                            begin
                                home_cells[c]<= home_cells[c]+1'b1;
                                for (i = 0; i < 21; i = i + 1) begin
                                    tableau[source[2:0]][i] <= tableau[source[2:0]][i+1];
                                end
                                illegal<= 1'b0;
                            end
                        else
                            begin illegal<= 1'b1;
                            end
                    end

                    h:
                    begin
                        if (home_cells[h]==((tableau[source[2:0]][0][3:0]) - 1'b1))
                            begin
                                home_cells[h]<= home_cells[h]+1'b1;
                                for (i = 0; i < 21; i = i + 1) begin
                                    tableau[source[2:0]][i] <= tableau[source[2:0]][i+1];
                                end
                                illegal<= 1'b0;
                            end
                        else
                            begin illegal<= 1'b1;
                            end
                    end

                    d:
                    begin
                        if (home_cells[d]==((tableau[source[2:0]][0][3:0]) - 1'b1))
                            begin
                                home_cells[d]<= home_cells[d]+1'b1;
                                for (i = 0; i < 21; i = i + 1) begin
                                    tableau[source[2:0]][i] <= tableau[source[2:0]][i+1];
                                end
                                illegal<= 1'b0;
                            end
                        else
                            begin illegal<= 1'b1;
                            end
                    end
                endcase
            end

            ({4'b10??, 4'b0???}): //free_cell to col
            begin
                if ((free_cells[source[1:0]] != 6'b000000) && ((tableau[dest[2:0]][0]==6'b000000)||(tableau[dest[2:0]][0][3:0]==((free_cells[source[1:0]][3:0]) +1'b1)) && (tableau[dest[2:0]][0][5] != free_cells[source[1:0]][5])))
                    begin//IF source free cell is NOT empty AND EITHER card is compatible with dest (color and number) OR dest is empty
                        tableau[dest[2:0]][0] <= free_cells[source[1:0]];
                        for (i = 21; i > 0; i = i - 1) begin
                            tableau[dest[2:0]][i] <= tableau[dest[2:0]][i-1];
                        end
                        free_cells[source[1:0]]<= 6'b000000;
                        illegal<= 1'b0;
                    end
                else
                    begin
                        illegal<= 1'b1;
                    end end

            ({4'b10??, 4'b10??}): //free_cell to free_cell
            begin
                if ((free_cells[source[1:0]] != 6'b000000) && (free_cells[dest[1:0]] == 6'b000000))
                    begin//Free cell source is not empty and free cell dest is empty
                        free_cells[dest[1:0]] <= free_cells[source[1:0]];
                        free_cells[source[1:0]]<= 6'b000000;
                        illegal<= 1'b0;
                    end
                else begin
                    illegal<= 1'b1;

                end
            end

            ({4'b10??, 4'b11??}): //free_cell to home_cell
            begin
                case (free_cells[source[1:0]][5:4]) //sort each card into its own home cell stack IF denomination is 1 above, free cell used as counter
                    s:
                    begin
                        if (home_cells[s]==((free_cells[source[1:0]][3:0]) - 1'b1))
                            begin
                                home_cells[s]<= home_cells[s]+1'b1;
                                free_cells[source[1:0]]<= 6'b000000;
                                illegal<= 1'b0;
                            end
                        else
                            begin illegal<= 1'b1;
                            end
                    end

                    c:
                    begin
                        if (home_cells[c]==((free_cells[source[1:0]][3:0]) - 1'b1))
                            begin
                                home_cells[c]<= home_cells[c]+1'b1;
                                free_cells[source[1:0]]<= 6'b000000;
                                illegal<= 1'b0;
                            end
                        else
                            begin illegal<= 1'b1;
                            end
                    end

                    h:
                    begin
                        if (home_cells[h]==((free_cells[source[1:0]][3:0]) - 1'b1))
                            begin
                                home_cells[h]<= home_cells[h]+1'b1;
                                free_cells[source[1:0]]<= 6'b000000;
                                illegal<= 1'b0;
                            end
                        else
                            begin illegal<= 1'b1;
                            end
                    end

                    d:
                    begin
                        if (home_cells[d]==((free_cells[source[1:0]][3:0]) - 1'b1))
                            begin
                                home_cells[d]<= home_cells[d]+1'b1;
                                free_cells[source[1:0]]<= 6'b000000;
                                illegal<= 1'b0;
                            end
                        else
                            begin illegal<= 1'b1;
                            end
                    end
                endcase
            end

            default: //illigal
            begin
                illegal<= 1'b1;
            end

        endcase
    end

    always @(*)
    begin
        if ((home_cells[s] & home_cells[c] & home_cells[h] & home_cells[d]) == 4'b1101)
            begin
                win<= 1'b1;
            end
        else begin
            win<= 1'b0;
        end
    end
    
integer k, j;

    initial begin
        
    for (k = 0; k < 8; k = k + 1) begin
        for (j = 0; j < 22; j = j + 1) begin
            tableau[k][j] = 6'b0;
        end
    end
        free_cells[0] = 6'b0;
        free_cells[1] = 6'b0;
        free_cells[2] = 6'b0;
        free_cells[3] = 6'b0;

        home_cells[0] = 4'b0;
        home_cells[1] = 4'b0;
        home_cells[2] = 4'b0;
        home_cells[3] = 4'b0;

        win= 1'b0;
        // Col 1
        tableau[0][6] = {s, four};
        tableau[0][5] = {d, jack};
        tableau[0][4] = {d, ten};
        tableau[0][3] = {d, six};
        tableau[0][2] = {s, three};
        tableau[0][1] = {d, ace};
        tableau[0][0] = {h, ace};

        // Col 2
        tableau[1][6] = {s, five};
        tableau[1][5] = {s, ten};
        tableau[1][4] = {h, eight};
        tableau[1][3] = {c, four};
        tableau[1][2] = {h, six};
        tableau[1][1] = {h, king};
        tableau[1][0] = {h, two};

        // Col 3
        tableau[2][6] = {s, jack};
        tableau[2][5] = {c, seven};
        tableau[2][4] = {c, nine};
        tableau[2][3] = {c, six};
        tableau[2][2] = {c, two};
        tableau[2][1] = {s, king};
        tableau[2][0] = {c, ace};

        // Col 4
        tableau[3][6] = {h, four};
        tableau[3][5] = {s, ace};
        tableau[3][4] = {c, queen};
        tableau[3][3] = {c, five};
        tableau[3][2] = {s, seven};
        tableau[3][1] = {h, nine};
        tableau[3][0] = {s, eight};

        // Col 5
        tableau[4][5] = {d, queen};
        tableau[4][4] = {h, jack};
        tableau[4][3] = {s, queen};
        tableau[4][2] = {s, six};
        tableau[4][1] = {d, two};
        tableau[4][0] = {s, nine};
        //tableau[4][6] = {};

        // Col 6
        tableau[5][5] = {d, five};
        tableau[5][4] = {d, king};
        tableau[5][3] = {c, three};
        tableau[5][2] = {d, nine};
        tableau[5][1] = {h, three};
        tableau[5][0] = {s, two};
        //tableau[4][6] = {}; 

        // Col 7
        tableau[6][5] = {h, five};
        tableau[6][4] = {d, three};
        tableau[6][3] = {h, queen};
        tableau[6][2] = {d, seven};
        tableau[6][1] = {c, king};
        tableau[6][0] = {c, ten};
        //tableau[6][6] = {};

        // Col 8
        tableau[7][5] = {c, jack};
        tableau[7][4] = {d, four};
        tableau[7][3] = {h, ten};
        tableau[7][2] = {c, eight};
        tableau[7][1] = {h, seven};
        tableau[7][0] = {d, eight};
        // tableau[7][6] = {};   

    end

endmodule