library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_program_rom is
end tb_program_rom;

architecture behavior of tb_program_rom is

    component program_rom
        Port ( addr : in  STD_LOGIC_VECTOR (3 downto 0);
               data : out STD_LOGIC_VECTOR (11 downto 0));
    end component;

    signal addr : std_logic_vector(3 downto 0) := "0000";
    signal data : std_logic_vector(11 downto 0);

    -- Expected ROM contents (Appendix B, Set 0).  Unused locations = 0x000
    type rom_array is array (0 to 15) of std_logic_vector(11 downto 0);
    constant exp_data : rom_array := (
        "000110100101",   -- 0 : 0x1A5  LDI 0xA5
        "010001011010",   -- 1 : 0x45A  AND 0x5A
        "110000000101",   -- 2 : 0xC05  JZ  0x05
        "001000000001",   -- 3 : 0x201  ADD 0x01
        "001000000001",   -- 4 : 0x201  ADD 0x01
        "011100000000",   -- 5 : 0x700  NOT
        "010000001111",   -- 6 : 0x40F  AND 0x0F
        "110000000000",   -- 7 : 0xC00  JZ  0x00
        "001000000001",   -- 8 : 0x201  ADD 0x01
        "000000000000",   -- 9
        "000000000000",   -- 10
        "000000000000",   -- 11
        "000000000000",   -- 12
        "000000000000",   -- 13
        "000000000000",   -- 14
        "000000000000");  -- 15

begin

    uut: program_rom PORT MAP (addr => addr, data => data);

    stim_proc: process
        variable errors : integer := 0;
    begin
        for i in 0 to 15 loop
            addr <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
            if data = exp_data(i) then
                report "ROM addr " & integer'image(i) & " : PASS" severity note;
            else
                errors := errors + 1;
                report "ROM addr " & integer'image(i) & " : FAIL" severity error;
            end if;
        end loop;

        if errors = 0 then
            report "PROGRAM ROM TEST PASSED" severity note;
        else
            report "PROGRAM ROM TEST FAILED" severity error;
        end if;
        wait;
    end process;

end behavior;
