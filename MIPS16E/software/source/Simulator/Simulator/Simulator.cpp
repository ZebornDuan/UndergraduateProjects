#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <windows.h>
#include <conio.h>
#include <cstring>
#include<iostream>
using namespace std;

#pragma comment(lib, "ws2_32.lib")


typedef	unsigned short word;
typedef unsigned short regis;
typedef word (*func) (word);
typedef void (*decode) (word);

const int LimitConsoleBuffer = 4096;

const word E_NOFILE = 1;
const word W_MMEXST = 2;
const word W_MMDRTY = 3;
const word E_UNKNOW = 4;
const word E_MMREAD = 5;
const word E_MMWRTE = 6;
const word E_MMNVST = 7;
const word E_NOFUNC = 8;
const word C_SBREAK = 9;
const word E_DIVZER = 10;
const word RET=11;
const word COM1_DATA_ADDR = 0xBF00;
const word COM1_STATE_ADDR= 0xBF01;
const word COM2_DATA_ADDR = 0xBF02;
const word COM2_STATE_ADDR= 0xBF03;
const int SCRN_X = 80;
const int SCRN_Y = 100;
const int BUFFER_SIZE_CLIENT = 1024;
int console_mode = -1;
int int_mode = 0;
const int const_int_step = 1024;
FILE* output;


SOCKET server, client1, client2;

//*****************************************************************************
//寄存器堆
struct RegHeap
{
	regis T:1;
	regis regh[8];
	regis PC;
	regis RA;
	regis SP;
	regis HI;
	regis LO;
	regis IH;
	RegHeap();
	void list_regs();
};

RegHeap::RegHeap()
{
	T = 0;
	PC = 0x0000;
	SP = 0xDFFF;
}

void RegHeap::list_regs()
{
	for (int i=0;i<8;i++)
	{
		printf("    R%d = %04x",i,regh[i]);
		if ((i+1) % 4 == 0)
			printf("\n");
	}
	printf("    PC = %04x    RA = %04x    SP = %04x     T = %04x\n",PC,RA,SP,T);
	printf("    HI = %04x    LO = %04x\n",HI,LO);
}

struct RegHeap reg;
//*****************************************************************************
//用于生成Intel HEX File Formt形式文件的结构
struct Hex_16
{
	char colon;
	char datalen[2];
	char addr[4];
	char type[2];
	char data[4];
	char checksum[2];
    char newline;
	Hex_16();
	void create(word address, word bin_data);
};

Hex_16::Hex_16()
{
	colon = ':';
	datalen[0]='0';
	datalen[1]='2';
	newline='\n';
};

void Hex_16::create(word addr_, word data_)
{
	word address = addr_;
	word bin_data = data_;
	for(int i=0;i<4;i++)
	{
		if((address & 0xF)>=0 && (address & 0xF)<=9)
			addr[3-i] = char((address & 0xF)+48);
		else
			addr[3-i] = char((address & 0xf)+87);
		address >>= 4;
	}
	
	type[0]='0';
	type[1]='0';
	for(int i=0;i<4;i++)
	{
		if((bin_data & 0xF)>=0 && (bin_data & 0xF)<=9)
			data[3-i] = char((bin_data & 0xF)+48);
		else
			data[3-i] = char((bin_data & 0xf)+87);
		bin_data >>= 4;
	}
    
	char sum = (2+(addr_>>8&0xFF)+(addr_&0xFF)+(data_>>8&0xFF)+(data_&0xFF)) % 256;
    char check = ~sum + 1;

	for(int i=0;i<2;i++)
	{
		if((check & 0xF)>=0 && (check & 0xF)<=9)
			checksum[1-i] = char((check & 0xF)+48);
		else
			checksum[1-i] = char((check & 0xf)+87);
		check >>= 4;
	}
}

//内存
struct Memory
{
	word flags0, flags1;
	static const unsigned int MEM_SIZE = 0x10000;
	Memory();
	word can_vst(word index);
	word load_mem(char *rom_file);
	word read_mem(word );
	void save_mem(char *rom_file);
	void save_memFormat(char *rom_file, int pc);
	void write_mem(word ,word );
	word memory[MEM_SIZE];
	word Mrecv[2], Msend[2];
};

Memory::Memory()
{
	flags0 = 0;
	flags1 = 0;
	memset(memory,0,sizeof(word)*MEM_SIZE);
};

word Memory::load_mem(char *rom_file)
{
	FILE *rom_handle = fopen(rom_file,"rb");
	if (rom_handle == NULL)
	{
		cout<<"Cannot open file "<<rom_file<<endl;
		return E_NOFILE;
	}
	fread(memory,sizeof(word),MEM_SIZE,rom_handle);
	fclose(rom_handle);
	return 0;
}

void Memory::save_mem(char *rom_file)
{
	FILE *rom_handle = fopen(rom_file,"wb+");
	fwrite(memory,sizeof(word),MEM_SIZE,rom_handle);
	fclose(rom_handle);
}

void Memory::save_memFormat(char *rom_file, int pc)
{
	char* endfile = ":00000001ff";
	int size = pc;

	word* mem16;
	mem16 = new word[size];
	memset(mem16, 0, size*sizeof(word));
	memcpy(mem16,memory,size*sizeof(word));

	Hex_16* hex16;
	hex16 = new Hex_16[size];
	for(int i=0; i<size; i++)
	{
		hex16[i].create(i,mem16[i]);
	}

	FILE *rom_handle = fopen(rom_file,"wb+");
	fwrite(hex16,16,size,rom_handle);
	fwrite(endfile,10,1,rom_handle);
	fclose(rom_handle);
}

word Memory::can_vst(word index)
{
	/*if (index < 0x2800 || (index >= 0x4000 && index < 0x6004))
		return 0;
	else return E_MMNVST;*/
	return 0;
}

word Memory::read_mem(word index)
{
	if (index != COM1_DATA_ADDR && index != COM2_DATA_ADDR)
		return memory[index];
	if (console_mode == 0)		//console_mode==0貌似是单步模式，-1是正常模式，1是server
	{
		char ch = getch();
		printf("%c",ch);
		memory[index] = (word)ch;
		return memory[index];
	}
	memory[index+1] &= 0xFFFD;//设置状态寄存器的值
	return (Mrecv[(index-COM1_DATA_ADDR) >> 1] & 0xFF);
}

void Memory::write_mem(word index,word str)
{
	memory[index] = str;
	if (index == COM1_DATA_ADDR || index == COM2_DATA_ADDR)
	{
		if (console_mode == 0)
			printf("%c",str);
		else
		{
			memory[index+1] &= 0xFFFE;//设置状态寄存器的值
			Msend[(index-COM1_DATA_ADDR) >> 1] = (str & 0xFF);
		}
	}
}

struct Memory mem;
//*****************************************************************************
//定义全部汇编指令
word index1, index2 ,index3, offset, index_jr, index_b, F , t; //index_jr临时交给jr指令使用
word IR = 0;
word PC = reg.PC;
func asm_set[32];

void run_regs(int ,char *[]);
//int
word asm_func_int(word int_num)
{
	if ((reg.IH & 0x8000) == 0)
		return 0;
	reg.IH=reg.IH&0x7fff;
	printf("%x interrupted.\n", int_num);
	reg.SP --;
	if ((t = mem.can_vst(reg.SP)) != 0)
		return t;
	mem.memory[reg.SP] = reg.PC;
	reg.SP --;
	if ((t = mem.can_vst(reg.SP)) != 0)
		return t;
	mem.memory[reg.SP] = int_num;
	reg.PC = (reg.IH & 0x7FFF);
	return 0;
}

//ADDIU_SP_3OP
word asm_00(word code)
{
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	if ((offset & 0x80) != 0)
		offset |= 0xFF00;
	reg.regh[index1] = reg.SP+offset;
	return 0;
}

//NOP
word asm_01(word code)
{
	return 0;
}

//B
word asm_02(word code)
{
	PC = reg.PC;
	if ((t = mem.can_vst(PC)) != 0) return t;
	IR = mem.read_mem(PC);
	index_b = ((IR >> 11) & 0x001F);
	if (asm_set[index_b] == NULL)
		return E_UNKNOW;
	offset = (code & 0x7FF);
	if ((offset & 0x400) != 0)
		offset |= 0xF800;
	reg.PC += offset;
	asm_set[index_b](IR);
	return 0;
}

