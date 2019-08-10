library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity exe is
	port(
		clock, reset: in std_logic;
		from_wb_memory_or_alu_out: in std_logic_vector(1 downto 0);
		wb_memory_or_alu_out: out std_logic_vector(1 downto 0);
		exe_select_goal: in std_logic_vector(2 downto 0);
		exe_alu_op: in std_logic_vector(2 downto 0);
		exe_alu_rx: in std_logic_vector(2 downto 0);
		exe_alu_ry: in std_logic_vector(1 downto 0);
		exe_address: in  std_logic_vector(1 downto 0);
		from_memoryWrite: in std_logic;
		memoryWrite: out std_logic;
		from_memoryRead: in std_logic;
		memoryRead: out std_logic;
		from_registerWrite: in std_logic;
		registerWrite: out std_logic;
		fromWhere: in std_logic;
		where: out std_logic;
		memoryData: out std_logic_vector(15 downto 0);
		
		fromBranch: in std_logic_vector(2 downto 0);
		shouldJump: out std_logic := '0';
		jumpAddress: out std_logic_vector(15 downto 0) := x"0000";
		
		rx: in std_logic_vector(15 downto 0);
		ry: in std_logic_vector(15 downto 0);
		sp: in std_logic_vector(15 downto 0);
		pc: in std_logic_vector(15 downto 0);
		ra: in std_logic_vector(15 downto 0);
		ih: in std_logic_vector(15 downto 0);
		t: in std_logic_vector(15 downto 0);
		immediate: in std_logic_vector(15 downto 0);
		
		r_x: in std_logic_vector(2 downto 0);
		r_y: in std_logic_vector(2 downto 0);
		r_z: in std_logic_vector(2 downto 0);
		
		goal: out std_logic_vector(3 downto 0);
		alu_out: out std_logic_vector(15 downto 0);
		
				forward_exe_alu_rx: out std_logic_vector(2 downto 0);
                forward_exe_alu_ry: out std_logic_vector(1 downto 0);
                forward_exe_address: out  std_logic_vector(1 downto 0);
        		forward_r_x: out std_logic_vector(2 downto 0);
                forward_r_y: out std_logic_vector(2 downto 0);
                
                memory_data_forward: in std_logic;
                forward_memory_data: in std_logic_vector(15 downto 0);

		from_forwardx: in std_logic;
		from_forwardy: in std_logic;
		from_forward_address: in std_logic;
		
		forward_datax: in std_logic_vector(15 downto 0);
		forward_datay: in std_logic_vector(15 downto 0);
		forward_address: in std_logic_vector(15 downto 0)
	);
end exe;

architecture behavior of exe is

component alu
	port(
		alu_op: in std_logic_vector(2 downto 0);
		alu_rx: in std_logic_vector(15 downto 0);
		alu_ry: in std_logic_vector(15 downto 0);
		alu_out: out std_logic_vector(15 downto 0)
	);
end component;

component mux_rx
	port(
		rx: in std_logic_vector(15 downto 0);
		ry: in std_logic_vector(15 downto 0);
		sp: in std_logic_vector(15 downto 0);
		pc: in std_logic_vector(15 downto 0);
		ra: in std_logic_vector(15 downto 0);
		ih: in std_logic_vector(15 downto 0);
		t: in std_logic_vector(15 downto 0);
        forward_datax: in std_logic_vector(15 downto 0);
        from_forwardx: in std_logic;
		immediate: in std_logic_vector(15 downto 0);
		alu_mux_rx: in std_logic_vector(2 downto 0);
		alu_rx: out std_logic_vector(15 downto 0)
	);
end component;

component mux_ry
	port(
		immediate: in std_logic_vector(15 downto 0);
		ry: in std_logic_vector(15 downto 0);
		rx: in std_logic_vector(15 downto 0);
		forward_datay: in std_logic_vector(15 downto 0);
		from_forwardy: in std_logic;
		alu_mux_ry: in std_logic_vector(1 downto 0);
		alu_ry: out std_logic_vector(15 downto 0)
	);
end component;

