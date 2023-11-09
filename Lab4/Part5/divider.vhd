library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Divider is
    Port(
        Dividend, Divisor_in : in  STD_LOGIC_VECTOR(3 downto 0);
        Quotient, Remainder  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity Divider;

architecture Behavioral of Divider is
    signal Int_Divisor                : STD_LOGIC_VECTOR(4 downto 0);
    signal B_In3, B_In2, B_In1, B_In0 : STD_LOGIC_VECTOR(5 downto 0);
    signal D4, D3, D2, D1, D0         : STD_LOGIC_VECTOR(5 downto 0);

    component BitSubtractor is
        Port(
            y, x, b_i, os : in  STD_LOGIC;
            b_o, d        : out STD_LOGIC
        );
    end component BitSubtractor;

begin
    -- Initialize signals
    Int_Divisor <= '0' & Divisor_in;
    B_In3(0)          <= '0';
    B_In2(0)          <= '0';
    B_In1(0)          <= '0';
    B_In0(0)          <= '0';
    D4(4 downto 1) <= "0000";
    D4(0)          <= Dividend(3);
    D3(0)          <= Dividend(2);
    D2(0)          <= Dividend(1);
    D1(0)          <= Dividend(0);

    -- Level 3
    bs : for i in 0 to 4 generate
        BitSubtractor_3 : BitSubtractor
            Port Map(
                y   => Int_Divisor(i),
                x   => D4(i),
                b_i => B_In3(i),
                os  => B_In3(5),
                b_o => B_In3(i + 1),
                d   => D3(i + 1)
            );

        -- Level 2
        BitSubtractor_2 : BitSubtractor
            Port Map(
                y   => Int_Divisor(i),
                x   => D3(i),
                b_i => B_In2(i),
                os  => B_In2(5),
                b_o => B_In2(i + 1),
                d   => D2(i + 1)
            );

        -- Level 1
        BitSubtractor_1 : BitSubtractor
            Port Map(
                y   => Int_Divisor(i),
                x   => D2(i),
                b_i => B_In1(i),
                os  => B_In1(5),
                b_o => B_In1(i + 1),
                d   => D1(i + 1)
            );

        -- Level 0
        BitSubtractor_0 : BitSubtractor
            Port Map(
                y   => Int_Divisor(i),
                x   => D1(i),
                b_i => B_In0(i),
                os  => B_In0(5),
                b_o => B_In0(i + 1),
                d   => D0(i + 1)
            );
    end generate;
    -- Assign quotient and remainder
    Quotient  <= not (B_In3(5) & B_In2(5) & B_In1(5) & B_In0(5));
    Remainder <= D0(4 downto 1);
end architecture Behavioral;
