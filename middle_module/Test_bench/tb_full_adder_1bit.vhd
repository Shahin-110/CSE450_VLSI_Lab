library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_full_adder_1bit is
-- Testbench has no ports
end tb_full_adder_1bit;

architecture behavior of tb_full_adder_1bit is 

    -- Component Declaration for 1-bit Full Adder
    component full_adder_1bit
        Port ( a    : in  STD_LOGIC;
               b    : in  STD_LOGIC;
               cin  : in  STD_LOGIC;
               sum  : out STD_LOGIC;
               cout : out STD_LOGIC);
    end component;

    -- Inputs
    signal a   : std_logic := '0';
    signal b   : std_logic := '0';
    signal cin : std_logic := '0';

    -- Outputs
    signal sum  : std_logic;
    signal cout : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: full_adder_1bit PORT MAP (
          a    => a,
          b    => b,
          cin  => cin,
          sum  => sum,
          cout => cout
        );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Truth Table Evaluation (8 Combinations)
        a <= '0'; b <= '0'; cin <= '0'; wait for 10 ns;
        a <= '0'; b <= '0'; cin <= '1'; wait for 10 ns;
        a <= '0'; b <= '1'; cin <= '0'; wait for 10 ns;
        a <= '0'; b <= '1'; cin <= '1'; wait for 10 ns;
        a <= '1'; b <= '0'; cin <= '0'; wait for 10 ns;
        a <= '1'; b <= '0'; cin <= '1'; wait for 10 ns;
        a <= '1'; b <= '1'; cin <= '0'; wait for 10 ns;
        a <= '1'; b <= '1'; cin <= '1'; wait for 10 ns;

        wait; -- Stops simulation loops
    end process;

end behavior;