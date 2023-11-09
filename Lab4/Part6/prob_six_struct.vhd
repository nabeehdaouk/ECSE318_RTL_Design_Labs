library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity prob_six_struct is
    Port(
        out1 : out STD_LOGIC;
        clk : in STD_LOGIC;
        E : in STD_LOGIC;
        W : in STD_LOGIC
        
    );
end entity prob_six_struct;

architecture Behavioral of prob_six_struct is
    signal b0, b1, b2, b3, b4, b5 : STD_LOGIC;
    signal q1 : STD_LOGIC := '0';
    signal q2 : STD_LOGIC := '0';
begin
    b0<= q1 and (not q2);
    b1<= q1 and W;
    b2<= E or b0 or b1;
    
    b3<= q2 and (not q1);
    b4<= q2 and E;
    b5<= W or b3 or b4;
    
    out1 <= (not q1) and (not q2);
    
    process (clk)
    begin
        if rising_edge(clk) then
            q1 <= b2;
            q2 <= b5;
        end if;
    end process;

end architecture Behavioral;
