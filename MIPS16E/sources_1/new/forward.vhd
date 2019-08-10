library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity forward is
	port(
		exe_alu_rx: in std_logic_vector(2 downto 0);
		exe_alu_ry: in std_logic_vector(1 downto 0);
		exe_select_address: in std_logic_vector(1 downto 0);
		
		memoryWrite: in std_logic;
		exe_where: in std_logic;
		
		rx: in std_logic_vector(2 downto 0);
		ry: in std_logic_vector(2 downto 0);
		
		address_memory: in std_logic_vector(3 downto 0);
		mem_registerWrite: in std_logic;
		mem_aluout: in std_logic_vector(15 downto 0);
		
		address_wb: in std_logic_vector(3 downto 0);
		wb_registerWrite: in std_logic;
		wb_toRegister: in std_logic_vector(15 downto 0);
		
		from_forward_datax: out std_logic := '0';
		from_forward_datay: out std_logic := '0';
		from_forward_address: out std_logic := '0';
		from_forward_memory: out std_logic := '0';
		
		memory_which: in std_logic_vector(1 downto 0);
--		wb_which: in std_logic_vector(1 downto 0);
		wb_memory_data: in std_logic_vector(15 downto 0);
		
		forward_memory: out std_logic_vector(15 downto 0) := "0000000000000000";
		forward_data: out std_logic_vector(15 downto 0) := "0000000000000000";
		forward_datay: out std_logic_vector(15 downto 0):= "0000000000000000"
		
	);
end forward;

architecture behavior of forward is
begin
	process(memory_which,wb_memory_data,exe_alu_rx,exe_alu_ry,exe_select_address,rx,ry,address_memory,mem_registerWrite,mem_aluout,address_wb,memoryWrite,exe_where,wb_registerWrite,wb_toRegister)
	begin
		if wb_registerWrite = '1' and address_memory /= address_wb and
			((exe_alu_rx = "000" and ("0" & rx) = address_wb) or  
			(exe_alu_rx = "001" and ("0" & ry) = address_wb) or
			(exe_alu_rx = "010" and address_wb = "1000") or
			(exe_alu_rx = "100" and address_wb = "1001") or
			(exe_alu_rx = "101" and address_wb = "1010") or
			(exe_alu_rx = "110" and address_wb= "1011")) then
			from_forward_datax <= '1';
			forward_data <= wb_toRegister;
	     elsif mem_registerWrite = '1' and 
                        ((exe_alu_rx = "000" and ("0" & rx) = address_memory) or  
                        (exe_alu_rx = "001" and ("0" & ry) = address_memory) or
                        (exe_alu_rx = "010" and address_memory = "1000") or
                        (exe_alu_rx = "100" and address_memory = "1001") or
                        (exe_alu_rx = "101" and address_memory = "1010") or
                        (exe_alu_rx = "110" and address_memory = "1011")) then
                        from_forward_datax <= '1';
            if    (memory_which="00") then
                        forward_data<=mem_aluout;
            --        elsif memory_which = "01" then
            --            forward_data<=wb_memory_data;
                    elsif memory_which = "10" then 
                        if mem_aluout = "0000000000000000" then
                            forward_data<="0000000000000000";
                        else
                            forward_data<="0000000000000001";
                        end if;
                    elsif memory_which = "11" then
                        if mem_aluout(15) = '0' then
                            forward_data<="0000000000000000";
                        else
                            forward_data<="0000000000000001";
                        end if;
                    end if;
                else
                from_forward_datax <= '0';
		
		end if;
		
		if wb_registerWrite = '1' and address_memory /= address_wb and
			((exe_alu_ry = "10" and ("0" & rx) = address_wb) or  
			(exe_alu_ry = "01" and ("0" & ry) = address_wb)) then
			from_forward_datay <= '1';
			forward_datay <= wb_toRegister;
			
	   elsif mem_registerWrite = '1' and 
                        ((exe_alu_ry = "10" and ("0" & rx) = address_memory) or  
                        (exe_alu_ry = "01" and ("0" & ry) = address_memory)) then
                        from_forward_datay <= '1';
            --            from_forward_datax <= '0';
            --            from_forward_address <= '0';
            --            from_forward_memory <= '0';
            --            forward_data <= mem_aluout;
            if    (memory_which="00") then
                        forward_datay<=mem_aluout;
            --        elsif memory_which = "01" then
            --            forward_data<=wb_memory_data;
                    elsif memory_which = "10" then 
                        if mem_aluout = "0000000000000000" then
                            forward_datay<="0000000000000000";
                        else
                            forward_datay<="0000000000000001";
                        end if;
                    elsif memory_which = "11" then
                        if mem_aluout(15) = '0' then
                            forward_datay<="0000000000000000";
                        else
                            forward_datay<="0000000000000001";
                        end if;
                    end if;
            else
                from_forward_datay <= '0';
            end if;

		
		if wb_registerWrite = '1' and address_memory /= address_wb and
			((exe_select_address = "10" and address_wb = "1001") or 
			(exe_select_address = "01" and ("0" & rx) = address_wb)) then
			from_forward_address <= '1';
