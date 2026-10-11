library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_d_flip_flop is
-- Testbench has no ports
end tb_d_flip_flop;

architecture behavior of tb_d_flip_flop is 

    -- Component Declaration
    component d_flip_flop
        Port ( d   : in  STD_LOGIC;
               clk : in  STD_LOGIC;
               q   : out STD_LOGIC;
               qb  : out STD_LOGIC);
    end component;

    -- Inputs
    signal d   : std_logic := '0';
    signal clk : std_logic := '0';

    -- Outputs
    signal q   : std_logic;
    signal qb  : std_logic;

    -- Clock period definitions
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: d_flip_flop PORT MAP (
          d   => d,
          clk => clk,
          q   => q,
          qb  => qb
        );

    -- Clock process definition
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- Wait for initial global reset
        wait for 25 ns;

        -- Apply Test Inputs
        d <= '1'; wait for 20 ns;
        d <= '0'; wait for 20 ns;
        d <= '1'; wait for 40 ns;
        d <= '0'; wait for 20 ns;

        wait; -- Stop Simulation
    end process;

end behavior;