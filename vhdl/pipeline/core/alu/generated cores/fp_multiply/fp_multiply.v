////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: M.81d
//  \   \         Application: netgen
//  /   /         Filename: fp_multiply.v
// /___/   /\     Timestamp: Thu Nov 14 10:31:54 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog ./tmp/_cg\fp_multiply.ngc ./tmp/_cg\fp_multiply.v 
// Device	: 6slx45csg324-2
// Input file	: ./tmp/_cg/fp_multiply.ngc
// Output file	: ./tmp/_cg/fp_multiply.v
// # of Modules	: 1
// Design Name	: fp_multiply
// Xilinx        : C:\Xilinx\12.4\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module fp_multiply (
  overflow, underflow, a, b, result
)/* synthesis syn_black_box syn_noprune=1 */;
  output overflow;
  output underflow;
  input [15 : 0] a;
  input [15 : 0] b;
  output [15 : 0] result;
  
  // synthesis translate_off
  
  wire \blk00000003/sig00000109 ;
  wire \blk00000003/sig00000108 ;
  wire \blk00000003/sig00000107 ;
  wire \blk00000003/sig00000106 ;
  wire \blk00000003/sig00000105 ;
  wire \blk00000003/sig00000104 ;
  wire \blk00000003/sig00000103 ;
  wire \blk00000003/sig00000102 ;
  wire \blk00000003/sig00000101 ;
  wire \blk00000003/sig00000100 ;
  wire \blk00000003/sig000000ff ;
  wire \blk00000003/sig000000fe ;
  wire \blk00000003/sig000000fd ;
  wire \blk00000003/sig000000fc ;
  wire \blk00000003/sig000000fb ;
  wire \blk00000003/sig000000fa ;
  wire \blk00000003/sig000000f9 ;
  wire \blk00000003/sig000000f8 ;
  wire \blk00000003/sig000000f7 ;
  wire \blk00000003/sig000000f6 ;
  wire \blk00000003/sig000000f5 ;
  wire \blk00000003/sig000000f4 ;
  wire \blk00000003/sig000000f3 ;
  wire \blk00000003/sig000000f2 ;
  wire \blk00000003/sig000000f1 ;
  wire \blk00000003/sig000000f0 ;
  wire \blk00000003/sig000000ef ;
  wire \blk00000003/sig000000ee ;
  wire \blk00000003/sig000000ed ;
  wire \blk00000003/sig000000ec ;
  wire \blk00000003/sig000000eb ;
  wire \blk00000003/sig000000ea ;
  wire \blk00000003/sig000000e9 ;
  wire \blk00000003/sig000000e8 ;
  wire \blk00000003/sig000000e7 ;
  wire \blk00000003/sig000000e6 ;
  wire \blk00000003/sig000000e5 ;
  wire \blk00000003/sig000000e4 ;
  wire \blk00000003/sig000000e3 ;
  wire \blk00000003/sig000000e2 ;
  wire \blk00000003/sig000000e1 ;
  wire \blk00000003/sig000000e0 ;
  wire \blk00000003/sig000000df ;
  wire \blk00000003/sig000000de ;
  wire \blk00000003/sig000000dd ;
  wire \blk00000003/sig000000dc ;
  wire \blk00000003/sig000000db ;
  wire \blk00000003/sig000000da ;
  wire \blk00000003/sig000000d9 ;
  wire \blk00000003/sig000000d8 ;
  wire \blk00000003/sig000000c9 ;
  wire \blk00000003/sig000000c8 ;
  wire \blk00000003/sig000000c7 ;
  wire \blk00000003/sig000000c6 ;
  wire \blk00000003/sig000000c5 ;
  wire \blk00000003/sig000000c4 ;
  wire \blk00000003/sig000000c3 ;
  wire \blk00000003/sig000000c2 ;
  wire \blk00000003/sig000000c1 ;
  wire \blk00000003/sig000000c0 ;
  wire \blk00000003/sig000000bf ;
  wire \blk00000003/sig000000be ;
  wire \blk00000003/sig000000bd ;
  wire \blk00000003/sig000000bc ;
  wire \blk00000003/sig000000bb ;
  wire \blk00000003/sig000000ba ;
  wire \blk00000003/sig000000b9 ;
  wire \blk00000003/sig000000b8 ;
  wire \blk00000003/sig000000b7 ;
  wire \blk00000003/sig000000b6 ;
  wire \blk00000003/sig000000b5 ;
  wire \blk00000003/sig000000b4 ;
  wire \blk00000003/sig000000b3 ;
  wire \blk00000003/sig000000b2 ;
  wire \blk00000003/sig000000b1 ;
  wire \blk00000003/sig000000b0 ;
  wire \blk00000003/sig000000af ;
  wire \blk00000003/sig000000ae ;
  wire \blk00000003/sig0000009b ;
  wire \blk00000003/sig0000009a ;
  wire \blk00000003/sig00000099 ;
  wire \blk00000003/sig00000098 ;
  wire \blk00000003/sig00000097 ;
  wire \blk00000003/sig00000096 ;
  wire \blk00000003/sig00000095 ;
  wire \blk00000003/sig00000094 ;
  wire \blk00000003/sig00000093 ;
  wire \blk00000003/sig00000092 ;
  wire \blk00000003/sig00000091 ;
  wire \blk00000003/sig00000090 ;
  wire \blk00000003/sig0000008f ;
  wire \blk00000003/sig0000008e ;
  wire \blk00000003/sig0000008d ;
  wire \blk00000003/sig0000008c ;
  wire \blk00000003/sig0000008b ;
  wire \blk00000003/sig0000008a ;
  wire \blk00000003/sig00000089 ;
  wire \blk00000003/sig00000088 ;
  wire \blk00000003/sig00000087 ;
  wire \blk00000003/sig00000086 ;
  wire \blk00000003/sig00000085 ;
  wire \blk00000003/sig00000084 ;
  wire \blk00000003/sig00000083 ;
  wire \blk00000003/sig00000082 ;
  wire \blk00000003/sig00000081 ;
  wire \blk00000003/sig00000080 ;
  wire \blk00000003/sig0000007f ;
  wire \blk00000003/sig0000007e ;
  wire \blk00000003/sig0000007d ;
  wire \blk00000003/sig0000007c ;
  wire \blk00000003/sig0000007b ;
  wire \blk00000003/sig0000007a ;
  wire \blk00000003/sig00000079 ;
  wire \blk00000003/sig00000078 ;
  wire \blk00000003/sig00000077 ;
  wire \blk00000003/sig00000076 ;
  wire \blk00000003/sig00000075 ;
  wire \blk00000003/sig00000074 ;
  wire \blk00000003/sig00000073 ;
  wire \blk00000003/sig00000072 ;
  wire \blk00000003/sig00000071 ;
  wire \blk00000003/sig00000070 ;
  wire \blk00000003/sig0000006f ;
  wire \blk00000003/sig0000006e ;
  wire \blk00000003/sig0000006d ;
  wire \blk00000003/sig0000006c ;
  wire \blk00000003/sig0000006b ;
  wire \blk00000003/sig0000006a ;
  wire \blk00000003/sig00000069 ;
  wire \blk00000003/sig00000068 ;
  wire \blk00000003/sig00000067 ;
  wire \blk00000003/sig00000066 ;
  wire \blk00000003/sig00000065 ;
  wire \blk00000003/sig00000064 ;
  wire \blk00000003/sig00000063 ;
  wire \blk00000003/sig00000062 ;
  wire \blk00000003/sig00000061 ;
  wire \blk00000003/sig00000060 ;
  wire \blk00000003/sig0000005f ;
  wire \blk00000003/sig0000005e ;
  wire \blk00000003/sig0000005d ;
  wire \blk00000003/sig0000005c ;
  wire \blk00000003/sig0000005b ;
  wire \blk00000003/sig0000005a ;
  wire \blk00000003/sig00000059 ;
  wire \blk00000003/sig00000058 ;
  wire \blk00000003/sig00000057 ;
  wire \blk00000003/sig00000056 ;
  wire \blk00000003/sig00000055 ;
  wire \blk00000003/sig00000054 ;
  wire \blk00000003/sig00000053 ;
  wire \blk00000003/sig00000052 ;
  wire \blk00000003/sig00000051 ;
  wire \blk00000003/sig00000050 ;
  wire \blk00000003/sig0000004f ;
  wire \blk00000003/sig0000004e ;
  wire \blk00000003/sig0000004d ;
  wire \blk00000003/sig0000004c ;
  wire \blk00000003/sig0000004b ;
  wire \blk00000003/sig0000004a ;
  wire \blk00000003/sig00000049 ;
  wire \blk00000003/sig00000048 ;
  wire \blk00000003/sig00000035 ;
  wire \blk00000003/sig00000032 ;
  wire \blk00000003/sig00000021 ;
  wire NLW_blk00000001_P_UNCONNECTED;
  wire NLW_blk00000002_G_UNCONNECTED;
  wire \NLW_blk00000003/blk0000001e_CARRYOUTF_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_CARRYOUT_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_BCOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<47>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<46>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<45>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<44>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<43>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<42>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<41>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<40>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<39>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<38>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<37>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<36>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<32>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<31>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<30>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<29>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<28>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<27>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<26>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<25>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<24>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<23>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<22>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_P<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<47>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<46>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<45>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<44>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<43>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<42>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<41>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<40>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<39>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<38>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<37>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<36>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<32>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<31>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<30>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<29>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<28>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<27>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<26>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<25>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<24>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<23>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<22>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<21>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<20>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<19>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<18>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_PCOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<32>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<31>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<30>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<29>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<28>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<27>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<26>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<25>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<24>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<23>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<22>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<21>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<20>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<19>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<18>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000001e_M<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_CARRYOUTF_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_CARRYOUT_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<47>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<46>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<45>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<44>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<43>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<42>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<41>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<40>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<39>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<38>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<37>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<36>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<32>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<31>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<30>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<29>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<28>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<27>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<26>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<25>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<24>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<23>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<22>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<21>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<20>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<19>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<18>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_C<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<47>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<46>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<45>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<44>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<43>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<42>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<41>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<40>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<39>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<38>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<37>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<36>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<32>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<31>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<30>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<29>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<28>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<27>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<26>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<25>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<24>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<23>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<22>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<21>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<20>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<19>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<18>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<0>_UNCONNECTED ;
  wire [15 : 0] a_0;
  wire [15 : 0] b_1;
  wire [15 : 0] result_2;
  assign
    a_0[15] = a[15],
    a_0[14] = a[14],
    a_0[13] = a[13],
    a_0[12] = a[12],
    a_0[11] = a[11],
    a_0[10] = a[10],
    a_0[9] = a[9],
    a_0[8] = a[8],
    a_0[7] = a[7],
    a_0[6] = a[6],
    a_0[5] = a[5],
    a_0[4] = a[4],
    a_0[3] = a[3],
    a_0[2] = a[2],
    a_0[1] = a[1],
    a_0[0] = a[0],
    b_1[15] = b[15],
    b_1[14] = b[14],
    b_1[13] = b[13],
    b_1[12] = b[12],
    b_1[11] = b[11],
    b_1[10] = b[10],
    b_1[9] = b[9],
    b_1[8] = b[8],
    b_1[7] = b[7],
    b_1[6] = b[6],
    b_1[5] = b[5],
    b_1[4] = b[4],
    b_1[3] = b[3],
    b_1[2] = b[2],
    b_1[1] = b[1],
    b_1[0] = b[0],
    result[15] = result_2[15],
    result[14] = result_2[14],
    result[13] = result_2[13],
    result[12] = result_2[12],
    result[11] = result_2[11],
    result[10] = result_2[10],
    result[9] = result_2[9],
    result[8] = result_2[8],
    result[7] = result_2[7],
    result[6] = result_2[6],
    result[5] = result_2[5],
    result[4] = result_2[4],
    result[3] = result_2[3],
    result[2] = result_2[2],
    result[1] = result_2[1],
    result[0] = result_2[0];
  VCC   blk00000001 (
    .P(NLW_blk00000001_P_UNCONNECTED)
  );
  GND   blk00000002 (
    .G(NLW_blk00000002_G_UNCONNECTED)
  );
  LUT5 #(
    .INIT ( 32'h55404040 ))
  \blk00000003/blk00000060  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000e1 ),
    .I2(\blk00000003/sig000000ed ),
    .I3(\blk00000003/sig0000005f ),
    .I4(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000109 )
  );
  LUT6 #(
    .INIT ( 64'h5555400040004000 ))
  \blk00000003/blk0000005f  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig000000e2 ),
    .I4(\blk00000003/sig00000060 ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000108 )
  );
  MUXF7   \blk00000003/blk0000005e  (
    .I0(\blk00000003/sig00000108 ),
    .I1(\blk00000003/sig00000109 ),
    .S(\blk00000003/sig00000056 ),
    .O(result_2[1])
  );
  LUT5 #(
    .INIT ( 32'h55404040 ))
  \blk00000003/blk0000005d  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000e0 ),
    .I2(\blk00000003/sig000000ed ),
    .I3(\blk00000003/sig0000005e ),
    .I4(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000107 )
  );
  LUT6 #(
    .INIT ( 64'h5555400040004000 ))
  \blk00000003/blk0000005c  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig000000e1 ),
    .I4(\blk00000003/sig0000005f ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000106 )
  );
  MUXF7   \blk00000003/blk0000005b  (
    .I0(\blk00000003/sig00000106 ),
    .I1(\blk00000003/sig00000107 ),
    .S(\blk00000003/sig00000056 ),
    .O(result_2[2])
  );
  LUT5 #(
    .INIT ( 32'h55404040 ))
  \blk00000003/blk0000005a  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000df ),
    .I2(\blk00000003/sig000000ed ),
    .I3(\blk00000003/sig0000005d ),
    .I4(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000105 )
  );
  LUT6 #(
    .INIT ( 64'h5555400040004000 ))
  \blk00000003/blk00000059  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig000000e0 ),
    .I4(\blk00000003/sig0000005e ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000104 )
  );
  MUXF7   \blk00000003/blk00000058  (
    .I0(\blk00000003/sig00000104 ),
    .I1(\blk00000003/sig00000105 ),
    .S(\blk00000003/sig00000056 ),
    .O(result_2[3])
  );
  LUT5 #(
    .INIT ( 32'h55404040 ))
  \blk00000003/blk00000057  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000de ),
    .I2(\blk00000003/sig000000ed ),
    .I3(\blk00000003/sig0000005c ),
    .I4(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000103 )
  );
  LUT6 #(
    .INIT ( 64'h5555400040004000 ))
  \blk00000003/blk00000056  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig000000df ),
    .I4(\blk00000003/sig0000005d ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000102 )
  );
  MUXF7   \blk00000003/blk00000055  (
    .I0(\blk00000003/sig00000102 ),
    .I1(\blk00000003/sig00000103 ),
    .S(\blk00000003/sig00000056 ),
    .O(result_2[4])
  );
  LUT5 #(
    .INIT ( 32'h55404040 ))
  \blk00000003/blk00000054  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000dd ),
    .I2(\blk00000003/sig000000ed ),
    .I3(\blk00000003/sig0000005b ),
    .I4(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000101 )
  );
  LUT6 #(
    .INIT ( 64'h5555400040004000 ))
  \blk00000003/blk00000053  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig000000de ),
    .I4(\blk00000003/sig0000005c ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000100 )
  );
  MUXF7   \blk00000003/blk00000052  (
    .I0(\blk00000003/sig00000100 ),
    .I1(\blk00000003/sig00000101 ),
    .S(\blk00000003/sig00000056 ),
    .O(result_2[5])
  );
  LUT5 #(
    .INIT ( 32'h55404040 ))
  \blk00000003/blk00000051  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000dc ),
    .I2(\blk00000003/sig000000ed ),
    .I3(\blk00000003/sig0000005a ),
    .I4(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig000000ff )
  );
  LUT6 #(
    .INIT ( 64'h5555400040004000 ))
  \blk00000003/blk00000050  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig000000dd ),
    .I4(\blk00000003/sig0000005b ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig000000fe )
  );
  MUXF7   \blk00000003/blk0000004f  (
    .I0(\blk00000003/sig000000fe ),
    .I1(\blk00000003/sig000000ff ),
    .S(\blk00000003/sig00000056 ),
    .O(result_2[6])
  );
  LUT5 #(
    .INIT ( 32'h55404040 ))
  \blk00000003/blk0000004e  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000db ),
    .I2(\blk00000003/sig000000ed ),
    .I3(\blk00000003/sig00000059 ),
    .I4(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig000000fd )
  );
  LUT6 #(
    .INIT ( 64'h5555400040004000 ))
  \blk00000003/blk0000004d  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig000000dc ),
    .I4(\blk00000003/sig0000005a ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig000000fc )
  );
  MUXF7   \blk00000003/blk0000004c  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fd ),
    .S(\blk00000003/sig00000056 ),
    .O(result_2[7])
  );
  LUT5 #(
    .INIT ( 32'h55404040 ))
  \blk00000003/blk0000004b  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000da ),
    .I2(\blk00000003/sig000000ed ),
    .I3(\blk00000003/sig00000058 ),
    .I4(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig000000fb )
  );
  LUT6 #(
    .INIT ( 64'h5555400040004000 ))
  \blk00000003/blk0000004a  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig000000db ),
    .I4(\blk00000003/sig00000059 ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig000000fa )
  );
  MUXF7   \blk00000003/blk00000049  (
    .I0(\blk00000003/sig000000fa ),
    .I1(\blk00000003/sig000000fb ),
    .S(\blk00000003/sig00000056 ),
    .O(result_2[8])
  );
  LUT6 #(
    .INIT ( 64'h4154015441440104 ))
  \blk00000003/blk00000048  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000056 ),
    .I3(\blk00000003/sig00000061 ),
    .I4(\blk00000003/sig000000e2 ),
    .I5(\blk00000003/sig00000060 ),
    .O(result_2[0])
  );
  LUT5 #(
    .INIT ( 32'h54440444 ))
  \blk00000003/blk00000047  (
    .I0(\blk00000003/sig00000056 ),
    .I1(\blk00000003/sig00000058 ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig00000062 ),
    .I4(\blk00000003/sig000000da ),
    .O(\blk00000003/sig000000f2 )
  );
  LUT5 #(
    .INIT ( 32'hFEFFFFFF ))
  \blk00000003/blk00000046  (
    .I0(\blk00000003/sig000000e7 ),
    .I1(\blk00000003/sig000000e9 ),
    .I2(\blk00000003/sig000000e6 ),
    .I3(\blk00000003/sig000000e8 ),
    .I4(\blk00000003/sig000000be ),
    .O(\blk00000003/sig000000f3 )
  );
  LUT5 #(
    .INIT ( 32'h1511FFFF ))
  \blk00000003/blk00000045  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000056 ),
    .I2(\blk00000003/sig00000060 ),
    .I3(\blk00000003/sig000000b2 ),
    .I4(\blk00000003/sig00000061 ),
    .O(\blk00000003/sig000000f9 )
  );
  LUT5 #(
    .INIT ( 32'hFFFFFFFB ))
  \blk00000003/blk00000044  (
    .I0(\blk00000003/sig000000e6 ),
    .I1(\blk00000003/sig000000e8 ),
    .I2(\blk00000003/sig000000e7 ),
    .I3(\blk00000003/sig000000e9 ),
    .I4(\blk00000003/sig000000f1 ),
    .O(\blk00000003/sig000000f8 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFFFF2220 ))
  \blk00000003/blk00000043  (
    .I0(\blk00000003/sig000000be ),
    .I1(\blk00000003/sig000000eb ),
    .I2(\blk00000003/sig000000bd ),
    .I3(\blk00000003/sig000000f7 ),
    .I4(\blk00000003/sig000000e6 ),
    .I5(\blk00000003/sig000000e7 ),
    .O(\blk00000003/sig000000e5 )
  );
  LUT5 #(
    .INIT ( 32'h80808000 ))
  \blk00000003/blk00000042  (
    .I0(\blk00000003/sig000000c1 ),
    .I1(\blk00000003/sig000000c7 ),
    .I2(\blk00000003/sig000000c4 ),
    .I3(\blk00000003/sig000000c9 ),
    .I4(\blk00000003/sig00000056 ),
    .O(\blk00000003/sig000000f7 )
  );
  LUT6 #(
    .INIT ( 64'h0040400000555500 ))
  \blk00000003/blk00000041  (
    .I0(\blk00000003/sig000000f6 ),
    .I1(\blk00000003/sig000000ba ),
    .I2(\blk00000003/sig000000e8 ),
    .I3(b_1[15]),
    .I4(a_0[15]),
    .I5(\blk00000003/sig000000e7 ),
    .O(result_2[15])
  );
  LUT3 #(
    .INIT ( 8'hA2 ))
  \blk00000003/blk00000040  (
    .I0(\blk00000003/sig000000e6 ),
    .I1(\blk00000003/sig000000b6 ),
    .I2(\blk00000003/sig000000e9 ),
    .O(\blk00000003/sig000000f6 )
  );
  LUT6 #(
    .INIT ( 64'hAAAADDD5AAAFDDD5 ))
  \blk00000003/blk0000003f  (
    .I0(\blk00000003/sig000000be ),
    .I1(\blk00000003/sig000000ea ),
    .I2(\blk00000003/sig000000c9 ),
    .I3(\blk00000003/sig00000056 ),
    .I4(\blk00000003/sig000000bd ),
    .I5(\blk00000003/sig000000f5 ),
    .O(\blk00000003/sig000000f1 )
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \blk00000003/blk0000003e  (
    .I0(\blk00000003/sig000000c1 ),
    .I1(\blk00000003/sig000000c4 ),
    .I2(\blk00000003/sig000000c7 ),
    .O(\blk00000003/sig000000f5 )
  );
  LUT6 #(
    .INIT ( 64'h0000000111111111 ))
  \blk00000003/blk0000003d  (
    .I0(\blk00000003/sig000000be ),
    .I1(\blk00000003/sig000000ec ),
    .I2(\blk00000003/sig000000f4 ),
    .I3(\blk00000003/sig000000e4 ),
    .I4(\blk00000003/sig00000056 ),
    .I5(\blk00000003/sig000000bd ),
    .O(underflow)
  );
  LUT4 #(
    .INIT ( 16'hFFFE ))
  \blk00000003/blk0000003c  (
    .I0(\blk00000003/sig000000c1 ),
    .I1(\blk00000003/sig000000c4 ),
    .I2(\blk00000003/sig000000c7 ),
    .I3(\blk00000003/sig000000c9 ),
    .O(\blk00000003/sig000000f4 )
  );
  LUT6 #(
    .INIT ( 64'h5555555544444440 ))
  \blk00000003/blk0000003b  (
    .I0(\blk00000003/sig000000f3 ),
    .I1(\blk00000003/sig000000ea ),
    .I2(\blk00000003/sig000000e4 ),
    .I3(\blk00000003/sig00000056 ),
    .I4(\blk00000003/sig000000c9 ),
    .I5(\blk00000003/sig000000bd ),
    .O(overflow)
  );
  LUT6 #(
    .INIT ( 64'h5555555555551110 ))
  \blk00000003/blk0000003a  (
    .I0(\blk00000003/sig000000eb ),
    .I1(\blk00000003/sig000000f1 ),
    .I2(\blk00000003/sig000000f2 ),
    .I3(\blk00000003/sig000000f0 ),
    .I4(\blk00000003/sig000000e7 ),
    .I5(\blk00000003/sig000000e6 ),
    .O(result_2[9])
  );
  LUT4 #(
    .INIT ( 16'hA820 ))
  \blk00000003/blk00000039  (
    .I0(\blk00000003/sig00000056 ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig00000057 ),
    .I3(\blk00000003/sig000000d9 ),
    .O(\blk00000003/sig000000f0 )
  );
  LUT6 #(
    .INIT ( 64'h5555555514444444 ))
  \blk00000003/blk00000038  (
    .I0(\blk00000003/sig000000e3 ),
    .I1(\blk00000003/sig000000c1 ),
    .I2(\blk00000003/sig000000e4 ),
    .I3(\blk00000003/sig000000c4 ),
    .I4(\blk00000003/sig000000ef ),
    .I5(\blk00000003/sig000000e5 ),
    .O(result_2[13])
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \blk00000003/blk00000037  (
    .I0(\blk00000003/sig000000c7 ),
    .I1(\blk00000003/sig000000c9 ),
    .O(\blk00000003/sig000000ef )
  );
  LUT6 #(
    .INIT ( 64'h5555555541111111 ))
  \blk00000003/blk00000036  (
    .I0(\blk00000003/sig000000e3 ),
    .I1(\blk00000003/sig000000bd ),
    .I2(\blk00000003/sig000000e4 ),
    .I3(\blk00000003/sig000000c1 ),
    .I4(\blk00000003/sig000000ee ),
    .I5(\blk00000003/sig000000e5 ),
    .O(result_2[14])
  );
  LUT3 #(
    .INIT ( 8'h80 ))
  \blk00000003/blk00000035  (
    .I0(\blk00000003/sig000000c4 ),
    .I1(\blk00000003/sig000000c7 ),
    .I2(\blk00000003/sig000000c9 ),
    .O(\blk00000003/sig000000ee )
  );
  LUT4 #(
    .INIT ( 16'hEAAA ))
  \blk00000003/blk00000034  (
    .I0(\blk00000003/sig00000056 ),
    .I1(\blk00000003/sig000000d8 ),
    .I2(\blk00000003/sig00000061 ),
    .I3(\blk00000003/sig00000062 ),
    .O(\blk00000003/sig000000e4 )
  );
  LUT5 #(
    .INIT ( 32'hAABB8088 ))
  \blk00000003/blk00000033  (
    .I0(\blk00000003/sig00000061 ),
    .I1(\blk00000003/sig00000056 ),
    .I2(\blk00000003/sig00000060 ),
    .I3(\blk00000003/sig000000b2 ),
    .I4(\blk00000003/sig00000062 ),
    .O(\blk00000003/sig000000ed )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \blk00000003/blk00000032  (
    .I0(a_0[0]),
    .I1(a_0[1]),
    .I2(a_0[2]),
    .I3(a_0[3]),
    .I4(a_0[4]),
    .I5(a_0[5]),
    .O(\blk00000003/sig000000b3 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk00000031  (
    .I0(a_0[6]),
    .I1(a_0[7]),
    .I2(a_0[8]),
    .I3(a_0[9]),
    .O(\blk00000003/sig000000b5 )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \blk00000003/blk00000030  (
    .I0(b_1[0]),
    .I1(b_1[1]),
    .I2(b_1[2]),
    .I3(b_1[3]),
    .I4(b_1[4]),
    .I5(b_1[5]),
    .O(\blk00000003/sig000000b7 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk0000002f  (
    .I0(b_1[6]),
    .I1(b_1[7]),
    .I2(b_1[8]),
    .I3(b_1[9]),
    .O(\blk00000003/sig000000b9 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000002e  (
    .I0(a_0[14]),
    .I1(b_1[14]),
    .O(\blk00000003/sig000000bc )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000002d  (
    .I0(a_0[13]),
    .I1(b_1[13]),
    .O(\blk00000003/sig000000c0 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000002c  (
    .I0(a_0[12]),
    .I1(b_1[12]),
    .O(\blk00000003/sig000000c3 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000002b  (
    .I0(a_0[11]),
    .I1(b_1[11]),
    .O(\blk00000003/sig000000c6 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000002a  (
    .I0(a_0[10]),
    .I1(b_1[10]),
    .O(\blk00000003/sig000000c8 )
  );
  LUT5 #(
    .INIT ( 32'hFFFFFFFE ))
  \blk00000003/blk00000029  (
    .I0(a_0[12]),
    .I1(a_0[13]),
    .I2(a_0[14]),
    .I3(a_0[10]),
    .I4(a_0[11]),
    .O(\blk00000003/sig000000e8 )
  );
  LUT4 #(
    .INIT ( 16'hFFFD ))
  \blk00000003/blk00000028  (
    .I0(\blk00000003/sig000000e8 ),
    .I1(\blk00000003/sig000000e9 ),
    .I2(\blk00000003/sig000000e6 ),
    .I3(\blk00000003/sig000000e7 ),
    .O(\blk00000003/sig000000ec )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \blk00000003/blk00000027  (
    .I0(b_1[14]),
    .I1(b_1[13]),
    .I2(b_1[12]),
    .I3(b_1[11]),
    .I4(b_1[10]),
    .O(\blk00000003/sig000000e7 )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \blk00000003/blk00000026  (
    .I0(a_0[10]),
    .I1(a_0[14]),
    .I2(a_0[13]),
    .I3(a_0[12]),
    .I4(a_0[11]),
    .O(\blk00000003/sig000000e6 )
  );
  LUT5 #(
    .INIT ( 32'h00000001 ))
  \blk00000003/blk00000025  (
    .I0(b_1[10]),
    .I1(b_1[14]),
    .I2(b_1[13]),
    .I3(b_1[12]),
    .I4(b_1[11]),
    .O(\blk00000003/sig000000e9 )
  );
  LUT6 #(
    .INIT ( 64'h5E13121354111011 ))
  \blk00000003/blk00000024  (
    .I0(\blk00000003/sig000000e6 ),
    .I1(\blk00000003/sig000000e7 ),
    .I2(\blk00000003/sig000000e9 ),
    .I3(\blk00000003/sig000000e8 ),
    .I4(\blk00000003/sig000000ba ),
    .I5(\blk00000003/sig000000b6 ),
    .O(\blk00000003/sig000000eb )
  );
  LUT3 #(
    .INIT ( 8'h80 ))
  \blk00000003/blk00000023  (
    .I0(\blk00000003/sig000000c1 ),
    .I1(\blk00000003/sig000000c4 ),
    .I2(\blk00000003/sig000000c7 ),
    .O(\blk00000003/sig000000ea )
  );
  LUT6 #(
    .INIT ( 64'h1111111101010111 ))
  \blk00000003/blk00000022  (
    .I0(\blk00000003/sig000000e6 ),
    .I1(\blk00000003/sig000000e7 ),
    .I2(\blk00000003/sig000000e8 ),
    .I3(\blk00000003/sig000000bd ),
    .I4(\blk00000003/sig000000be ),
    .I5(\blk00000003/sig000000e9 ),
    .O(\blk00000003/sig000000e3 )
  );
  LUT4 #(
    .INIT ( 16'h5514 ))
  \blk00000003/blk00000021  (
    .I0(\blk00000003/sig000000e3 ),
    .I1(\blk00000003/sig000000c9 ),
    .I2(\blk00000003/sig000000e4 ),
    .I3(\blk00000003/sig000000e5 ),
    .O(result_2[10])
  );
  LUT5 #(
    .INIT ( 32'h55551444 ))
  \blk00000003/blk00000020  (
    .I0(\blk00000003/sig000000e3 ),
    .I1(\blk00000003/sig000000c7 ),
    .I2(\blk00000003/sig000000c9 ),
    .I3(\blk00000003/sig000000e4 ),
    .I4(\blk00000003/sig000000e5 ),
    .O(result_2[11])
  );
  LUT6 #(
    .INIT ( 64'h5555555514444444 ))
  \blk00000003/blk0000001f  (
    .I0(\blk00000003/sig000000e3 ),
    .I1(\blk00000003/sig000000c4 ),
    .I2(\blk00000003/sig000000c9 ),
    .I3(\blk00000003/sig000000c7 ),
    .I4(\blk00000003/sig000000e4 ),
    .I5(\blk00000003/sig000000e5 ),
    .O(result_2[12])
  );
  DSP48A1 #(
    .A0REG ( 0 ),
    .A1REG ( 0 ),
    .B0REG ( 0 ),
    .B1REG ( 0 ),
    .CARRYINREG ( 0 ),
    .CARRYINSEL ( "OPMODE5" ),
    .CREG ( 0 ),
    .DREG ( 0 ),
    .MREG ( 0 ),
    .OPMODEREG ( 0 ),
    .PREG ( 0 ),
    .RSTTYPE ( "SYNC" ),
    .CARRYOUTREG ( 0 ))
  \blk00000003/blk0000001e  (
    .CECARRYIN(\blk00000003/sig00000032 ),
    .RSTC(\blk00000003/sig00000032 ),
    .RSTCARRYIN(\blk00000003/sig00000032 ),
    .CED(\blk00000003/sig00000032 ),
    .RSTD(\blk00000003/sig00000032 ),
    .CEOPMODE(\blk00000003/sig00000032 ),
    .CEC(\blk00000003/sig00000032 ),
    .CARRYOUTF(\NLW_blk00000003/blk0000001e_CARRYOUTF_UNCONNECTED ),
    .RSTOPMODE(\blk00000003/sig00000032 ),
    .RSTM(\blk00000003/sig00000032 ),
    .CLK(\blk00000003/sig00000021 ),
    .RSTB(\blk00000003/sig00000032 ),
    .CEM(\blk00000003/sig00000032 ),
    .CEB(\blk00000003/sig00000032 ),
    .CARRYIN(\blk00000003/sig00000032 ),
    .CEP(\blk00000003/sig00000032 ),
    .CEA(\blk00000003/sig00000032 ),
    .CARRYOUT(\NLW_blk00000003/blk0000001e_CARRYOUT_UNCONNECTED ),
    .RSTA(\blk00000003/sig00000032 ),
    .RSTP(\blk00000003/sig00000032 ),
    .B({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000035 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 }),
    .BCOUT({\NLW_blk00000003/blk0000001e_BCOUT<17>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<16>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_BCOUT<15>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<14>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_BCOUT<13>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<12>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_BCOUT<11>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<10>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_BCOUT<9>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<8>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_BCOUT<7>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<6>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_BCOUT<5>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<4>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_BCOUT<3>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<2>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_BCOUT<1>_UNCONNECTED , \NLW_blk00000003/blk0000001e_BCOUT<0>_UNCONNECTED }),
    .PCIN({\blk00000003/sig0000006c , \blk00000003/sig0000006d , \blk00000003/sig0000006e , \blk00000003/sig0000006f , \blk00000003/sig00000070 , 
\blk00000003/sig00000071 , \blk00000003/sig00000072 , \blk00000003/sig00000073 , \blk00000003/sig00000074 , \blk00000003/sig00000075 , 
\blk00000003/sig00000076 , \blk00000003/sig00000077 , \blk00000003/sig00000078 , \blk00000003/sig00000079 , \blk00000003/sig0000007a , 
\blk00000003/sig0000007b , \blk00000003/sig0000007c , \blk00000003/sig0000007d , \blk00000003/sig0000007e , \blk00000003/sig0000007f , 
\blk00000003/sig00000080 , \blk00000003/sig00000081 , \blk00000003/sig00000082 , \blk00000003/sig00000083 , \blk00000003/sig00000084 , 
\blk00000003/sig00000085 , \blk00000003/sig00000086 , \blk00000003/sig00000087 , \blk00000003/sig00000088 , \blk00000003/sig00000089 , 
\blk00000003/sig0000008a , \blk00000003/sig0000008b , \blk00000003/sig0000008c , \blk00000003/sig0000008d , \blk00000003/sig0000008e , 
\blk00000003/sig0000008f , \blk00000003/sig00000090 , \blk00000003/sig00000091 , \blk00000003/sig00000092 , \blk00000003/sig00000093 , 
\blk00000003/sig00000094 , \blk00000003/sig00000095 , \blk00000003/sig00000096 , \blk00000003/sig00000097 , \blk00000003/sig00000098 , 
\blk00000003/sig00000099 , \blk00000003/sig0000009a , \blk00000003/sig0000009b }),
    .C({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 }),
    .P({\NLW_blk00000003/blk0000001e_P<47>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<46>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<45>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<44>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<43>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<42>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<41>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<40>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<39>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<38>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<37>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<36>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<35>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<34>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<33>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<32>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<31>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<30>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<29>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<28>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<27>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<26>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<25>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<24>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<23>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<22>_UNCONNECTED , 
\blk00000003/sig000000d8 , \blk00000003/sig000000d9 , \blk00000003/sig000000da , \blk00000003/sig000000db , \blk00000003/sig000000dc , 
\blk00000003/sig000000dd , \blk00000003/sig000000de , \blk00000003/sig000000df , \blk00000003/sig000000e0 , \blk00000003/sig000000e1 , 
\blk00000003/sig000000e2 , \NLW_blk00000003/blk0000001e_P<10>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<9>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<8>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<7>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<6>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<5>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<4>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<3>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_P<2>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<1>_UNCONNECTED , \NLW_blk00000003/blk0000001e_P<0>_UNCONNECTED }),
    .OPMODE({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000035 , \blk00000003/sig00000035 , \blk00000003/sig00000035 }),
    .D({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 }),
    .PCOUT({\NLW_blk00000003/blk0000001e_PCOUT<47>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<46>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<45>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<44>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<43>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<42>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<41>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<40>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<39>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<38>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<37>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<36>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<35>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<34>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<33>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<32>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<31>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<30>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<29>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<28>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<27>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<26>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<25>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<24>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<23>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<22>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<21>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<20>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<19>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<18>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<17>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<16>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<15>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<14>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<13>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<12>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<11>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<10>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<9>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<8>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<7>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<6>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<5>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<4>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<3>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<2>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_PCOUT<1>_UNCONNECTED , \NLW_blk00000003/blk0000001e_PCOUT<0>_UNCONNECTED }),
    .A({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 }),
    .M({\NLW_blk00000003/blk0000001e_M<35>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<34>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<33>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<32>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<31>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<30>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<29>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<28>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<27>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<26>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<25>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<24>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<23>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<22>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<21>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<20>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<19>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<18>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<17>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<16>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<15>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<14>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<13>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<12>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<11>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<10>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<9>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<8>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<7>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<6>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<5>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<4>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<3>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<2>_UNCONNECTED , \NLW_blk00000003/blk0000001e_M<1>_UNCONNECTED , 
\NLW_blk00000003/blk0000001e_M<0>_UNCONNECTED })
  );
  MUXCY   \blk00000003/blk00000019  (
    .CI(\blk00000003/sig00000035 ),
    .DI(b_1[10]),
    .S(\blk00000003/sig000000c8 ),
    .O(\blk00000003/sig000000c5 )
  );
  XORCY   \blk00000003/blk00000018  (
    .CI(\blk00000003/sig00000035 ),
    .LI(\blk00000003/sig000000c8 ),
    .O(\blk00000003/sig000000c9 )
  );
  MUXCY   \blk00000003/blk00000017  (
    .CI(\blk00000003/sig000000c5 ),
    .DI(b_1[11]),
    .S(\blk00000003/sig000000c6 ),
    .O(\blk00000003/sig000000c2 )
  );
  XORCY   \blk00000003/blk00000016  (
    .CI(\blk00000003/sig000000c5 ),
    .LI(\blk00000003/sig000000c6 ),
    .O(\blk00000003/sig000000c7 )
  );
  MUXCY   \blk00000003/blk00000015  (
    .CI(\blk00000003/sig000000c2 ),
    .DI(b_1[12]),
    .S(\blk00000003/sig000000c3 ),
    .O(\blk00000003/sig000000bf )
  );
  XORCY   \blk00000003/blk00000014  (
    .CI(\blk00000003/sig000000c2 ),
    .LI(\blk00000003/sig000000c3 ),
    .O(\blk00000003/sig000000c4 )
  );
  MUXCY   \blk00000003/blk00000013  (
    .CI(\blk00000003/sig000000bf ),
    .DI(b_1[13]),
    .S(\blk00000003/sig000000c0 ),
    .O(\blk00000003/sig000000bb )
  );
  XORCY   \blk00000003/blk00000012  (
    .CI(\blk00000003/sig000000bf ),
    .LI(\blk00000003/sig000000c0 ),
    .O(\blk00000003/sig000000c1 )
  );
  MUXCY   \blk00000003/blk00000011  (
    .CI(\blk00000003/sig000000bb ),
    .DI(b_1[14]),
    .S(\blk00000003/sig000000bc ),
    .O(\blk00000003/sig000000be )
  );
  XORCY   \blk00000003/blk00000010  (
    .CI(\blk00000003/sig000000bb ),
    .LI(\blk00000003/sig000000bc ),
    .O(\blk00000003/sig000000bd )
  );
  MUXCY   \blk00000003/blk0000000f  (
    .CI(\blk00000003/sig000000b8 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b9 ),
    .O(\blk00000003/sig000000ba )
  );
  MUXCY   \blk00000003/blk0000000e  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b7 ),
    .O(\blk00000003/sig000000b8 )
  );
  MUXCY   \blk00000003/blk0000000d  (
    .CI(\blk00000003/sig000000b4 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b5 ),
    .O(\blk00000003/sig000000b6 )
  );
  MUXCY   \blk00000003/blk0000000c  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b3 ),
    .O(\blk00000003/sig000000b4 )
  );
  XORCY   \blk00000003/blk0000000b  (
    .CI(\blk00000003/sig000000b1 ),
    .LI(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig000000b2 )
  );
  MUXCY   \blk00000003/blk0000000a  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000af ),
    .O(\blk00000003/sig000000b0 )
  );
  MUXCY   \blk00000003/blk00000009  (
    .CI(\blk00000003/sig000000b0 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000ae ),
    .O(\blk00000003/sig000000b1 )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \blk00000003/blk00000008  (
    .I0(\blk00000003/sig0000006b ),
    .I1(\blk00000003/sig0000006a ),
    .I2(\blk00000003/sig00000069 ),
    .I3(\blk00000003/sig00000068 ),
    .I4(\blk00000003/sig00000067 ),
    .I5(\blk00000003/sig00000066 ),
    .O(\blk00000003/sig000000af )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \blk00000003/blk00000007  (
    .I0(\blk00000003/sig00000065 ),
    .I1(\blk00000003/sig00000064 ),
    .I2(\blk00000003/sig00000063 ),
    .I3(\blk00000003/sig00000032 ),
    .I4(\blk00000003/sig00000032 ),
    .I5(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig000000ae )
  );
  DSP48A1 #(
    .A0REG ( 0 ),
    .A1REG ( 0 ),
    .B0REG ( 0 ),
    .B1REG ( 0 ),
    .CARRYINREG ( 0 ),
    .CARRYINSEL ( "OPMODE5" ),
    .CREG ( 0 ),
    .DREG ( 0 ),
    .MREG ( 0 ),
    .OPMODEREG ( 0 ),
    .PREG ( 0 ),
    .RSTTYPE ( "SYNC" ),
    .CARRYOUTREG ( 0 ))
  \blk00000003/blk00000006  (
    .CECARRYIN(\blk00000003/sig00000032 ),
    .RSTC(\blk00000003/sig00000032 ),
    .RSTCARRYIN(\blk00000003/sig00000032 ),
    .CED(\blk00000003/sig00000032 ),
    .RSTD(\blk00000003/sig00000032 ),
    .CEOPMODE(\blk00000003/sig00000032 ),
    .CEC(\blk00000003/sig00000032 ),
    .CARRYOUTF(\NLW_blk00000003/blk00000006_CARRYOUTF_UNCONNECTED ),
    .RSTOPMODE(\blk00000003/sig00000032 ),
    .RSTM(\blk00000003/sig00000032 ),
    .CLK(\blk00000003/sig00000021 ),
    .RSTB(\blk00000003/sig00000032 ),
    .CEM(\blk00000003/sig00000032 ),
    .CEB(\blk00000003/sig00000032 ),
    .CARRYIN(\blk00000003/sig00000032 ),
    .CEP(\blk00000003/sig00000032 ),
    .CEA(\blk00000003/sig00000032 ),
    .CARRYOUT(\NLW_blk00000003/blk00000006_CARRYOUT_UNCONNECTED ),
    .RSTA(\blk00000003/sig00000032 ),
    .RSTP(\blk00000003/sig00000032 ),
    .B({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000035 , b_1[9], b_1[8], b_1[7], b_1[6], b_1[5], b_1[4], b_1[3], b_1[2], 
b_1[1], b_1[0]}),
    .BCOUT({\NLW_blk00000003/blk00000006_BCOUT<17>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<16>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<15>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<14>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<13>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<12>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<11>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<10>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<9>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<8>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<7>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<6>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<5>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<4>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<3>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<2>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<1>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<0>_UNCONNECTED }),
    .PCIN({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 }),
    .C({\NLW_blk00000003/blk00000006_C<47>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<46>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<45>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<44>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<43>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<42>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<41>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<40>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<39>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<38>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<37>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<36>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<35>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<34>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<33>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<32>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<31>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<30>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<29>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<28>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<27>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<26>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<25>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<24>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<23>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<22>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<21>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<20>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<19>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<18>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<17>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<16>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<15>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<14>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<13>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<12>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<11>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<10>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<9>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<8>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<7>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<6>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<5>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<4>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<3>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<2>_UNCONNECTED , \NLW_blk00000003/blk00000006_C<1>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_C<0>_UNCONNECTED }),
    .P({\NLW_blk00000003/blk00000006_P<47>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<46>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<45>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<44>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<43>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<42>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<41>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<40>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<39>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<38>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<37>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<36>_UNCONNECTED , \blk00000003/sig00000048 , \blk00000003/sig00000049 , \blk00000003/sig0000004a , 
\blk00000003/sig0000004b , \blk00000003/sig0000004c , \blk00000003/sig0000004d , \blk00000003/sig0000004e , \blk00000003/sig0000004f , 
\blk00000003/sig00000050 , \blk00000003/sig00000051 , \blk00000003/sig00000052 , \blk00000003/sig00000053 , \blk00000003/sig00000054 , 
\blk00000003/sig00000055 , \blk00000003/sig00000056 , \blk00000003/sig00000057 , \blk00000003/sig00000058 , \blk00000003/sig00000059 , 
\blk00000003/sig0000005a , \blk00000003/sig0000005b , \blk00000003/sig0000005c , \blk00000003/sig0000005d , \blk00000003/sig0000005e , 
\blk00000003/sig0000005f , \blk00000003/sig00000060 , \blk00000003/sig00000061 , \blk00000003/sig00000062 , \blk00000003/sig00000063 , 
\blk00000003/sig00000064 , \blk00000003/sig00000065 , \blk00000003/sig00000066 , \blk00000003/sig00000067 , \blk00000003/sig00000068 , 
\blk00000003/sig00000069 , \blk00000003/sig0000006a , \blk00000003/sig0000006b }),
    .OPMODE({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000035 }),
    .D({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 }),
    .PCOUT({\blk00000003/sig0000006c , \blk00000003/sig0000006d , \blk00000003/sig0000006e , \blk00000003/sig0000006f , \blk00000003/sig00000070 , 
\blk00000003/sig00000071 , \blk00000003/sig00000072 , \blk00000003/sig00000073 , \blk00000003/sig00000074 , \blk00000003/sig00000075 , 
\blk00000003/sig00000076 , \blk00000003/sig00000077 , \blk00000003/sig00000078 , \blk00000003/sig00000079 , \blk00000003/sig0000007a , 
\blk00000003/sig0000007b , \blk00000003/sig0000007c , \blk00000003/sig0000007d , \blk00000003/sig0000007e , \blk00000003/sig0000007f , 
\blk00000003/sig00000080 , \blk00000003/sig00000081 , \blk00000003/sig00000082 , \blk00000003/sig00000083 , \blk00000003/sig00000084 , 
\blk00000003/sig00000085 , \blk00000003/sig00000086 , \blk00000003/sig00000087 , \blk00000003/sig00000088 , \blk00000003/sig00000089 , 
\blk00000003/sig0000008a , \blk00000003/sig0000008b , \blk00000003/sig0000008c , \blk00000003/sig0000008d , \blk00000003/sig0000008e , 
\blk00000003/sig0000008f , \blk00000003/sig00000090 , \blk00000003/sig00000091 , \blk00000003/sig00000092 , \blk00000003/sig00000093 , 
\blk00000003/sig00000094 , \blk00000003/sig00000095 , \blk00000003/sig00000096 , \blk00000003/sig00000097 , \blk00000003/sig00000098 , 
\blk00000003/sig00000099 , \blk00000003/sig0000009a , \blk00000003/sig0000009b }),
    .A({\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000032 , 
\blk00000003/sig00000032 , \blk00000003/sig00000032 , \blk00000003/sig00000035 , a_0[9], a_0[8], a_0[7], a_0[6], a_0[5], a_0[4], a_0[3], a_0[2], 
a_0[1], a_0[0]}),
    .M({\NLW_blk00000003/blk00000006_M<35>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<34>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<33>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<32>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<31>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<30>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<29>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<28>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<27>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<26>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<25>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<24>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<23>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<22>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<21>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<20>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<19>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<18>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<17>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<16>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<15>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<14>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<13>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<12>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<11>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<10>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<9>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<8>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<7>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<6>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<5>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<4>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<3>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<2>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<1>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<0>_UNCONNECTED })
  );
  VCC   \blk00000003/blk00000005  (
    .P(\blk00000003/sig00000035 )
  );
  GND   \blk00000003/blk00000004  (
    .G(\blk00000003/sig00000032 )
  );

// synthesis translate_on

endmodule

// synthesis translate_off

`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

// synthesis translate_on
