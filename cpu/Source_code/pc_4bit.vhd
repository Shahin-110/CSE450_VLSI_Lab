library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_4bit is
    Port ( clk       : in  STD_LOGIC;
           reset     : in  STD_LOGIC;
           jump      : in  STD_LOGIC;
           jump_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           pc_out    : out STD_LOGIC_VECTOR (3 downto 0));
end pc_4bit;

architecture Structural of pc_4bit is

    -- Component Declarations
    component half_adder
        Port ( a     : in  STD_LOGIC;
               b     : in  STD_LOGIC;
               sum   : out STD_LOGIC;
               carry : out STD_LOGIC);
    end component;

    component mux_2to1
        Port ( i0  : in  STD_LOGIC;
               i1  : in  STD_LOGIC;
               sel : in  STD_LOGIC;
               y   : out STD_LOGIC);
    end component;

    component and_gate
        Port ( a : in  STD_LOGIC;
               b : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    component not_gate
        Port ( a : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    component register_1bit
        Port ( d_in  : in  STD_LOGIC;
               load  : in  STD_LOGIC;
               clk   : in  STD_LOGIC;
               q_out : out STD_LOGIC);
    end component;

    -- Internal Signals
    signal vcc      : STD_LOGIC;
    signal reset_n  : STD_LOGIC;
    signal pc_cur   : STD_LOGIC_VECTOR (3 downto 0);
    signal pc_inc   : STD_LOGIC_VECTOR (3 downto 0);
    signal inc_c    : STD_LOGIC_VECTOR (2 downto 0);
    signal pc_sel   : STD_LOGIC_VECTOR (3 downto 0);
    signal pc_next  : STD_LOGIC_VECTOR (3 downto 0);

begin

    vcc <= '1';

    -- PC + 1 using a chain of Half Adders (REUSED)
    HA0: half_adder port map (a => pc_cur(0), b => vcc,      sum => pc_inc(0), carry => inc_c(0));
    HA1: half_adder port map (a => pc_cur(1), b => inc_c(0), sum => pc_inc(1), carry => inc_c(1));
    HA2: half_adder port map (a => pc_cur(2), b => inc_c(1), sum => pc_inc(2), carry => inc_c(2));
    HA3: half_adder port map (a => pc_cur(3), b => inc_c(2), sum => pc_inc(3), carry => open);

    -- Select PC+1 (jump = 0) or jump address (jump = 1) using 2:1 MUX (REUSED)
    GEN_MUX: for i in 0 to 3 generate
        U_MUX: mux_2to1 port map (i0 => pc_inc(i), i1 => jump_addr(i), sel => jump, y => pc_sel(i));
    end generate GEN_MUX;

    -- Synchronous reset: next PC = 0 when reset = 1
    U_RNOT: not_gate port map (a => reset, y => reset_n);

    GEN_RST: for i in 0 to 3 generate
        U_RAND: and_gate port map (a => pc_sel(i), b => reset_n, y => pc_next(i));
    end generate GEN_RST;

    -- 4 x 1-bit Registers (always load, clocked on rising edge)
    GEN_REG: for i in 0 to 3 generate
        U_REG: register_1bit port map (d_in => pc_next(i), load => vcc, clk => clk, q_out => pc_cur(i));
    end generate GEN_REG;

    pc_out <= pc_cur;

end Structural;
