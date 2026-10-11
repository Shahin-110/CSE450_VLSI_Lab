library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flip_flop is
    Port ( d   : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           q   : out STD_LOGIC;
           qb  : out STD_LOGIC);
end d_flip_flop;

architecture Structural of d_flip_flop is

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

    -- Internal Signals
    signal clk_inv : STD_LOGIC;
    signal d_inv   : STD_LOGIC;
    
    -- Master Latch Internal Wires
    signal m_s, m_r : STD_LOGIC;
    signal m_q, m_qb : STD_LOGIC;

    -- Slave Latch Internal Wires
    signal s_s, s_r : STD_LOGIC;
    signal s_q_int, s_qb_int : STD_LOGIC;

begin

    -- Invert Clock & Data Input (using NOT Gate)
    U_NOT_CLK: not_gate port map (a => clk, y => clk_inv);
    U_NOT_D  : not_gate port map (a => d,   y => d_inv);

    -------------------------------------------------------------------
    -- 1. Master Latch (Active when clk = 0 / clk_inv = 1)
    -------------------------------------------------------------------
    U_M_AND1: and_gate port map (a => d,     b => clk_inv, y => m_s);
    U_M_AND2: and_gate port map (a => d_inv, b => clk_inv, y => m_r);

    -- Active-low SR Latch logic using basic gates (m_q = NOR-like logic via OR/NOT)
    U_M_OR1:  or_gate  port map (a => m_r, b => m_q,  y => m_qb);
    U_M_OR2:  or_gate  port map (a => m_s, b => m_qb, y => m_q);

    -------------------------------------------------------------------
    -- 2. Slave Latch (Active when clk = 1)
    -------------------------------------------------------------------
    -- Invert Master Outputs for Slave SR Inputs
    U_S_AND1: and_gate port map (a => m_q,  b => clk, y => s_s);
    U_S_AND2: and_gate port map (a => m_qb, b => clk, y => s_r);

    U_S_OR1:  or_gate  port map (a => s_r, b => s_q_int,  y => s_qb_int);
    U_S_OR2:  or_gate  port map (a => s_s, b => s_qb_int, y => s_q_int);

    -- Assign Outputs
    q  <= s_q_int;
    qb <= s_qb_int;

end Structural;