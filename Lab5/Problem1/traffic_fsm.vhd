library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity traffic_fsm is
    Port ( clock, Sa, Sb, reset : in STD_LOGIC;
           Ga, Ya, Ra, Gb, Yb, Rb : out STD_LOGIC);
end traffic_fsm;

architecture Behavioral of traffic_fsm is
    -- State encodings
    constant S0 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    constant S1 : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant S2 : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant S3 : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    constant S4 : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant S5 : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    constant S6 : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    constant S7 : STD_LOGIC_VECTOR(3 downto 0) := "0111";
    constant S8 : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    constant S9 : STD_LOGIC_VECTOR(3 downto 0) := "1001";
    constant S10 : STD_LOGIC_VECTOR(3 downto 0) := "1010";
    constant S11 : STD_LOGIC_VECTOR(3 downto 0) := "1011";
    constant S12 : STD_LOGIC_VECTOR(3 downto 0) := "1100";

    signal CurrentState, NextState : STD_LOGIC_VECTOR(3 downto 0);

begin

    process (clock, reset)
    begin
        if reset = '1' then
            CurrentState <= S0;
        elsif rising_edge(clock) then
            CurrentState <= NextState;
        end if;
    end process;

    process (CurrentState, Sa, Sb)
    begin
        -- Default outputs
        Ga <= '0';
        Ya <= '0';
        Ra <= '0';
        Gb <= '0';
        Yb <= '0';
        Rb <= '0';

        -- State machine logic
        case CurrentState is
            when S0 =>
                Ga <= '1';
                Gb <= '0';
                Ya <= '0';
                Yb <= '0';
                Ra <= '0';
                Rb <= '1';
                NextState <= S1;

            when S1 =>
                Ga <= '1';
                Gb <= '0';
                Ya <= '0';
                Yb <= '0';
                Ra <= '0';
                Rb <= '1';
                NextState <= S2;

            when S2 =>
                Ga <= '1';
                Gb <= '0';
                Ya <= '0';
                Yb <= '0';
                Ra <= '0';
                Rb <= '1';
                NextState <= S3;

            when S3 =>
                Ga <= '1';
                Gb <= '0';
                Ya <= '0';
                Yb <= '0';
                Ra <= '0';
                Rb <= '1';
                NextState <= S4;

            when S4 =>
                Ga <= '1';
                Gb <= '0';
                Ya <= '0';
                Yb <= '0';
                Ra <= '0';
                Rb <= '1';
                NextState <= S5;

            when S5 =>
                Ga <= '1';
                Gb <= '0';
                Ya <= '0';
                Yb <= '0';
                Ra <= '0';
                Rb <= '1';
                if Sb = '0' then
                    NextState <= S5;
                else
                    NextState <= S6;
                end if;

            when S6 =>
                Ga <= '0';
                Gb <= '0';
                Ya <= '1';
                Yb <= '0';
                Ra <= '0';
                Rb <= '1';
                NextState <= S7;

            when S7 =>
                Ga <= '0';
                Gb <= '1';
                Ya <= '0';
                Yb <= '0';
                Ra <= '1';
                Rb <= '0';
                NextState <= S8;

            when S8 =>
                Ga <= '0';
                Gb <= '1';
                Ya <= '0';
                Yb <= '0';
                Ra <= '1';
                Rb <= '0';
                NextState <= S9;

            when S9 =>
                Ga <= '0';
                Gb <= '1';
                Ya <= '0';
                Yb <= '0';
                Ra <= '1';
                Rb <= '0';
                NextState <= S10;

            when S10 =>
                Ga <= '0';
                Gb <= '1';
                Ya <= '0';
                Yb <= '0';
                Ra <= '1';
                Rb <= '0';
                NextState <= S11;

            when S11 =>
                Ga <= '0';
                Gb <= '1';
                Ya <= '0';
                Yb <= '0';
                Ra <= '1';
                Rb <= '0';
                if Sa = '0' and Sb = '1' then
                    NextState <= S11;
                else
                    NextState <= S12;
                end if;

            when S12 =>
                Ga <= '0';
                Gb <= '0';
                Ya <= '0';
                Yb <= '1';
                Ra <= '1';
                Rb <= '0';
                NextState <= S0;

            when others =>
                -- Default case, should not occur
                NextState <= S0;
        end case;
    end process;

end Behavioral;
