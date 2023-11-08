library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla is
    Port (
        a     : in  std_logic_vector(3 downto 0);
        b     : in  std_logic_vector(3 downto 0);
        c_in  : in  std_logic;
        s     : out std_logic_vector(3 downto 0);
        c_out : out std_logic
    );
end entity cla;

architecture Behavioral of cla is
    signal prop     : std_logic_vector(3 downto 0);
    signal g        : std_logic_vector(3 downto 0);
    signal carry_o  : std_logic_vector(3 downto 0);
begin
    g <= a and b after 10 ps;
    prop <= a xor b after 10 ps;

    carry_o(0) <= (c_in and prop(0)) or g(0) after 20 ps;
    carry_o(1) <= (carry_o(0) and prop(1)) or g(1) after 20 ps;
    carry_o(2) <= (carry_o(1) and prop(2)) or g(2) after 20 ps;
    carry_o(3) <= (carry_o(2) and prop(3)) or g(3) after 20 ps;

    s(0) <= c_in xor prop(0) after 10 ps;
    s(1) <= carry_o(0) xor prop(1) after 10 ps;
    s(2) <= carry_o(1) xor prop(2) after 10 ps;
    s(3) <= carry_o(2) xor prop(3) after 10 ps;

    c_out <= carry_o(3);
end architecture Behavioral;
