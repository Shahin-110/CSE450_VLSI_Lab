library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_1bit is
    Port ( a    : in  STD_LOGIC;
           b    : in  STD_LOGIC;
           cin  : in  STD_LOGIC;
           sum  : out STD_LOGIC;
           cout : out STD_LOGIC);
end full_adder_1bit;

architecture Structural of full_adder_1bit is

    -- Component Declaration for Half Adder
    component half_adder
        Port ( a     : in  STD_LOGIC;
               b     : in  STD_LOGIC;
               sum   : out STD_LOGIC;
               carry : out STD_LOGIC);
    end component;

    -- Component Declaration for OR Gate
    component or_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    -- Internal Signals (Wires)
    signal s1 : STD_LOGIC;
    signal c1 : STD_LOGIC;
    signal c2 : STD_LOGIC;

begin

    -- First Half Adder
    HA1: half_adder port map (
        a     => a,
        b     => b,
        sum   => s1,
        carry => c1
    );

    -- Second Half Adder
    HA2: half_adder port map (
        a     => s1,
        b     => cin,
        sum   => sum,
        carry => c2
    );

    -- Final Carry Output using Basic OR Gate
    OR1: or_gate port map (
        a => c1,
        b => c2,
        y => cout
    );

end Structural;