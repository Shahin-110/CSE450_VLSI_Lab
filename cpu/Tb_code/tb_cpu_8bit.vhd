library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cpu_8bit is
-- Testbench has no ports
end tb_cpu_8bit;

architecture behavior of tb_cpu_8bit is 

    -- Component Declaration
    component cpu_8bit
        Port ( CLK   : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               Q     : out STD_LOGIC_VECTOR (7 downto 0);
               Z     : out STD_LOGIC;
               PC    : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    -- Inputs
    signal CLK   : std_logic := '0';
    signal RESET : std_logic := '1';

    -- Outputs
    signal Q  : std_logic_vector(7 downto 0);
    signal Z  : std_logic;
    signal PC : std_logic_vector(3 downto 0);

    -- Clock period
    constant clk_period : time := 20 ns;
    signal sim_done : boolean := false;

    -- Expected results of Appendix B, Set 0 (value AFTER each rising edge)
    -- Cycle 0 = RESET, cycles 1..7 = LDI, AND, JZ(taken), NOT, AND, JZ(not taken), ADD
    type acc_array is array (0 to 7) of std_logic_vector(7 downto 0);
    type pc_array  is array (0 to 7) of std_logic_vector(3 downto 0);

    constant exp_acc : acc_array := ("00000000",   -- 0 : RESET
                                     "10100101",   -- 1 : LDI 0xA5
                                     "00000000",   -- 2 : AND 0x5A
                                     "00000000",   -- 3 : JZ 0x05 (taken)
                                     "11111111",   -- 4 : NOT
                                     "00001111",   -- 5 : AND 0x0F
                                     "00001111",   -- 6 : JZ 0x00 (not taken)
                                     "00010000");  -- 7 : ADD 0x01

    constant exp_z   : std_logic_vector(0 to 7) := "10110000";

    constant exp_pc  : pc_array  := ("0000",   -- 0
                                     "0001",   -- 1
                                     "0010",   -- 2
                                     "0101",   -- 3  (jump to 5)
                                     "0110",   -- 4
                                     "0111",   -- 5
                                     "1000",   -- 6
                                     "1001");  -- 7

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: cpu_8bit PORT MAP (
          CLK   => CLK,
          RESET => RESET,
          Q     => Q,
          Z     => Z,
          PC    => PC
        );

    -- Clock Generation (stops when the test is finished)
    clk_process : process
    begin
        while not sim_done loop
            CLK <= '0';
            wait for clk_period/2;
            CLK <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    -- Stimulus + Checking Process
    stim_proc: process
        variable errors : integer := 0;
    begin
        RESET <= '1';

        for i in 0 to 7 loop
            wait until rising_edge(CLK);   -- cycle i
            wait for 5 ns;                 -- let the outputs settle

            if (Q = exp_acc(i)) and (Z = exp_z(i)) and (PC = exp_pc(i)) then
                report "Cycle " & integer'image(i) & " : PASS" severity note;
            else
                errors := errors + 1;
                report "Cycle " & integer'image(i) & " : FAIL (ACC / Z / PC mismatch)" severity error;
            end if;

            if i = 0 then
                RESET <= '0';              -- RESET was applied for exactly one rising edge
            end if;
        end loop;

        if errors = 0 then
            report "ALL 8 CYCLES MATCH APPENDIX B (SET 0) - CPU TEST PASSED" severity note;
        else
            report "CPU TEST FAILED" severity error;
        end if;

        sim_done <= true;
        wait; -- Stop simulation
    end process;

end behavior;