//BEQZ
word asm_04(word code)
{	
	PC = reg.PC;
	if ((t = mem.can_vst(PC)) != 0) return t;
	IR = mem.read_mem(PC);
	index_b = ((IR >> 11) & 0x001F);
	if (asm_set[index_b] == NULL)
		return E_UNKNOW;
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	if ((offset & 0x80) != 0)
		offset |= 0xFF00;
	if (reg.regh[index1] == 0)
	{
		reg.PC += offset;
		asm_set[index_b](IR);
	}
	return 0;
}

//BNEZ
word asm_05(word code)
{
	PC = reg.PC;
	if ((t = mem.can_vst(PC)) != 0) return t;
	IR = mem.read_mem(PC);
	index_b = ((IR >> 11) & 0x001F);
	if (asm_set[index_b] == NULL)
		return E_UNKNOW;
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	if ((offset & 0x80) != 0)
		offset |= 0xFF00;
	if (reg.regh[index1] != 0)
	{
		reg.PC += offset;
		asm_set[index_b](IR);
	}
	return 0;
}

//SLL SRL SRA
word asm_06(word code)
{
	index3 = (code & 0x3);
	code >>= 2;
	offset = (code & 0x7);
	code >>= 3;
	index2 = (code & 0x7);
	code >>= 3;
	index1 = (code & 0x7);
	switch (index3)
	{
	case 0: //SLL
		reg.regh[index1] = (offset == 0) ? (reg.regh[index2] << 8) : (reg.regh[index2] << offset);
		return 0;
	case 2: //SRL
		reg.regh[index1] = (offset == 0) ? (reg.regh[index2] >> 8) : (reg.regh[index2] >> offset);
		return 0;
	case 3: //SRA
		reg.regh[index1] = (offset == 0) ? (((short )reg.regh[index2]) >> 8) : (((short )reg.regh[index2]) >> offset);
		return 0;
	default: return E_UNKNOW;
	}
}

//ADDIU_3OP
word asm_08(word code)
{
	offset = (code & 0xF);
	code >>= 4;
	index3 = (code & 0x1);
	code >>= 1;
	if (index3 != 0) 
		return E_UNKNOW;
	index2 = (code & 0x7);
	code >>= 3;
	index1 = (code & 0x7);
	if ((offset & 0x8) != 0)
		offset |= 0xFFF0;
	reg.regh[index2] = reg.regh[index1]+offset;
	return 0;
}

//ADDIU
word asm_09(word code)
{
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	if ((offset & 0x80) != 0 )
		offset |= 0xFF00;
	reg.regh[index1] += offset;
	return 0;
}

//SLTI
word asm_10(word code)
{
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	if ((offset & 0x80) != 0)
		offset |= 0xFF00;
	reg.T = ((short)reg.regh[index1] < (short)offset) ? 1 : 0;
	return 0;
}

//SLTUI
word asm_11(word code)
{
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	reg.T = (reg.regh[index1] < offset) ? 1 : 0;
	return 0;
}

//BTEQZ BTNEZ SW-RA-SP ADDIU_SP MOVE
word asm_12(word code)
{
	PC = reg.PC;
	if ((t = mem.can_vst(PC)) != 0) return t;
	IR = mem.read_mem(PC);
	index_b = ((IR >> 11) & 0x001F);
	if (asm_set[index_b] == NULL)
		return E_UNKNOW;
	offset = (code & 0xFF);
	code >>= 8;
	index3 = (code & 0x7);
	switch (index3)
	{
	case 0: //BTEQZ
		if (reg.T == 0)
		{
			if ((offset & 0x80) != 0)
				offset |= 0xFF00;
			reg.PC += offset;
			asm_set[index_b](IR);
		}
		return 0;
	case 1: //BTNEZ
		if (reg.T != 0)
		{
			if ((offset & 0x80) != 0)
				offset |= 0xFF00;
			reg.PC += offset;
			asm_set[index_b](IR);
		}
		return 0;
	case 2: //SW-RA-SP
		F = reg.SP+offset;
		if ((t = mem.can_vst(F)) != 0) return t;
		mem.write_mem(F,reg.RA);
		return 0;
	case 3: // ADDIU_SP
		if ((offset & 0x80) != 0)
			offset |= 0xFF00;
		reg.SP += offset;
		return 0;
	case 4: //MTSP
		index1 = (offset >> 5);
		reg.SP = reg.regh[index1];
		return 0;
	
	default: return E_UNKNOW;
	}
}
word asm_15(word code)   //changed by chenyong
{
	code >>=5;
	index2=(code & 0x7);
	code >>=3;
	index1=(code & 0x7);
	reg.regh[index1] = reg.regh[index2];
	return 0;
}
//LI
word asm_13(word code)
{
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	reg.regh[index1] = offset;
	return 0;
}

//CMPI
word asm_14(word code)
{
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	reg.T = ((reg.regh[index1] ^ offset) == 0) ? 0 : 1;
	return 0;
}

//LW-SP
word asm_18(word code)
{
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	if ((offset & 0x80) != 0)
		offset |= 0xFF00;
	F = reg.SP+offset;
	if ((t = mem.can_vst(F)) != 0) return t;
	reg.regh[index1] = mem.read_mem(F);
	return 0;
}

//LW
word asm_19(word code)
{
	offset = (code & 0x1F);
	code >>= 5;
	if((offset & 0x10) != 0)
		offset |=0xFFE0;
	index2 = (code & 0x7);
	code >>= 3;
	index1 = (code & 0x7);
	F = reg.regh[index1]+offset;
	if ((t = mem.can_vst(F)) != 0) return t;
	reg.regh[index2] = mem.read_mem(F);
	return 0;
}

//SW-SP
word asm_26(word code)
{
	offset = (code & 0xFF);
	code >>= 8;
	index1 = (code & 0x7);
	if ((offset & 0x80) != 0)
		offset |= 0xFF00;
	F = reg.SP+offset;
	if ((t = mem.can_vst(F)) != 0) return t;
	mem.write_mem(F,reg.regh[index1]);
	return 0;
}

//SW
word asm_27(word code)
{
	offset = (code & 0x1F);
	code >>= 5;
	if((offset & 0x10) != 0)
		offset |=0xFFE0;
	index2 = (code & 0x7);
	code >>= 3;
	index1 = (code & 0x7);
	F = reg.regh[index1]+offset;
	if ((t = mem.can_vst(F)) != 0) return t;
	mem.write_mem(F,reg.regh[index2]);
	return 0;
}

//ADDU SUBU
word asm_28(word code)
{
	offset = (code & 0x3);
	code >>= 2;
	index3 = (code & 0x7);
	code >>= 3;
	index2 = (code & 0x7);
	code >>= 3;
	index1 = (code & 0x7);
	switch (offset)
	{
	case 1: //ADDU
		reg.regh[index3] = reg.regh[index1]+reg.regh[index2];
		return 0;
	case 3: //SUBU
		reg.regh[index3] = reg.regh[index1]-reg.regh[index2];
		return 0;
	default: return E_UNKNOW;
	}
}

