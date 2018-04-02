library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    generic (
    	stable_clocks : natural := (125 * 10**6) / 1000 * 10 -- default to 10ms @ 125 MHz
    );
    port (
    	clk : in std_logic;
    	raw : in std_logic;	-- raw input
    	deb : out std_logic  -- rebounced output
    );
end debounce;

architecture Behavioral of debounce is

type debounce_state_type is (unknown, unstable, stable);

signal debounce_state: debounce_state_type := unknown;

signal s: std_logic := 'U';

signal cntr: natural := 0;

begin
	
	state_proc: process(clk)
	begin
		if rising_edge(clk) then
		
			case debounce_state is
				when unknown =>
					s <= raw;
					cntr <= stable_clocks;
					debounce_state <= unstable;
				when unstable =>
            		if s = raw then
            			if cntr = 0 then
            				debounce_state <= stable;
            			else
            				cntr <= cntr - 1;
            			end if;
            		else
            			-- raw changed, reset
            			debounce_state <= unknown;
	            	end if;
    	        when stable =>
        	    	if not s = raw then
        	    		-- raw changed, reset
            			debounce_state <= unknown;
	            	end if;
	            	-- s is stable
            		deb <= s;
				end case;
				
			end if;
	end process state_proc;

end Behavioral;
