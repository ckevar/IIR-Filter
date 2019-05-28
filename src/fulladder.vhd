library ieee;
use ieee.std_logic_1164.all;

entity fulladder is 		-- entity declaration
	port (
		a 	:	in std_logic; 	-- input: operand 1
		b 	: 	in std_logic; 	-- input: operand 2
		cin : 	in std_logic; 	-- input: carry in
		cout: 	out std_logic; 	-- output: carry out
		s 	: 	out std_logic 	-- output: result = operand 1 + operand 2
	);
end fulladder;

architecture bhv of fulladder is --- architectural declaration (behavioral description)

begin
	
	s <= a xor  b xor cin; 		-- result
	cout <= (a and b) or (a and cin) or (b and cin); -- carry out

end bhv;