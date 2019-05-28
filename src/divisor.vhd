library ieee;
use ieee.std_logic_1164.all;

entity divisor is 			-- entity declaration,  
	port (
		x0 : in std_logic_vector(15 downto 0); 	-- input0
		x1 : in std_logic_vector(15 downto 0); 	-- input1
		clk_div: in std_logic; 					-- clock 
		rst_div: in std_logic; 					-- Asynchronous active low reset
		y0 : out std_logic_vector(15 downto 0); -- output0 = input0 / 4
		y1 : out std_logic_vector(15 downto 0) 	-- output1 = input1 / 4
	);
end entity divisor;

architecture rtl of divisor is
	component shift1_4 is 		-- calling shift arithmetic righr, it shifts by 2 (divides by 4)
		port (
			x 		: 	in std_logic_vector(15 downto 0); 	-- input
			clk		: 	in std_logic; 						-- clock
			rst_14	:	in std_logic; 						-- reset
			y_14 	:	out std_logic_vector(15 downto 0)  	-- result = input / 4
		);
	end component shift1_4;
begin
	div1: shift1_4	 			-- first operation, output0 = input0 / 4
		port map ( 			
		 	x => x0,
		 	clk => clk_div,
		 	rst_14 => rst_div,
		 	y_14 => y0 
		); 

	div2: shift1_4 				-- first operation, output0 = input1 / 4
		port map (
		 	x => x1,
		 	clk => clk_div,
		 	rst_14 => rst_div,
		 	y_14 => y1 
		);

end architecture rtl;