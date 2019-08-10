## Introduction

This is a 16-bit instruction pipelining CPU implemented on a FPGA board. Under the 'source' directory is the source codes in VHDL and the Computer.vhd is the top level of the whole project. A simulator written in C language is under the 'software' directory, which can simulate the work of the CPU.

## Hardwares

This project is based on the THINPAD board provided by department of computer science and technology in Tsinghua University. Besides the FPGA chips, other parts on the board and their usage are as follows:

- two SRAM and a FLASH used as the memory
- serial ports to communicate with termimal program running on a PC
- a VGA player used to show the general purpose register values
- two 7-segment digital tubes
- 32 switches and 32 LED lights to debug the program

## Architecture

The architecture of the processor is similar to the classic architecture descriped in many textbook such as Computer Organization and Design-Hardware / Software Interface. The execution of the Instruction are divided into 5 stages -- Instruction Fetch(IF), Instruction Decode(ID), Execution(EXE), Memory Visit(MEM) and Write Back(WB). At the same time there are totaly 5 instructions executing. To solve the structure hazard, dataflow hazard and control hazard, a forward unit and a hazard unit are designed. The whole architecture of the processor can be seen in the datapath graph.

The processor supports 16-bit long MIPS instruction set. 30 instructions are implementd in total. The format and function of each instruciton can be seen in the 'decoder.vhd' file. A monitor program on the instruction set plays a role as operation system, which monitor the serial ports and run the command from the connected termimal.

## More Information

To get more information about this project, please refer to the book -- [The Tutorial of Computer Hardware System Experiments, Tsinghua University Press](http://product.dangdang.com/1185600906.html).