//JR(ra) JR MFHI MFLO JALR SLT SLTU SLLV SRLV SRAV CMP NEG AND OR XOR NOT MULT MULTU DIV DIVU
word asm_29(word code)
{
	index3 = (code & 0x1F);
	code >>= 5;
	index2 = (code & 0x7);
	code >>= 3;
	index1 = (code & 0x7);
	if (index3 == 0)
	{
		switch (index2)
		{
		case 0: //JR
			PC = reg.PC;
			if ((t = mem.can_vst(PC)) != 0) return t;
			IR = mem.read_mem(PC);
			index_jr = ((IR >> 11) & 0x001F);
			if (asm_set[index_jr] == NULL)
				return E_UNKNOW;
			else
			{
				reg.PC = reg.regh[index1];
				asm_set[index_jr](IR);
				return 0;
			}
		case 2: //MFPC
			reg.regh[index1] = reg.PC;
			return 0;
		case 1: //JR(ra)
			if (index1 != 0) return E_UNKNOW;
			reg.PC = reg.RA;
			return 0;
		case 6: //JALR
			reg.RA = reg.PC;
			reg.PC = reg.regh[index1];
			return 0;
		default: return E_UNKNOW;
		}
	}
	unsigned int mul;
	switch (index3)
	{
	case 2: //SLT
		reg.T = ((short)reg.regh[index1] < (short)reg.regh[index2]) ? 1 : 0;
		return 0;
	case 3: //SLTU
		reg.T = (reg.regh[index1] < reg.regh[index2]) ? 1 : 0;
		return 0;
	case 4: //SLLV
		reg.regh[index2] = (reg.regh[index2] << reg.regh[index1]);
		return 0;
	case 6: //SRLV
		reg.regh[index2] = (reg.regh[index2] >> reg.regh[index1]);
		return 0;
	case 7: //SRAV
		reg.regh[index2] = (((short )reg.regh[index2]) >> reg.regh[index1]);
		return 0;
	case 10: //CMP
		reg.T  = ((reg.regh[index1] ^ reg.regh[index2]) == 0) ? 0 : 1;
		return 0;
	case 11: //NEG
		reg.regh[index1] = -reg.regh[index2];
		return 0;
	case 12: //AND
		reg.regh[index1] &= reg.regh[index2];
		return 0;
	case 13: //OR
		reg.regh[index1] |= reg.regh[index2];
		return 0;
	case 14: //XOR
		reg.regh[index1] ^= reg.regh[index2];
		return 0;
	case 15: //NOT
		reg.regh[index1] = ~reg.regh[index2];
		return 0;
	case 16: //MFHI
		reg.regh[index1] = reg.HI;
		return 0;
	case 18: //MFLO
		reg.regh[index1] = reg.LO;
		return 0;
	case 24: //MULT
		mul = (int)reg.regh[index1]*(int)reg.regh[index2];
		reg.HI = (word)((mul >> 16) & 0xFFFF);
		reg.LO = (word)(mul & 0xFFFF);
		return 0;
	case 25: //MULTU
		mul = (unsigned int)(reg.regh[index1])*(unsigned int)(reg.regh[index2]);
		reg.HI = (word)((mul >> 16) & 0xFFFF);
		reg.LO = (word)(mul & 0xFFFF);
		return 0;
	case 26: //DIV
		if (reg.regh[index2] == 0)
			return E_DIVZER;
		reg.LO = (word)((short)reg.regh[index1]/(short)reg.regh[index2]);
		reg.HI = (word)((short)reg.regh[index1]%(short)reg.regh[index2]);
		return 0;
	case 27: //DIVU
		if (reg.regh[index2] == 0)
			return E_DIVZER;
		reg.LO = reg.regh[index1]/reg.regh[index2];
		reg.HI = reg.regh[index1]%reg.regh[index2];
		return 0;
	default: return E_UNKNOW;
	}
}

//MFIH MTIH
word asm_30(word code)
{
	offset = (code & 0xFF);
	code = (code >> 8);
	index1 = (code & 7);
	switch (offset)
	{
	case 0: //MFIH
		reg.regh[index1] = reg.IH;
		return 0;
	case 1: //MTIH
		printf("\nMTIH : %04x ", reg.regh[index1]);
		reg.IH = reg.regh[index1];
		return 0;
	default:
		return E_UNKNOW;
	}
}

word asm_31(word code)
{
	index1 = (code & 0xF);
	code = (code >> 4);
	index2 = (code & 0x7F);
	if (index2 != 0)
		return E_UNKNOW;
	return asm_func_int(index1);
}

//*****************************************************************************
//模拟

struct TASM
{
	char *name;
	int code;
	int x,y,z;
};

int asm_total;
//{name,}
const struct TASM const_asm[] = {
	{"ADDSP3",1793,63743,65280,65535},
	{"B",4096,63488,65535,65535},
	{"BEQZ",9984,63743,65280,65535},
	{"BNEZ",12032,63743,65280,65535},
	{"SLL",14308,63743,65311,65507},
	{"SRL",14310,63743,65311,65507},
	{"SRA",14311,63743,65311,65507},
	{"ADDIU3",18400,63743,65311,65520},
	{"ADDIU",20224,63743,65280,65535},
	{"SLTI",22272,63743,65280,65535},
	{"SLTUI",24321,63743,65280,65535},
	{"BTEQZ",24576,65280,65535,65535},
	{"BTNEZ",24832,65280,65535,65535},
	{"SW-RS",25089,65280,65535,65535},
	{"ADDSP",25344,65280,65535,65535},
	{"MTSP",25824,65311,65535,65535},
	{"MOVE",32736,63743,65311,65535},  //changed by chenyong
	{"LI",28417,63743,65280,65535},
	{"CMPI",30465,63743,65280,65535},
	{"LW-SP",38657,63743,65280,65535},
	{"LW",40929,63743,65311,65504},
	{"SW-SP",55041,63743,65280,65535},
	{"SW",57313,63743,65311,65504},
	{"ADDU",59389,63743,65311,65507},
	{"SUBU",59391,63743,65311,65507},
	{"JR",61184,63743,65535,65535},
	{"JRRA",59424,65535,65535,65535},  
	{"JALR",61376,63743,65535,65535}, 
	{"MFHI",61200,63743,65535,65535},
	{"MFLO",61202,63743,65535,65535},
	{"MFPC",61248,63743,65535,65535},
	{"SLT",61410,63743,65311,65535},
	{"SLTU",61411,63743,65311,65535},
	{"SLLV",61412,63743,65311,65535},
	{"SRLV",61414,63743,65311,65535},
	{"SRAV",61415,63743,65311,65535},
	{"CMP",61418,63743,65311,65535},
	{"NEG",61419,63743,65311,65535},
	{"AND",61420,63743,65311,65535},
	{"OR",61421,63743,65311,65535},
	{"XOR",61422,63743,65311,65535},
	{"NOT",61423,63743,65311,65535},
	{"MULT",61432,63743,65311,65535},
	{"MULTU",61433,63743,65311,65535},
	{"DIV",61434,63743,65311,65535},
	{"DIVU",61435,63743,65311,65535},
	{"NOP",2048,65535,65535,65535,},
	{"INT",63489,65520,65535,65535},
	{"MFIH",63232,63743,65535,65535},
	{"MTIH",63233,63743,65535,65535},
	{"RET",65535,65535,65535,65535}
};

void init()
{
	asm_total = (int)(sizeof(const_asm)/sizeof(struct TASM));
	memset(asm_set,0,sizeof(func)*32);
	asm_set[0] = asm_00;
	asm_set[1] = asm_01;
	asm_set[2] = asm_02;
//	asm_set[3] = asm_03;
	asm_set[4] = asm_04;
	asm_set[5] = asm_05;
	asm_set[6] = asm_06;
//	asm_set[7] = asm_07;
	asm_set[8] = asm_08;
	asm_set[9] = asm_09;
	asm_set[10] = asm_10;
	asm_set[11] = asm_11;
	asm_set[12] = asm_12;
	asm_set[13] = asm_13;
	asm_set[14] = asm_14;
	asm_set[15] = asm_15;//changed by chenyong
//	asm_set[16] = asm_16;
	printf("here init");
//	asm_set[17] = asm_17;
	asm_set[18] = asm_18;
	asm_set[19] = asm_19;
//	asm_set[20] = asm_20;
//	asm_set[21] = asm_21;
//	asm_set[22] = asm_22;
//	asm_set[23] = asm_23;
//	asm_set[24] = asm_24;
//	asm_set[25] = asm_25;
	asm_set[26] = asm_26;
	asm_set[27] = asm_27;
	asm_set[28] = asm_28;
	asm_set[29] = asm_29;
	asm_set[30] = asm_30;
	asm_set[31] = asm_31;
}

struct BreakStack
{
	int btotal;
	int bsize;
	word *list;
	BreakStack()
	{
		btotal = 0;
		bsize = 4;
		list = (word *)malloc(sizeof(word)*bsize);
	}
	word binsert(word addr)
	{
		word tmp;
		if ((tmp = mem.can_vst(addr)) != 0) return tmp;
		for (int i=0;i<btotal;i++)
		{
			if (list[i] == addr)
				return 0;
		}
		list[btotal++] = addr;
		if (btotal == bsize)
		{
			bsize <<= 1;
			word *temp = (word *)malloc(sizeof(word)*bsize);
			for (int i=0;i<btotal;i++)
				temp[i] = list[i];
			free(list);
			list = temp;
		}
		for (int i=0;i<btotal-1;i++)
		{
			int min = i;
			for (int j=i+1;j<btotal;j++)
			{
				if (list[j] < list[min])
					min = j;
			}
			if (min == i)
				continue;
			word tmp = list[i];
			list[i] = list[min];
			list[min] = tmp;
		}
		return 0;
	}
	void delbp(int index)
	{
		if (index >= 0 && index < btotal)
		{
			for (int i=index+1;i<btotal;i++)
				list[i-1] = list[i];
			btotal --;
		}
	}
	int is_break(word addr)
	{
		for (int i=0;i<btotal;i++)
		{
			if (list[i] < addr)
				continue;
			if (list[i] == addr)
				return 1;
			if (list[i] > addr)
				return 0;
		}
		return 0;
	}
	void list_break()
	{
		printf("\n   > BreakPoints: total = %d\n",btotal);
		for (int i=0;i<btotal;i++)
			printf("      %d\t%04x\n",i,list[i]);
	}
};


