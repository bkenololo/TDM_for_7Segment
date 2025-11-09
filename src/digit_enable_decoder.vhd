library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   

entity digit_enable_decoder is
    port (
        selector : in STD_LOGIC_VECTOR(1 downto 0); -- 2 bit input from counter
        digit_selected : out STD_LOGIC_VECTOR(3 downto 0) -- 4 bit output to digit enable lines
    );
end entity digit_enable_decoder;

architecture Behavioral of digit_enable_decoder is
begin
    process(selector)
    begin
        case (selector) is
            when "00" =>
                digit_selected <= "1110"; -- active low (digit 0 enabled)
            when "01" =>
                digit_selected <= "1101"; -- active low (digit 1 enabled)
            when "10" =>
                digit_selected <= "1011"; -- active low (digit 2 enabled)
            when others => -- "11"
                digit_selected <= "0111"; -- active low (digit 3 enabled)
        end case;
    end process;
end architecture Behavioral;