library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
    Port (
        sysaddress : in STD_LOGIC_VECTOR(15 downto 0);
        sysdata_in : in STD_LOGIC_VECTOR(7 downto 0);
        sysstrobe : in STD_LOGIC;
        sysrw : in STD_LOGIC;
        clk : in STD_LOGIC;
        sysdata_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end memory;

architecture Behavioral of memory is
    type memory_array is array (65535 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    signal mem : memory_array;

    constant read : STD_LOGIC := '1';
    constant write : STD_LOGIC := '0';

    constant val_10 : STD_LOGIC_VECTOR(15 downto 0) := x"0010";
    -- [Other constants]

    procedure initialize_memory(signal mem_out : out memory_array) is
        variable addr_vec : STD_LOGIC_VECTOR(15 downto 0);
        variable addr_int : INTEGER;
    begin
        -- For val_10 and "11"
        addr_vec := val_10(13 downto 0) & "11";
        addr_int := to_integer(unsigned(addr_vec));
        mem_out(addr_int) <= x"aa";

        -- For val_10 and "10"
        addr_vec := val_10(13 downto 0) & "10";
        addr_int := to_integer(unsigned(addr_vec));
        mem_out(addr_int) <= x"bb";

        -- [Continue initialization for other memory addresses]
    end procedure;

begin
    -- Initialization process
    process
    begin
        initialize_memory(mem);
        wait;
    end process;

    -- Memory read/write logic
    process(clk)
    begin
        if rising_edge(clk) then
            case sysrw is
                when read =>
                    sysdata_out <= mem(to_integer(unsigned(sysaddress)));

                when write =>
                    mem(to_integer(unsigned(sysaddress))) <= sysdata_in;

                when others =>
                    -- Handle other cases if needed
            end case;
        end if;
    end process;
end Behavioral;