struct BreakStack breakstack;

struct AsmID
{
	char *name;
	int id;
};

struct AsmID IDList[] = {
	{"ADDSP3",0},
	{"B",2},
	{"BEQZ",4},
	{"BNEZ",5},
	{"SLL",6},
	{"SRL",6},
	{"SRA",6},
	{"ADDIU3",8},
	{"ADDIU",9},
	{"SLTI",10},
	{"SLTUI",11},
	{"BTEQZ",12},
	{"BTNEZ",12},
	{"SW-RS",12},
	{"ADDSP",12},	
	{"MTSP",12},
	{"LI",13},
	{"CMPI",14},
	{"MOVE",15},//changed by chenyong
	{"LW-SP",18},
	{"LW",19},
	{"SW-SP",26},
	{"SW",27},
	{"ADDU",28},
	{"SUBU",28},
	{"JR",29},
	{"MFHI",29},
	{"MFLO",29},
	{"JALR",29},
	{"SLT",29},
	{"SLTU",29},
	{"SLLV",29},
	{"SRLV",29},
	{"SRAV",29},
	{"CMP",29},
	{"NEG",29},
	{"AND",29},
	{"OR",29},
	{"XOR",29},
	{"NOT",29},
	{"MULT",29},
	{"MULTU",29},
	{"DIV",29},
	{"DIVU",29},
	{"MFPC",29}
};

AsmID RegsList[] = {
	{"R0",0},
	{"R1",1},
	{"R2",2},
	{"R3",3},
	{"R4",4},
	{"R5",5},
	{"R6",6},
	{"R7",7}
};

//执行一条指令
//FILE* PCout = fopen("PC.log", "w");
word pc_step(int next = 0)
{
	PC = reg.PC;
//	fprintf(PCout, "%04x\n", PC);
//	fflush(PCout);
	if ((t = mem.can_vst(PC)) != 0) return t;
	if(COM1_DATA_ADDR<=reg.PC && reg.PC<=COM2_STATE_ADDR)//[COM1_DATA_ADDR,COM2_STATE_ADDR]为串口所有 
			return RET;
	IR = mem.read_mem(PC);
	if (next == 0 && breakstack.is_break(PC) != 0)
		return C_SBREAK;
	if(IR==0xFFFF)
		return RET;
	index1 = ((IR >> 11)& 0x001F);
	if (asm_set[index1] == NULL)
	{
		index1=int(index1);
		cout<<index1<<endl;
		return E_NOFUNC;
	}
	else 
	{
		reg.PC++;
		return asm_set[index1](IR);
	}
}

int get_regs_id(char argv[])
{
	if (strlen(argv) != 2)
		return -1;
	for (int i=0;i<8;i++)
	{
		if (strcmp(argv,RegsList[i].name) == 0)
			return RegsList[i].id;
	}
	printf("%s",argv);
	return -1;
}

int get_number_10(char argv[],int lenlimit)
{
	int value = 0, len = strlen(argv);
	char ch;
	for (int i=0;i<len;i++)
	{
		ch = argv[i];
		value *= 10;
		if (ch >= '0' && ch <= '9')
			value |= (ch-'0') & 0xF;
		else return -1;
	}
	if (value >> lenlimit != 0)
		return -1;
	return value;
}

int get_number(char argv[],int lenlimit,int bin_mode = 0)
{
	int value = 0, len = strlen(argv);
	char ch;
	for (int i=0;i<len;i++)
	{
		ch = argv[i];
		value <<= 4;
		if (ch >= '0' && ch <= '9')
			value |= (ch-'0') & 0xF;
		else if (ch >= 'A' && ch <= 'F')
			value |= (ch-'A'+10) & 0xF;
		else if (ch >= 'a' && ch <= 'f')
			value |= (ch-'a'+10) & 0xF;
		else return -1;
	}
	if (bin_mode == 0)
	{
		if (value >> lenlimit != 0)
			return -1;
	}
	else
	{
		if ((value & (~lenlimit)) != 0)
			return -1;
	}
	return value;
}

void writefile(word num,int flag)
{
	
	int temp=0;
	char ch[20];
	if (flag==1)
	{
		itoa(num,ch,16);	
		//ch=(char*)(ch-20);
		fwrite(ch,strlen(ch),1,output);
		return;

	}
	
	for(int i=0;i<4;i++)
	{
		short sdd=0x0000;            //截取
		int n=0;                 //移位数		
		switch(i){
			case 0:
				sdd=0xf000;
				n=12;
			//	printf("%d\n",n);//////// 
				break;
			case 1:
				sdd=0x0f00;
				n=8;
				break;
				//printf("%d\n",n);////////
			case 2:
				sdd=0x00f0;
				n=4;
				break;
			case 3:
				sdd=0x000f;
				n=0;
				break;
		}	
		temp=num&sdd;		
		temp >>=n;
		temp &=0x000f;		
	
		itoa(temp,ch,16);	
		//ch=(char*)(ch-20);
		fwrite(ch,strlen(ch),1,output);
	}


}

void pc_decode(word code,int flag=0)
{
	const struct TASM *p = const_asm;
	int i;
	word j ,k;
	for (i=0;i<asm_total;i++)
	{
		j = ((*p).code & (*p).x & (*p).y & (*p).z); 
		k = (code & (*p).x & (*p).y & (*p).z);
		if (j == k)
			break;
		p ++;
	}
	printf("  <%04x>",code);
	//fwrite((short*)code,sizeof(code),1,output); //////////////////////
	if (i == asm_total)
	{
		printf("--- UNKNOWN ---");
		if(flag==1){
			writefile(code,0);
			fwrite("\n",strlen("\n"),1,output);
		}

		return ;
	}

	if(flag==1&&((*p).name=="MULT"||(*p).name=="DIV"||(*p).name=="DIVU"
		||(*p).name=="MULTU"||(*p).name=="MFHI"||(*p).name=="MFLO"))//未实现的指令
	{
		writefile(code,0);
		fwrite("\n",strlen("\n"),1,output);
		return ;
	}
	printf(" %s",(*p).name);
	if(flag==1){
		fwrite((*p).name,strlen((*p).name),1,output); //////////////
		fwrite(" ",strlen(" "),1,output); //////////////
	}
	word regs[3];
	word num;
	num=0x0000;
	regs[0] = ~(*p).x;
	regs[1] = ~(*p).y;
	regs[2] = ~(*p).z;
	for (i=0;i<3;i++)
	{
		if (regs[i] != 0)
		{
			k = (regs[i] & (*p).code);
			num = (regs[i] & code);
			if (regs[i] == k)
			{
				while ((regs[i] & 1) == 0)
				{
					num = (num >> 1);
					regs[i] = (regs[i] >> 1);
				}
				printf(" R%d",num);
				if(flag==1){
					fwrite("R",strlen("R"),1,output); //////////////////////
					writefile(num,1); //////////////////////
					fwrite(" ",strlen(" "),1,output); //////////////
				}

			}
			else if (k == 0)
			{
				while ((regs[i] & 1) == 0)
				{
					num = (num >> 1);
					regs[i] = (regs[i] >> 1);
				}
				j = ~regs[i];
				if ((num & (j >> 1)) != 0)
					num = (num | j);	
				printf(" %04x",num);
				if(flag==1){
					writefile(num,0); //////////////////////
					fwrite(" ",strlen(" "),1,output); //////////////
				}

			}
			else
			{
				while ((regs[i] & 1) == 0)
				{
					num = (num >> 1);
					regs[i] = (regs[i] >> 1);
				}
				
				if ((num & 0x0010) !=0 && ((*p).name == "LW" || (*p).name == "SW"))
					printf(" %04x",num | 0xffE0);
				else
					printf(" %04x",num);
				if(flag==1){
					writefile(num,0); //////////////////////
					fwrite(" ",strlen(" "),1,output); //////////////
				}

			}
		}
	}
	if(flag==1){
		fwrite("\n",strlen("\n"),1,output);
	}
}
	
	



void run_regs(int ,char *[]);

