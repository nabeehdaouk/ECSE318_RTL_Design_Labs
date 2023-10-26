module FreeCell(
    input clk,
    input [3:0] source, dest,
    output win
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




    reg [5:0] tableau[7:0][6:0];

    initial begin
        // Col 0
        tableau[0][0] = {s, four};
        tableau[0][1] = {d, jack};
        tableau[0][2] = {d, ten};
        tableau[0][3] = {d, six};
        tableau[0][4] = {s, three};
        tableau[0][5] = {d, ace};
        tableau[0][6] = {h, ace};
        
        // Col 1
        tableau[1][0] = {s, five};
        tableau[1][1] = {s, ten};      
        tableau[1][2] = {h, eight};      
        tableau[1][3] = {c, four};      
        tableau[1][4] = {h, six};      
        tableau[1][5] = {h, king};      
        tableau[1][6] = {h, two};     
        
        // Col 2
        tableau[2][0] = {s, jack};
        tableau[2][1] = {c, seven};
        tableau[2][2] = {c, nine};
        tableau[2][3] = {c, six};
        tableau[2][4] = {c, two};
        tableau[2][5] = {s, king};
        tableau[2][6] = {c, ace};
        
        // Col 3
        tableau[3][0] = {h, four};
        tableau[3][1] = {s, ace};      
        tableau[3][2] = {c, queen};      
        tableau[3][3] = {c, five};      
        tableau[3][4] = {s, seven};      
        tableau[3][5] = {h, nine};      
        tableau[3][6] = {s, eight};    
        
        // Col 4
        tableau[4][0] = {d, queen};
        tableau[4][1] = {h, jack};
        tableau[4][2] = {s, queen};
        tableau[4][3] = {s, six};
        tableau[4][4] = {d, two};
        tableau[4][5] = {s, nine};
        //tableau[4][6] = {};
        
        // Col 5
        tableau[4][0] = {d, five};
        tableau[4][1] = {d, king};      
        tableau[4][2] = {c, three};      
        tableau[4][3] = {d, nine};      
        tableau[4][4] = {h, three};      
        tableau[4][5] = {s, two};      
        //tableau[4][6] = {}; 
        
        // Col 6
        tableau[6][0] = {h, five};
        tableau[6][1] = {d, three};
        tableau[6][2] = {h, queen};
        tableau[6][3] = {d, seven};
        tableau[6][4] = {c, king};
        tableau[6][5] = {c, ten};
        //tableau[6][6] = {};
        
        // Col 7
        tableau[7][0] = {c, jack};
        tableau[7][1] = {d, four};      
        tableau[7][2] = {h, ten};      
        tableau[7][3] = {c, eight};      
        tableau[7][4] = {h, seven};      
        tableau[7][5] = {d, eight};      
       // tableau[7][6] = {};   

    
    end



















endmodule