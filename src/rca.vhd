library ieee;
use ieee.std_logic_1164.all;

entity RCA is 	-- entity declaration, ripple carry adder RCA
	generic (N_bit : integer); 	-- generica parameter modelling the number of bits to add
	port (
		aN 		: in std_logic_vector(N_bit - 1 downto 0);	-- vector operand 1
		bN 		: in std_logic_vector(N_bit - 1 downto 0);	-- vector operand 2
		cinN	: in std_logic;	 							-- carry in
		coutN 	: out std_logic;	 						-- carry out
		sN 		: out std_logic_vector(N_bit - 1 downto 0) 	-- result = operand 1 + operand 2
	);
end RCA;

architecture rtl of RCA is 			-- architectural description (Register-Transfer Level description)

	component fulladder is  		-- calling full adder component
		port (
			a 	:	in std_logic;
			b 	:	in std_logic;
			cin :	in std_logic;
			cout:	out std_logic;
			s 	: 	out std_logic
		);
	end component fulladder;

	signal c : std_logic_vector(N_bit - 2 downto 0); -- internal signal used to connect carries between full adders

begin
										-- generating full adders modules
	GEN : for i in 0 to N_bit generate  
		FIRST: if i = 0 generate		-- generatingg full adder for the LSB bits
			FF1: fulladder port map (aN(i), bN(i), cinN, c(i), sN(i));
		end generate FIRST;

		INTERNAL: if i > 0 and i < N_bit - 1 generate
			FFI: fulladder port map (aN(i), bN(i), c(i - 1), c(i), sN(i));
		end generate INTERNAL;

		LAST: if i = N_bit - 1 generate -- generating full adder for MSB bits
			FFN: fulladder port map (aN(i), bN(i), c(i - 1), coutN, sN(i));
		end generate LAST;

	end generate GEN;

end rtl;