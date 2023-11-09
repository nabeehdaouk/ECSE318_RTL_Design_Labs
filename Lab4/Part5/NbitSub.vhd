library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BitSubtractor is
    Port (
        y, x, b_i, os : in STD_LOGIC;
        b_o, d : out STD_LOGIC
    );
end entity BitSubtractor;

architecture Behavioral of BitSubtractor is
    signal diff : STD_LOGIC;
begin
    FullSubtractor_inst : entity work.FullSubtractor
        Port Map (
            A => x,
            B => y,
            BorrowIn => b_i,
            Difference => diff,
            BorrowOut => b_o
        );

    process(diff, os, x)
    begin
        if os = '1' then
            d <= x;
        else
            d <= diff;
        end if;
    end process;
end architecture Behavioral;
