library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu_8bit is
-- Testbench has no ports
end tb_alu_8bit;

architecture behavior of tb_alu_8bit is 

    -- Component Declaration
    component alu_8bit
        Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
               B      : in  STD_LOGIC_VECTOR (7 downto 0);
               Cin    : in  STD_LOGIC;
               Op     : in  STD_LOGIC_VECTOR (2 downto 0);
               ALU_Out: out STD_LOGIC_VECTOR (7 downto 0);
               Cout   : out STD_LOGIC;
               Zero   : out STD_LOGIC);
    end component;

    -- Inputs
    signal A   : std_logic_vector(7 downto 0) := (others => '0');
    signal B   : std_logic_vector(7 downto 0) := (others => '0');
    signal Cin : std_logic := '0';
    signal Op  : std_logic_vector(2 downto 0) := "000";

    -- Outputs
    signal ALU_Out : std_logic_vector(7 downto 0);
    signal Cout    : std_logic;
    signal Zero    : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_8bit PORT MAP (
          A       => A,
          B       => B,
          Cin     => Cin,
          Op      => Op,
          ALU_Out => ALU_Out,
          Cout    => Cout,
          Zero    => Zero
        );

    -- Stimulus Process
    stim_proc: process
    begin		
        wait for 10 ns;

        -- Test 1: Addition (A = 15, B = 10) -> Sum = 25
        A <= "00001111"; B <= "00001010"; Cin <= '0'; Op <= "000"; wait for 20 ns;

        -- Test 2: Subtraction (A = 25, B = 10) -> Result = 15
        A <= "00011001"; B <= "00001010"; Cin <= '0'; Op <= "001"; wait for 20 ns;

        -- Test 3: Subtraction Zero Flag (A = 10, B = 10) -> Result = 0, Zero = 1
        A <= "00001010"; B <= "00001010"; Cin <= '0'; Op <= "001"; wait for 20 ns;

        -- Test 4: AND Operation (A = 11110000, B = 10101010)
        A <= "11110000"; B <= "10101010"; Op <= "010"; wait for 20 ns;

        -- Test 5: OR Operation
        A <= "11110000"; B <= "10101010"; Op <= "011"; wait for 20 ns;

        -- Test 6: XOR Operation
        A <= "11110000"; B <= "10101010"; Op <= "100"; wait for 20 ns;

        -- Test 7: NOT Operation (A = 11110000) -> Result = 00001111
        A <= "11110000"; Op <= "101"; wait for 20 ns;

        wait; -- Stop simulation
    end process;

end behavior;