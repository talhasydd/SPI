library IEEE;
use IEEE.std_logic_1164.all;

entity SPI_TB is
end entity;

architecture TB of SPI_TB is
  
    -- Signals for SPI interface
    signal clk 		: std_logic := '0';
    signal reset 	: std_logic := '0';
    signal Tx_Byte 	: std_logic_vector(7 downto 0) := (others => '0');
    signal Tx_DV 	: std_logic := '0';
    signal Tx_Ready : std_logic;
    signal Rx_DV 	: std_logic;
    signal Rx_Byte 	: std_logic_vector(7 downto 0) := (others => '0');
    signal SPI_clk 	: std_logic;
    signal SPI_MISO : std_logic := '0';
    signal SPI_MOSI : std_logic;
	signal SPI_CS	: std_logic := '1'; -- Active low CS
    
    -- Constants for SPI generics
    constant SPI_Mode 			: integer := 0;  --  SPI mode (to test different modes)
    constant CLK_per_half_bit 	: integer := 2;  --  clock rate, sets SPI clock frequency
	constant received_data 		: std_logic_vector(7 downto 0) := "00110100";
    
    
    component SPI
        generic (
            SPI_Mode 			: integer := 0;
            CLK_per_half_bit 	: integer := 2
        );
        port (
            clk 				: in std_logic;
            reset 				: in std_logic;
            Tx_Byte 			: in std_logic_vector(7 downto 0);
            Tx_DV 				: in std_logic;
            Tx_Ready 			: out std_logic;
            Rx_DV 				: out std_logic;
            Rx_Byte 			: out std_logic_vector(7 downto 0);
            SPI_clk 			: out std_logic;
            SPI_MISO 			: in std_logic;
            SPI_MOSI 			: out std_logic;
            SPI_CS 				: out std_logic
        );
    end component;
    
begin

clk <= not clk after 5ns;


    UUT : SPI
        generic map (
            SPI_Mode 			=> SPI_Mode,
            CLK_per_half_bit 	=> CLK_per_half_bit
        )
        port map (
            clk 			=> clk,
            reset 			=> reset,
            Tx_Byte		 	=> Tx_Byte,
            Tx_DV			=> Tx_DV,
            Tx_Ready 		=> Tx_Ready,
            Rx_DV 			=> Rx_DV,
            Rx_Byte 		=> Rx_Byte,
            SPI_clk 		=> SPI_clk,
            SPI_MISO		=> SPI_MISO,
            SPI_MOSI		=> SPI_MOSI,
            SPI_CS 			=> SPI_CS
        );
        

    
	process
    begin
        reset <= '1';  -- Assert reset
        wait for 10 ns;
        reset <= '0';  -- Deassert reset
        
        -- Test scenario 1: Transmit data with Tx_DV pulse
        Tx_Byte <= X"5A";  
		Tx_DV   <= '1';  
		wait until rising_edge(clk);
		Tx_DV   <= '0';  
		wait until Tx_Ready = '1';  -- Wait for transmission to complete 
        
        -- Test scenario 2: Receive data
        Tx_Byte <= X"FF";  
        Tx_DV   <= '1';  
        wait until rising_edge(clk);
        Tx_DV   <= '0';
        wait until SPI_CS = '0';  -- Wait until chip select is asserted
    
        for i in 7 downto 0 loop
        wait until falling_edge(SPI_clk);
        SPI_MISO <= received_data(i);
        wait for 1 ns;  -- Small delay to ensure stable signal
  
		end loop;
		
        wait until Tx_Ready = '1';
        wait for 50 ns; 
        
	  -- Test scenario 3: Assert Chip Select (SPI_CS)
        Tx_Byte <= X"A5";  
        Tx_DV 	<= '1';  
        wait for 40 ns;  
       
        Tx_DV 	<= '0';  
       
        wait for 40 ns; 
        
        -- Test scenario 4: Test data valid (Tx_DV and Rx_DV)
        Tx_Byte <= X"77";  
        Tx_DV 	<= '1'; 
        wait for 40 ns;  
        Tx_DV 	<= '0';  
        wait for 40 ns;  
        assert Rx_DV = '1' report "Rx_DV was not asserted correctly" severity error;
        wait for 40 ns;  
        
        -- Test scenario 5: Test ready signal (Tx_Ready)
        Tx_Byte <= X"3C";  
        Tx_DV 	<= '1';  
        wait for 40 ns;  
        Tx_DV 	<= '0'; 
        wait for 40 ns;  
        assert Tx_Ready = '1' report "Tx_Ready was not asserted correctly" severity error;
        wait;
    end process;
    
end TB;
