
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK: 	    in std_logic;
	RST: 	    in std_logic;
	DIN: 	    in std_logic;
	DOUT: 	    out std_logic_vector(7 downto 0);
	DOUT_VLD: 	out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
signal cnt 			: std_logic_vector(4 downto 0);
signal data_bit_cnt	: std_logic_vector(3 downto 0);
signal cnt_en    	: std_logic;
signal data_confirm : std_logic;

begin

	FSM: entity work.UART_FSM(behavioral)
    port map (		
        CLK 	     => CLK,
        RST 	     => RST,
        DIN 	     => DIN,
		CNT			 => cnt,
		DATA_BIT_CNT => data_bit_cnt,
		CNT_EN	 	 => cnt_en,
		DATA_CONFIRM => data_confirm
    );

	
	process(CLK) begin
		if falling_edge(CLK) then
			if RST = '1' then
				cnt <= "00000";
				data_bit_cnt <= "0000";				
			else
				cnt <= cnt +1;
			end if;	
				DOUT_VLD <= '0';
			
			if cnt = "11000" and cnt_en = '1' then
				DOUT(0) <= DIN; 
				data_bit_cnt <= data_bit_cnt +1;
				cnt <= "00000";
			end if;
			
			if cnt_en = '1' and cnt = "10000" then
				case data_bit_cnt is					
					when "0001" => DOUT(1) <= DIN;
					when "0010" => DOUT(2) <= DIN;
					when "0011" => DOUT(3) <= DIN;
					when "0100" => DOUT(4) <= DIN;
					when "0101" => DOUT(5) <= DIN;
					when "0110" => DOUT(6) <= DIN;
					when "0111" => DOUT(7) <= DIN;
					when others => null;
				end case;
				
				data_bit_cnt <= data_bit_cnt +1;
				cnt <= "00000";
			end if;
			
			if data_bit_cnt = "1000" then
				data_bit_cnt <= "0000";
			end if;
			
			if data_confirm = '1' and DIN = '1' then
				DOUT_VLD <= '1';
			end if;
			
			
		end if;
	end process;

end behavioral;
