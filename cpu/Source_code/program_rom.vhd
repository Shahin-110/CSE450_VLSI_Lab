library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_rom is
    Port ( addr : in  STD_LOGIC_VECTOR (3 downto 0);
           data : out STD_LOGIC_VECTOR (11 downto 0));
end program_rom;

architecture Behavioral of program_rom is

    type rom_array is array (0 to 15) of STD_LOGIC_VECTOR (11 downto 0);

    -- Set 0 test program (Appendix B).  instr = opcode(4) & operand(8)
    constant rom_data : rom_array := (
        0      => "000110100101",   -- 0x1A5 : LDI 0xA5
        1      => "010001011010",   -- 0x45A : AND 0x5A
        2      => "110000000101",   -- 0xC05 : JZ  0x05
        3      => "001000000001",   -- 0x201 : ADD 0x01
        4      => "001000000001",   -- 0x201 : ADD 0x01
        5      => "011100000000",   -- 0x700 : NOT
        6      => "010000001111",   -- 0x40F : AND 0x0F
        7      => "110000000000",   -- 0xC00 : JZ  0x00
        8      => "001000000001",   -- 0x201 : ADD 0x01
        others => "000000000000");  -- 0x000 : NOP

begin

    -- Combinational read (no clock)
    data <= rom_data(to_integer(unsigned(addr)));

end Behavioral;
