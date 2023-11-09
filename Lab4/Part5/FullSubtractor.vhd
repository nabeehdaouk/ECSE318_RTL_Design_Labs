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
    BorrowOut <= ((NOT A) AND B) OR (((NOT A) OR B) AND BorrowIn);
end architecture Behavioral;
