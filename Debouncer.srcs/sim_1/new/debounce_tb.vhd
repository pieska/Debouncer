----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2018 18:58:32
-- Design Name: 
-- Module Name: debounce_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce_tb is
--  Port ( );
end debounce_tb;

architecture Behavioral of debounce_tb is

component debounce is
	generic (
		stable_clocks: positive := 10
	);
    port (
    	clk : in std_logic;
    	raw : in std_logic;
    	deb : out std_logic
    );
end component;

constant clkp: time := 1ms;

signal clk_sim: std_logic;
signal raw_sim: std_logic;
signal deb_sim: std_logic;

begin
	dut: debounce 
	port map (
		clk => clk_sim,
		raw => raw_sim,
		deb => deb_sim
	);

	clk_gen: process
	begin
		clk_sim <= '1';
		wait for clkp / 2;
		clk_sim <= '0';
		wait for clkp / 2;		
	end process clk_gen;

	sim: process
	begin
		raw_sim <= '0';
		wait for 14ms; -- clkp * stable_clocks + 4 clocks
		assert (deb_sim = '0') report "deb_sim != 0" severity failure;
		wait for 7ms;
		raw_sim <= '1';
		wait for 1ms;		
		raw_sim <= '0';
		wait for 2ms;
		raw_sim <= '1';
		wait for 20ms;
		
		raw_sim <= '0';
		wait for 2ms;
		raw_sim <= '1';
		wait for 1ms;
		raw_sim <= '0';
		wait for 1ms;
		raw_sim <= '1';
		wait for 3ms;
		raw_sim <= '0';
		wait;
	end process sim;


end Behavioral;
