LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY full_adder IS 
    PORT( 
        A, B, Cin:  IN std_logic;
        Sum, Cout:  OUT std_logic
    );
END full_adder;

ARCHITECTURE full_adder_arch OF full_adder IS
BEGIN 
    Sum <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (B AND Cin) OR (A AND Cin);
END full_adder_arch;