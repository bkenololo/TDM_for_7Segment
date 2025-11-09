# TDM_for_4_7Segment

Small VHDL project: time‑division multiplexing driver for a 4‑digit 7‑segment display.  
This repo provides a 2‑bit scanner (counter), a byte MUX to select the active digit's 7‑segment pattern, a decoder for digit enable lines, and simple testbenches.

## Repository layout
- src/
  - TDM_for_7Segment.vhd        — top-level TDM module
  - two_bit_counter.vhd         — 2‑bit scan counter
  - digit_data_MUX.vhd          — selects one byte (digit) from data_in
  - digit_enable_decoder.vhd    — converts 2‑bit count to one‑hot digit enables
- tb/
  - tb_TDM_for_7Segment.vhd     — testbench that drives clk, rst and data_in
- sim/
- README.md

## Design summary
- Input `data_in : std_logic_vector(31 downto 0)` contains four 8‑bit digit patterns (in 7segment format):
  - data_in(7 downto 0)   = digit0 (least-significant / rightmost)
  - data_in(15 downto 8)  = digit1
  - data_in(23 downto 16) = digit2
  - data_in(31 downto 24) = digit3 (most-significant / leftmost)
- Each byte is an encoded 7‑segment pattern (assume bit7 = DP, bits6..0 = segments).
- Outputs:
  - `seg_out : std_logic_vector(6 downto 0)` — segments a..g (DP omitted)
  - `dig_sel : std_logic_vector(3 downto 0)` — one‑hot digit enable lines

## Conventions (recommended)
- Bit mapping (default convention used by testbench examples):
  - bit0 = segment a
  - bit1 = segment b
  - bit2 = segment c
  - bit3 = segment d
  - bit4 = segment e
  - bit5 = segment f
  - bit6 = segment g
  - bit7 = decimal point (DP)
- Segment polarity:
  - Default examples assume active‑high segment outputs (common‑cathode).
  - If your hardware is common‑anode (active‑low), invert the segment bits before driving the pins.

## How to simulate
Using ModelSim / Questa (Windows):
1. In ModelSim transcript:
   - vcom src\*.vhd
   - vcom tb\tb_TDM_for_7Segment.vhd
2. Run:
   - vsim work.tb_TDM_for_7Segment
   - run 200us

Adjust run time to observe digit multiplexing and to test different data patterns.

## Example: pack digits (1,2,3,4) as 7‑segment bytes
Common‑cathode encodings (bit0=a .. bit6=g, no DP):
- 1 = 0x06, 2 = 0x5B, 3 = 0x4F, 4 = 0x66

Pack as data_in = {digit3, digit2, digit1, digit0}:
- data_in <= x"664F5B06";

## Quick adapter examples
If encoder bit order or polarity differs, adapt in TDM_for_7Segment before assigning seg_out:

- Reorder / map bits (example: if encoder uses bit6..0 = a..g):
```vhdl
-- seg_adapter(0)=a ... seg_adapter(6)=g
seg_adapter <= digit_data(6) & digit_data(5) & digit_data(4)
             & digit_data(3) & digit_data(2) & digit_data(1)
             & digit_data(0);
seg_out <= seg_adapter;
```

- Invert for active‑low outputs:
```vhdl
seg_out <= not digit_data(6 downto 0);
```

## Notes & TODO
- Verify encoder bit mapping and digit enable polarity with your hardware.
- Add more test vectors in tb to validate DP, polarity and refresh rate.
- Consider exposing refresh speed as a configurable generic.

# What this project lacks
- Digit‑enable polarity & default
  - The decoder currently uses active‑low one‑hot outputs (default enable pattern `1110` for digit0). This may differ from target hardware; note the default is not `1111`.
- Bit ordering & segment mapping not enforced
  - The repo does not force a canonical bit‑to‑segment mapping. The encoder that produces `data_in` must document which bit = a..g and DP (recommended: bit0=a .. bit6=g, bit7=DP).
- Segment / digit polarity
  - Segment outputs in examples assume active‑high (common‑cathode). If your display is active‑low (common‑anode), an inverter is required.
- No DP handling on seg_out
  - `seg_out` omits the DP bit (digit_data(7)). README/adapter should explain DP handling if needed.
- No configurable refresh/scan rate
  - Refresh rate is fixed by the counter/testbench; no generics to tune scan frequency or PWM brightness control.
- No verification vectors or exhaustive testbench
  - Testbench provides simple patterns only. Missing systematic tests for edge cases (polarity, DP, byte order).
- No packaging for different digit counts
  - Code targets 4 digits; not parameterized for other digit counts or buses.
- Assumptions about byte packing
  - MUX expects data_in packed as {digit3, digit2, digit1, digit0} = data_in(31 downto 0). Verify producers use same packing.

Suggested quick fixes / additions
- Add a "Conventions" subsection (bit order, DP position, polarity, byte packing) and a one-line adapter example for inversion/reordering.
- Add generics to TDM_for_7Segment for refresh rate and active‑low/high select.
- Expand testbench with explicit 7‑segment encodings, DP tests, polarity inversion tests and a waveform VCD script.
- Document expected hardware wiring (common‑cathode vs common‑anode) and the default `dig_sel` polarity.

## License
- Add your preferred license or keep for private use.
