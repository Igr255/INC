-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): 
--
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK 				: in std_logic;
   RST 				: in std_logic;
   DIN 				: in std_logic;
   CNT_EN			: out std_logic;
   DATA_CONFIRM     : out std_logic;
   CNT				: in std_logic_vector(4 downto 0);
   DATA_BIT_CNT		: in std_logic_vector(3 downto 0)   
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
type STATE is (WAIT_START_BIT, WAIT_STOP_BIT,WAIT_INFO_BIT,READ_INFO);
signal signal_state : STATE := WAIT_START_BIT;
begin

CNT_EN <= '1' when signal_state = READ_INFO else '0';
DATA_CONFIRM <= '1' when signal_state = WAIT_STOP_BIT else '0';

process(CLK) begin
	if RST = '1' then
		signal_state <= WAIT_START_BIT;
	else
		case signal_state is
			when WAIT_START_BIT	=>  if DIN = '0' then
										signal_state <= WAIT_INFO_BIT;
									end if;
			
			when WAIT_INFO_BIT 	=>   if CNT = "11000" then
										signal_state <= READ_INFO;
									end if;
		
	
			when READ_INFO 	=>	if DATA_BIT_CNT = "1000" then
										signal_state <= WAIT_STOP_BIT;
									end if;
									
			when WAIT_STOP_BIT 	=>   if DIN ='1' then
										signal_state <= WAIT_START_BIT;
									end if;
			when others        	=> 	null;
		end case;
	end if;
end process;


end behavioral;
