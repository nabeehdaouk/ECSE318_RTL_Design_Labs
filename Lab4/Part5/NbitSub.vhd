LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY n_bit_subtractor IS 
    GENERIC(n: INTEGER :=8);
    PORT( 
        A, B:   IN std_logic_vector (n-1 downto 0);
        Bin:    IN std_logic;
        Diff:   OUT std_logic_vector (n-1 downto 0);
        Bout:   OUT std_logic
    );
END n_bit_subtractor;

ARCHITECTURE n_bit_subtractor_arch of n_bit_subtractor is
    COMPONENT full_subtractor PORT(
    A, B, Bin:  IN std_logic;
    Diff, Bout: OUT std_logic);
    END COMPONENT;


signal borrow: std_logic_vector(n downto 0);

BEGIN
    borrow(0) <=Bin;
    Bout <= borrow(n);

FS: for i in 0 to n-1 generate
    FS_i: full_subtractor PORT MAP (A(i), B(i), borrow(i), Diff(i), borrow(i+1));
end generate;

END;