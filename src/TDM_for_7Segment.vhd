library ieee;
use ieee.std_logic_1164.all;

entity TDM_for_7Segment is
    port (
        clk : in std_logic;
        rst : in std_logic;
        data_in : in std_logic_vector(31 downto 0); -- 32 bit input data for 4 digits (in 7 segment format)
        seg_out : out std_logic_vector(6 downto 0);
        dig_sel : out std_logic_vector(3 downto 0)
    );
end entity TDM_for_7Segment;

architecture Behavioral of TDM_for_7Segment is
    -- Instantiation of components
    component two_bit_counter -- 2-bit counter to cycle through digits
        port (
            clk : in std_logic;
            rst : in std_logic;
            en : in std_logic;
            count : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
    component digit_data_MUX -- MUX to select digit data based on counter
        port (
            data_in : in STD_LOGIC_VECTOR(31 downto 0);
            selector : in STD_LOGIC_VECTOR(1 downto 0);
            digit_data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    component digit_enable_decoder -- Decoder to enable the correct digit
        port (
            selector : in STD_LOGIC_VECTOR(1 downto 0);
            digit_selected : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Signals
    signal count : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal digit_data : STD_LOGIC_VECTOR(7 downto 0)  := (others => '0');
    signal digit_selected : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin
    -- Instantiate 2-bit counter
    counter_inst : two_bit_counter
        port map (
            clk => clk,
            rst => rst,
            en => '1', -- always enabled
            count => count
        );

    -- Instantiate digit data MUX
    mux_inst : digit_data_MUX
        port map (
            data_in => data_in,
            selector => count,
            digit_data_out => digit_data(7 downto 0) -- only need 8 bits for current digit
        );

    -- Instantiate digit enable decoder
    decoder_inst : digit_enable_decoder
        port map (
            selector => count,
            digit_selected => digit_selected
        );

    -- Output assignments
    seg_out <= digit_data(6 downto 0); -- assign 7-segment data (ignore decimal point)
    dig_sel <= digit_selected; -- assign digit select lines
end architecture Behavioral;

