library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- CPU ALU block : uses the lab's alu_8bit for ADD / AND / NOT,
-- and a MUX row to bypass the ALU for LDI.
entity cpu_alu is
    Port ( a       : in  STD_LOGIC_VECTOR (7 downto 0);   -- ACC
           b       : in  STD_LOGIC_VECTOR (7 downto 0);   -- 8-bit operand
           op      : in  STD_LOGIC_VECTOR (2 downto 0);   -- alu_8bit Op
           ldi_sel : in  STD_LOGIC;                       -- 1 = pass operand (LDI)
           result  : out STD_LOGIC_VECTOR (7 downto 0);
           zero    : out STD_LOGIC);
end cpu_alu;

architecture Structural of cpu_alu is

    -- Component Declarations
    component alu_8bit
        Port ( A       : in  STD_LOGIC_VECTOR (7 downto 0);
               B       : in  STD_LOGIC_VECTOR (7 downto 0);
               Cin     : in  STD_LOGIC;
               Op      : in  STD_LOGIC_VECTOR (2 downto 0);
               ALU_Out : out STD_LOGIC_VECTOR (7 downto 0);
               Cout    : out STD_LOGIC;
               Zero    : out STD_LOGIC);
    end component;

    component mux_2to1
        Port ( i0  : in  STD_LOGIC;
               i1  : in  STD_LOGIC;
               sel : in  STD_LOGIC;
               y   : out STD_LOGIC);
    end component;

    component or_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    component not_gate
        Port ( a : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    -- Internal Signals
    signal gnd     : STD_LOGIC;
    signal alu_out : STD_LOGIC_VECTOR (7 downto 0);
    signal res     : STD_LOGIC_VECTOR (7 downto 0);

    -- Zero detect wires
    signal o01, o23, o45, o67    : STD_LOGIC;
    signal o0123, o4567, any_one : STD_LOGIC;

begin

    gnd <= '0';

    -- ADD / AND / NOT : lab ALU (REUSED)
    ALU_INST: alu_8bit port map (
        A       => a,
        B       => b,
        Cin     => gnd,
        Op      => op,
        ALU_Out => alu_out,
        Cout    => open,
        Zero    => open
    );

    -- LDI bypass : ldi_sel = 1 -> operand, else ALU result  (2:1 MUX REUSED)
    GEN_MUX: for i in 0 to 7 generate
        U_MUX: mux_2to1 port map (i0 => alu_out(i), i1 => b(i), sel => ldi_sel, y => res(i));
    end generate GEN_MUX;

    -- Zero flag of the FINAL result (also covers LDI) : NOR of all bits
    U_Z01  : or_gate port map (a => res(0), b => res(1), y => o01);
    U_Z23  : or_gate port map (a => res(2), b => res(3), y => o23);
    U_Z45  : or_gate port map (a => res(4), b => res(5), y => o45);
    U_Z67  : or_gate port map (a => res(6), b => res(7), y => o67);
    U_Z0123: or_gate port map (a => o01,    b => o23,    y => o0123);
    U_Z4567: or_gate port map (a => o45,    b => o67,    y => o4567);
    U_ZANY : or_gate port map (a => o0123,  b => o4567,  y => any_one);
    U_ZNOT : not_gate port map (a => any_one, y => zero);

    result <= res;

end Structural;
