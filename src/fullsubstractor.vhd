library ieee;
use ieee.std_logic_1164.all;

entity fulllsubstractor is 			-- entity declaration
	port (
		min		: in std_logic; 	-- input minuend
		sub		: in std_logic; 	-- input subtrahend
		bin 	: in std_logic; 	-- input borrow in
		bout	: out std_logic; 	-- out borrow out
		diff	: out std_logic 	-- output result = miuend - subtrahend
	);
end entity fulllsubstractor;

architecture bhv of fulllsubstractor is 	-- architectural description (behavioral description)

begin

	diff <= min xor sub xor bin; 			-- result 
	bout <= (bin and not(min)) or (not(min) and sub) or (sub and bin); -- borrow out
	
end architecture bhv;