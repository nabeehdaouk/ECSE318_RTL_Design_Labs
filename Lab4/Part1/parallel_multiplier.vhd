library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parallel_multiplier is
    Port (
        x : in STD_LOGIC_VECTOR(3 downto 0);
        y : in STD_LOGIC_VECTOR(3 downto 0);
        p : out STD_LOGIC_VECTOR(7 downto 0)
    );
end parallel_multiplier;

architecture Behavioral of parallel_multiplier is
    signal s_out_x0, s_out_x1, s_out_x2, s_out_x3 : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal c_out_x0, c_out_x1, c_out_x2, c_out_x3 : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal ab_x0, ab_x1, ab_x2, ab_x3 : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal CI : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
begin
    process(x, y)
    begin
        for i in 0 to 3 loop
            ab_x0(i) <= y(i) and x(0);
            (c_out_x0(i), s_out_x0(i)) <= ('0' & ab_x0(i));

            ab_x1(i) <= y(i) and x(1);
            (c_out_x1(i), s_out_x1(i)) <= ('0' & ab_x1(i)) + c_out_x0(i) + s_out_x0(i);

            ab_x2(i) <= y(i) and x(2);
            (c_out_x2(i), s_out_x2(i)) <= ('0' & ab_x2(i)) + c_out_x1(i) + s_out_x1(i);

            ab_x3(i) <= y(i) and x(3);
            (c_out_x3(i), s_out_x3(i)) <= ('0' & ab_x3(i)) + c_out_x2(i) + s_out_x2(i);

            (CI(i+1), p(i+4)) <= '0' & (c_out_x3(i) + s_out_x3(i)) & s_out_x0(0);
        end loop;
    end process;

    p(0) <= s_out_x0(0);
    p(1) <= s_out_x1(0);
    p(2) <= s_out_x2(0);
    p(3) <= s_out_x3(0);
    p(4) <= CI(4);
    p(5) <= CI(3);
    p(6) <= CI(2);
    p(7) <= CI(1);
end Behavioral;
