-------------------------------------------------------------------------------
-- This is free and unencumbered software released into the public domain.
--
-- Anyone is free to copy, modify, publish, use, compile, sell, or distribute
-- this software, either in source code form or as a compiled bitstream, for 
-- any purpose, commercial or non-commercial, and by any means.
--
-- In jurisdictions that recognize copyright laws, the author or authors of 
-- this software dedicate any and all copyright interest in the software to 
-- the public domain. We make this dedication for the benefit of the public at
-- large and to the detriment of our heirs and successors. We intend this 
-- dedication to be an overt act of relinquishment in perpetuity of all present
-- and future rights to this software under copyright law.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
-- ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- THIS DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 
-------------------------------------------------------------------------------
-- Version      Date            Author       Description
-- 1.0          2020            Teledyne-e2v Creation
-------------------------------------------------------------------------------
-- Description: odelaye2: ug471, 7 Series FPGAs SelectIO Resources User Guide
----------------------------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity odelaye2_wrapper is
  port (
    --! general    
    clk         : in  std_logic;
    refclk      : in  std_logic;
    rst         : in  std_logic;
    set_delay   : in  std_logic;
    inc_delay   : in  std_logic;
    in_delay    : in  std_logic_vector(4 downto 0);
    get_delay   : in  std_logic;
    out_delay   : out std_logic_vector(4 downto 0);
    sync        : in  std_logic;
    sync_odelay : out std_logic
    );
end;


architecture rtl of odelaye2_wrapper is

  signal idelayctrl_rdy  : std_logic                    := '0';
  signal out_delay_o     : std_logic_vector(4 downto 0) := (others => '0');
  signal in_delay_i      : std_logic_vector(4 downto 0) := (others => '0');
  signal odelaye2_load   : std_logic                    := '0';
  signal odelaye2_inc    : std_logic                    := '0';
  --
  type t_state is (ST_SET_NEW_DELAY, ST_WAIT_1, ST_LOAD, ST_INC, ST_WAIT_2);
  signal state           : t_state;
  signal next_state      : t_state;
  --
  signal odelaye2_ce     : std_logic                    := '0';
  --
  signal cntr            : unsigned(3 downto 0)         := (others => '0');
  signal cntr_enable     : std_logic                    := '0';
  signal cntr_end        : std_logic                    := '0';
  signal cntr_end_d      : std_logic                    := '0';
  signal cntr_end_re     : std_logic                    := '0';
  -- 
  signal cntr_enable_i   : std_logic                    := '0';
  signal odelaye2_load_i : std_logic                    := '0';
  signal odelaye2_ce_i   : std_logic                    := '0';
  signal odelaye2_inc_i  : std_logic                    := '0';
