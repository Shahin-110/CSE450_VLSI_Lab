library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_full_adder_8bit is
-- Testbench has no ports
end tb_full_adder_8bit;

architecture behavior of tb_full_adder_8bit is 

    -- Component Declaration for 8-bit Full Adder
    component full_adder_8bit
        Port ( A    : in  STD_LOGIC_VECTOR (7 downto 0);
               B    : in  STD_LOGIC_VECTOR (7 downto 0);
               Cin  : in  STD_LOGIC;
               Sum  : out STD_LOGIC_VECTOR (7 downto 0);
               Cout : out STD_LOGIC);
    end component;

    -- Inputs
    signal A   : std_logic_vector(7 downto 0) := (others => '0');
    signal B   : std_logic_vector(7 downto 0) := (others => '0');
    signal Cin : std_logic := '0';

    -- Outputs
    signal Sum  : std_logic_vector(7 downto 0);
    signal Cout : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: full_adder_8bit PORT MAP (
          A    => A,
          B    => B,
          Cin  => Cin,
          Sum  => Sum,
          Cout => Cout
        );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Test Case 1: 15 + 10 (without carry in)
        A <= "00001111"; B <= "00001010"; Cin <= '0'; wait for 10 ns;
        -- Expected Sum = 00011001 (25), Cout = 0

        -- Test Case 2: 100 + 50 + 1 (with carry in)
        A <= "01100100"; B <= "00110010"; Cin <= '1'; wait for 10 ns;
        -- Expected Sum = 10010111 (151), Cout = 0

        -- Test Case 3: 255 + 1 (Overflow test)
        A <= "11111111"; B <= "00000001"; Cin <= '0'; wait for 10 ns;
        -- Expected Sum = 00000000 (0), Cout = 1

        -- Test Case 4: Alternating bit test
        A <= "10101010"; B <= "01010101"; Cin <= '1'; wait for 10 ns;
        -- Expected Sum = 00000000 (0), Cout = 1

        wait; -- Stops simulation loops
    end process;

end behavior;