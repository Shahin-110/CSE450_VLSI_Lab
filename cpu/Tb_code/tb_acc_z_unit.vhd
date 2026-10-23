library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_acc_z_unit is
end tb_acc_z_unit;

architecture behavior of tb_acc_z_unit is

    component acc_z_unit
        Port ( clk      : in  STD_LOGIC;
               reset    : in  STD_LOGIC;
               acc_load : in  STD_LOGIC;
               z_load   : in  STD_LOGIC;
               d_in     : in  STD_LOGIC_VECTOR (7 downto 0);
               z_in     : in  STD_LOGIC;
               acc_q    : out STD_LOGIC_VECTOR (7 downto 0);
               z_q      : out STD_LOGIC);
    end component;

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';
    signal acc_load : std_logic := '0';
    signal z_load   : std_logic := '0';
    signal d_in     : std_logic_vector(7 downto 0) := (others => '0');
    signal z_in     : std_logic := '0';
    signal acc_q    : std_logic_vector(7 downto 0);
    signal z_q      : std_logic;

    constant clk_period : time := 20 ns;
    signal sim_done : boolean := false;

    constant N : integer := 8;
    type v8_array is array (0 to N-1) of std_logic_vector(7 downto 0);

    -- Vector i is applied BEFORE rising edge i
    -- 0: reset (even with no load)   1: load ACC and Z         2: hold (no load)
    -- 3: load Z only                 4: load ACC only          5: load 0x00, Z = 1
    -- 6: load 0xF0, Z = 0            7: reset has priority over load
    constant t_reset : std_logic_vector(0 to N-1) := "10000001";
    constant t_accld : std_logic_vector(0 to N-1) := "01001111";
    constant t_zld   : std_logic_vector(0 to N-1) := "01010111";
    constant t_zin   : std_logic_vector(0 to N-1) := "00110100";
    constant t_d     : v8_array := ("11111111","10100101","11111111","11111111",
                                    "00111100","00000000","11110000","00001111");

    -- Expected values after each rising edge
    constant e_acc   : v8_array := ("00000000","10100101","10100101","10100101",
                                    "00111100","00000000","11110000","00000000");
    constant e_z     : std_logic_vector(0 to N-1) := "10011101";

begin

    uut: acc_z_unit PORT MAP (
          clk      => clk,
          reset    => reset,
          acc_load => acc_load,
          z_load   => z_load,
          d_in     => d_in,
          z_in     => z_in,
          acc_q    => acc_q,
          z_q      => z_q
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
            reset    <= t_reset(i);
            acc_load <= t_accld(i);
            z_load   <= t_zld(i);
            z_in     <= t_zin(i);
            d_in     <= t_d(i);

            wait until rising_edge(clk);
            wait for 5 ns;

            if (acc_q = e_acc(i)) and (z_q = e_z(i)) then
                report "ACC/Z cycle " & integer'image(i) & " : PASS" severity note;
            else
                errors := errors + 1;
                report "ACC/Z cycle " & integer'image(i) & " : FAIL" severity error;
            end if;
        end loop;

        if errors = 0 then
            report "ACC/Z UNIT TEST PASSED" severity note;
        else
            report "ACC/Z UNIT TEST FAILED" severity error;
        end if;

        sim_done <= true;
        wait;
    end process;

end behavior;