void run_continue(int argc,char *argv[])
{
	if (argc == 2)
	{
		if (strcmp(argv[1],"int") != 0)
		{
			printf ("\n Unknown control identifier `%s'.\n", argv [1]);
			return ;
		}
	}
	else if (argc != 1)
	{
		printf ("\n Unknown control identifier ");
		for (int i=1;i<argc;i++)
			printf("`%s' ", argv [i]);
		printf("\n");
		return ;
	}
	printf("\n");
	word ret;
	char ch;
	int step = 0;
	console_mode = 0;
	if (argc == 2)
		int_mode = 1;
	int int_count = 0;
	while ((ret = pc_step()) == 0)
	{
		if (step == 0x100)
		{
			if (kbhit())
			{
				while (kbhit())
				{
					ch = getch();
					if (ch == 7)
					{
						run_regs(1,argv);
						console_mode = -1;
						return ;
					}
					else if (ch == 21)
						asm_func_int(0x10);
				}
			}
			step = 0;
		}
		step ++;
		if (int_mode == 1)
		{
			if ((reg.IH & 0x8000) == 0)
				int_count = 0;
			else
				int_count ++;
			if (int_count == const_int_step)
			{
				int_count = 0;
				asm_func_int(0x20);
			}
		}
	}
	switch (ret)
	{
	case C_SBREAK:
		printf("\n    [%04x] %04x   ",PC,IR);
		pc_decode(IR);
		break;
	case E_NOFUNC:
		printf("\n    no such function\n");
		break ;
	case E_MMNVST:
		printf("\n    Can not read memory :  [%04x]  ",PC);
		pc_decode(IR);
		break ;
	case RET:
		break;
	default: printf("\n    error %d\n",ret);
		break;
	}
	console_mode = -1;
	int_mode = 0;
}

void run_step(int argc,char *argv[])
{
	word err;
	console_mode = 0;
	if (argc == 1)
	{
		err = pc_step(1);
		PC = reg.PC;
		if (mem.can_vst(PC) != 0 || err != 0)
			printf("    Cannot read memory\n");
		else
		{
			IR = mem.read_mem(PC);
			printf("\n   [%04x]  %04x  ",PC,IR);
			pc_decode(IR);
		}
	}
	else
	{
		int value = get_number(argv[1],16);
		if (value == -1)
		{
			printf ("\n Unknown control identifier `%s'.\n", argv [1]);
			console_mode = -1;
			return ;
		}
		for (int i=0;i<value;i++)
		{
			err = pc_step(1);
			if (err != 0)
			{
				PC = reg.PC;
				if (mem.can_vst(PC) != 0)
				printf("\n    Cannot read memory\n");
				else
				{
					IR = mem.read_mem(PC);
					printf("\n   [%04x]  %04x  ",PC,IR);
					pc_decode(IR);
				}
				break;
			}
		}
		run_regs(1,argv);
	}
	console_mode = -1;
}

void run_quit(int argc,char *argv[])
{
	if (argc != 1)
	{
		printf ("\n Unknown control identifier `%s'.\n", argv [1]);
		return ;
	}
	else
	{
		printf("\n\n");
		exit(0);
	}
}

void run_setbreak(int argc,char *argv[])
{
	int len;
	if (argc < 2)
	{
		printf ("\n Not enough arguments.\n");
		return;
	}
	if ((len = strlen(argv[1])) > 4)
	{
		printf ("\n Unknown control identifier `%s'.\n", argv [1]);
		return ;
	}
	int value = get_number(argv[1],16);
	if (value == -1)
	{
		printf ("\n Unknown control identifier `%s'.\n", argv [1]);
		return ;
	}
	word addr = (word)value;
	breakstack.binsert(addr);
}

void run_infobreak(int argc,char *argv[])
{
	if (argc != 1)
	{
		printf ("\n Unknown control identifier `%s'.\n", argv [1]);
		return ;
	}
	breakstack.list_break();
}

void run_delbreak(int argc,char *argv[])
{
	if (argc < 2)
	{
		printf ("\n Not enough arguments.\n");
		return;
	}
	int len = strlen(argv[1]);
	int index = 0;
	char ch;
	for (int i=0;i<len;i++)
	{
		ch = argv[1][i];
		if (ch <= '9' && ch >= '0')
		{
			index *= 10;
			index += (ch-'0') & 0xF;
		}
		else 
		{
			printf ("\n Unknown control identifier `%s'.\n", argv [1]);
			return ;
		}
	}
	breakstack.delbp(index);
}

void run_regs(int argc,char *argv[])
{
	if (argc != 1)
	{
		printf ("\n Unknown control identifier `%s'.\n", argv [1]);
		return ;
	}
	printf("\n");
	reg.list_regs();
}

void goto_pos(int pos)
{
	HANDLE hstdout = GetStdHandle(STD_OUTPUT_HANDLE);
	COORD scrn;
	CONSOLE_SCREEN_BUFFER_INFO sbinf;
	GetConsoleScreenBufferInfo(hstdout,&sbinf);
	if (pos == 0)
		pos = 0;
	else pos += sbinf.dwCursorPosition.X;
	if (pos < 0 || pos >= SCRN_X)
		return ;
	scrn.X = pos;
	scrn.Y = sbinf.dwCursorPosition.Y;
	SetConsoleCursorPosition(hstdout,scrn);
}

void mem_save(word addr,char buffer[])
{
	IR = 0;
	for (int i=0;i<16;i++)
	{
		IR <<= 1;
		if (buffer[i] == '1')
			IR |= 0x1;
	}
	mem.write_mem(addr,IR);
}

void run_edit_mem(int argc,char *argv[])
{
	word addr = 0;
	int len, value;
	if (argc != 1)
	{
		len = strlen(argv[1]);
		if (len > 4)
		{
			printf ("\n Unknown control identifier `%s'.\n", argv [1]);
			return ;
		}
		value = get_number(argv[1],16);
		if (value == -1)
		{
			printf ("\n Unknown control identifier `%s'.\n", argv [1]);
			return ;
		}
	}
	else value = reg.PC;
	addr = (word)value;
	if (mem.can_vst(addr) != 0) 
	{
		printf("\n   Can not read memory %04x\n",addr);
		return ;
	}
	char ch;
	char buffer[17];
	buffer[16] = '\0';
	IR = mem.read_mem(addr);
	for (int i=0;i<16;i++)
	{
		if ((IR & 0x8000) != 0)
		{
			buffer[i] = '1';
		}
		else buffer[i] = '0';
		IR <<= 1;
	}
	printf("\n   [%04x]  %s",addr,buffer);
	goto_pos(-16);
	int cur = 0;
	while (true)
	{
		ch = getch();
		if (ch == -32)
		{
			ch = getch();
			switch (ch)
			{
			case 75:
				if (cur == 0)
					break;
				cur --;
				goto_pos(-1);
				break;
			case 77:
				if (cur == 15)
					break;
				cur ++;
				goto_pos(1);
				break;
			}
		}
		else if (ch == '0')
		{
			printf("%c",'0');
			buffer[cur] = '0';
			if (cur == 15)
				goto_pos(-1);
			else cur ++;
		}
		else if (ch == '1')
		{
			printf("%c",'1');
			buffer[cur] = '1';
			if (cur == 15)
				goto_pos(-1);
			else cur ++;
		}
		else if (ch == 13)
		{
			mem_save(addr,buffer);
			addr ++;
			if (mem.can_vst(addr) != 0)
				return ;
			IR = mem.read_mem(addr);
			for (int i=0;i<16;i++)
			{
				if ((IR & 0x8000) != 0)
					buffer[i] = '1';
				else buffer[i] = '0';
				IR <<= 1;
			}
			cur = 0;
			printf("\n   [%04x]  %s",addr,buffer);
			goto_pos(-16);
		}
		else if (ch == 'm' || ch == 7)
			return ;
	}
}

