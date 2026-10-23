library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cpu_alu is
end tb_cpu_alu;

architecture behavior of tb_cpu_alu is

    component cpu_alu
        Port ( a       : in  STD_LOGIC_VECTOR (7 downto 0);
               b       : in  STD_LOGIC_VECTOR (7 downto 0);
               op      : in  STD_LOGIC_VECTOR (2 downto 0);
               ldi_sel : in  STD_LOGIC;
               result  : out STD_LOGIC_VECTOR (7 downto 0);
               zero    : out STD_LOGIC);
    end component;

    signal a       : std_logic_vector(7 downto 0) := (others => '0');
    signal b       : std_logic_vector(7 downto 0) := (others => '0');
    signal op      : std_logic_vector(2 downto 0) := "000";
    signal ldi_sel : std_logic := '0';
    signal result  : std_logic_vector(7 downto 0);
    signal zero    : std_logic;

    constant N : integer := 10;
    type v8_array is array (0 to N-1) of std_logic_vector(7 downto 0);
    type v3_array is array (0 to N-1) of std_logic_vector(2 downto 0);

    -- Vectors: 0-2 ADD, 3-4 AND, 5-6 NOT, 7-8 LDI, 9 ADD 0+0
    constant t_a   : v8_array := ("00001111","11111111","01111111","10100101","11111111",
                                  "11111111","10100101","01110111","11111111","00000000");
    constant t_b   : v8_array := ("00000001","00000001","00000001","01011010","00001111",
                                  "00000000","00000000","10100101","00000000","00000000");
    constant t_op  : v3_array := ("000","000","000","010","010","101","101","000","000","000");
    constant t_ldi : std_logic_vector(0 to N-1) := "0000000110";

    -- Expected results
    constant e_res : v8_array := ("00010000","00000000","10000000","00000000","00001111",
                                  "00000000","01011010","10100101","00000000","00000000");
    constant e_zero: std_logic_vector(0 to N-1) := "0101010011";

begin

    uut: cpu_alu PORT MAP (
          a       => a,
          b       => b,
          op      => op,
          ldi_sel => ldi_sel,
          result  => result,
          zero    => zero
        );

    stim_proc: process
        variable errors : integer := 0;
    begin
        for i in 0 to N-1 loop
            a       <= t_a(i);
            b       <= t_b(i);
            op      <= t_op(i);
            ldi_sel <= t_ldi(i);
            wait for 10 ns;

            if (result = e_res(i)) and (zero = e_zero(i)) then
                report "ALU vector " & integer'image(i) & " : PASS" severity note;
            else
                errors := errors + 1;
                report "ALU vector " & integer'image(i) & " : FAIL" severity error;
            end if;
        end loop;

        if errors = 0 then
            report "CPU ALU TEST PASSED" severity note;
        else
            report "CPU ALU TEST FAILED" severity error;
        end if;
        wait;
    end process;

end behavior;
