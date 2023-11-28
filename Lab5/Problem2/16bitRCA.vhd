library IEEE;
use IEEE.std_logic_1164.ALL;

ENTITY sixteen_bit_RCA IS
    -- No generics needed for top-level instantiation
    PORT(
        A, B:   IN std_logic_vector (15 downto 0);
        Cin:    IN std_logic;
        Sum:    OUT std_logic_vector (15 downto 0);
        Cout:   OUT std_logic
    );
END sixteen_bit_RCA;

ARCHITECTURE top_level_arch OF sixteen_bit_RCA IS
    -- Instantiate n_bit_adder with n=16
    COMPONENT n_bit_adder
        GENERIC(n: INTEGER := 16); -- Set n to 16
        PORT( 
            A, B:   IN std_logic_vector (15 downto 0);
            Cin:    IN std_logic;
            Sum:    OUT std_logic_vector (15 downto 0);
            Cout:   OUT std_logic
        );
    END COMPONENT;

BEGIN
    -- Instantiate n_bit_adder with n=16
    U16bit: n_bit_adder GENERIC MAP (n => 16)
        PORT MAP (
            A => A,
            B => B,
            Cin => Cin,
            Sum => Sum,
            Cout => Cout
        );
END top_level_arch;
