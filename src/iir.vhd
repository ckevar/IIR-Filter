library ieee;
use ieee.std_logic_1164.all;

entity iir is								-- entity declaration
	port (									
		x 	: in std_logic_vector(15 downto 0); 	-- input filter
		y 	: out std_logic_vector(15 downto 0);	-- output filter
		clk : in std_logic;							-- clock
		rst : in std_logic
	);
end entity iir;

architecture rtl of iir is					-- architectural declaration (Register-Transfer Level) 
	component paralleldff is				-- Calling Parallel Register
		generic (N_bit : integer);			-- generic parameter modelling the generic number of bits of the parallel register 
		port (
			d 	: in std_logic_vector(N_bit - 1 downto 0); 	-- input register
			q 	: out std_logic_vector(N_bit - 1 downto 0);	-- output register
			clk : in std_logic;								-- clk
			resetn : in std_logic 							-- Reset button
		);
	end component paralleldff;

	component delayerx4 is					-- calling 4 delays
		generic (Nbit_d : integer);			-- generic parameter modelling the generic number of bits of the delayer
		port (
			x : in std_logic_vector(Nbit_d - 1 downto 0); 	-- input
			clk_d : in std_logic;							-- clock
			rst_d : in std_logic; 							-- reset
			xz4 : out std_logic_vector(Nbit_d - 1 downto 0)	-- output (4 clock cycles delayed)
		);
	end component delayerx4;

	component divisor is					-- calling divisor-by-4 module
		port (
			x0 : in std_logic_vector(15 downto 0); 	-- input 0
			x1 : in std_logic_vector(15 downto 0);	-- input 1
			clk_div: in std_logic;					-- clock
			rst_div: in std_logic;					-- reset
			y0 : out std_logic_vector(15 downto 0);	-- output 0 = input 0 / 4
			y1 : out std_logic_vector(15 downto 0)	-- output 1 = input 1 / 4
		);
	end component divisor;

	component RCA is 						-- calling Ripple Carry Adder
		generic (N_bit : integer);			-- generic parameter modelling number of bits of operands 
		port (
			aN 		: in std_logic_vector(N_bit - 1 downto 0); 	-- operand 1
			bN 		: in std_logic_vector(N_bit - 1 downto 0);	-- operand 2
			cinN 	: in std_logic;								-- carry in
			coutN 	: out std_logic;							-- carry out
			sN 		: out std_logic_vector(N_bit - 1 downto 0) 	-- result = openra 1 + operand 2
		);
	end component RCA;

	component RBS is 						-- calling Substractor
		generic (Nbit_rbs : integer);		-- generic parameter modelling number of bits of operands
		port (
			minN : in std_logic_vector(Nbit_rbs - 1 downto 0); 	-- operand 1
			subN : in std_logic_vector(Nbit_rbs - 1 downto 0);	-- operand 2
			binN : in std_logic; 								-- borrow in
			boutN: out std_logic;								-- borrow out
			diffN: out std_logic_vector(Nbit_rbs - 1 downto 0) 	-- result = operand 1 - operand 2
		);
	end component RBS;

	signal yz1 	: std_logic_vector(15 downto 0);	-- internal signal used to map 1-clock-cycle delay the output 
	signal xz4 	: std_logic_vector(15 downto 0);	-- internal signal used to map 4-clock-cycle delay the output
	signal sx 	: std_logic_vector(15 downto 0);	-- internal signal used to map the result of the x / 4 
	signal sy 	: std_logic_vector(15 downto 0);	-- internal signal used to map the result of 
	signal sxz4	: std_logic_vector(15 downto 0);	-- internal signal used to map the result of 4-cycles delayed / 4
	signal sum1	: std_logic_vector(15 downto 0);	-- internal signal used to
	signal co1 	: std_logic;						-- internal signal used to map the carry out of the RCA
	signal bo 	: std_logic;						-- internal signal used to map the borrow out of the Substractor
begin
	
	dx4 : delayerx4							-- delays the signal 4-clock cycles
		generic map (Nbit_d => 16)			-- mapped as 16 bits, according to the requirements
		port map (						
			x => x,							-- mapping the input
			clk_d => clk,					-- mapping the clock
			rst_d => rst,					-- mapping the reset
			xz4 => xz4						-- mapping the delayed output
		);
	
	div: divisor 							-- divides two entries by 4, according to the requirements 
		port map (	
			x0 => x,						-- mapping input x
			x1 => xz4,						-- mapping 4-clock-cycles delayed output 
			clk_div => clk,					-- mapping clock
			rst_div => rst,					-- mapping reset
			y0 => sx,						-- mapping result 0 = x / 4
			y1 => sxz4						-- mapping result 1 = 4-clock-cycles delayed / 4
		);

	y_z1: paralleldff					 	-- Delays the output of the system by 1-clock cycle 
		generic map (N_bit => 16)			-- mapping 16 bits according to requirements
		port map (
			d => sy,						-- mapping output of the system 
			q => yz1,						-- mapping delayed output 
			clk => clk,						-- mapping clock
			resetn => rst 					-- mapping reset
	);

	c_RCA: RCA 								-- Summation module
		generic map (N_bit => 16) 			-- 
		port map (			
			aN => sxz4,						
			bN => yz1,
			cinN => '0',					-- mapping '0' as carry in
			coutN => co1, 					-- mapping carry out to an inner signal
			sN => sum1 						-- mapping result
		);

	c_RBS: RBS  							-- Substrator
		generic map (Nbit_rbs => 16)		-- mapping 16 bits as required 
		port map (
			minN => sum1, 					-- mapping minuend, result of the sumation 
			subN => sx,						-- mapping result of the 
			binN => '0', 					-- mapping as 0 the borrow in
			boutN => bo, 					-- mapping borrow out as inner signal
			diffN => sy 					-- mapping the result 
		); 
	y <= sy; 								-- system result.

end rtl;