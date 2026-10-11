library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_half_adder is
-- Testbench has no ports
end tb_half_adder;

architecture behavior of tb_half_adder is 

    -- Component Declaration for Half Adder
    component half_adder
        Port ( a     : in  STD_LOGIC;
               b     : in  STD_LOGIC;
               sum   : out STD_LOGIC;
               carry : out STD_LOGIC);
    end component;

    -- Inputs
    signal a : std_logic := '0';
    signal b : std_logic := '0';

    -- Outputs
    signal sum   : std_logic;
    signal carry : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: half_adder PORT MAP (
          a => a,
          b => b,
          sum => sum,
          carry => carry
        );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Test Case 1: 0 + 0
        a <= '0'; b <= '0'; wait for 10 ns;
        
        -- Test Case 2: 0 + 1
        a <= '0'; b <= '1'; wait for 10 ns;
        
        -- Test Case 3: 1 + 0
        a <= '1'; b <= '0'; wait for 10 ns;
        
        -- Test Case 4: 1 + 1
        a <= '1'; b <= '1'; wait for 10 ns;

        wait; -- Stops simulation loops
    end process;

end behavior;