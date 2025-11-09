library ieee;
use ieee.std_logic_1164.all;

entity digit_data_MUX is
    port (
        data_in : in STD_LOGIC_VECTOR(31 downto 0); -- 32 bit input data (segment data) for 4 digits
        selector : in STD_LOGIC_VECTOR(1 downto 0); -- 2 bit input from counter
        digit_data_out : out STD_LOGIC_VECTOR(7 downto 0) -- 8 bit output to 7-segment data lines
    );
end entity digit_data_MUX;

architecture Behavioral of digit_data_MUX is
begin
    process(data_in, selector)
    begin
        case (selector) is
            when "00" =>
                digit_data_out <= data_in(7 downto 0); -- digit 0 data
            when "01" =>
                digit_data_out <= data_in(15 downto 8); -- digit 1 data
            when "10" =>
                digit_data_out <= data_in(23 downto 16); -- digit 2 data
            when others => -- "11"
                digit_data_out <= data_in(31 downto 24); -- digit 3 data
        end case;
    end process;
end architecture Behavioral;        