int save_asm(word addr,char buffer[])
{
	char *argv[64];
	int argc = 0;
	int in_command = 0;
	int i;
	for (i=0;buffer[i] != '\0';i++)
	{
		if (buffer[i] != ' ')
		{
			if (in_command == 0)
			{
				argv[argc++] = &buffer[i];
				in_command = 1;
			}
		}
		else
		{
			buffer[i] = '\0';
			in_command = 0;
		}
	}
	if (argc == 0)
		return -1;
	word code = 0;
	const struct TASM *p = const_asm;
	for (i=0;i<asm_total;i++)
	{
		if (strcmp(argv[0],(*p).name) == 0)
			break;
		p ++;
	}
	if (i == asm_total)
		return -1;
	int value;
	code = ((*p).code & (*p).x & (*p).y & (*p).z);
	word regs[3], k;
	regs[0] = ~(*p).x;
	regs[1] = ~(*p).y;
	regs[2] = ~(*p).z;
	word num;
	for (i=0;i<3;i++)
	{
		if (regs[i] != 0)
		{
			if (argc < i+2)
				return -1;
			k = (regs[i] & (*p).code);
			if (regs[i] == k)
			{
				if ((value = get_regs_id(argv[i+1])) < 0) return -1;
				while ((regs[i] & 1) == 0)
				{
					value = (value << 1);
					regs[i] = (regs[i] >> 1);
				}
				code |= value;
			}
			else
			{
				num = regs[i];
				while ((num & 1) == 0) num = (num >> 1);
				if ((value = get_number(argv[i+1],num,1)) < 0) return -1;
				while ((regs[i] & 1) == 0)
				{
					value = (value << 1);
					regs[i] = (regs[i] >> 1);
				}
				code |= value;
			}
		}
		else
		{
			if (argc != i+1)
				return -1;
			break ;
		}
	}
	mem.write_mem(addr,code);
	return 0;
}


void run_edit_asm(int argc,char *argv[])
{
	int len;
	char ch;
	word addr = 0;
	if (argc == 1)
		addr = reg.PC;
	else
	{
		len = strlen(argv[1]);
		if (len > 4)
		{
			printf ("\n Unknown control identifier `%s'.\n", argv [1]);
			return ;
		}
		for (int i=0;i<len;i++)
		{
			addr <<=4;
			ch = argv[1][i];
			if (ch <= '9' && ch >= '0')
				addr |= (ch-'0');
			else if (ch <= 'F' && ch >= 'A')
				addr |= (ch-'A'+10);
			else if (ch <= 'f' && ch >= 'a')
				addr |= (ch-'a'+10);
			else
			{
				printf ("\n Unknown control identifier `%s'.\n", argv [1]);
				return ;
			}
		}
	}
	if (mem.can_vst(addr) != 0) 
	{
		printf("\n   Can not read memory %04x\n",addr);
		return ;
	}
	len = 0;
	int cur = 0;
	char buffer[65];
	buffer[len] = buffer[64] = '\0';
	printf("\n   [%04x]  ",addr);
	while (true)
	{
		ch = getch();
		if (ch == 8)
		{
			if (cur != 0)
			{
				if (cur == len)
				{
					buffer[--len] = '\0';
					cur --;
					goto_pos(-1);
						printf(" ");
					goto_pos(-1);
				}
				else
				{
					memcpy(&buffer[cur-1],&buffer[cur],len-cur);
					buffer[--len] = '\0';
					printf("\b%s ",&buffer[--cur]);
					goto_pos(cur-len-1);
				}
			}
		}
		else if (ch == -32)
		{
			ch = getch();
			switch (ch)
			{
			case 75:
				if (cur != 0)
				{
					cur --;
					goto_pos(-1);
				}
					break;
			case 77:
				if (cur != len)
				{
					goto_pos(1);
						cur ++;
				}
				break;
			case 83:
				if (cur != len)
				{
					len --;
					memcpy(&buffer[cur],&buffer[cur+1],len-cur);
						buffer[len] = '\0';
					printf("%s ",&buffer[cur]);
					goto_pos(cur-len-1);
				}
				break;
			}
		}
		else if (ch == 13)
		{
			if (len == 0)
					return ;
			if (save_asm(addr,buffer) == 0)
			{
				addr ++;
				if (mem.can_vst(addr) != 0)
						return ;
			}
			cur = len = 0;
			buffer[len] = '\0';
			printf("\n   [%04x]  %s",addr,buffer);
		}
		else if ((ch <= '9' && ch >= '0') || ch == '-' || (ch <= 'Z' && ch >= 'A') || ch == ' ' || (ch <= 'z' && ch >= 'a'))
		{
			if (len != 64)
			{
				if (ch <= 'z' && ch >= 'a')
					ch -= 32;
				if (cur == len)
				{
					buffer[cur++] = ch;
					buffer[++len] = '\0';
					printf("%c",ch);
				}
				else
				{
					len ++;
					memcpy(&buffer[cur+1],&buffer[cur],len-cur);
					buffer[cur] = ch;
					printf("%s",&buffer[cur++]);
					goto_pos(cur-len);
				}
			}
		}
	}
}

void view_bincode(word code)
{
	word j = 0x8000;
	for (int i=0;i<16;i++)
	{
		if ((j & code) != 0)
			printf("1");
		else printf("0");
		j >>= 1;
	}
	printf("    <%04x>",code);
}

void run_view_bincode(int argc,char *argv[])
{
	int steps = 10;
	int value;
	if (argc == 1)
		PC = reg.PC;
	else if (argc >= 2)
	{
		value = get_number(argv[1],16);
		if (value == -1)
		{
			if (strcmp(argv[1],"sp") == 0 || strcmp(argv[1],"SP") == 0)
				value = reg.SP;
			else 
			{	
				printf ("\n Unknown control identifier `%s'.\n", argv[1]);
				return ;
			}
		}
		PC = (word)value;
	}
	if (argc > 2)
	{
		value = get_number(argv[2],16);
		if (value == -1)
		{
			printf ("\n Unknown control identifier `%s'.\n", argv[1]);
			return ;
		}
		if (steps < value)
			steps = value;
	}
	
	for (int i=0;i<steps && mem.can_vst(PC) == 0;i++)
	{
		printf("\n        [%04x] ",PC);
		IR = mem.read_mem(PC++);
		view_bincode(IR);
	}
}

void run_uasm(int argc,char *argv[])
{
	output=fopen("uasm.out","w");
	if (argc == 1)
	{
		PC = reg.PC;
		for (int i=0;i<10 && mem.can_vst(PC) == 0;i++)
		{
			printf("\n        [%04x] ",PC);
			// fwrite(&PC,sizeof(PC),1,output); //////////////////////
			IR = mem.read_mem(PC++);
			pc_decode(IR,1);
		}
		return ;
	}
	int steps = 10;
	int value = get_number(argv[1],16);
	if (value == -1)
	{
		printf ("\n Unknown control identifier `%s'.\n", argv[1]);
		return ;
	}
	PC = value;
	if (argc == 3)
	{
		value = get_number(argv[2],16);
		if (value == -1)
		{
			printf ("\n Unknown control identifier `%s'.\n", argv[2]);
			return ;
		}
		if (steps < value)
			steps = value;
	}
	for (int i=0;i<steps && mem.can_vst(PC) == 0;i++)
	{
		printf("\n        [%04x] ",PC);
		// fwrite(&PC,sizeof(PC),1,output); //////////////////////
		IR = mem.read_mem(PC++);
		pc_decode(IR,1);
	}
	fclose(output);
}

void run_reset(int argc,char *argv[])
{
	reg.PC = 0x0000;
	reg.SP = 0xDFFF;
	for (int i=0;i<8;i++)
		reg.regh[i] = 0x0000;
	reg.T = 0;
	reg.HI = reg.LO = 0;
	if (argv != NULL)
		run_regs(1,argv);
}

void run_load(int argc,char *argv[])
{
	if (argc == 1)
	{
		t = mem.load_mem("code.cod");
		run_reset(1,NULL);
	}
	else
	{		
		if ((t = mem.load_mem(argv[1]) != 0 ))
			printf("\n    Can not load file %s...\n",argv[1]);
	}
}

void run_save(int argc,char *argv[])
{
	if (argc == 1)
		mem.save_mem("rom.dat");
	else mem.save_mem(argv[1]);
}

void run_saveFormat(int argc,char *argv[])
{
	int PC = reg.PC;
	if(argc == 1)
		mem.save_memFormat("romFormat.dat",PC);
	else mem.save_memFormat(argv[1],PC);
}

void run_restart(int argc,char *argv[])
{
	//reg.PC = 0x0001;
	reg.PC = 0x0000;					//by zhangteng:why 0x0001?
	run_continue(1,argv);
}

void run_set_reg(int argc,char *argv[])
{
	if (argc < 3)
	{
		printf ("\n Not enough arguments.\n");
		return;
	}
	if (strlen(argv[1]) != 2)
	{
		printf ("\n Unknown control identifier `%s'.\n",argv[1]);
		return ;
	}
	if (argv[1][0] == 'r')
		argv[1][0] = 'R';
	if (strlen(argv[2]) > 4)
	{
		printf ("\n Unknown control identifier `%s'.\n",argv[2]);
		return ;
	}
	word *regis = NULL;
	int value;
	if (argv[1][0] == 'R' && argv[1][1] <= '7' && argv[1][1] >= '0')
	{
		for (int i=0;i<8;i++)
		{
			if (strcmp(RegsList[i].name,argv[1]) == 0)
			{
				regis = &reg.regh[i];
				break;
			}
		}
	}
	else
	{
		if (strcmp("SP",argv[1]) == 0 || strcmp("sp",argv[1]) == 0)
			regis = &reg.SP;
	}
	if (regis == NULL)
	{
		printf ("\n Unknown control identifier `%s'.\n",argv[1]);
		return ;
	}
	value = get_number(argv[2],16);
	if (value == -1)
	{
		printf ("\n Unknown control identifier `%s'.\n",argv[2]);
		return ;
	}
	*regis = (word)value;
	run_regs(1,argv);
}

