LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY full_subtractor IS
PORT (
    A, B, Bin:  IN std_logic;
    Diff, Bout: OUT std_logic
);

END full_subtractor;

Architecture full_subtractor_arch OF full_subtractor IS

BEGIN
    Diff <= A XOR B XOR Bin;
    Bout <= ((NOT A) AND B) OR ((NOT A) AND Bin) OR (B AND Bin);
END full_subtractor_arch;