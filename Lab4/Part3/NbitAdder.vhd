LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY n_bit_adder IS 
    GENERIC(n: INTEGER :=8);
    PORT( 
        A, B:   IN std_logic_vector (n-1 downto 0);
        Cin:    IN std_logic;
        Sum:    OUT std_logic_vector (n-1 downto 0);
        Cout:   OUT std_logic
    );
END n_bit_adder;

ARCHITECTURE n_bit_adder_arch OF n_bit_adder IS
    COMPONENT full_adder PORT(
    A, B, Cin:  IN std_logic;
    Sum, Cout:  OUT std_logic);
    END COMPONENT;


signal carry: std_logic_vector(n downto 0);

BEGIN
    carry(0) <=Cin;
    Cout <= carry(n);

FS: for i in 0 to n-1 generate
    FS_i: full_adder PORT MAP (A(i), B(i), carry(i), Sum(i), carry(i+1));
end generate;

END;