--			from_forward_datay <= '0';
--			from_forward_datax <= '0';
--			from_forward_memory <= '0';
			forward_data <= wb_toRegister;
			
			elsif mem_registerWrite = '1' and 
                        ((exe_select_address = "10" and address_memory = "1001") or 
                        (exe_select_address = "01" and ("0" & rx) = address_memory)) then
                        from_forward_address <= '1';
            --            from_forward_datay <= '0';
            --            from_forward_datax <= '0';
            --            from_forward_memory <= '0';
            --            forward_data <= mem_aluout;
            if    (memory_which="00") then
                        forward_data<=mem_aluout;
            --        elsif memory_which = "01" then
            --            forward_data<=wb_memory_data;
                    elsif memory_which = "10" then 
                        if mem_aluout = "0000000000000000" then
                            forward_data<="0000000000000000";
                        else
                            forward_data<="0000000000000001";
                        end if;
                    elsif memory_which = "11" then
                        if mem_aluout(15) = '0' then
                            forward_data<="0000000000000000";
                        else
                            forward_data<="0000000000000001";
                        end if;
                    end if;
	   else
	   from_forward_address <= '0';
--                   from_forward_datay <= '0';
--                   from_forward_datax <= '0';

		end if;
		
		
        --end if;
                
        
        --end if;
        
        
        
        
        
        
         if memoryWrite = '1' and exe_where = '1' and ("0" & ry = address_memory) and
                   mem_registerWrite = '1' then
                   from_forward_memory <= '1';
--                   from_forward_datay <= '0';
--                   from_forward_datax <= '0';
--                   from_forward_address <= '0';
                   forward_memory <= mem_aluout;
               elsif memoryWrite = '1' and exe_where = '0' and ("0" & rx = address_memory) and
                               mem_registerWrite = '1' then
                               from_forward_memory <= '1';
--                               from_forward_datay <= '0';
--                               from_forward_datax <= '0';
--                               from_forward_address <= '0';
                               forward_memory <= mem_aluout;
                elsif memoryWrite = '1' and exe_where = '0' and ("0" & rx = address_wb) and
                      wb_registerWrite = '1' and address_memory /= address_wb then
                       from_forward_memory <= '1';
--                       from_forward_datay <= '0';
--                       from_forward_datax <= '0';
--                       from_forward_address <= '0';
                       forward_memory <= wb_toRegister;
               elsif memoryWrite = '1' and exe_where = '1' and ("0" & ry = address_wb) and
                     wb_registerWrite = '1' and address_memory /= address_wb then
                      from_forward_memory <= '1';
--                      from_forward_datay <= '0';
--                      from_forward_datax <= '0';
--                      from_forward_address <= '0';
                      forward_memory <= wb_toRegister;
                else
                    from_forward_memory <= '0';
                    forward_memory <= "0000000000000000";
             end if;                         
                
		
	end process;
end behavior;
	