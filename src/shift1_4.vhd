library ieee;
use ieee.std_logic_1164.all;

entity shift1_4 is 	-- entity declaration
	port (
		x 		: 	in std_logic_vector(15 downto 0); 	-- input to be divided by 4
		clk		: 	in std_logic; 						-- clock
		rst_14	:	in std_logic; 						-- reset
		y_14 	:	out std_logic_vector(15 downto 0) 	-- result = input / 4 (input >> 4)
	);
end shift1_4;

architecture bhv of shift1_4 is 			-- architectural description (behavioral description)

begin

	shift1_4_proc: process(clk, rst_14) 	-- Process doing a sequential network with asynchronous reset
	begin 
		if(rst_14 = '0') then 				-- Asynchronous reset model
			y_14 <= (others => '0'); 		-- clearing output

		elsif (rising_edge(clk)) then 		-- positive edge trigger D-flip-flop modelling
				
			if(x(15) = '1') then 			-- Since this is a Shift Aritmethic Right operation, the sign of the input vector has to be checked 
				y_14(15 downto 14) <= "11"; -- if it's a negative number, then the two MSBs have to be ones, to keep the sign consistency 
			else 
				y_14(15 downto 14) <= "00"; -- otherwise, if its 0, then the MSBs have to be zeros, to keep the sign consistency
			end if;

			y_14(13 downto 0) <= x(15 downto 2); -- short circuit to ignore the last two LSBs, later on, this will be a warning because the 
												-- two LSBs of x are not connected.
		end if;
	end process;
		
end bhv;