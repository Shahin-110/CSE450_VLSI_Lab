library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port ( opcode   : in  STD_LOGIC_VECTOR (3 downto 0);
           z_flag   : in  STD_LOGIC;
           alu_op   : out STD_LOGIC_VECTOR (2 downto 0);  -- alu_8bit Op: 000=ADD 010=AND 101=NOT
           ldi_sel  : out STD_LOGIC;                      -- 1 = LDI (load operand directly)
           acc_load : out STD_LOGIC;
           z_load   : out STD_LOGIC;
           pc_jump  : out STD_LOGIC);
end control_unit;

architecture Structural of control_unit is

    -- Component Declarations
    component not_gate
        Port ( a : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    component and_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    component or_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    -- Inverted opcode bits
    signal n3, n2, n1, n0 : STD_LOGIC;

    -- Shared partial products
    signal n3n2, n3o2, o3o2 : STD_LOGIC;

    -- Partial products of each decoder
    signal ldi_t, add_t, and_t, not_t, jz_t : STD_LOGIC;

    -- Decoded instructions
    signal is_ldi, is_add, is_and, is_not, is_jz : STD_LOGIC;

    -- Load logic
    signal ld_add, and_not, load_i : STD_LOGIC;

begin

    -- Invert opcode bits
    U_N3: not_gate port map (a => opcode(3), y => n3);
    U_N2: not_gate port map (a => opcode(2), y => n2);
    U_N1: not_gate port map (a => opcode(1), y => n1);
    U_N0: not_gate port map (a => opcode(0), y => n0);

    -- Shared terms
    U_P1: and_gate port map (a => n3,        b => n2,        y => n3n2);
    U_P2: and_gate port map (a => n3,        b => opcode(2), y => n3o2);
    U_P3: and_gate port map (a => opcode(3), b => opcode(2), y => o3o2);

    -- LDI = 0001
    U_LDI1: and_gate port map (a => n3n2, b => n1,        y => ldi_t);
    U_LDI2: and_gate port map (a => ldi_t, b => opcode(0), y => is_ldi);

    -- ADD = 0010
    U_ADD1: and_gate port map (a => n3n2, b => opcode(1), y => add_t);
    U_ADD2: and_gate port map (a => add_t, b => n0,        y => is_add);

    -- AND = 0100
    U_AND1: and_gate port map (a => n3o2, b => n1, y => and_t);
    U_AND2: and_gate port map (a => and_t, b => n0, y => is_and);

    -- NOT = 0111
    U_NOT1: and_gate port map (a => n3o2, b => opcode(1), y => not_t);
    U_NOT2: and_gate port map (a => not_t, b => opcode(0), y => is_not);

    -- JZ = 1100
    U_JZ1: and_gate port map (a => o3o2, b => n1, y => jz_t);
    U_JZ2: and_gate port map (a => jz_t, b => n0, y => is_jz);

    -- ACC / Z load : high for LDI, ADD, AND, NOT  (JZ and NOP do not load)
    U_OR1: or_gate port map (a => is_ldi, b => is_add, y => ld_add);
    U_OR2: or_gate port map (a => is_and, b => is_not, y => and_not);
    U_OR3: or_gate port map (a => ld_add, b => and_not, y => load_i);

    acc_load <= load_i;
    z_load   <= load_i;

    -- ALU opcode for alu_8bit :  ADD = 000 , AND = 010 , NOT = 101
    --   (LDI does not use the ALU, so its Op is don't-care and stays 000)
    alu_op(2) <= is_not;
    alu_op(1) <= is_and;
    alu_op(0) <= is_not;

    -- LDI : operand goes straight to ACC (selected by a MUX in cpu_alu)
    ldi_sel <= is_ldi;

    -- Jump taken only when instruction is JZ and Z = 1
    U_JMP: and_gate port map (a => is_jz, b => z_flag, y => pc_jump);

end Structural;
