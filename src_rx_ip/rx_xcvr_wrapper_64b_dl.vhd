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
-- 1.1          2019            REFLEXCES    Creation
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.esistream_pkg.all;

library unisim;
use unisim.vcomponents.all;

entity rx_xcvr_wrapper is
  generic (
    NB_LANES : natural := 4                                                        -- number of lanes
    );
  port (
    rst           : in  std_logic;                                                 -- Active high (A)synchronous reset
    rst_xcvr      : in  std_logic;                                                 -- Active high (A)synchronous reset
    rx_rstdone    : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    rx_frame_clk  : out std_logic                                         := '0';
    rx_usrclk     : out std_logic                                         := '0';  --_vector(NB_LANES-1 downto 0)             := (others => '0');  -- user clock
    sysclk        : in  std_logic;                                                 -- transceiver ip system clock
    refclk_n      : in  std_logic;                                                 -- transceiver ip reference clock
    refclk_p      : in  std_logic;                                                 -- transceiver ip reference clock
    rxp           : in  std_logic_vector(NB_LANES-1 downto 0);                     -- lane serial input p
    rxn           : in  std_logic_vector(NB_LANES-1 downto 0);                     -- lane Serial input n
    xcvr_pll_lock : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    data_out      : out std_logic_vector(DESER_WIDTH*NB_LANES-1 downto 0) := (others => '0')
    );
end entity rx_xcvr_wrapper;

architecture rtl of rx_xcvr_wrapper is
  --============================================================================================================================
  -- Function and Procedure declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Constant and Type declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Component declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Signal declarations
  --============================================================================================================================
  signal refclk          : std_logic                               := '0';
  signal qpll_lock       : std_logic_vector(NB_LANES/4-1 downto 0) := (others => '0');
  signal xcvr_pll_lock_t : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');
  signal rx_usrclk_2     : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');

