library IEEE;
use IEEE.std_logic_1164.all;

entity paralleldff is   -- entity declaration
		generic(N_bit : integer);  -- generic parameter modelling the generic number of bits of the shift register
		port(
			d       : in std_logic_vector(N_bit - 1 downto 0);   --  Shift register input
			q       : out std_logic_vector(N_bit - 1 downto 0);  --  Shift register output
			clk     : in std_logic;   --  clk
			resetn : in std_logic    --  Asynchronous active low reset
		);
end paralleldff;

architecture bvh of paralleldff is 	 -- architectural declaration (behavioral description)

begin

	parallel_dff_proc : process(clk, resetn) 	-- Process doing a sequential network with asynchronous reset
	begin
		if(resetn = '0') then 					-- Asynchronous reset model
			q <= (others => '0'); 				-- clear output

		elsif (rising_edge(clk)) then 			-- Positive edge trigger D-flip-flop register model
			q <= d; 							-- sampling the input d
		end if;
	end process;

end bvh;


