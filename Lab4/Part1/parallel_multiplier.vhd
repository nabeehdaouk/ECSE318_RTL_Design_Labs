library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity parallel_multiplier is
    Port (
        x : in std_logic_vector(3 downto 0);
        y : in std_logic_vector(3 downto 0);
        p : out std_logic_vector(7 downto 0)
    );
end parallel_multiplier;

architecture BehavioralPar of parallel_multiplier is
    signal s_out_x0, s_out_x1, s_out_x2, s_out_x3 : std_logic_vector(4 downto 0);
    signal c_out_x0, c_out_x1, c_out_x2, c_out_x3 : std_logic_vector(3 downto 0);
    signal ab_x0, ab_x1, ab_x2, ab_x3 : std_logic_vector(3 downto 0);
    signal CI : std_logic_vector(4 downto 0);
    signal temp : std_logic_vector(4 downto 0);
begin
    CI <= "00000";

    process (x, y)
    begin
        ab_x0(0) <= y(0) and x(0);
        c_out_x0(0) <= '0';
        s_out_x0(0) <= ab_x0(0);
        
        ab_x0(1) <= y(1) and x(0);
        c_out_x0(1) <= '0';
        s_out_x0(1) <= ab_x0(1);
        
        ab_x0(2) <= y(2) and x(0);
        c_out_x0(2) <= '0';
        s_out_x0(2) <= ab_x0(2);
        
        ab_x0(3) <= y(3) and x(0);
        c_out_x0(3) <= '0';
        s_out_x0(3) <= ab_x0(3);
        
        ab_x1(0) <= y(0) and x(1);
        c_out_x1(0) <= '0';
        s_out_x1(0) <= ab_x1(0);
        
        ab_x1(1) <= y(1) and x(1);
        c_out_x1(1) <= '0';
        s_out_x1(1) <= ab_x1(1);
        
        ab_x1(2) <= y(2) and x(1);
        c_out_x1(2) <= '0';
        s_out_x1(2) <= ab_x1(2);
        
        ab_x1(3) <= y(3) and x(1);
        c_out_x1(3) <= '0';
        s_out_x1(3) <= ab_x1(3);
        
        ab_x2(0) <= y(0) and x(2);
        c_out_x2(0) <= '0';
        s_out_x2(0) <= ab_x2(0);
        
        ab_x2(1) <= y(1) and x(2);
        c_out_x2(1) <= '0';
        s_out_x2(1) <= ab_x2(1);
        
        ab_x2(2) <= y(2) and x(2);
        c_out_x2(2) <= '0';
        s_out_x2(2) <= ab_x2(2);
        
        ab_x2(3) <= y(3) and x(2);
        c_out_x2(3) <= '0';
        s_out_x2(3) <= ab_x2(3);
        
        ab_x3(0) <= y(0) and x(3);
        c_out_x3(0) <= '0';
        s_out_x3(0) <= ab_x3(0);
        
        ab_x3(1) <= y(1) and x(3);
        c_out_x3(1) <= '0';
        s_out_x3(1) <= ab_x3(1);
        
        ab_x3(2) <= y(2) and x(3);
        c_out_x3(2) <= '0';
        s_out_x3(2) <= ab_x3(2);
        
        ab_x3(3) <= y(3) and x(3);
        c_out_x3(3) <= '0';
        s_out_x3(3) <= ab_x3(3);
    end process;

    process
    begin
        temp(0) <= c_out_x3(0) + s_out_x3(1) + CI(0);
        temp(1) <= c_out_x3(1) + s_out_x3(2) + CI(1);
        temp(2) <= c_out_x3(2) + s_out_x3(3) + CI(2);
        temp(3) <= c_out_x3(3) + '0' + CI(3);
        temp(4) <= '0';
        
        CI <= temp;
        
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
