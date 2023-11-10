library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Using numeric_std for arithmetic operations

entity bit_ser_add is
    Port ( 
        clk : in STD_LOGIC;
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        clr_n : in STD_LOGIC;
        set_n : in STD_LOGIC;
        result : out STD_LOGIC_VECTOR (8 downto 0)
    );
end entity bit_ser_add;

architecture Behavioral of bit_ser_add is
    signal carry_reg : STD_LOGIC := '0';
    signal addend : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal augand : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal result_internal : STD_LOGIC_VECTOR (8 downto 0) := (others => '0'); -- Internal signal to drive the output
begin

    -- Assign internal signal to the output port
    result <= result_internal;

    process(clk)
    begin
        if rising_edge(clk) then
            if clr_n = '0' then
                carry_reg <= '0';
                addend <= (others => '0');
                augand <= (others => '0');
                result_internal <= (others => '0');
            elsif set_n = '1' then -- loading
                addend <= A & addend(7 downto 1);
                augand <= B & augand(7 downto 1);
            elsif set_n = '0' then -- operating
                carry_reg <= (addend(0) AND augand(0)) OR (augand(0) AND carry_reg) OR (addend(0) AND carry_reg);
                augand <= '0' & augand(7 downto 1);
                addend <= '0' & addend(7 downto 1);
                result_internal <= (addend(0) XOR augand(0) XOR carry_reg) & result_internal(8 downto 1);
            end if;
        end if;
    end process;
end Behavioral;
