library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ACC (8-bit accumulator) and Z flag (1 bit).
-- (R register is not needed: Set 0 has no STA / LDR)
entity acc_z_unit is
    Port ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           acc_load : in  STD_LOGIC;
           z_load   : in  STD_LOGIC;
           d_in     : in  STD_LOGIC_VECTOR (7 downto 0);  -- ALU result
           z_in     : in  STD_LOGIC;                      -- ALU zero flag
           acc_q    : out STD_LOGIC_VECTOR (7 downto 0);
           z_q      : out STD_LOGIC);
end acc_z_unit;

architecture Structural of acc_z_unit is

    -- Component Declarations
    component register_8bit
        Port ( d_in  : in  STD_LOGIC_VECTOR (7 downto 0);
               load  : in  STD_LOGIC;
               clk   : in  STD_LOGIC;
               q_out : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component register_1bit
        Port ( d_in  : in  STD_LOGIC;
               load  : in  STD_LOGIC;
               clk   : in  STD_LOGIC;
               q_out : out STD_LOGIC);
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

    component not_gate
        Port ( a : in  STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    -- Internal Signals
    signal reset_n : STD_LOGIC;
    signal acc_d   : STD_LOGIC_VECTOR (7 downto 0);
    signal acc_en  : STD_LOGIC;
    signal z_d     : STD_LOGIC;
    signal z_en    : STD_LOGIC;

begin

    U_RNOT: not_gate port map (a => reset, y => reset_n);

    -- ACC data = ALU result, forced to 0x00 when reset = 1
    GEN_ACC_D: for i in 0 to 7 generate
        U_ADAND: and_gate port map (a => d_in(i), b => reset_n, y => acc_d(i));
    end generate GEN_ACC_D;

    -- ACC loads when the instruction asks for it OR when reset = 1
    U_ACC_EN: or_gate port map (a => acc_load, b => reset, y => acc_en);

    ACC_REG: register_8bit port map (
        d_in  => acc_d,
        load  => acc_en,
        clk   => clk,
        q_out => acc_q
    );

    -- Z data = new zero flag, forced to 1 when reset = 1
    U_Z_D  : or_gate port map (a => z_in,   b => reset, y => z_d);
    U_Z_EN : or_gate port map (a => z_load, b => reset, y => z_en);

    Z_REG: register_1bit port map (
        d_in  => z_d,
        load  => z_en,
        clk   => clk,
        q_out => z_q
    );

end Structural;