void run_goto(int argc,char *argv[])
{
	int value = get_number(argv[1],16);
	if (value == -1)
		return ;
	word addr = (word)value;
	if (mem.can_vst(addr) != 0)
		return ;
	reg.PC = addr;
	run_regs(1,argv);
}

void run_server(int argc,char *argv[])
{
	if (argc == 2)
	{
		if (strcmp(argv[1],"int") != 0)
		{
			printf ("\n Unknown control identifier `%s'.\n",argv[1]);
			return ;
		}
	}
	else if (argc != 1)
	{
		printf ("\n Unknown control identifier  ");
		for (int i=1;i<argc;i++)
			printf(" `%s' ",argv[i]);
		printf("\n");
		return ;
	}
	//load kernel
	printf("\n");
	t = mem.load_mem("kernel.bin");
	if (t != 0)
	{
		printf("\n   Can not load kernel \n");
		return ;
	}
	printf("Waiting for term connect\n");
	WSADATA wsaData;
	int errcode=WSAStartup(0x101,&wsaData);
	if(errcode != 0)
	{
		printf("\n Failed to change mode...\n");
		return ;
	}

	sockaddr_in local;
	local.sin_family=AF_INET;				//Address family
	local.sin_addr.s_addr=INADDR_ANY;		//Wild card IP address
	local.sin_port=htons((u_short)8000);	//port to use

	server=socket(AF_INET,SOCK_STREAM,0);

	if(server == INVALID_SOCKET)
	{
		printf("\n Failed to create socket...\n");
		return ;
	}

	if(bind(server,(sockaddr*)&local,sizeof(local))!=0)
	{
		printf("\n Failed to bind...\n");
		return ;
	}

	if(listen(server,2)!=0)
		return ;

	sockaddr_in from1, from2;
	int fromlen1=sizeof(from1);
	//int fromlen2=sizeof(from2);
	unsigned long ul1 = 1;
	//unsigned long ul2 = 1;
	int start, total;
	int len;
	char buffer[BUFFER_SIZE_CLIENT+1];
	client1 = accept(server,(struct sockaddr*)&from1,&fromlen1);
	sprintf(buffer,"--COM1--  Accept user from IP %s\r\n  ---------------------------------------------------\r\n",
		inet_ntoa(from1.sin_addr));
	len = strlen(buffer);
	ioctlsocket(client1,FIONBIO,(unsigned long *)&ul1);
	start = 0;
	while (start < len-1)
	{
		total = send(client1,buffer+start,len-start,0);
		start += total;
	}
	printf("\n   --COM1-- Connection from %s\n",inet_ntoa(from1.sin_addr));

	/*client2 = accept(server,(struct sockaddr*)&from2,&fromlen2);
	sprintf(buffer,"--COM2--  Accept user from IP %s\r\n  ---------------------------------------------------\r\n",
		inet_ntoa(from2.sin_addr));
	len = strlen(buffer);
	ioctlsocket(client2,FIONBIO,(unsigned long *)&ul2);
	start = 0;
	while (start < len-1)
	{
		total = send(client2,buffer+start,len-start,0);
		start += total;
	}
	printf("   --COM2-- Connection from %s\n",inet_ntoa(from2.sin_addr));*/

	//reset registers
	printf("Working ....\n");
	run_reset(1,NULL);
	for (int i=0;i<34;i++)
		pc_step(1);
	run_uasm(1,NULL);

	char ch;
	word *mem1 = &mem.memory[0xBF01];
	word *mem3 = &mem.memory[0xBF03];
	//设定寄存器状态
	*mem1 = *mem3 = 1;

	bool loop = true;
	word err;
	console_mode = 1;
	int steps = 0;
	if (argc == 2)
		int_mode = 1;
	int int_count = 0;
	while (loop)
	{
		if (steps == 200)
		{
			if (kbhit())
			{
				ch = getch();
				if (ch == 7)
					goto break_while;
				else if (ch == 21)
					asm_func_int(0x10);	//硬中断
			}
			steps = 0;
		}
		if (((*mem1) & 1) == 0)
		{
			ch = (char )(mem.Msend[0] & 0xFF);
			send(client1,&ch,1,0);
			if (ch <= 0x20 || ch >= 0x7E)
				printf("\nCOM1>>send <hex> %02x",ch);
			else printf("\nCOM1>>send %c",ch);
			(*mem1) |= 1;
		}
		if (((*mem1) & 2) == 0)
		{
			len = recv(client1,&ch,1,0);
			if (len == 0)
			{
				printf("\n     Lost COM1...\n");
				goto break_while;
			}
			else if (len == 1)
			{
				if (ch <= 0x20 || ch >= 0x7E)
					printf("\nCOM1>>received <hex> %02x",ch);
				else printf("\nCOM1>>received %c",ch);
				mem.Mrecv[0] = (word)ch;
				*mem1 |= 2;
			}
		}
		if (((*mem3) & 1) == 0)
		{
			ch = (char )(mem.Msend[1] & 0xFF);
			send(client2,&ch,1,0);
			if (ch <= 0x20 || ch >= 0x7E)
				printf("\nCOM2>>send <hex> %02x",ch);
			else printf("\nCOM2>>send %c",ch);
			(*mem3) |= 1;
		}
		if (((*mem3) & 2) == 0)
		{
			len = recv(client2,&ch,1,0);
			if (len == 0)
			{
				printf("\n     Lost COM2...\n");
				goto break_while;
			}
			else if (len == 1)
			{
				if (ch <= 0x20 || ch >= 0x7E)
					printf("\nCOM2>>received <hex> %02x",ch);
				else printf("\nCOM2>>received %c",ch);
				mem.Mrecv[1] = (word)ch;
				*mem3 |= 2;
			}
		}
		steps ++;
		err = pc_step(1);
		if (err)
		{
			goto break_while;
		}
		if (int_mode == 1)
		{
			if ((reg.IH & 0x8000) == 0)
				int_count = 0;
			else 
				int_count ++;
			if (int_count == const_int_step)
			{
				int_count = 0;
				asm_func_int(0x20);
			}
		}
	}
break_while:
	console_mode = -1;
	closesocket(client1);
	closesocket(client2);
	closesocket(server);
	WSACleanup();
	int_mode = 0;
}



void run_help(int argc,char *argv[]);

typedef void (* Tconsole_func) (int , char *[]);

struct Tcommand
{
	Tconsole_func func;
	char *func_name;
	char *func_description;
};

Tcommand commands [] = {
	{run_continue,"c","[int]\t\t\tcontinue executing"},
	{run_step,"s","\t\t\texecute one instruction"},
	{run_quit,"q","\t\t\tstop execution, and quit"},
	{run_setbreak,"b","<addr>\t\t\tset a breakpoint"},
	{run_infobreak,"lb","\t\t\tdisplay state of all breakpoints"},
	{run_delbreak,"db"," <num>\t\t\tdelete a breakpoint"},
	{run_regs,"r","\t\t\tlist of all CPU registers and their contents"},
	{run_view_bincode,"v"," [addr]\t\t\tscan memory (binary)"},
	{run_uasm,"u"," [addr]\t\t\tscan memory (assemble)"},
	{run_edit_mem,"em","[addr]\t\t\tedit memory (binary)"},
	{run_edit_asm,"ea","[addr]\t\t\tedit memory (assemble)"},
	{run_set_reg,"sr","<regs> <value>\t\tchange a CPU register(Rx or SP) to value"},
	{run_reset,"reset","\t\t\treset registers"},
	{run_restart,"restart","\t\t\treset registers and continue executing"},
	{run_goto,"goto","<addr>\t\tchange PC to addr"},
	{run_load,"load","[file]\t\tload file to memory, default is code.cod"},
	{run_save,"save","[file]\t\tsave memory, default is rom.dat"},
	{run_saveFormat,"saveformat","[file]\t\tsave memory as Intel HEX Filt Format,default is romFormat.dat"},
	{run_server,"server","[int]\t\tcompile and execute kernel.x"},
	{run_help,"help","\t\t\tlist of all commands"}
};

