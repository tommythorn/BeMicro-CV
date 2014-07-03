library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bemicro_cv_top is
  port (
    CLK_50      : in    std_logic;
    DIP_N       : in    std_logic_vector(3 downto 1);
    SW_N        : in    std_logic_vector(2 downto 1);
    LED_N       :   out std_logic_vector(7 downto 0);

    MEM_A       :   out std_logic_vector(12 downto 0);
    MEM_BA      :   out std_logic_vector( 2 downto 0);

    MEM_DQ      : inout std_logic_vector(15 downto 0);
    MEM_DQS     : inout std_logic_vector( 1 downto 0);
    MEM_DQS_N   : inout std_logic_vector( 1 downto 0);
    MEM_DM      :   out std_logic_vector( 1 downto 0);

    MEM_RESET_N :   out std_logic;
    MEM_CS_N    :   out std_logic_vector(0 downto 0);
    MEM_WE_N    :   out std_logic_vector(0 downto 0);
    MEM_RAS_N   :   out std_logic_vector(0 downto 0);
    MEM_CAS_N   :   out std_logic_vector(0 downto 0);
    MEM_CK      :   out std_logic_vector(0 downto 0);
    MEM_CK_N    :   out std_logic_vector(0 downto 0);
    MEM_CKE     :   out std_logic_vector(0 downto 0);
    MEM_ODT     :   out std_logic_vector(0 downto 0);
    MEM_RZQ     :    in std_logic
  );
end;


architecture rtl of bemicro_cv_top is

  component bemicro_cv is
      port (
          clk_clk          : in    std_logic                     := 'X';             -- clk
          reset_reset_n    : in    std_logic                     := 'X';             -- reset_n
          led_export       : out   std_logic_vector(7 downto 0);                     -- export
          sw_export        : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- export
          pb_export        : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
          ddr3_mem_a       : out   std_logic_vector(12 downto 0);                    -- mem_a
          ddr3_mem_ba      : out   std_logic_vector(2 downto 0);                     -- mem_ba
          ddr3_mem_ck      : out   std_logic_vector(0 downto 0);                     -- mem_ck
          ddr3_mem_ck_n    : out   std_logic_vector(0 downto 0);                     -- mem_ck_n
          ddr3_mem_cke     : out   std_logic_vector(0 downto 0);                     -- mem_cke
          ddr3_mem_cs_n    : out   std_logic_vector(0 downto 0);                     -- mem_cs_n
          ddr3_mem_dm      : out   std_logic_vector(1 downto 0);                     -- mem_dm
          ddr3_mem_ras_n   : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
          ddr3_mem_cas_n   : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
          ddr3_mem_we_n    : out   std_logic_vector(0 downto 0);                     -- mem_we_n
          ddr3_mem_reset_n : out   std_logic;                                        -- mem_reset_n
          ddr3_mem_dq      : inout std_logic_vector(15 downto 0) := (others => 'X'); -- mem_dq
          ddr3_mem_dqs     : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- mem_dqs
          ddr3_mem_dqs_n   : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- mem_dqs_n
          ddr3_mem_odt     : out   std_logic_vector(0 downto 0);                     -- mem_odt
          ddr3_oct_rzqin   : in    std_logic                     := 'X';             -- rzqin
          ddr3_status_local_init_done   : out   std_logic;                           -- local_init_done
          ddr3_status_local_cal_success : out   std_logic;                           -- local_cal_success
          ddr3_status_local_cal_fail    : out   std_logic                            -- local_cal_fail
      );
  end component bemicro_cv;

--  signal LED_2 : std_logic_vector(7 downto 0);
  signal STATUS : std_logic_vector(2 downto 0);
  signal RESET_N : std_logic;
  
begin

--    process( CLK_50 )
--    begin
--      if( rising_edge(CLK_50) ) then
--        LED_N(7 downto 3) <= "11111";
--        LED_N(2 downto 0) <= NOT STATUS;
--  --      LED_N <= DIP_N & DIP_N & SW_N;
--      end if;
--    end process;

    RESET_N <= SW_N(2) OR SW_N(1);

    u0 : component bemicro_cv
        port map (
            clk_clk          => CLK_50,                        --   clk.clk
            reset_reset_n    => RESET_N,                       -- reset.reset_n
            led_export       => LED_N,                         --   led.export
            sw_export        => DIP_N,                         --    sw.export
            pb_export        => SW_N,                          --    pb.export
            ddr3_mem_a       => MEM_A,                         --  ddr3.mem_a
            ddr3_mem_ba      => MEM_BA,                        --      .mem_ba
            ddr3_mem_ck      => MEM_CK,                        --      .mem_ck
            ddr3_mem_ck_n    => MEM_CK_N,                      --      .mem_ck_n
            ddr3_mem_cke     => MEM_CKE,                       --      .mem_cke
            ddr3_mem_cs_n    => MEM_CS_N,                      --      .mem_cs_n
            ddr3_mem_dm      => MEM_DM,                        --      .mem_dm
            ddr3_mem_ras_n   => MEM_RAS_N,                     --      .mem_ras_n
            ddr3_mem_cas_n   => MEM_CAS_N,                     --      .mem_cas_n
            ddr3_mem_we_n    => MEM_WE_N,                      --      .mem_we_n
            ddr3_mem_reset_n => MEM_RESET_N,                   --      .mem_reset_n
            ddr3_mem_dq      => MEM_DQ,                        --      .mem_dq
            ddr3_mem_dqs     => MEM_DQS,                       --      .mem_dqs
            ddr3_mem_dqs_n   => MEM_DQS_N,                     --      .mem_dqs_n
            ddr3_mem_odt     => MEM_ODT,                       --      .mem_odt
            ddr3_oct_rzqin   => MEM_RZQ,                       -- ddr3_oct.rzqin
            ddr3_status_local_init_done   => STATUS(0),        -- ddr3_status.local_init_done
            ddr3_status_local_cal_success => STATUS(1),        --            .local_cal_success
            ddr3_status_local_cal_fail    => STATUS(2)         --            .local_cal_fail
        );

end;
