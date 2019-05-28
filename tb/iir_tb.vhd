library ieee;
use ieee.std_logic_1164.all;

entity iir_tb is -- empty entity declaration
end entity iir_tb;

architecture bhv of iir_tb is
	constant T_CLK 		: time := 22676 ns; 	-- clock for audio application
	constant T_RESET 	: time := 55352 ns; 		-- reset time 

	signal clk_tb 	: std_logic := '0'; 		-- clck starts at 0
	signal rst_tb 	: std_logic := '0';			-- reset startts at 0

	signal x_tb 	: std_logic_vector(15 downto 0); 	-- declaring input vector
	signal y_tb		: std_logic_vector(15 downto 0); 	-- output vector

	signal end_sim 	: std_logic := '1'; 

	component iir is 				-- calling filter component
		port (
			x 	: in std_logic_vector(15 downto 0);
			y 	: out std_logic_vector(15 downto 0);
			clk : in std_logic;
			rst : in std_logic
		);
	end component iir;

begin

	clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;	-- enerating clock
	rst_tb <= '1' after T_RESET; 							-- 
 
	test_iir: iir 		-- mapping the filter with signals of the test bench
		port map (
			x => x_tb,
			y => y_tb,
			clk => clk_tb,
			rst => rst_tb
		);
	
		d_process : process (clk_tb, rst_tb) 	
			variable t : integer := 0; 	-- clock counter
		begin
			if(rst_tb = '0') then
				x_tb <= (others => '0'); -- in case of reset
				t := 0; 
			elsif (rising_edge(clk_tb)) then
				case(t) is 				-- calues generated with MATLAB screipt
					when 1 => x_tb <= "0000000000000000";
					when 2 => x_tb <= "0100100011100100";
					when 3 => x_tb <= "0010010010101010";
					when 4 => x_tb <= "1110000001011101";
					when 5 => x_tb <= "1111111100111011";
					when 6 => x_tb <= "0101101000011101";
					when 7 => x_tb <= "0110001000011100";
					when 8 => x_tb <= "0001010010000111";
					when 9 => x_tb <= "1111111101000010";
					when 10 => x_tb <= "0100111000011011";
					when 11 => x_tb <= "0111111111000111";
					when 12 => x_tb <= "0100001010111001";
					when 13 => x_tb <= "0000000001110001";
					when 14 => x_tb <= "0010100100101000";
					when 15 => x_tb <= "0111010000001111";
					when 16 => x_tb <= "0101101111001011";
					when 17 => x_tb <= "0000001001111000";
					when 18 => x_tb <= "1111011110000101";
					when 19 => x_tb <= "0100001011000011";
					when 20 => x_tb <= "0101011101000100";
					when 21 => x_tb <= "0000010001110000";
					when 22 => x_tb <= "1100100101011011";
					when 23 => x_tb <= "1111101111100000";
					when 24 => x_tb <= "0011011000111000";
					when 25 => x_tb <= "0000010100111010";
					when 26 => x_tb <= "1010110101110110";
					when 27 => x_tb <= "1011011001011100";
					when 28 => x_tb <= "0000001100001111";
					when 29 => x_tb <= "0000010000000001";
					when 30 => x_tb <= "1010110010001000";
					when 31 => x_tb <= "1000100010111100";
					when 32 => x_tb <= "1100111000111100";
					when 33 => x_tb <= "0000000010110100";
					when 34 => x_tb <= "1100011001110011";
					when 35 => x_tb <= "1000000111000001";
					when 36 => x_tb <= "1010100011110100";
					when 37 => x_tb <= "1111110000101110";
					when 38 => x_tb <= "1111001001110011";
					when 39 => x_tb <= "1010001110100110";
					when 40 => x_tb <= "1001111110010101";
					when 41 => x_tb <= "1111100000000010";
					when 42 => x_tb <= "0010001000011000";
					when 43 => x_tb <= "1110001101101000";
					when 44 => x_tb <= "1011010110000100";
					when 45 => x_tb <= "1111010111101111";
					when 46 => x_tb <= "0100011000000001";
					when 47 => x_tb <= "0010110001011010";
					when 48 => x_tb <= "1110010000000000";
					when 49 => x_tb <= "1111011100101111";
					when 50 => x_tb <= "0101001011010100";
					when 51 => x_tb <= "0110011011011011";
					when 52 => x_tb <= "0001110000101011";
					when 53 => x_tb <= "1111101111100010";
					when 54 => x_tb <= "0100010011010011";
					when 55 => x_tb <= "0111111111111111";
					when 56 => x_tb <= "0100101111010101";
					when 57 => x_tb <= "0000001011011011";
					when 58 => x_tb <= "0010000011110100";
					when 59 => x_tb <= "0110111110101101";
					when 60 => x_tb <= "0110001101011000";
					when 61 => x_tb <= "0000100111011111";
					when 62 => x_tb <= "1111001100011111";
					when 63 => x_tb <= "0011101100111101";
					when 64 => x_tb <= "0101101011000100";
					when 65 => x_tb <= "0000111001100011";
					when 66 => x_tb <= "1100101000111011";
					when 67 => x_tb <= "1111001110110110";
					when 68 => x_tb <= "0011010010000101";
					when 69 => x_tb <= "0000111001101110";
					when 70 => x_tb <= "1011001101010101";
					when 71 => x_tb <= "1011000001001001";
					when 72 => x_tb <= "1111110010111100";
					when 73 => x_tb <= "0000100101101101";
					when 74 => x_tb <= "1011010101111000";
					when 75 => x_tb <= "1000011011000101";
					when 76 => x_tb <= "1100010101100101";
					when 77 => x_tb <= "0000000010001111";
					when 78 => x_tb <= "1100111101111110";
					when 79 => x_tb <= "1000010010001111";
					when 80 => x_tb <= "1010000010001001";
					when 81 => x_tb <= "1111011010000100";
					when 82 => x_tb <= "1111100010011001";
					when 83 => x_tb <= "1010101001001011";
					when 84 => x_tb <= "1001101001011111";
					when 85 => x_tb <= "1110111010110010";
					when 86 => x_tb <= "0010001101001110";
					when 87 => x_tb <= "1110101110101101";
					when 88 => x_tb <= "1011010100111011";
					when 89 => x_tb <= "1110110000001110";
					when 91 => x_tb <= (others => '0');
					when 92 => end_sim <= '0';
					when others => null;
				end case;
				t := t + 1;
			end if;
		end process;

end architecture bhv;