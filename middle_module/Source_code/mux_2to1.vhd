library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2to1 is
    Port ( i0  : in  STD_LOGIC;
           i1  : in  STD_LOGIC;
           sel : in  STD_LOGIC;
           y   : out STD_LOGIC);
end mux_2to1;

architecture Structural of mux_2to1 is

    -- Component Declaration for NOT Gate
    component not_gate
        Port ( a : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    -- Component Declaration for AND Gate
    component and_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    -- Component Declaration for OR Gate
    component or_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    -- Internal Wires (Signals)
    signal sel_inv : STD_LOGIC;
    signal and0_out: STD_LOGIC;
    signal and1_out: STD_LOGIC;

begin

    -- Invert the Select line (NOT Gate reuse)
    U1_NOT: not_gate port map (
        a => sel,
        y => sel_inv
    );

    -- AND Gate for Input 0 (i0 AND NOT sel)
    U2_AND: and_gate port map (
        a => i0,
        b => sel_inv,
        y => and0_out
    );

    -- AND Gate for Input 1 (i1 AND sel)
    U3_AND: and_gate port map (
        a => i1,
        b => sel,
        y => and1_out
    );

    -- Combine outputs using OR Gate
    U4_OR: or_gate port map (
        a => and0_out,
        b => and1_out,
        y => y
    );

end Structural;