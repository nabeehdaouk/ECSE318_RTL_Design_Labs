library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SixteenBitCSA is
  Port (
    A     : in  STD_LOGIC_VECTOR(15 downto 0);
    B     : in  STD_LOGIC_VECTOR(15 downto 0);
    Cin   : in  STD_LOGIC;
    Sum   : out STD_LOGIC_VECTOR(15 downto 0);
    Cout  : out STD_LOGIC
  );
end SixteenBitCSA;

architecture Behavioral of SixteenBitCSA is
  signal carry_select : STD_LOGIC_VECTOR(3 downto 0); -- 4 carry-out bits from the 4 n-bit adders
  signal sum_0 : STD_LOGIC_VECTOR(15 downto 0);
  signal sum_1 : STD_LOGIC_VECTOR(15 downto 0);
  signal carry_0 : STD_LOGIC_VECTOR(3 downto 1);
  signal carry_1 : STD_LOGIC_VECTOR(3 downto 1);

  -- Create four instances of the n_bit_adder module with Cin
  component n_bit_adder
    generic (
      N : integer := 4
    );
    port (
      A     : in  STD_LOGIC_VECTOR(N - 1 downto 0);
      B     : in  STD_LOGIC_VECTOR(N - 1 downto 0);
      Cin   : in  STD_LOGIC;
      Sum   : out STD_LOGIC_VECTOR(N - 1 downto 0);
      Cout  : out STD_LOGIC
    );
  end component;

begin
  -- Instantiate four n_bit_adder modules
  adder0 : n_bit_adder
    generic map (
      N => 4
    )
    port map (
      A => A(3 downto 0),
      B => B(3 downto 0),
      Cin => Cin,
      Sum => Sum(3 downto 0),
      Cout => carry_select(0)
    );

  adder1_c0 : n_bit_adder
    generic map (
      N => 4
    )
    port map (
      A => A(7 downto 4),
      B => B(7 downto 4),
      Cin => '0',
      Sum => sum_0(7 downto 4),
      Cout => carry_0(1)
    );

  adder1_c1 : n_bit_adder
    generic map (
      N => 4
    )
    port map (
      A => A(7 downto 4),
      B => B(7 downto 4),
      Cin => '1',
      Sum => sum_1(7 downto 4),
      Cout => carry_1(1)
    );

  adder2_c0 : n_bit_adder
    generic map (
      N => 4
    )
    port map (
      A => A(11 downto 8),
      B => B(11 downto 8),
      Cin => '0',
      Sum => sum_0(11 downto 8),
      Cout => carry_0(2)
    );

  adder2_c1 : n_bit_adder
    generic map (
      N => 4
    )
    port map (
      A => A(11 downto 8),
      B => B(11 downto 8),
      Cin => '1',
      Sum => sum_1(11 downto 8),
      Cout => carry_1(2)
    );

  adder3_c0 : n_bit_adder
    generic map (
      N => 4
    )
    port map (
      A => A(15 downto 12),
      B => B(15 downto 12),
      Cin => '0',
      Sum => sum_0(15 downto 12),
      Cout => carry_0(3)
    );

  adder3_c1 : n_bit_adder
    generic map (
      N => 4
    )
    port map (
      A => A(15 downto 12),
      B => B(15 downto 12),
      Cin => '1',
      Sum => sum_1(15 downto 12),
      Cout => carry_1(3)
    );

  -- Generate the final 16-bit sum using multiplexers
process (carry_select, sum_0, sum_1)
begin
  if carry_select(0) = '1' then
    Sum(7 downto 4) <= sum_1(7 downto 4);
  else
    Sum(7 downto 4) <= sum_0(7 downto 4);
  end if;

  if carry_select(1) = '1' then
    Sum(11 downto 8) <= sum_1(11 downto 8);
  else
    Sum(11 downto 8) <= sum_0(11 downto 8);
  end if;

  if carry_select(2) = '1' then
    Sum(15 downto 12) <= sum_1(15 downto 12);
  else
    Sum(15 downto 12) <= sum_0(15 downto 12);
  end if;
end process;


  carry_select(1) <= carry_select(0) when carry_1(1) = '1' else carry_0(1);
  carry_select(2) <= carry_select(1) when carry_1(2) = '1' else carry_0(2);
  carry_select(3) <= carry_select(2) when carry_1(3) = '1' else carry_0(3);
  Cout <= carry_select(3);

end Behavioral;