--
-- 
begin

  -- IDELAYCTRL: IDELAYE2/ODELAYE2 Tap Delay Value Control
  --             Virtex-7
  -- Xilinx HDL Language Template, version 2019.2
  -- If the IDELAYE2 or ODELAYE2 primitives are instantiated, the IDELAYCTRL module
  -- must also be instantiated. The IDELAYCTRL module continuously calibrates the
  -- individual delay taps (IDELAY/ODELAY) in its region (see Figure 2-16, page 126), to
  -- reduce the effects of process, voltage, and temperature variations. The IDELAYCTRL
  -- module calibrates IDELAY and ODELAY using the user supplied REFCLK.
  IDELAYCTRL_inst : IDELAYCTRL
    port map (
      RDY    => idelayctrl_rdy,  -- 1-bit output: Ready output
      REFCLK => refclk,          -- 1-bit input: Reference clock input
      RST    => rst              -- 1-bit input: Active high reset input. Asynchronous assert, synchronous deassert to REFCLK.
      );

  -- Increase refclk frequency to reduce step delay value:
  -- -- at 200 MHz, step delay is approximatively 80 ps
  -- -- at 400 MHz, step delay is approximatively 40 ps
  -- -- at 800 MHz, step delay is approximatively 20 ps
  
  -- ODELAYE2: Output Fixed or Variable Delay Element
  --           Virtex-7
  -- Xilinx HDL Language Template, version 2019.2
  ODELAYE2_inst : ODELAYE2
    generic map (
      CINVCTRL_SEL          => "FALSE",     -- Enable dynamic clock inversion (FALSE, TRUE)
      DELAY_SRC             => "ODATAIN",   -- Delay input (ODATAIN, CLKIN)
      HIGH_PERFORMANCE_MODE => "TRUE",      -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
      ODELAY_TYPE           => "VAR_LOAD",  -- FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      ODELAY_VALUE          => 31,          -- Output delay tap setting (0-31)
      PIPE_SEL              => "FALSE",     -- Select pipelined mode, FALSE, TRUE
      REFCLK_FREQUENCY      => 300.0,       -- IDELAYCTRL clock input frequency in MHz (200.0-2667.0).
      SIGNAL_PATTERN        => "DATA"       -- DATA, CLOCK input signal
      )
    port map (
      CNTVALUEOUT => out_delay_o,           -- 9-bit output: Counter value output
      DATAOUT     => sync_odelay,           -- 1-bit output: Delayed data from ODATAIN input port
      C           => clk,                   -- 1-bit input: Clock input
      CE          => odelaye2_ce,           -- 1-bit input: Active high enable increment/decrement input
      CINVCTRL    => '0',                   -- 1-bit input: Dynamic clock inversion input
      CLKIN       => clk,                   -- 1-bit input: Clock delay input
      CNTVALUEIN  => in_delay_i,            -- 9-bit input: Counter value input
      INC         => odelaye2_inc,          -- 1-bit input: Increment/Decrement tap delay input
      LD          => odelaye2_load,         -- 1-bit input: Load DELAY_VALUE input
      LDPIPEEN    => '0',                   -- 1-bit input: Enables the pipeline register to load data
      ODATAIN     => sync,                  -- 1-bit input: Data input
      REGRST      => '0'                    -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
      );

  out_delay <= out_delay_o;

  p_delay_in : process (clk)
  begin
    if rising_edge(clk) then
      if (get_delay = '1') and (cntr_end_re = '1') then
        in_delay_i <= out_delay_o;
      elsif (cntr_end_re = '1') then
        in_delay_i <= in_delay;
      else
        in_delay_i <= in_delay_i;
      end if;
    end if;
  end process;

  SYNC_PROC : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state         <= ST_SET_NEW_DELAY;
        odelaye2_load <= '0';
        cntr_enable   <= '0';
        odelaye2_ce   <= '0';
        odelaye2_inc  <= '0';
      else
        state         <= next_state;
        odelaye2_load <= odelaye2_load_i;
        cntr_enable   <= cntr_enable_i;
        odelaye2_ce   <= odelaye2_ce_i;
        odelaye2_inc  <= odelaye2_inc_i;
      end if;

    end if;
  end process;

  --MOORE State-Machine - Outputs based on state only
  OUTPUT_DECODE : process (state)
  begin
    --insert statements to decode internal output signals
    --below is simple example
    if state = ST_SET_NEW_DELAY then
      cntr_enable_i   <= '0';
      odelaye2_load_i <= '0';
      odelaye2_ce_i   <= '0';
      odelaye2_inc_i  <= '0';
    elsif state = ST_WAIT_1 then
      cntr_enable_i   <= '1';
      odelaye2_load_i <= '0';
      odelaye2_ce_i   <= '0';
      odelaye2_inc_i  <= '0';
    elsif state = ST_LOAD then
      cntr_enable_i   <= '0';
      odelaye2_load_i <= '1';
      odelaye2_ce_i   <= '0';
      odelaye2_inc_i  <= '0';
    elsif state = ST_INC then
      cntr_enable_i   <= '0';
      odelaye2_load_i <= '0';
      odelaye2_ce_i   <= '1';
      odelaye2_inc_i  <= '1';
    else
      cntr_enable_i   <= '1';
      odelaye2_load_i <= '0';
      odelaye2_ce_i   <= '0';
      odelaye2_inc_i  <= '0';
    end if;
  end process;

  NEXT_STATE_DECODE : process (state, idelayctrl_rdy, cntr_end_re, set_delay, inc_delay)
  begin
    next_state <= state;
    case (state) is

      when ST_SET_NEW_DELAY =>
        if idelayctrl_rdy = '1' and set_delay = '1' then
          next_state <= ST_WAIT_1;
        elsif idelayctrl_rdy = '1' and inc_delay = '1' then
          next_state <= ST_INC;
        else
          next_state <= ST_SET_NEW_DELAY;
        end if;

      when ST_WAIT_1 =>
        if cntr_end_re = '0' then
          next_state <= ST_WAIT_1;
        else
          next_state <= ST_LOAD;
        end if;

      when ST_LOAD =>
        next_state <= ST_WAIT_2;

      when ST_INC =>
        next_state <= ST_WAIT_2;

      when ST_WAIT_2 =>
        if cntr_end_re = '0' then
          next_state <= ST_WAIT_2;
        else
          next_state <= ST_SET_NEW_DELAY;
        end if;

      when others =>
        next_state <= ST_SET_NEW_DELAY;

    end case;
  end process;

  p_cntr : process(clk)
  begin
    if rising_edge(clk) then
      cntr_end_d  <= cntr_end;
      cntr_end_re <= cntr_end and not cntr_end_d;
      if cntr_enable = '1' then
        if cntr = 0 then
          cntr     <= cntr;
          cntr_end <= '1';
        else
          cntr     <= cntr-1;
          cntr_end <= '0';
        end if;
      else
        cntr     <= (others => '1');
        cntr_end <= '0';
      end if;
    end if;
  end process;

end;
