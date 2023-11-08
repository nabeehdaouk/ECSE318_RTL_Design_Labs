library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity csa is
    Port(
        a : in  std_logic_vector(7 downto 0);
        b : in  std_logic_vector(7 downto 0);
        c : in  std_logic_vector(7 downto 0);
        d : in  std_logic_vector(7 downto 0);
        e : in  std_logic_vector(7 downto 0);
        f : in  std_logic_vector(7 downto 0);
        g : in  std_logic_vector(7 downto 0);
        h : in  std_logic_vector(7 downto 0);
        i : in  std_logic_vector(7 downto 0);
        j : in  std_logic_vector(7 downto 0);
        s : out std_logic_vector(17 downto 0)
    );
end entity csa;

architecture Behavioral of csa is
    signal s8            : std_logic_vector(7 downto 0);
    signal s9            : std_logic_vector(8 downto 0);
    signal c8            : std_logic_vector(8 downto 0);
    signal s10           : std_logic_vector(9 downto 0);
    signal c9            : std_logic_vector(9 downto 0);
    signal s11           : std_logic_vector(10 downto 0);
    signal c10           : std_logic_vector(10 downto 0);
    signal s12           : std_logic_vector(11 downto 0);
    signal c11           : std_logic_vector(11 downto 0);
    signal s13           : std_logic_vector(12 downto 0);
    signal c12           : std_logic_vector(12 downto 0);
    signal s14           : std_logic_vector(13 downto 0);
    signal c13           : std_logic_vector(13 downto 0);
    signal s15           : std_logic_vector(14 downto 0);
    signal c14           : std_logic_vector(14 downto 0);
    signal c15           : std_logic_vector(15 downto 0);
    signal s_a9, s_c9    : std_logic_vector(8 downto 0);
    signal s_a10, s_c10  : std_logic_vector(9 downto 0);
    signal s_a11, s_c11  : std_logic_vector(10 downto 0);
    signal s_a12, s_c12  : std_logic_vector(11 downto 0);
    signal s_a13, s_c13  : std_logic_vector(12 downto 0);
    signal s_a14, s_c14  : std_logic_vector(13 downto 0);
    signal s_a15, s_c15  : std_logic_vector(14 downto 0);
    signal s_s15, s2_c15 : std_logic_vector(17 downto 0);

    component NBitCSA
        generic(
            N : positive := 8
        );
        Port(
            A     : in  std_logic_vector(N - 1 downto 0);
            B     : in  std_logic_vector(N - 1 downto 0);
            C     : in  std_logic_vector(N - 1 downto 0);
            S     : out std_logic_vector(N - 1 downto 0);
            Carry : out std_logic_vector(N downto 0)
        );
    end component;

    component n_bit_adder
        generic(
            N : positive := 8
        );
        PORT(
            A, B : IN  std_logic_vector(N - 1 downto 0);
            Cin  : IN  std_logic;
            Sum  : OUT std_logic_vector(N - 1 downto 0);
            Cout : OUT std_logic
        );
    end component;

begin
    BitCSA_instance8 : NBitCSA
        generic map(N => 8)
        port map(
            A     => a,
            B     => b,
            C     => c,
            S     => s8,
            Carry => c8
        );

    BitCSA_instance9 : NBitCSA
        generic map(N => 9)
        port map(
            A     => s_a9,
            B     => c8,
            C     => s_c9,
            S     => s9,
            Carry => c9
        );

    BitCSA_instance10 : NBitCSA
        generic map(N => 10)
        port map(
            A     => s_a10,
            B     => c9,
            C     => s_c10,
            S     => s10,
            Carry => c10
        );

    BitCSA_instance11 : NBitCSA
        generic map(N => 11)
        port map(
            A     => s_a11,
            B     => c10,
            C     => s_c11,
            S     => s11,
            Carry => c11
        );

    BitCSA_instance12 : NBitCSA
        generic map(N => 12)
        port map(
            A     => s_a12,
            B     => c11,
            C     => s_c12,
            S     => s12,
            Carry => c12
        );

    BitCSA_instance13 : NBitCSA
        generic map(N => 13)
        port map(
            A     => s_a13,
            B     => c12,
            C     => s_c13,
            S     => s13,
            Carry => c13
        );

    BitCSA_instance14 : NBitCSA
        generic map(N => 14)
        port map(
            A     => s_a14,
            B     => c13,
            C     => s_c14,
            S     => s14,
            Carry => c14
        );

    BitCSA_instance15 : NBitCSA
        generic map(N => 15)
        port map(
            A     => s_a15,
            B     => c14,
            C     => s_c15,
            S     => s15,
            Carry => c15
        );

    FinalAddition: n_bit_adder
        generic map(N => 18)
        port map( --ignore carry out bit
            A    => s_s15,
            B    => s2_c15,
            Cin  => '0',
            Sum  => s
        );


    process(d, e, f, g, h, i, j, s10, s11, s12, s13, s14, s8, s9, s15, c15)
    begin
        s_a9 <= '0' & s8;
        s_c9 <= '0' & d;

        s_a10 <= '0' & s9;
        s_c10 <= "00" & e;

        s_a11 <= '0' & s10;
        s_c11 <= "000" & f;

        s_a12 <= '0' & s11;
        s_c12 <= "0000" & g;

        s_a13 <= '0' & s12;
        s_c13 <= "00000" & h;

        s_a14 <= '0' & s13;
        s_c14 <= "000000" & i;

        s_a15 <= '0' & s14;
        s_c15 <= "0000000" & j;
        
        s_s15 <= "000" & s15; 
        s2_c15<= "00" & c15;

    end process;

end architecture Behavioral;

