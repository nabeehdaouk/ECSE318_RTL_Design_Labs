library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NBitCSA is
    generic (
        N : positive := 8
    );
    port (
        A     : in  std_logic_vector(N - 1 downto 0);
        B     : in  std_logic_vector(N - 1 downto 0);
        C     : in  std_logic_vector(N - 1 downto 0);
        S     : out std_logic_vector(N - 1 downto 0);
        Carry : out std_logic_vector(N downto 0)
    );
end entity NBitCSA;

architecture Behavioral of NBitCSA is
    signal Carry_bs : std_logic_vector(N downto 0);
begin
    carry_generation: for i in 0 to (N - 1) generate
        S(i) <= A(i) xor B(i) xor C(i);
        Carry_bs(i) <= (A(i) and B(i)) or (A(i) and C(i)) or (B(i) and C(i));
    end generate;

    Carry <= Carry_bs(N - 1 downto 0) & '0';
end architecture Behavioral;