component mux_address
	port(
		pc_offset: in std_logic_vector(15 downto 0);
		rx: in std_logic_vector(15 downto 0);
		ra: in std_logic_vector(15 downto 0);
		from_forward_address: in std_logic;
		forward_address: in std_logic_vector(15 downto 0);
		address_mux: in std_logic_vector(1 downto 0);
		address: out std_logic_vector(15 downto 0)
	);
end component;

component mux_goal
	port(
		alu_select_goal: in std_logic_vector(2 downto 0);
		rx: in std_logic_vector(2 downto 0);
		ry: in std_logic_vector(2 downto 0);
		rz: in std_logic_vector(2 downto 0);
		goal: out std_logic_vector(3 downto 0)
	);
end component;

component adder
	port(
		pc: in std_logic_vector(15 downto 0);
		offset: in std_logic_vector(15 downto 0);
		address: out std_logic_vector(15 downto 0)
	);
end component;

signal s_rx: std_logic_vector(15 downto 0);
signal s_ry: std_logic_vector(15 downto 0);
signal s_sp: std_logic_vector(15 downto 0);
signal s_pc: std_logic_vector(15 downto 0);
signal s_ra: std_logic_vector(15 downto 0);
signal s_ih: std_logic_vector(15 downto 0);
signal s_t: std_logic_vector(15 downto 0);
signal s_immediate: std_logic_vector(15 downto 0);

signal s_r_x: std_logic_vector(2 downto 0);
signal s_r_y: std_logic_vector(2 downto 0);
signal s_r_z: std_logic_vector(2 downto 0);

signal s_select_goal: std_logic_vector(2 downto 0);
signal s_alu_op: std_logic_vector(2 downto 0);
signal s_alu_mux_rx: std_logic_vector(2 downto 0);
signal s_alu_mux_ry: std_logic_vector(1 downto 0);
signal s_address_mux: std_logic_vector(1 downto 0);
signal s_branch: std_logic_vector(2 downto 0);

signal s_from_forwardx: std_logic;
signal s_from_forwardy: std_logic;
signal s_from_forward_address: std_logic;
signal s_forward_datax: std_logic_vector(15 downto 0);
signal s_forward_datay: std_logic_vector(15 downto 0);
signal s_forward_address: std_logic_vector(15 downto 0);

signal s_alu_rx: std_logic_vector(15 downto 0);
signal s_alu_ry: std_logic_vector(15 downto 0);
signal add_result: std_logic_vector(15 downto 0);
signal address_result: std_logic_vector(15 downto 0);

signal s_alu_out: std_logic_vector(15 downto 0);
signal s_goal: std_logic_vector(3 downto 0);
signal s_where: std_logic;

