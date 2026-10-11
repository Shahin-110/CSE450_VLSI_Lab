library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    Port ( a     : in  STD_LOGIC;
           b     : in  STD_LOGIC;
           sum   : out STD_LOGIC;
           carry : out STD_LOGIC);
end half_adder;

architecture Structural of half_adder is

    -- Component Declaration for XOR Gate
    component xor_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    -- Component Declaration for AND Gate
    component and_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

begin

    -- Instantiating XOR Gate for Sum
    U1_XOR: xor_gate port map (
        a => a,
        b => b,
        y => sum
    );

    -- Instantiating AND Gate for Carry
    U2_AND: and_gate port map (
        a => a,
        b => b,
        y => carry
    );

end Structural;