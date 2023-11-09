library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity prob_six_behav is
    Port(
        out1 : out STD_LOGIC;
        clk : in STD_LOGIC;
        E : in STD_LOGIC;
        W : in STD_LOGIC
    );
end entity prob_six_behav;

architecture Behavioral of prob_six_behav is
    signal q1 : STD_LOGIC := '0';
    signal q2 : STD_LOGIC := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            q1 <= E or (q1 and not q2) or (q1 and W);
            q2 <= W or (q2 and not q1) or (q2 and E);
        end if;
    end process;

    out1 <= not q1 and not q2;

end architecture Behavioral;
