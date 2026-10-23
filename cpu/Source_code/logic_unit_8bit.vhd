library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_unit_8bit is
    Port ( A        : in  STD_LOGIC_VECTOR (7 downto 0);
           B        : in  STD_LOGIC_VECTOR (7 downto 0);
           Out_AND  : out STD_LOGIC_VECTOR (7 downto 0);
           Out_OR   : out STD_LOGIC_VECTOR (7 downto 0);
           Out_XOR  : out STD_LOGIC_VECTOR (7 downto 0);
           Out_NOT  : out STD_LOGIC_VECTOR (7 downto 0);
           Out_NAND : out STD_LOGIC_VECTOR (7 downto 0);
           Out_NOR  : out STD_LOGIC_VECTOR (7 downto 0));
end logic_unit_8bit;

architecture Structural of logic_unit_8bit is

    -- Component Declarations (basic gates, reused bit by bit)
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

    component xor_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    component not_gate
        Port ( a : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    component nand_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    component nor_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

begin

    -- One gate of every type per bit (8 bits)
    GEN_LOGIC: for i in 0 to 7 generate
        U_AND  : and_gate  port map (a => A(i), b => B(i), y => Out_AND(i));
        U_OR   : or_gate   port map (a => A(i), b => B(i), y => Out_OR(i));
        U_XOR  : xor_gate  port map (a => A(i), b => B(i), y => Out_XOR(i));
        U_NOT  : not_gate  port map (a => A(i),            y => Out_NOT(i));
        U_NAND : nand_gate port map (a => A(i), b => B(i), y => Out_NAND(i));
        U_NOR  : nor_gate  port map (a => A(i), b => B(i), y => Out_NOR(i));
    end generate GEN_LOGIC;

end Structural;
