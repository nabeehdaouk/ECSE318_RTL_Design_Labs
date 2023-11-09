library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullSubtractor is
    Port (
        A, B, BorrowIn : in STD_LOGIC;
        Difference, BorrowOut : out STD_LOGIC
    );
end entity FullSubtractor;

architecture Behavioral of FullSubtractor is
begin
    Difference <= A XOR B XOR BorrowIn;
    BorrowOut <= (A AND (NOT B) AND (NOT BorrowIn)) OR ((NOT A) AND B AND BorrowIn);
end architecture Behavioral;