begin 
	mux_rx_instance: mux_rx port map(
		rx => s_rx,
		ry => s_ry,
		sp => s_sp,
		pc => s_pc,
		ra => s_ra,
		ih => s_ih,
		t => s_t,
        forward_datax => s_forward_datax,
        from_forwardx => s_from_forwardx,
--        forward_datax => forward_datax,
--                from_forwardx => from_forwardx,
		immediate => s_immediate,
		alu_mux_rx => s_alu_mux_rx,
		alu_rx => s_alu_rx
	);
	
	mux_ry_instance: mux_ry port map(
		immediate => s_immediate,
		ry => s_ry,
		rx => s_rx,
		forward_datay => s_forward_datay,
		from_forwardy => s_from_forwardy,
--forward_datay => forward_datay,
--		from_forwardy => from_forwardy,
		alu_mux_ry => s_alu_mux_ry,
		alu_ry => s_alu_ry
	);
	
	adder_instance: adder port map(
		pc => s_pc,
		offset => s_immediate,
		address => add_result
	);
	
	mux_address_instance: mux_address port map(
		pc_offset => add_result,
		rx => s_rx,
		ra => s_ra,
		from_forward_address => s_from_forward_address,
		forward_address => s_forward_address,
--from_forward_address => from_forward_address,
--		forward_address => forward_address,
		address_mux => s_address_mux,
		address => address_result
	);
	
	alu_instance: alu port map(
		alu_op => s_alu_op,
		alu_rx => s_alu_rx,
		alu_ry => s_alu_ry,
		alu_out => s_alu_out
	);
	
	mux_goal_instance: mux_goal port map(
		rx => s_r_x,
		ry => s_r_y,
		rz => s_r_z,
		alu_select_goal => s_select_goal,
		goal => s_goal
	);
				
	jumpAddress <= address_result;
	alu_out <= s_alu_out;
	goal <= s_goal;
	
	process(s_branch,s_alu_out)
	begin
		if s_branch = "001" or (s_branch = "010" and s_alu_out = X"0000") or 
			(s_branch = "011" and s_alu_out /= X"0000") or (s_branch = "100" and s_alu_out = X"0000") or
			s_branch = "101" or s_branch = "110" or s_branch = "111" then
			shouldJump <= '1';
		else
			shouldJump <= '0';
		end if;			
	end process;
	
	process(from_forwardx, from_forwardy, from_forward_address, forward_datax, forward_datay, forward_address)
        begin
                        s_from_forwardx <= from_forwardx;
                        s_from_forwardy <= from_forwardy;
                        s_from_forward_address <= from_forward_address;
                        
                        s_forward_datax <= forward_datax;
                        s_forward_datay <= forward_datay;
                        s_forward_address <= forward_address;    
        end process;

	process(s_where,s_rx,s_ry, memory_data_forward, forward_memory_data)
	begin
	if memory_data_forward = '1' then
	   memoryData <= forward_memory_data;
	else
		if s_where = '0' then
			memoryData <= s_rx;
		else
			memoryData <= s_ry;
		end if;
    end if;
	end process;
	
	process(reset, clock)
	begin
		if reset = '1' then
			s_rx <= "0000000000000000";
			s_ry <= "0000000000000000";
			s_sp <= "0000000000000000";
			s_pc <= "0000000000000000";
			s_ra <= "0000000000000000";
			s_ih <= "0000000000000000";
			s_t <= "0000000000000000";
			s_immediate <= "0000000000000000";
				
			s_alu_op <= "000";
			s_alu_mux_rx <= "000";
			s_alu_mux_ry <= "00";
			s_select_goal <= "000";
			s_address_mux <= "00";
				
			s_branch <= "000";
				
			s_r_x <= "000";
			s_r_y <= "000";
			s_r_z <= "000";
				
--			s_from_forwardx <= '0';
--			s_from_forwardy <= '0';
--			s_from_forward_address <= '0';
			s_where <= '0';
				
--			s_forward_datax <= "0000000000000000";
--			s_forward_datay <= "0000000000000000";
--			s_forward_address <= "0000000000000000";	
			
						forward_exe_alu_rx <= "000";
                        forward_exe_alu_ry <= "00";
                        forward_exe_address <= "00";
                        
                        forward_r_x <= "000";
                        forward_r_y <= "000";

			wb_memory_or_alu_out <= "00";
			memoryRead <= '0';
			memoryWrite <= '0';
			registerWrite <= '0';
			where <= '0';
		else
			if clock'event and clock = '1' then
				s_rx <= rx;
				s_ry <= ry;
				s_sp <= sp;
				s_pc <= pc;
				s_ra <= ra;
				s_ih <= ih;
				s_t <= t;
				s_immediate <= immediate;
				
				s_alu_op <= exe_alu_op;
				s_alu_mux_rx <= exe_alu_rx;
				s_alu_mux_ry <= exe_alu_ry;
				s_select_goal <= exe_select_goal;
				s_address_mux <= exe_address;

				s_where <= fromWhere;
				
				s_branch <= fromBranch;
				
				s_r_x <= r_x;
				s_r_y <= r_y;
				s_r_z <= r_z;
				
--				s_from_forwardx <= from_forwardx;
--				s_from_forwardy <= from_forwardy;
--				s_from_forward_address <= from_forward_address;
				
--				s_forward_datax <= forward_datax;
--				s_forward_datay <= forward_datay;
--				s_forward_address <= forward_address;	

				forward_exe_alu_rx <= exe_alu_rx;
                forward_exe_alu_ry <= exe_alu_ry;
                            forward_exe_address <= exe_address;
                            
                            forward_r_x <= r_x;
                            forward_r_y <= r_y;


				wb_memory_or_alu_out <= from_wb_memory_or_alu_out;
				memoryRead <= from_memoryRead;
				memoryWrite <= from_memoryWrite;
				registerWrite <= from_registerWrite;
				where <= fromWhere;
			end if;
		end if;
	end process;	
end behavior;