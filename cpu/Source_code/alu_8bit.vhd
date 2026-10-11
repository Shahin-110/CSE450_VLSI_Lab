library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_8bit is
    Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
           B      : in  STD_LOGIC_VECTOR (7 downto 0);
           Cin    : in  STD_LOGIC;
           Op     : in  STD_LOGIC_VECTOR (2 downto 0);
           ALU_Out: out STD_LOGIC_VECTOR (7 downto 0);
           Cout   : out STD_LOGIC;
           Zero   : out STD_LOGIC);
end alu_8bit;

architecture Structural of alu_8bit is

    -- Component Declarations
    component full_adder_8bit
        Port ( A    : in  STD_LOGIC_VECTOR (7 downto 0);
               B    : in  STD_LOGIC_VECTOR (7 downto 0);
               Cin  : in  STD_LOGIC;
               Sum  : out STD_LOGIC_VECTOR (7 downto 0);
               Cout : out STD_LOGIC);
    end component;

    component logic_unit_8bit
        Port ( A        : in  STD_LOGIC_VECTOR (7 downto 0);
               B        : in  STD_LOGIC_VECTOR (7 downto 0);
               Out_AND  : out STD_LOGIC_VECTOR (7 downto 0);
               Out_OR   : out STD_LOGIC_VECTOR (7 downto 0);
               Out_XOR  : out STD_LOGIC_VECTOR (7 downto 0);
               Out_NOT  : out STD_LOGIC_VECTOR (7 downto 0);
               Out_NAND : out STD_LOGIC_VECTOR (7 downto 0);
               Out_NOR  : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component xor_gate Port ( a, b : in STD_LOGIC; y : out STD_LOGIC ); end component;
    component nor_gate Port ( a, b : in STD_LOGIC; y : out STD_LOGIC ); end component;

    -- Internal Wires
    signal b_sub        : STD_LOGIC_VECTOR (7 downto 0);
    signal adder_cin    : STD_LOGIC;
    signal adder_sum    : STD_LOGIC_VECTOR (7 downto 0);
    signal adder_cout   : STD_LOGIC;

    signal and_out, or_out, xor_out, not_out, nand_out, nor_out : STD_LOGIC_VECTOR (7 downto 0);
    signal result       : STD_LOGIC_VECTOR (7 downto 0);

begin

    -- XOR Gate array for Subtraction Control (Op(0) = '1' for Subtract)
    GEN_SUB: for i in 0 to 7 generate
        U_XOR_B: xor_gate port map (a => B(i), b => Op(0), y => b_sub(i));
    end generate GEN_SUB;

    -- Adder Carry In: Cin for Addition, '1' for 2's Complement Subtraction
    adder_cin <= Cin when Op = "000" else Op(0);

    -- Instantiating 8-bit Adder Module (REUSED)
    ADDER_INST: full_adder_8bit port map (
        A    => A,
        B    => b_sub,
        Cin  => adder_cin,
        Sum  => adder_sum,
        Cout => adder_cout
    );

    -- Instantiating 8-bit Logic Unit
    LOGIC_INST: logic_unit_8bit port map (
        A        => A,
        B        => B,
        Out_AND  => and_out,
        Out_OR   => or_out,
        Out_XOR  => xor_out,
        Out_NOT  => not_out,
        Out_NAND => nand_out,
        Out_NOR  => nor_out
    );

    -- 8:1 Multiplexer Logic for Final Output Selection
    process(Op, adder_sum, and_out, or_out, xor_out, not_out, nand_out, nor_out)
    begin
        case Op is
            when "000" => result <= adder_sum; -- ADD
            when "001" => result <= adder_sum; -- SUB
            when "010" => result <= and_out;   -- AND
            when "011" => result <= or_out;    -- OR
            when "100" => result <= xor_out;   -- XOR
            when "101" => result <= not_out;   -- NOT A
            when "110" => result <= nand_out;  -- NAND
            when "111" => result <= nor_out;   -- NOR
            when others => result <= (others => '0');
        end case;
    end process;

    -- Zero Flag Calculation (High when result is 0x00)
    Zero <= '1' when result = "00000000" else '0';

    -- Output Assignments
    ALU_Out <= result;
    Cout    <= adder_cout when (Op = "000" or Op = "001") else '0';

end Structural;