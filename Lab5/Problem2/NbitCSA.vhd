library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NBitCSA is
  generic (
    N : integer := 16 -- Default value for N is 16
  );
  Port (
    A     : in  STD_LOGIC_VECTOR(N-1 downto 0);
    B     : in  STD_LOGIC_VECTOR(N-1 downto 0);
    Cin   : in  STD_LOGIC;
    Sum   : out STD_LOGIC_VECTOR(N-1 downto 0):= (others => '0');
    Cout  : out STD_LOGIC := '0'
  );
end NBitCSA;

architecture Behavioral of NBitCSA is
  signal carry_select : STD_LOGIC_VECTOR((N/4) downto 0) := (others => '0') ; -- N carry-out bits from the N n-bit adders
  signal sum_0        : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0'); -- Initialize sum_0 with '0's
  signal sum_1        : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0'); -- Initialize sum_1 with '0's
  signal carry_0      : STD_LOGIC_VECTOR((N/4) downto 1):= (others => '0');
  signal carry_1      : STD_LOGIC_VECTOR((N/4) downto 1):= (others => '0');
  signal carry_select0 : STD_LOGIC;

begin


  -- Instantiate (N-4) n-bit adders for the remaining bits using a for loop
  gen_insts: for i in 1 to ((N/4)-1) generate
    adder_inst0: entity work.n_bit_adder
      generic map (n => 4)
      port map (
        A     => A((4*i+3) downto (4*i)),
        B     => B((4*i+3) downto (4*i)),
        Cin   => '0',
        Sum   => sum_0((4*i+3) downto (4*i)),
        Cout  => carry_0(i)
      );

    adder_inst1: entity work.n_bit_adder
      generic map (n => 4)
      port map (
        A     => A((4*i+3) downto (4*i)),
        B     => B((4*i+3) downto (4*i)),
        Cin   => '1',
        Sum   => sum_1((4*i+3) downto (4*i)),
        Cout  => carry_1(i)
      );
  end generate;
  
    -- Instantiate a 4-bit adder for the first 4 bits
  adder_4bits: entity work.n_bit_adder
    generic map (n => 4)
    port map (
      A     => A(3 downto 0),
      B     => B(3 downto 0),
      Cin   => Cin,
      Sum   => sum_1(3 downto 0),
      Cout  => carry_select0
    );

  process(carry_0, carry_1, carry_select, sum_0, sum_1, carry_select0)
    variable i : integer;
  begin
    i := 1;
    while i < (N/4) loop
      if carry_select(i-1) = '1' then
        Sum((4*i+3) downto (4*i)) <= sum_1((4*i+3) downto (4*i));
        carry_select(i) <= carry_1(i);
      else
        Sum((4*i+3) downto (4*i)) <= sum_0((4*i+3) downto (4*i));
        carry_select(i) <= carry_0(i);
      end if;

      i := i + 1;
  end loop;
Cout <= carry_select(N/4-1);
Sum(3 downto 0) <= sum_1(3 downto 0);
carry_select(0) <= carry_select0;
  
  
  
  end process;


end Behavioral;
