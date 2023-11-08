library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity parallel_multiplier is
    Port(
        x : in  std_logic_vector(3 downto 0);
        y : in  std_logic_vector(3 downto 0);
        p : out std_logic_vector(7 downto 0)
    );
end parallel_multiplier;

architecture BehavioralPar of parallel_multiplier is
    
    COMPONENT full_adder
        PORT(
            A, B, Cin : IN  std_logic;
            Sum, Cout : OUT std_logic);
    END COMPONENT;

    signal s_out_x0, s_out_x1, s_out_x2, s_out_x3 : std_logic_vector(4 downto 0);
    signal c_out_x0, c_out_x1, c_out_x2, c_out_x3 : std_logic_vector(3 downto 0);
    signal ab_x0, ab_x1, ab_x2, ab_x3             : std_logic_vector(3 downto 0);
    signal CI                                     : std_logic_vector(4 downto 0);

begin
    CI(0)       <= '0';
    s_out_x0(4) <= '0';
    s_out_x1(4) <= '0';
    s_out_x2(4) <= '0';
    s_out_x3(4) <= '0';

    fa : for i in 0 to 3 generate
        ab_x0(i) <= y(i) and x(0);
        fa0 : full_adder
            port map(
                A    => ab_x0(i),
                B    => '0',
                Cin  => '0',
                Sum  => s_out_x0(i),
                Cout => c_out_x0(i)
            );
        ab_x1(i) <= y(i) and x(1);

        fa1 : full_adder
            port map(
                A    => ab_x1(i),
                B    => c_out_x0(i),
                Cin  => s_out_x0(i + 1),
                Sum  => s_out_x1(i),
                Cout => c_out_x1(i)
            );
        ab_x2(i) <= y(i) and x(2);

        fa2 : full_adder
            port map(
                A    => ab_x2(i),
                B    => c_out_x1(i),
                Cin  => s_out_x1(i + 1),
                Sum  => s_out_x2(i),
                Cout => c_out_x2(i)
            );
        ab_x3(i) <= y(i) and x(3);

        fa3 : full_adder
            port map(
                A    => ab_x3(i),
                B    => c_out_x2(i),
                Cin  => s_out_x2(i + 1),
                Sum  => s_out_x3(i),
                Cout => c_out_x3(i)
            );
        fa4 : full_adder
            port map(
                A    => c_out_x3(i),
                B    => s_out_x3(i + 1),
                Cin  => CI(i),
                Sum  => p(i + 4),
                Cout => CI(i + 1)
            );
        p(0) <= s_out_x0(0);
        p(1) <= s_out_x1(0);
        p(2) <= s_out_x2(0);
        p(3) <= s_out_x3(0);
    end generate;

    process(s_out_x0(0), s_out_x1(0), s_out_x2(0), s_out_x3(0), s_out_x3(1), s_out_x3(2), s_out_x3(3))
    begin
        p(0) <= s_out_x0(0);
        p(1) <= s_out_x1(0);
        p(2) <= s_out_x2(0);
        p(3) <= s_out_x3(0);
        p(4) <= s_out_x3(0);
        p(5) <= s_out_x3(1);
        p(6) <= s_out_x3(2);
        p(7) <= s_out_x3(3);
    end process;
end BehavioralPar;
