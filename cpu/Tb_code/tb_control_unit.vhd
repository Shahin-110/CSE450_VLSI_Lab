library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_control_unit is
end tb_control_unit;

architecture behavior of tb_control_unit is

    component control_unit
        Port ( opcode   : in  STD_LOGIC_VECTOR (3 downto 0);
               z_flag   : in  STD_LOGIC;
               alu_op   : out STD_LOGIC_VECTOR (2 downto 0);
               ldi_sel  : out STD_LOGIC;
               acc_load : out STD_LOGIC;
               z_load   : out STD_LOGIC;
               pc_jump  : out STD_LOGIC);
    end component;

    signal opcode   : std_logic_vector(3 downto 0) := "0000";
    signal z_flag   : std_logic := '0';
    signal alu_op   : std_logic_vector(2 downto 0);
    signal ldi_sel  : std_logic;
    signal acc_load : std_logic;
    signal z_load   : std_logic;
    signal pc_jump  : std_logic;

    constant N : integer := 10;
    type op4_array is array (0 to N-1) of std_logic_vector(3 downto 0);
    type op3_array is array (0 to N-1) of std_logic_vector(2 downto 0);

    -- Test vectors :  NOP, LDI, ADD, AND, NOT, JZ(Z=0), JZ(Z=1), 3 unused opcodes
    constant t_opcode : op4_array := ("0000","0001","0010","0100","0111","1100","1100","0011","1000","1111");
    constant t_z      : std_logic_vector(0 to N-1) := "0010101101";

    -- Expected outputs
    constant e_alu_op : op3_array := ("000","000","000","010","101","000","000","000","000","000");
    constant e_ldi    : std_logic_vector(0 to N-1) := "0100000000";
    constant e_acc    : std_logic_vector(0 to N-1) := "0111100000";
    constant e_zld    : std_logic_vector(0 to N-1) := "0111100000";
    constant e_jump   : std_logic_vector(0 to N-1) := "0000001000";

begin

    uut: control_unit PORT MAP (
          opcode   => opcode,
          z_flag   => z_flag,
          alu_op   => alu_op,
          ldi_sel  => ldi_sel,
          acc_load => acc_load,
          z_load   => z_load,
          pc_jump  => pc_jump
        );

    stim_proc: process
        variable errors : integer := 0;
    begin
        for i in 0 to N-1 loop
            opcode <= t_opcode(i);
            z_flag <= t_z(i);
            wait for 10 ns;

            if (alu_op = e_alu_op(i)) and (ldi_sel = e_ldi(i)) and
               (acc_load = e_acc(i)) and (z_load = e_zld(i)) and (pc_jump = e_jump(i)) then
                report "Control vector " & integer'image(i) & " : PASS" severity note;
            else
                errors := errors + 1;
                report "Control vector " & integer'image(i) & " : FAIL" severity error;
            end if;
        end loop;

        if errors = 0 then
            report "CONTROL UNIT TEST PASSED" severity note;
        else
            report "CONTROL UNIT TEST FAILED" severity error;
        end if;
        wait;
    end process;

end behavior;