void run_help (int argc, char * argv [])
{
	printf ("\n   List of commands:\n");
	for (unsigned int i=0; i<sizeof(commands)/sizeof(Tcommand);i++)
	{
		printf ("      %s %s\n", commands[i].func_name,commands[i].func_description);
	}
}

struct Tconsole
{
	HANDLE hstdout;
	COORD scrn;
	CONSOLE_SCREEN_BUFFER_INFO sbinf;
	int curcom;
	int totalcom;
	int sizecom;
	char **comlist;
	Tconsole()
	{
		sizecom = 4;
		curcom = totalcom = 0;
		comlist = (char **)malloc(sizeof(char *)*sizecom);
		hstdout = GetStdHandle(STD_OUTPUT_HANDLE);
		WORD attr = FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_INTENSITY | BACKGROUND_BLUE;
		SetConsoleTextAttribute(hstdout,attr);
		clearscrn();
		work();
	}	
	void clearscrn()
	{	
		int size;
		LPDWORD lpNumber = new DWORD;
		scrn.X = SCRN_X;
		scrn.Y = SCRN_Y;
		SetConsoleScreenBufferSize(hstdout,scrn);
		GetConsoleScreenBufferInfo(hstdout,&sbinf);
		size = SCRN_X*SCRN_Y;
		scrn.X = scrn.Y = 0;
		FillConsoleOutputAttribute(hstdout,sbinf.wAttributes,size,scrn,lpNumber);
		FillConsoleOutputCharacter(hstdout,' ',size,scrn,lpNumber);
		gotoxy(0,0);
	}
	void gotoxy(int xpos,int ypos)
	{
		scrn.X = xpos;
		scrn.Y = ypos;
		SetConsoleCursorPosition(hstdout,scrn);
	}
	void gotoxy_cur(int next)
	{
		if (next == 0)
			return ;
		GetConsoleScreenBufferInfo(hstdout,&sbinf);
		int pos = sbinf.dwCursorPosition.Y*SCRN_X+sbinf.dwCursorPosition.X+next;
		if (next > 0)
		{
			if (pos > SCRN_X*SCRN_Y)
				return ;
		}
		else 
		{
			if (pos < 0)
				return ;
		}
		scrn.X = pos%SCRN_X;
		scrn.Y = pos/SCRN_X;
		SetConsoleCursorPosition(hstdout,scrn);
	}
	void addcom(char *str)
	{
		comlist[totalcom] = (char *)malloc(sizeof(char)*(strlen(str)+1));
		memcpy(comlist[totalcom++],str,strlen(str)+1);
		if (totalcom == sizecom)
		{
			sizecom <<= 1;
			char **temp = (char **)malloc(sizeof(char *)*sizecom);
			for (int i=0;i<totalcom;i++)
				temp[i] = comlist[i];
			free(comlist);
			comlist = temp;
		}
		curcom = totalcom;
	}
	char *getcom(int next)
	{
		if (totalcom == 0)
			return NULL;
		switch (next)
		{
		case 0:
			if (curcom == 0)
				return NULL;
			else return comlist[--curcom];
		case 1:
			if (curcom == totalcom-1)
				return NULL;
			else return comlist[++curcom];
		case 2:
			return comlist[totalcom-1];
		default:
			return NULL;
		}
	}
	void work();
	void parse_and_run(char [], int );
};

void Tconsole::parse_and_run(char buffer[], int len)
{
	char *argv[64];
	int argc = 0;
	int in_command = 0;
	for (int i=0;buffer[i] != '\0';i++)
	{
		if (buffer[i] != ' ')
		{
			if (in_command == 0)
				argv[argc++] = &buffer[i];
			in_command = 1;
		}
		else
		{
			buffer[i] = '\0';
			in_command = 0;
		}
	}
	if (argc == 0)
		return ;
	for (unsigned int i=0;i<sizeof(commands)/sizeof(Tcommand);i++)
	{
		if (strcmp(commands[i].func_name,argv[0]) == 0)
		{
			commands[i].func(argc,argv);
			return ;
		}
	}
	if (argc == 1)
	{
		int value = get_number_10(argv[0],16);
		if (value != -1)
		{
			printf("\n   ");
			pc_decode((word)value);
			return ;
		}
		else 
		{
			printf ("\n Unknown control identifier `%s'.\n",argv[0]);
			return ;
		}
	}
	printf("\n  ->Unknown command. Use ``help'' to list commands.\n");
}

void Tconsole::work()
{
	char *com;
	int cur = 0;
	int len = 0;
	char ch;
	char buffer[LimitConsoleBuffer+1];
	buffer[len] = '\0';
	printf(">>");
	while (true)
	{
		ch = getch();
		if(ch<='Z'&&ch>='A')
			ch = 'a'+ch-'A';
		if (ch == 8)
		{
			if (cur != 0)
			{
				if (cur == len)
				{
					cur --;
					buffer[--len] = '\0';
					gotoxy_cur(-1);
					printf(" ");
					gotoxy_cur(-1);
				}
				else
				{
					memcpy(&buffer[cur-1],&buffer[cur],len-cur);
					buffer[--len] = '\0';
					printf("\b%s ",&buffer[--cur]);
					gotoxy_cur(cur-len-1);
				}
			}
		}
		else if (ch == -32)
		{
			ch = getch();
			switch (ch)
			{
			case 75: //left
				if (cur != 0)
				{
					cur --;
					gotoxy_cur(-1);
				}
				break;
			case 77: //right
				if (cur != len)
				{
					cur ++;
					gotoxy_cur(1);
				}
				break;
			case 72: //up
				if (curcom != 0)
				{
					for(int i=0;i<len;i++)
						buffer[i] = ' ';
					gotoxy_cur(-cur);
					printf("%s",buffer);
					gotoxy_cur(-len);
					com = getcom(0);							
					cur = len = strlen(com);
					memcpy(buffer,com,len+1);
					printf("%s",buffer);
				}
				break;
			case 80: //down
				if (totalcom != 0 && curcom < totalcom-1)
				{
					for(int i=0;i<len;i++)
						buffer[i] = ' ';
					gotoxy_cur(-cur);
					printf("%s",buffer);
					gotoxy_cur(-len);
					com = getcom(1);							
					cur = len = strlen(com);
					memcpy(buffer,com,len+1);
					printf("%s",buffer);
				}
				break;
			case 71: //home
				gotoxy_cur(-cur);
				cur = 0;
				break;
			case 79: //end
				gotoxy_cur(len-cur);
				cur = len;
				break;
			case 83: //delete
				if (cur != len)
				{
					len--;
					memcpy(&buffer[cur],&buffer[cur+1],len-cur);
					buffer[len] = '\0';
					printf("%s ",&buffer[cur]);
					gotoxy_cur(cur-len-1);
				}
				break;
			}
		}
		else if (ch == 13)
		{
			if (len != 0)
			{
				addcom(buffer);
				parse_and_run(buffer,len);
			}
			else if (totalcom != 0)
			{
				com = getcom(2);
				len = strlen(com);
				memcpy(buffer,com,len+1);
				parse_and_run(buffer,len);
			}
			printf("\n>>");
			cur = len = 0;
			buffer[len] = '\0';
		}
		else if (ch == 27)
		{
			for (int i=0;i<len;i++)
				buffer[i] = ' ';
			gotoxy_cur(-cur);
			printf("%s",buffer);
			gotoxy_cur(-len);
			cur = len = 0;
			buffer[len] = '\0';
		}
		else
		{
			if (ch <= 126 && ch >= 32)
			{
				if (cur == len)
				{
					if (len != LimitConsoleBuffer)
					{
						cur ++;
						buffer[len++] = ch;
						buffer[len] = '\0';
						printf("%c",ch);
					}
				}
				else
				{
					if (len == LimitConsoleBuffer)
					{
						memcpy(&buffer[cur+1],&buffer[cur],len-cur-1);
						buffer[cur] = ch;
						printf("%s",&buffer[cur++]);
						gotoxy_cur(cur-len);
					}
					else
					{
						memcpy(&buffer[cur+1],&buffer[cur],len-cur);
						buffer[++len] = '\0';
						buffer[cur] = ch;
						printf("%s",&buffer[cur++]);
						gotoxy_cur(cur-len);
					}
				}
			}
		}
	}
}

int main ()
{
	
	init();
	Tconsole console;
	return 0;
	
}
