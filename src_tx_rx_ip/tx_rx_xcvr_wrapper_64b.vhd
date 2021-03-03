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
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABIqLITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
-- ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- THIS DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 
-------------------------------------------------------------------------------
-- Version      Date            Author       Description
-- 1.1          2019            REFLEXCES    FPGA target migration, 64-bit data path
--------------------------------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.esistream_pkg.all;

library unisim;
use unisim.vcomponents.all;


entity tx_rx_xcvr_wrapper is
  generic (
    NB_LANES : natural := 4
    );
  port (
    rst           : in  std_logic;
    rx_rst_xcvr   : in  std_logic;
    rx_rstdone    : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    rx_frame_clk  : out std_logic                                         := '0';
    rx_usrclk     : out std_logic                                         := '0';
    tx_rst_xcvr   : in  std_logic;
    tx_usrrdy     : in  std_logic_vector(NB_LANES-1 downto 0);				-- TX User Ready
    tx_rstdone    : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    tx_frame_clk  : out std_logic                                         := '0';
    tx_usrclk     : out std_logic                                         := '0';
    sysclk        : in  std_logic;
    refclk_n      : in  std_logic;
    refclk_p      : in  std_logic;
    rxp           : in  std_logic_vector(NB_LANES-1 downto 0);
    rxn           : in  std_logic_vector(NB_LANES-1 downto 0);
    txp           : out std_logic_vector(NB_LANES-1 downto 0);
    txn           : out std_logic_vector(NB_LANES-1 downto 0);
    xcvr_pll_lock : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    data_in       : in  std_logic_vector(SER_WIDTH*NB_LANES-1 downto 0)   := (others => '0');
    data_out      : out std_logic_vector(DESER_WIDTH*NB_LANES-1 downto 0) := (others => '0')
    );
end entity tx_rx_xcvr_wrapper;

architecture rtl of tx_rx_xcvr_wrapper is
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
  signal refclk            : std_logic                                := '0';
  signal qpll_lock         : std_logic_vector(NB_LANES/4-1 downto 0)  := (others => '0');
  signal xcvr_pll_lock_t : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');
  signal rx_usrclk_2     : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');
  signal tx_usrclk_2     : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');

