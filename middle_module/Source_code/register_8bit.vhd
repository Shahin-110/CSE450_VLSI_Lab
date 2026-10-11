library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_8bit is
    Port ( d_in  : in  STD_LOGIC_VECTOR (7 downto 0);
           load  : in  STD_LOGIC;
           clk   : in  STD_LOGIC;
           q_out : out STD_LOGIC_VECTOR (7 downto 0));
end register_8bit;

architecture Structural of register_8bit is

    -- Component Declaration for 1-bit Register
    component register_1bit
        Port ( d_in  : in  STD_LOGIC;
               load  : in  STD_LOGIC;
               clk   : in  STD_LOGIC;
               q_out : out STD_LOGIC);
    end component;

begin

    -- Instantiate 8 1-bit Registers
    REG0: register_1bit port map (d_in => d_in(0), load => load, clk => clk, q_out => q_out(0));
    REG1: register_1bit port map (d_in => d_in(1), load => load, clk => clk, q_out => q_out(1));
    REG2: register_1bit port map (d_in => d_in(2), load => load, clk => clk, q_out => q_out(2));
    REG3: register_1bit port map (d_in => d_in(3), load => load, clk => clk, q_out => q_out(3));
    REG4: register_1bit port map (d_in => d_in(4), load => load, clk => clk, q_out => q_out(4));
    REG5: register_1bit port map (d_in => d_in(5), load => load, clk => clk, q_out => q_out(5));
    REG6: register_1bit port map (d_in => d_in(6), load => load, clk => clk, q_out => q_out(6));
    REG7: register_1bit port map (d_in => d_in(7), load => load, clk => clk, q_out => q_out(7));

end Structural;