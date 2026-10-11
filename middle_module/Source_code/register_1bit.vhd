library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_1bit is
    Port ( d_in  : in  STD_LOGIC;
           load  : in  STD_LOGIC;
           clk   : in  STD_LOGIC;
           q_out : out STD_LOGIC);
end register_1bit;

architecture Structural of register_1bit is

    -- Component Declaration for 2:1 MUX
    component mux_2to1
        Port ( i0  : in  STD_LOGIC;
               i1  : in  STD_LOGIC;
               sel : in  STD_LOGIC;
               y   : out STD_LOGIC);
    end component;

    -- Component Declaration for D Flip-Flop
    component d_flip_flop
        Port ( d   : in  STD_LOGIC;
               clk : in  STD_LOGIC;
               q   : out STD_LOGIC;
               qb  : out STD_LOGIC);
    end component;

    -- Internal Signals
    signal mux_out : STD_LOGIC;
    signal current_q : STD_LOGIC;
    signal unused_qb : STD_LOGIC;

begin

    -- 2:1 MUX to select between New Data (d_in) and Hold Data (current_q)
    U_MUX: mux_2to1 port map (
        i0  => current_q,
        i1  => d_in,
        sel => load,
        y   => mux_out
    );

    -- D Flip-Flop to store the selected bit on Clock Edge
    U_DFF: d_flip_flop port map (
        d   => mux_out,
        clk => clk,
        q   => current_q,
        qb  => unused_qb
    );

    -- Connect output
    q_out <= current_q;

end Structural;