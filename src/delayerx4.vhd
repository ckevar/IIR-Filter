library ieee;
use ieee.std_logic_1164.all;

entity delayerx4 is 	-- entity declaration 
	generic (Nbit_d : integer); 	-- generic parameter modelling the generic number of bits
	port (
		x : in std_logic_vector(Nbit_d - 1 downto 0); 	-- input to be delayed 4-clock cycles
		clk_d : in std_logic; 							-- clock
		rst_d : in std_logic; 							-- Asynchronous active low reset
		xz4 : out std_logic_vector(Nbit_d - 1 downto 0) -- output: delayed x by 4-clock cycles
	);
end entity delayerx4;

architecture rtl of delayerx4 is 						-- architectural declaration (Register-Transfer Level)
	component paralleldff is 							-- call parallel register
		generic (N_bit : integer); 						-- generic param modelling number of bits of the register
		port (
			d 	: in std_logic_vector(N_bit - 1 downto 0); -- 
			q 	: out std_logic_vector(N_bit - 1 downto 0);
			clk : in std_logic;
			resetn: in std_logic
		);
	end component paralleldff;

	signal xz1 	: std_logic_vector(15 downto 0); 	-- internal signal used to 1-clock cycle delay
	signal xz2 	: std_logic_vector(15 downto 0); 	-- internal signal used to 2-clock cycle delay
	signal xz3 	: std_logic_vector(15 downto 0); 	-- internal signal used to 3-clock cycle delay
begin
	
	x_z1: paralleldff 								-- delays the input X by 1-clock cycle
		generic map (N_bit => Nbit_d) 				-- mapping number of bits of the delayerx4 entity 
		port map (
			d => x, 								-- mapping input of the entity
			q => xz1, 								-- mapping 1-clock cycle delay
			clk => clk_d, 							-- mapping clock
			resetn => rst_d 						-- mapping reset
		);

	x_z2: paralleldff 								-- delays the 1-clock cycle by 1-clock cycle (input x is delayed 2-clock cycles)
		generic map (N_bit => Nbit_d) 				-- mapping number of bits of the delayerx4 entity
		port map (
			d => xz1, 								-- mapping 1-clock cycle delay 
			q => xz2, 								-- mapping 2-clock cycle delay
			clk => clk_d,
			resetn => rst_d
		);

	x_z3: paralleldff 								-- delays the 2-clock cycle by 1-clock cycle (input x is delayed 3-clock cycles)
		generic map (N_bit => Nbit_d) 				-- mapping number of bits of the delayerx4 entity
		port map (
			d => xz2,								-- mapping the 2-clock cycle delayed signal 
			q => xz3,								-- mapping the 3-clocl cycle delayed signal
			clk => clk_d,
			resetn => rst_d
		);

	x_z4: paralleldff 								-- delays the 3-clock cycle by 1-clock cycle (input x is delayed 4-clock cycles)
		generic map (N_bit => Nbit_d)				-- mapping number of bits of the delayerx4 entity
		port map (
			d => xz3, 								-- mapping the 3-clock cycle delayed signal 
			q => xz4, 								-- mapping the delayed signal to the output of the system
			clk => clk_d,
			resetn => rst_d
		);
	
end architecture rtl;