library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_control is
	port(
		jump: in std_logic;
		bubble: in std_logic;
		
		fromMemoryRead: in std_logic;
		fromMemoryWrite: in std_logic;
		fromRegisterWrite: in std_logic;
		fromWhere: in std_logic;
		fromGoal: in std_logic_vector(2 downto 0);
		from_wb_memory_or_aluout: in std_logic_vector(1 downto 0);
		fromBranch: in std_logic_vector(2 downto 0);
		from_alu_op: in std_logic_vector(2 downto 0);
		from_alu_rx: in std_logic_vector(2 downto 0);
		from_alu_ry: in std_logic_vector(1 downto 0);
		from_address: in std_logic_vector(1 downto 0);
		
		MemoryRead: out std_logic;
		MemoryWrite: out std_logic;
		RegisterWrite: out std_logic;
		Where: out std_logic;
		Goal: out std_logic_vector(2 downto 0);
		wb_memory_or_aluout: out std_logic_vector(1 downto 0);
		Branch: out std_logic_vector(2 downto 0);
		alu_op: out std_logic_vector(2 downto 0);
		alu_rx: out std_logic_vector(2 downto 0);
		alu_ry: out std_logic_vector(1 downto 0);
		address: out std_logic_vector(1 downto 0)
	
	);
end mux_control;

architecture behavior of mux_control is
begin
	process(jump, bubble, fromMemoryRead, fromMemoryWrite, fromRegisterWrite, fromWhere, fromBranch,
			from_wb_memory_or_aluout, from_alu_op, from_alu_rx, from_alu_ry, from_address, fromGoal)
	begin
		if jump = '1'then 
			MemoryRead <= '0';
			MemoryWrite <= '0';
			RegisterWrite <= '0';
			Where <= '0';
			Goal <= "000";
			wb_memory_or_aluout <= "00";
			Branch <= "000";
			alu_op <= "000";
			alu_rx <= "000";
			alu_ry <= "00";
			address <= "00";
		else
			MemoryRead <= fromMemoryRead;
			MemoryWrite <= fromMemoryWrite;
			RegisterWrite <= fromRegisterWrite;
			Where <= fromWhere;
			Goal <= fromGoal;
			wb_memory_or_aluout <= from_wb_memory_or_aluout;
			Branch <= fromBranch;
			alu_op <= from_alu_op;
			alu_rx <= from_alu_rx;
			alu_ry <= from_alu_ry;
			address <= from_address;
		end if;
	end process;
end behavior;