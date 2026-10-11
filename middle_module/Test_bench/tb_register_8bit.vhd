library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_adder_register_8bit is
-- Testbench has no ports
end tb_adder_register_8bit;

architecture behavior of tb_adder_register_8bit is 

    -- Component Declaration
    component adder_register_8bit
        Port ( A        : in  STD_LOGIC_VECTOR (7 downto 0);
               B        : in  STD_LOGIC_VECTOR (7 downto 0);
               Cin      : in  STD_LOGIC;
               load     : in  STD_LOGIC;
               clk      : in  STD_LOGIC;
               Reg_Out  : out STD_LOGIC_VECTOR (7 downto 0);
               Cout     : out STD_LOGIC);
    end component;

    -- Inputs
    signal A    : std_logic_vector(7 downto 0) := (others => '0');
    signal B    : std_logic_vector(7 downto 0) := (others => '0');
    signal Cin  : std_logic := '0';
    signal load : std_logic := '0';
    signal clk  : std_logic := '0';

    -- Outputs
    signal Reg_Out : std_logic_vector(7 downto 0);
    signal Cout    : std_logic;

    -- Clock period
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: adder_register_8bit PORT MAP (
          A        => A,
          B        => B,
          Cin      => Cin,
          load     => load,
          clk      => clk,
          Reg_Out  => Reg_Out,
          Cout     => Cout
        );

    -- Clock Generation
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin		
        wait for 20 ns;

        -- Test Case 1: A = 15, B = 10 (Sum = 25), load = 0 -> Register holds old value
        A <= "00001111"; B <= "00001010"; Cin <= '0'; load <= '0'; wait for 20 ns;

        -- Test Case 2: load = 1 -> Register updates with 25 (00011001) on Clock Edge
        load <= '1'; wait for 20 ns;

        -- Test Case 3: A = 100, B = 50 (Sum = 150), load = 0 -> Register holds 25
        A <= "01100100"; B <= "00110010"; load <= '0'; wait for 20 ns;

        -- Test Case 4: load = 1 -> Register updates with 150 (10010110)
        load <= '1'; wait for 20 ns;

        wait; -- Stop simulation
    end process;

end behavior;