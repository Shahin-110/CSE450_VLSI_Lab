library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux_2to1 is
-- Testbench has no ports
end tb_mux_2to1;

architecture behavior of tb_mux_2to1 is 

    -- Component Declaration for 2:1 MUX
    component mux_2to1
        Port ( i0  : in  STD_LOGIC;
               i1  : in  STD_LOGIC;
               sel : in  STD_LOGIC;
               y   : out STD_LOGIC);
    end component;

    -- Inputs
    signal i0  : std_logic := '0';
    signal i1  : std_logic := '0';
    signal sel : std_logic := '0';

    -- Outputs
    signal y   : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: mux_2to1 PORT MAP (
          i0  => i0,
          i1  => i1,
          sel => sel,
          y   => y
        );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Test Case 1: sel = 0, y should follow i0
        sel <= '0'; i0 <= '1'; i1 <= '0'; wait for 10 ns;
        sel <= '0'; i0 <= '0'; i1 <= '1'; wait for 10 ns;

        -- Test Case 2: sel = 1, y should follow i1
        sel <= '1'; i0 <= '1'; i1 <= '0'; wait for 10 ns;
        sel <= '1'; i0 <= '0'; i1 <= '1'; wait for 10 ns;

        wait; -- Stop simulation
    end process;

end behavior;