library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_TDM_for_7Segment is
end tb_TDM_for_7Segment;

architecture Bhv of tb_TDM_for_7Segment is
    -- DUT signals
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal data_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal seg_out  : std_logic_vector(6 downto 0);
    signal dig_sel  : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;
begin
    -- Instantiate DUT
    UUT: entity work.TDM_for_7Segment
        port map (
            clk     => clk,
            rst     => rst,
            data_in => data_in,
            seg_out => seg_out,
            dig_sel => dig_sel
        );

    -- Clock generator
    clk_proc : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clk_proc;

    -- Stimulus
    stim_proc : process
    begin
        -- apply reset
        rst <= '1';
        data_in <= x"44332211"; -- bytes: LSB = 0x11 for digit 0, next = 0x22, etc.
        wait for clk_period * 5; -- EVENT 1
        rst <= '0';

        -- run for some cycles to observe multiplexing
        wait for clk_period * 200;

        -- change data to observe MUX switching
        data_in <= x"FFEEDDCC"; -- EVENT 2
        wait for clk_period * 200;

        -- assert reset again briefly
        rst <= '1';
        wait for clk_period * 4; -- EVENT 3
        rst <= '0';
        wait for clk_period * 100; -- EVENT 4

        -- finish simulation
        wait;
    end process stim_proc;
end Bhv;