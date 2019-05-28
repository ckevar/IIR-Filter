library ieee;
use ieee.std_logic_1164.all;

entity rfs_tb is
end entity rfs_tb;

architecture bhv of rfs_tb is
	constant T_CLK : time := 10 ns;
	constant T_RESET : time := 25 ns;
	constant N_BITS : integer := 8;

	signal clk_tb 	: std_logic := '0';
	signal rst_tb 	: std_logic := '0';
	signal min_tb	: std_logic_vector(N_BITS - 1 downto 0);
	signal sub_tb	: std_logic_vector(N_BITS - 1 downto 0);
	signal bin_tb 	: std_logic;
	signal bout_tb 	: std_logic;
	signal diff_tb 	: std_logic_vector(N_BITS - 1 downto 0);

	signal end_sim 	: std_logic := '1';

	component rbs is
		generic (Nbit_rbs : integer);
		port (
			minN : in std_logic_vector(Nbit_rbs - 1 downto 0);
			subN : in std_logic_vector(Nbit_rbs - 1 downto 0);
			binN : in std_logic;
			boutN: out std_logic;
			diffN: out std_logic_vector(Nbit_rbs - 1 downto 0)
		);
	end component rbs;

begin
	clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;
	rst_tb <= '1' after T_RESET;

	test_rfs: rbs 
		generic map (Nbit_rbs => N_BITS)
		port map (
			minN => min_tb,
			subN => sub_tb,
			binN => bin_tb,
			boutN => bout_tb,
			diffN => diff_tb
		);

	rfs_process : process (clk_tb)
		variable t : integer := 0;
	begin
		if(rst_tb = '0') then
			min_tb <= (others => '0');
			sub_tb <= (others => '0');
			bin_tb <= '0';
			t := 0;
		elsif (rising_edge(clk_tb)) then
			case(t) is
				when 1 => 	min_tb <= (others => '0');
							sub_tb <= (others => '0');
				
				when 2 => 	min_tb <= "00000001";
							sub_tb <= "00000011";
				
				when 5 => 	min_tb <= (others => '0');
							sub_tb <= (others => '0');
				when 10 => end_sim <= '0';
				when others => null;
			end case;
			t := t + 1;
		end if;
	end process; 
end architecture bhv;

