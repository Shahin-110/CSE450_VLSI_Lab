library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_pc_4bit is
end tb_pc_4bit;

architecture behavior of tb_pc_4bit is

    component pc_4bit
        Port ( clk       : in  STD_LOGIC;
               reset     : in  STD_LOGIC;
               jump      : in  STD_LOGIC;
               jump_addr : in  STD_LOGIC_VECTOR (3 downto 0);
               pc_out    : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '1';
    signal jump      : std_logic := '0';
    signal jump_addr : std_logic_vector(3 downto 0) := "0000";
    signal pc_out    : std_logic_vector(3 downto 0);

    constant clk_period : time := 20 ns;
    signal sim_done : boolean := false;

    constant N : integer := 12;
    type v4_array is array (0 to N-1) of std_logic_vector(3 downto 0);

    -- Vector i is applied BEFORE rising edge i
    -- 0: reset, 1-3: count, 4: jump to 5, 5-6: count, 7: jump to F, 8-9: wrap and count,
    -- 10: reset has priority over jump, 11: count again
    constant t_reset : std_logic_vector(0 to N-1) := "100000000010";
    constant t_jump  : std_logic_vector(0 to N-1) := "000010010010";
    constant t_addr  : v4_array := ("0000","0000","0000","0000","0101","0000",
                                    "0000","1111","0000","0000","1010","0000");

    -- Expected PC after each rising edge
    constant e_pc    : v4_array := ("0000","0001","0010","0011","0101","0110",
                                    "0111","1111","0000","0001","0000","0001");

begin

    uut: pc_4bit PORT MAP (
          clk       => clk,
          reset     => reset,
          jump      => jump,
          jump_addr => jump_addr,
          pc_out    => pc_out
        );

    clk_process : process
    begin
        while not sim_done loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    stim_proc: process
        variable errors : integer := 0;
    begin
        for i in 0 to N-1 loop
            reset     <= t_reset(i);
            jump      <= t_jump(i);
            jump_addr <= t_addr(i);

            wait until rising_edge(clk);
            wait for 5 ns;

            if pc_out = e_pc(i) then
                report "PC cycle " & integer'image(i) & " : PASS" severity note;
            else
                errors := errors + 1;
                report "PC cycle " & integer'image(i) & " : FAIL" severity error;
            end if;
        end loop;

        if errors = 0 then
            report "PC TEST PASSED" severity note;
        else
            report "PC TEST FAILED" severity error;
        end if;

        sim_done <= true;
        wait;
    end process;

end behavior;