begin
  --
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
  gth_txrx_8lanes_64b_1 : entity work.gth_txrx_8lanes_64b
    port map(
      SOFT_RESET_TX_IN            => rst,
      SOFT_RESET_RX_IN            => rst,
      DONT_RESET_ON_DATA_ERROR_IN => '1',
      Q8_CLK1_GTREFCLK_PAD_N_IN   => refclk_n,
      Q8_CLK1_GTREFCLK_PAD_P_IN   => refclk_p,
      
      GT0_TX_FSM_RESET_DONE_OUT => open,
      GT0_RX_FSM_RESET_DONE_OUT => open,
      GT0_DATA_VALID_IN         => '1',
      GT0_TX_MMCM_LOCK_OUT      => open,
      GT0_RX_MMCM_LOCK_OUT      => open,
      GT1_TX_FSM_RESET_DONE_OUT => open,
      GT1_RX_FSM_RESET_DONE_OUT => open,
      GT1_DATA_VALID_IN         => '1',
      GT1_TX_MMCM_LOCK_OUT      => open,
      GT1_RX_MMCM_LOCK_OUT      => open,
      GT2_TX_FSM_RESET_DONE_OUT => open,
      GT2_RX_FSM_RESET_DONE_OUT => open,
      GT2_DATA_VALID_IN         => '1',
      GT2_TX_MMCM_LOCK_OUT      => open,
      GT2_RX_MMCM_LOCK_OUT      => open,
      GT3_TX_FSM_RESET_DONE_OUT => open,
      GT3_RX_FSM_RESET_DONE_OUT => open,
      GT3_DATA_VALID_IN         => '1',
      GT3_TX_MMCM_LOCK_OUT      => open,
      GT3_RX_MMCM_LOCK_OUT      => open,
      GT4_TX_FSM_RESET_DONE_OUT => open,
      GT4_RX_FSM_RESET_DONE_OUT => open,
      GT4_DATA_VALID_IN         => '1',
      GT4_TX_MMCM_LOCK_OUT      => open,
      GT4_RX_MMCM_LOCK_OUT      => open,
      GT5_TX_FSM_RESET_DONE_OUT => open,
      GT5_RX_FSM_RESET_DONE_OUT => open,
      GT5_DATA_VALID_IN         => '1',
      GT5_TX_MMCM_LOCK_OUT      => open,
      GT5_RX_MMCM_LOCK_OUT      => open,
      GT6_TX_FSM_RESET_DONE_OUT => open,
      GT6_RX_FSM_RESET_DONE_OUT => open,
      GT6_DATA_VALID_IN         => '1',
      GT6_TX_MMCM_LOCK_OUT      => open,
      GT6_RX_MMCM_LOCK_OUT      => open,
      GT7_TX_FSM_RESET_DONE_OUT => open,
      GT7_RX_FSM_RESET_DONE_OUT => open,
      GT7_DATA_VALID_IN         => '1',
      GT7_TX_MMCM_LOCK_OUT      => open,
      GT7_RX_MMCM_LOCK_OUT      => open,

      GT0_TXUSRCLK_OUT  => open,
      GT0_TXUSRCLK2_OUT => tx_usrclk_2(0),
      GT0_RXUSRCLK_OUT  => open,
      GT0_RXUSRCLK2_OUT => rx_usrclk_2(0),

      GT1_TXUSRCLK_OUT  => open,
      GT1_TXUSRCLK2_OUT => tx_usrclk_2(1),
      GT1_RXUSRCLK_OUT  => open,
      GT1_RXUSRCLK2_OUT => rx_usrclk_2(1),

      GT2_TXUSRCLK_OUT  => open,
      GT2_TXUSRCLK2_OUT => tx_usrclk_2(2),
      GT2_RXUSRCLK_OUT  => open,
      GT2_RXUSRCLK2_OUT => rx_usrclk_2(2),

      GT3_TXUSRCLK_OUT  => open,
      GT3_TXUSRCLK2_OUT => tx_usrclk_2(3),
      GT3_RXUSRCLK_OUT  => open,
      GT3_RXUSRCLK2_OUT => rx_usrclk_2(3),

      GT4_TXUSRCLK_OUT  => open,
      GT4_TXUSRCLK2_OUT => tx_usrclk_2(4),
      GT4_RXUSRCLK_OUT  => open,
      GT4_RXUSRCLK2_OUT => rx_usrclk_2(4),

      GT5_TXUSRCLK_OUT  => open,
      GT5_TXUSRCLK2_OUT => tx_usrclk_2(5),
      GT5_RXUSRCLK_OUT  => open,
      GT5_RXUSRCLK2_OUT => rx_usrclk_2(5),

      GT6_TXUSRCLK_OUT  => open,
      GT6_TXUSRCLK2_OUT => tx_usrclk_2(6),
      GT6_RXUSRCLK_OUT  => open,
      GT6_RXUSRCLK2_OUT => rx_usrclk_2(6),

      GT7_TXUSRCLK_OUT  => open,
      GT7_TXUSRCLK2_OUT => tx_usrclk_2(7),
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
      gt0_gtrxreset_in         => rx_rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt0_rxpolarity_in                       => rx_polarity(0),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt0_gthrxp_in            => rxp(0),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt0_rxresetdone_out      => rx_rstdone(0),
      --------------------- TX Initialization and Reset Ports --------------------
      gt0_gttxreset_in         => tx_rst_xcvr,
      gt0_txuserrdy_in         => tx_usrrdy(0),
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt0_txdata_in            => data_in(1*SER_WIDTH-1 downto 0*SER_WIDTH),
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt0_gthtxn_out           => txn(0),
      gt0_gthtxp_out           => txp(0),
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt0_txoutclkfabric_out   => open,
      gt0_txoutclkpcs_out      => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt0_txresetdone_out      => tx_rstdone(0),

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
      gt1_gtrxreset_in         => rx_rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt1_rxpolarity_in                       => rx_polarity(1),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt1_gthrxp_in            => rxp(1),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt1_rxresetdone_out      => rx_rstdone(1),
      --------------------- TX Initialization and Reset Ports --------------------
      gt1_gttxreset_in         => tx_rst_xcvr,
      gt1_txuserrdy_in         => tx_usrrdy(1),
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt1_txdata_in            => data_in(2*SER_WIDTH-1 downto 1*SER_WIDTH),
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt1_gthtxn_out           => txn(1),
      gt1_gthtxp_out           => txp(1),
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt1_txoutclkfabric_out   => open,
      gt1_txoutclkpcs_out      => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt1_txresetdone_out      => tx_rstdone(1),   

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
      gt2_gtrxreset_in         => rx_rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt2_rxpolarity_in                       => rx_polarity(2),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt2_gthrxp_in            => rxp(2),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt2_rxresetdone_out      => rx_rstdone(2),
      --------------------- TX Initialization and Reset Ports --------------------
      gt2_gttxreset_in         => tx_rst_xcvr,
      gt2_txuserrdy_in         => tx_usrrdy(2),
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt2_txdata_in            => data_in(3*SER_WIDTH-1 downto 2*SER_WIDTH),
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt2_gthtxn_out           => txn(2),
      gt2_gthtxp_out           => txp(2),
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt2_txoutclkfabric_out   => open,
      gt2_txoutclkpcs_out      => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt2_txresetdone_out      => tx_rstdone(2),

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
      gt3_gtrxreset_in         => rx_rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt3_rxpolarity_in                       => rx_polarity(3),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt3_gthrxp_in            => rxp(3),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt3_rxresetdone_out      => rx_rstdone(3),
      --------------------- TX Initialization and Reset Ports --------------------
      gt3_gttxreset_in         => tx_rst_xcvr,
      gt3_txuserrdy_in         => tx_usrrdy(3),
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt3_txdata_in            => data_in(4*SER_WIDTH-1 downto 3*SER_WIDTH),
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt3_gthtxn_out           => txn(3),
      gt3_gthtxp_out           => txp(3),
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt3_txoutclkfabric_out   => open,
      gt3_txoutclkpcs_out      => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt3_txresetdone_out      => tx_rstdone(3),

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
      gt4_gtrxreset_in         => rx_rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt4_rxpolarity_in                       => rx_polarity(4),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt4_gthrxp_in            => rxp(4),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt4_rxresetdone_out      => rx_rstdone(4),
      --------------------- TX Initialization and Reset Ports --------------------
      gt4_gttxreset_in         => tx_rst_xcvr,
      gt4_txuserrdy_in         => tx_usrrdy(4),
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt4_txdata_in            => data_in(5*SER_WIDTH-1 downto 4*SER_WIDTH),
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt4_gthtxn_out           => txn(4),
      gt4_gthtxp_out           => txp(4),
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt4_txoutclkfabric_out   => open,
      gt4_txoutclkpcs_out      => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt4_txresetdone_out      => tx_rstdone(4),

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
      gt5_gtrxreset_in         => rx_rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt5_rxpolarity_in                       => rx_polarity(5),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt5_gthrxp_in            => rxp(5),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt5_rxresetdone_out      => rx_rstdone(5),
      --------------------- TX Initialization and Reset Ports --------------------
      gt5_gttxreset_in         => tx_rst_xcvr,
      gt5_txuserrdy_in         => tx_usrrdy(5),
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt5_txdata_in            => data_in(6*SER_WIDTH-1 downto 5*SER_WIDTH),
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt5_gthtxn_out           => txn(5),
      gt5_gthtxp_out           => txp(5),
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt5_txoutclkfabric_out   => open,
      gt5_txoutclkpcs_out      => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt5_txresetdone_out      => tx_rstdone(5),

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
      gt6_gtrxreset_in         => rx_rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt6_rxpolarity_in                       => rx_polarity(6),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt6_gthrxp_in            => rxp(6),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt6_rxresetdone_out      => rx_rstdone(6),
      --------------------- TX Initialization and Reset Ports --------------------
      gt6_gttxreset_in         => tx_rst_xcvr,
      gt6_txuserrdy_in         => tx_usrrdy(6),
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt6_txdata_in            => data_in(7*SER_WIDTH-1 downto 6*SER_WIDTH),
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt6_gthtxn_out           => txn(6),
      gt6_gthtxp_out           => txp(6),
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt6_txoutclkfabric_out   => open,
      gt6_txoutclkpcs_out      => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt6_txresetdone_out      => tx_rstdone(6),

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
      gt7_gtrxreset_in         => rx_rst_xcvr,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      --gt7_rxpolarity_in                       => rx_polarity(7),
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      gt7_gthrxp_in            => rxp(7),
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt7_rxresetdone_out      => rx_rstdone(7),
      --------------------- TX Initialization and Reset Ports --------------------
      gt7_gttxreset_in         => tx_rst_xcvr,
      gt7_txuserrdy_in         => tx_usrrdy(7),
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt7_txdata_in            => data_in(8*SER_WIDTH-1 downto 7*SER_WIDTH),
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt7_gthtxn_out           => txn(7), 
      gt7_gthtxp_out           => txp(7), 
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt7_txoutclkfabric_out   => open,
      gt7_txoutclkpcs_out      => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt7_txresetdone_out      => tx_rstdone(7),

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
  --
  rx_frame_clk <= rx_usrclk_2(0); 
  rx_usrclk    <= rx_usrclk_2(0);
  --
  tx_frame_clk <= tx_usrclk_2(0); 
  tx_usrclk    <= tx_usrclk_2(0);
  --
end architecture rtl;
