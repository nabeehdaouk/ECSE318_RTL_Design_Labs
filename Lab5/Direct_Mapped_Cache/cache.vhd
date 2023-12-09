library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cache is
    Port(
        pdata_in    : in  STD_LOGIC_VECTOR(31 downto 0);
        paddress    : in  STD_LOGIC_VECTOR(15 downto 0);
        sysdata_in  : in  STD_LOGIC_VECTOR(7 downto 0);
        clk         : in  STD_LOGIC;
        pstrobe     : in  STD_LOGIC;
        prw         : in  STD_LOGIC;
        pdata_out   : out STD_LOGIC_VECTOR(31 downto 0);
        sysaddress  : out STD_LOGIC_VECTOR(15 downto 0);
        sysdata_out : out STD_LOGIC_VECTOR(7 downto 0);
        pready      : out STD_LOGIC;
        sysrw       : out STD_LOGIC;
        sysstrobe   : out STD_LOGIC
    );
end cache;

architecture Behavioral of cache is

    type ram_array is array (255 downto 0) of STD_LOGIC_VECTOR(5 downto 0);
    type cache_array is array (255 downto 0) of STD_LOGIC_VECTOR(31 downto 0);

    signal tag_ram                          : ram_array;
    signal cache_ram                        : cache_array;
    signal byte0, byte1, byte2, byte3, done : STD_LOGIC;
    signal sysstrobe_internal               : STD_LOGIC;
    signal sysrw_internal                   : STD_LOGIC;
    signal pready_internal                  : STD_LOGIC;

    constant read  : STD_LOGIC := '1';
    constant write : STD_LOGIC := '0';

begin
    -- Assign internal signals to the output ports
    sysstrobe <= sysstrobe_internal;
    sysrw     <= sysrw_internal;
    pready    <= pready_internal;

    process(clk)
    begin
        if rising_edge(clk) then
            case prw is
                when read =>
                    if pstrobe = '1' then
                        pready_internal <= '0';
                        if paddress(15 downto 10) = tag_ram(to_integer(unsigned(paddress(9 downto 2)))) then
                            pdata_out <= cache_ram(to_integer(unsigned(paddress(9 downto 2))));
                        else
                            sysrw_internal     <= '1';
                            sysstrobe_internal <= '1';
                            sysaddress         <= paddress(13 downto 0) & "00"; --set byte bits to pull first byte
                        end if;
                    end if;

                    -- [Continue with the remaining logic for the read operation]
                    if sysstrobe_internal = '1' then
                        sysstrobe_internal <= '0';
                        byte0              <= '1';
                        byte1              <= '0';
                        byte2              <= '0';
                        byte3              <= '0';
                        done               <= '0';
                    end if;

                    if byte0 = '1' then
                        -- First byte logic
                        tag_ram(to_integer(unsigned(paddress(9 downto 2)))) <= paddress(15 downto 10);
                        byte0                                               <= '0';
                        byte1                                               <= '1';
                        sysaddress                                          <= paddress(13 downto 0) & "01";
                    end if;

                    if byte1 = '1' then
                        -- Second byte logic
                        cache_ram(to_integer(unsigned(paddress(9 downto 2))))(7 downto 0) <= sysdata_in;
                        byte1                                                             <= '0';
                        byte2                                                             <= '1';
                        sysaddress                                                        <= paddress(13 downto 0) & "10";
                    end if;

                    if byte2 = '1' then
                        -- Third byte logic
                        cache_ram(to_integer(unsigned(paddress(9 downto 2))))(15 downto 8) <= sysdata_in;
                        byte2                                                              <= '0';
                        byte3                                                              <= '1';
                        sysaddress                                                         <= paddress(13 downto 0) & "11";
                    end if;

                    if byte3 = '1' then
                        -- Fourth byte logic
                        cache_ram(to_integer(unsigned(paddress(9 downto 2))))(23 downto 16) <= sysdata_in;
                        byte3                                                               <= '0';
                        done                                                                <= '1';
                    end if;

                    if done = '1' then
                        -- Finalize read operation
                        cache_ram(to_integer(unsigned(paddress(9 downto 2))))(31 downto 24) <= sysdata_in;
                        pdata_out                                                           <= sysdata_in & cache_ram(to_integer(unsigned(paddress(9 downto 2))))(23 downto 0);
                        done                                                                <= '0';
                        pready_internal                                                     <= '1';
                    end if;

                when write =>

                    if pstrobe = '1' then
                        cache_ram(to_integer(unsigned(paddress(9 downto 2)))) <= pdata_in;
                        tag_ram(to_integer(unsigned(paddress(9 downto 2))))   <= paddress(15 downto 10);
                        pready_internal                                       <= '0';
                    else
                        sysrw_internal     <= '0';
                        sysstrobe_internal <= '1';
                        sysaddress         <= paddress(13 downto 0) & "00";
                    end if;

                    if sysstrobe_internal = '1' then
                        sysstrobe_internal <= '0';
                        byte0              <= '1';
                        byte1              <= '0';
                        byte2              <= '0';
                        byte3              <= '0';
                        done               <= '0';
                    end if;

                    if byte0 = '1' then
                        -- Write first byte
                        byte0       <= '0';
                        byte1       <= '1';
                        sysdata_out <= cache_ram(to_integer(unsigned(paddress(9 downto 2))))(7 downto 0);
                        sysaddress  <= paddress(13 downto 0) & "01";
                    end if;

                    if byte1 = '1' then
                        -- Write second byte
                        byte1       <= '0';
                        byte2       <= '1';
                        sysdata_out <= cache_ram(to_integer(unsigned(paddress(9 downto 2))))(15 downto 8);
                        sysaddress  <= paddress(13 downto 0) & "10";
                    end if;

                    if byte2 = '1' then
                        -- Write third byte
                        byte2       <= '0';
                        byte3       <= '1';
                        sysdata_out <= cache_ram(to_integer(unsigned(paddress(9 downto 2))))(23 downto 16);
                        sysaddress  <= paddress(13 downto 0) & "11";
                    end if;

                    if byte3 = '1' then
                        -- Write fourth byte
                        byte3       <= '0';
                        done        <= '1';
                        sysdata_out <= cache_ram(to_integer(unsigned(paddress(9 downto 2))))(31 downto 24);
                        sysaddress  <= paddress(13 downto 0) & "00";
                    end if;

                    if done = '1' then
                        -- Finalize write operation
                        done            <= '0';
                        pready_internal <= '1';
                    end if;

                when others =>
            end case;
        end if;
    end process;
end Behavioral;
