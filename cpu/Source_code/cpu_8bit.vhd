library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Mini 8-bit Accumulator CPU  (Set 0 : LDI, ADD, AND, JZ, NOT)
entity cpu_8bit is
    Port ( CLK   : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q     : out STD_LOGIC_VECTOR (7 downto 0);   -- ACC
           Z     : out STD_LOGIC;                       -- Zero flag
           PC    : out STD_LOGIC_VECTOR (3 downto 0));  -- Program counter
end cpu_8bit;

architecture Structural of cpu_8bit is

    -- Component Declarations
    component pc_4bit
        Port ( clk       : in  STD_LOGIC;
               reset     : in  STD_LOGIC;
               jump      : in  STD_LOGIC;
               jump_addr : in  STD_LOGIC_VECTOR (3 downto 0);
               pc_out    : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component program_rom
        Port ( addr : in  STD_LOGIC_VECTOR (3 downto 0);
               data : out STD_LOGIC_VECTOR (11 downto 0));
    end component;

    component control_unit
        Port ( opcode   : in  STD_LOGIC_VECTOR (3 downto 0);
               z_flag   : in  STD_LOGIC;
               alu_op   : out STD_LOGIC_VECTOR (2 downto 0);
               ldi_sel  : out STD_LOGIC;
               acc_load : out STD_LOGIC;
               z_load   : out STD_LOGIC;
               pc_jump  : out STD_LOGIC);
    end component;

    component cpu_alu
        Port ( a       : in  STD_LOGIC_VECTOR (7 downto 0);
               b       : in  STD_LOGIC_VECTOR (7 downto 0);
               op      : in  STD_LOGIC_VECTOR (2 downto 0);
               ldi_sel : in  STD_LOGIC;
               result  : out STD_LOGIC_VECTOR (7 downto 0);
               zero    : out STD_LOGIC);
    end component;

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

    -- Internal Signals (wires between the blocks)
    signal pc_s     : STD_LOGIC_VECTOR (3 downto 0);
    signal instr    : STD_LOGIC_VECTOR (11 downto 0);
    signal acc_s    : STD_LOGIC_VECTOR (7 downto 0);
    signal z_s      : STD_LOGIC;
    signal alu_op   : STD_LOGIC_VECTOR (2 downto 0);
    signal ldi_sel  : STD_LOGIC;
    signal alu_res  : STD_LOGIC_VECTOR (7 downto 0);
    signal alu_zero : STD_LOGIC;
    signal acc_load : STD_LOGIC;
    signal z_load   : STD_LOGIC;
    signal pc_jump  : STD_LOGIC;

begin

    -- Program Counter
    U_PC: pc_4bit port map (
        clk       => CLK,
        reset     => RESET,
        jump      => pc_jump,
        jump_addr => instr(3 downto 0),
        pc_out    => pc_s
    );

    -- Program ROM  (instr = opcode[11:8] & operand[7:0])
    U_ROM: program_rom port map (
        addr => pc_s,
        data => instr
    );

    -- Control Unit
    U_CU: control_unit port map (
        opcode   => instr(11 downto 8),
        z_flag   => z_s,
        alu_op   => alu_op,
        ldi_sel  => ldi_sel,
        acc_load => acc_load,
        z_load   => z_load,
        pc_jump  => pc_jump
    );

    -- ALU
    U_ALU: cpu_alu port map (
        a       => acc_s,
        b       => instr(7 downto 0),
        op      => alu_op,
        ldi_sel => ldi_sel,
        result  => alu_res,
        zero    => alu_zero
    );

    -- ACC and Z flag
    U_ACC: acc_z_unit port map (
        clk      => CLK,
        reset    => RESET,
        acc_load => acc_load,
        z_load   => z_load,
        d_in     => alu_res,
        z_in     => alu_zero,
        acc_q    => acc_s,
        z_q      => z_s
    );

    -- CPU outputs
    Q  <= acc_s;
    Z  <= z_s;
    PC <= pc_s;

end Structural;
