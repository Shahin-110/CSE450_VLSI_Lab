library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_8bit is
    Port ( A    : in  STD_LOGIC_VECTOR (7 downto 0);
           B    : in  STD_LOGIC_VECTOR (7 downto 0);
           Cin  : in  STD_LOGIC;
           Sum  : out STD_LOGIC_VECTOR (7 downto 0);
           Cout : out STD_LOGIC);
end full_adder_8bit;

architecture Structural of full_adder_8bit is

    -- Component Declaration for 1-bit Full Adder
    component full_adder_1bit
        Port ( a    : in  STD_LOGIC;
               b    : in  STD_LOGIC;
               cin  : in  STD_LOGIC;
               sum  : out STD_LOGIC;
               cout : out STD_LOGIC);
    end component;

    -- Internal Carry Wires
    signal c : STD_LOGIC_VECTOR (6 downto 0);

begin

    -- Bit 0
    FA0: full_adder_1bit port map (a => A(0), b => B(0), cin => Cin,  sum => Sum(0), cout => c(0));

    -- Bit 1 to 6
    FA1: full_adder_1bit port map (a => A(1), b => B(1), cin => c(0), sum => Sum(1), cout => c(1));
    FA2: full_adder_1bit port map (a => A(2), b => B(2), cin => c(1), sum => Sum(2), cout => c(2));
    FA3: full_adder_1bit port map (a => A(3), b => B(3), cin => c(2), sum => Sum(3), cout => c(3));
    FA4: full_adder_1bit port map (a => A(4), b => B(4), cin => c(3), sum => Sum(4), cout => c(4));
    FA5: full_adder_1bit port map (a => A(5), b => B(5), cin => c(4), sum => Sum(5), cout => c(5));
    FA6: full_adder_1bit port map (a => A(6), b => B(6), cin => c(5), sum => Sum(6), cout => c(6));

    -- Bit 7
    FA7: full_adder_1bit port map (a => A(7), b => B(7), cin => c(6), sum => Sum(7), cout => Cout);

end Structural;