begin
  --============================================================================================================================
  -- Assignments
  --============================================================================================================================
  xcvr_pll_lock_generate : for i in NB_LANES/4-1 downto 0 generate
    xcvr_pll_lock_t(i*4+0) <= qpll_lock(i);
    xcvr_pll_lock_t(i*4+1) <= qpll_lock(i);
    xcvr_pll_lock_t(i*4+2) <= qpll_lock(i);
    xcvr_pll_lock_t(i*4+3) <= qpll_lock(i);
  end generate;

  xcvr_pll_lock <= xcvr_pll_lock_t;

  --============================================================================================================================
  -- XCVR instance
  --============================================================================================================================
  -- GTH Transceivers
  gth_8lanes_64b_1 : entity work.gth_8lanes_64b
    port map(
      SOFT_RESET_RX_IN            => rst,
      DONT_RESET_ON_DATA_ERROR_IN => '1',
      Q8_CLK1_GTREFCLK_PAD_N_IN   => refclk_n,
      Q8_CLK1_GTREFCLK_PAD_P_IN   => refclk_p,

      GT0_TX_FSM_RESET_DONE_OUT => open,
      GT0_RX_FSM_RESET_DONE_OUT => open,
      GT0_DATA_VALID_IN         => '1',
      GT0_RX_MMCM_LOCK_OUT      => open,
      GT1_TX_FSM_RESET_DONE_OUT => open,
      GT1_RX_FSM_RESET_DONE_OUT => open,
      GT1_DATA_VALID_IN         => '1',
      GT1_RX_MMCM_LOCK_OUT      => open,
      GT2_TX_FSM_RESET_DONE_OUT => open,
      GT2_RX_FSM_RESET_DONE_OUT => open,
      GT2_DATA_VALID_IN         => '1',
      GT2_RX_MMCM_LOCK_OUT      => open,
      GT3_TX_FSM_RESET_DONE_OUT => open,
      GT3_RX_FSM_RESET_DONE_OUT => open,
      GT3_DATA_VALID_IN         => '1',
      GT3_RX_MMCM_LOCK_OUT      => open,
      GT4_TX_FSM_RESET_DONE_OUT => open,
      GT4_RX_FSM_RESET_DONE_OUT => open,
      GT4_DATA_VALID_IN         => '1',
      GT4_RX_MMCM_LOCK_OUT      => open,
      GT5_TX_FSM_RESET_DONE_OUT => open,
      GT5_RX_FSM_RESET_DONE_OUT => open,
      GT5_DATA_VALID_IN         => '1',
      GT5_RX_MMCM_LOCK_OUT      => open,
      GT6_TX_FSM_RESET_DONE_OUT => open,
      GT6_RX_FSM_RESET_DONE_OUT => open,
      GT6_DATA_VALID_IN         => '1',
      GT6_RX_MMCM_LOCK_OUT      => open,
      GT7_TX_FSM_RESET_DONE_OUT => open,
      GT7_RX_FSM_RESET_DONE_OUT => open,
      GT7_DATA_VALID_IN         => '1',
      GT7_RX_MMCM_LOCK_OUT      => open,

      GT0_RXUSRCLK_OUT  => open,
      GT0_RXUSRCLK2_OUT => rx_usrclk_2(0),

      GT1_RXUSRCLK_OUT  => open,
      GT1_RXUSRCLK2_OUT => rx_usrclk_2(1),

      GT2_RXUSRCLK_OUT  => open,
      GT2_RXUSRCLK2_OUT => rx_usrclk_2(2),

      GT3_RXUSRCLK_OUT  => open,
      GT3_RXUSRCLK2_OUT => rx_usrclk_2(3),

      GT4_RXUSRCLK_OUT  => open,
      GT4_RXUSRCLK2_OUT => rx_usrclk_2(4),

      GT5_RXUSRCLK_OUT  => open,
      GT5_RXUSRCLK2_OUT => rx_usrclk_2(5),

      GT6_RXUSRCLK_OUT  => open,
      GT6_RXUSRCLK2_OUT => rx_usrclk_2(6),

      GT7_RXUSRCLK_OUT  => open,
      GT7_RXUSRCLK2_OUT => rx_usrclk_2(7),

      --_________________________________________________________________________
      --GT0  (X1Y32)
      --____________________________CHANNEL PORTS________________________________
      --------------------- RX Initialization and Reset Ports --------------------
      gt0_eyescanreset_in      => '0',
      gt0_rxuserrdy_in         => xcvr_pll_lock_t(0),
      -------------------------- RX Margin Analysis Ports ------------------------
      gt0_eyescandataerror_out => open,
      gt0_eyescantrigger_in    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      gt0_dmonitorout_out      => open,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt0_rxdata_out           => data_out(1*DESER_WIDTH-1 downto 0*DESER_WIDTH),
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt0_gthrxn_in            => rxn(0),
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt0_rxmonitorout_out     => open,
      gt0_rxmonitorsel_in      => "01",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt0_rxoutclkfabric_out   => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt0_gtrxreset_in         => rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt0_rxpolarity_in                       => rx_polarity(0),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt0_gthrxp_in            => rxp(0),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt0_rxresetdone_out      => rx_rstdone(0),
      --------------------- TX Initialization and Reset Ports --------------------
      gt0_gttxreset_in         => '1',

      --GT1  (X1Y33)
      --____________________________CHANNEL PORTS________________________________
      --------------------- RX Initialization and Reset Ports --------------------
      gt1_eyescanreset_in      => '0',
      gt1_rxuserrdy_in         => xcvr_pll_lock_t(1),
      -------------------------- RX Margin Analysis Ports ------------------------
      gt1_eyescandataerror_out => open,
      gt1_eyescantrigger_in    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      gt1_dmonitorout_out      => open,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt1_rxdata_out           => data_out(2*DESER_WIDTH-1 downto 1*DESER_WIDTH),
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt1_gthrxn_in            => rxn(1),
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt1_rxmonitorout_out     => open,
      gt1_rxmonitorsel_in      => "01",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt1_rxoutclkfabric_out   => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt1_gtrxreset_in         => rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt1_rxpolarity_in                       => rx_polarity(1),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt1_gthrxp_in            => rxp(1),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt1_rxresetdone_out      => rx_rstdone(1),
      --------------------- TX Initialization and Reset Ports --------------------
      gt1_gttxreset_in         => '1',

      --GT2  (X1Y34)
      --____________________________CHANNEL PORTS________________________________
      --------------------- RX Initialization and Reset Ports --------------------
      gt2_eyescanreset_in      => '0',
      gt2_rxuserrdy_in         => xcvr_pll_lock_t(2),
      -------------------------- RX Margin Analysis Ports ------------------------
      gt2_eyescandataerror_out => open,
      gt2_eyescantrigger_in    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      gt2_dmonitorout_out      => open,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt2_rxdata_out           => data_out(3*DESER_WIDTH-1 downto 2*DESER_WIDTH),
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt2_gthrxn_in            => rxn(2),
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt2_rxmonitorout_out     => open,
      gt2_rxmonitorsel_in      => "01",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt2_rxoutclkfabric_out   => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt2_gtrxreset_in         => rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt2_rxpolarity_in                       => rx_polarity(2),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt2_gthrxp_in            => rxp(2),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt2_rxresetdone_out      => rx_rstdone(2),
      --------------------- TX Initialization and Reset Ports --------------------
      gt2_gttxreset_in         => '1',

      --GT3  (X1Y35)
      --____________________________CHANNEL PORTS________________________________
      --------------------- RX Initialization and Reset Ports --------------------
      gt3_eyescanreset_in      => '0',
      gt3_rxuserrdy_in         => xcvr_pll_lock_t(3),
      -------------------------- RX Margin Analysis Ports ------------------------
      gt3_eyescandataerror_out => open,
      gt3_eyescantrigger_in    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      gt3_dmonitorout_out      => open,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt3_rxdata_out           => data_out(4*DESER_WIDTH-1 downto 3*DESER_WIDTH),
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt3_gthrxn_in            => rxn(3),
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt3_rxmonitorout_out     => open,
      gt3_rxmonitorsel_in      => "01",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt3_rxoutclkfabric_out   => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt3_gtrxreset_in         => rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt3_rxpolarity_in                       => rx_polarity(3),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt3_gthrxp_in            => rxp(3),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt3_rxresetdone_out      => rx_rstdone(3),
      --------------------- TX Initialization and Reset Ports --------------------
      gt3_gttxreset_in         => '1',

      --GT4  (X1Y36)
      --____________________________CHANNEL PORTS________________________________
      --------------------- RX Initialization and Reset Ports --------------------
      gt4_eyescanreset_in      => '0',
      gt4_rxuserrdy_in         => xcvr_pll_lock_t(4),
      -------------------------- RX Margin Analysis Ports ------------------------
      gt4_eyescandataerror_out => open,
      gt4_eyescantrigger_in    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      gt4_dmonitorout_out      => open,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt4_rxdata_out           => data_out(5*DESER_WIDTH-1 downto 4*DESER_WIDTH),
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt4_gthrxn_in            => rxn(4),
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt4_rxmonitorout_out     => open,
      gt4_rxmonitorsel_in      => "01",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt4_rxoutclkfabric_out   => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt4_gtrxreset_in         => rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt4_rxpolarity_in                       => rx_polarity(4),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt4_gthrxp_in            => rxp(4),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt4_rxresetdone_out      => rx_rstdone(4),
      --------------------- TX Initialization and Reset Ports --------------------
      gt4_gttxreset_in         => '1',

      --GT5  (X1Y37)
      --____________________________CHANNEL PORTS________________________________
      --------------------- RX Initialization and Reset Ports --------------------
      gt5_eyescanreset_in      => '0',
      gt5_rxuserrdy_in         => xcvr_pll_lock_t(5),
      -------------------------- RX Margin Analysis Ports ------------------------
      gt5_eyescandataerror_out => open,
      gt5_eyescantrigger_in    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      gt5_dmonitorout_out      => open,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt5_rxdata_out           => data_out(6*DESER_WIDTH-1 downto 5*DESER_WIDTH),
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt5_gthrxn_in            => rxn(5),
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt5_rxmonitorout_out     => open,
      gt5_rxmonitorsel_in      => "01",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt5_rxoutclkfabric_out   => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt5_gtrxreset_in         => rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt5_rxpolarity_in                       => rx_polarity(5),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt5_gthrxp_in            => rxp(5),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt5_rxresetdone_out      => rx_rstdone(5),
      --------------------- TX Initialization and Reset Ports --------------------
      gt5_gttxreset_in         => '1',

      --GT6  (X1Y38)
      --____________________________CHANNEL PORTS________________________________
      --------------------- RX Initialization and Reset Ports --------------------
      gt6_eyescanreset_in      => '0',
      gt6_rxuserrdy_in         => xcvr_pll_lock_t(6),
      -------------------------- RX Margin Analysis Ports ------------------------
      gt6_eyescandataerror_out => open,
      gt6_eyescantrigger_in    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      gt6_dmonitorout_out      => open,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt6_rxdata_out           => data_out(7*DESER_WIDTH-1 downto 6*DESER_WIDTH),
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt6_gthrxn_in            => rxn(6),
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt6_rxmonitorout_out     => open,
      gt6_rxmonitorsel_in      => "01",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt6_rxoutclkfabric_out   => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt6_gtrxreset_in         => rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt6_rxpolarity_in                       => rx_polarity(6),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt6_gthrxp_in            => rxp(6),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt6_rxresetdone_out      => rx_rstdone(6),
      --------------------- TX Initialization and Reset Ports --------------------
      gt6_gttxreset_in         => '1',

      --GT7  (X1Y39)
      --____________________________CHANNEL PORTS________________________________
      --------------------- RX Initialization and Reset Ports --------------------
      gt7_eyescanreset_in      => '0',
      gt7_rxuserrdy_in         => xcvr_pll_lock_t(7),
      -------------------------- RX Margin Analysis Ports ------------------------
      gt7_eyescandataerror_out => open,
      gt7_eyescantrigger_in    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      gt7_dmonitorout_out      => open,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt7_rxdata_out           => data_out(8*DESER_WIDTH-1 downto 7*DESER_WIDTH),
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt7_gthrxn_in            => rxn(7),
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt7_rxmonitorout_out     => open,
      gt7_rxmonitorsel_in      => "01",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt7_rxoutclkfabric_out   => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt7_gtrxreset_in         => rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt7_rxpolarity_in                       => rx_polarity(7),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt7_gthrxp_in            => rxp(7),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt7_rxresetdone_out      => rx_rstdone(7),
      --------------------- TX Initialization and Reset Ports --------------------
      gt7_gttxreset_in         => '1',

      --____________________________COMMON PORTS________________________________
      GT0_QPLLLOCK_OUT       => qpll_lock(0),
      GT0_QPLLREFCLKLOST_OUT => open,
      GT0_QPLLOUTCLK_OUT     => open,
      GT0_QPLLOUTREFCLK_OUT  => open,
      --____________________________COMMON PORTS________________________________
      GT1_QPLLLOCK_OUT       => qpll_lock(1),
      GT1_QPLLREFCLKLOST_OUT => open,
      GT1_QPLLOUTCLK_OUT     => open,
      GT1_QPLLOUTREFCLK_OUT  => open,

      sysclk_in => sysclk
      );
  rx_frame_clk <= rx_usrclk_2(0); 
  rx_usrclk    <= rx_usrclk_2(0); 
  
end architecture rtl;
