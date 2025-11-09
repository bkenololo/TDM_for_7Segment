library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_bit_counter is
    port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        count : out STD_LOGIC_VECTOR(1 downto 0)
    );
end two_bit_counter;

architecture Behavioral of two_bit_counter is
    signal count_reg : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin   
        if rst = '1' then -- asynchronous reset
            count_reg <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                count_reg <= STD_LOGIC_VECTOR(UNSIGNED(count_reg) + 1); -- increment count, wrapping around
            end if;
        end if;
    end process;
    count <= count_reg;  
end architecture Behavioral;
