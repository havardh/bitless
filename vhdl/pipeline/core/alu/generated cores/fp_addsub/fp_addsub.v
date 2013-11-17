////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: M.81d
//  \   \         Application: netgen
//  /   /         Filename: fp_addsub.v
// /___/   /\     Timestamp: Thu Nov 14 10:27:38 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog ./tmp/_cg\fp_addsub.ngc ./tmp/_cg\fp_addsub.v 
// Device	: 6slx45csg324-2
// Input file	: ./tmp/_cg/fp_addsub.ngc
// Output file	: ./tmp/_cg/fp_addsub.v
// # of Modules	: 1
// Design Name	: fp_addsub
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

module fp_addsub (
  overflow, underflow, operation, a, b, result
)/* synthesis syn_black_box syn_noprune=1 */;
  output overflow;
  output underflow;
  input [5 : 0] operation;
  input [15 : 0] a;
  input [15 : 0] b;
  output [15 : 0] result;
  
  // synthesis translate_off
  
  wire \blk00000003/sig0000013d ;
  wire \blk00000003/sig0000013c ;
  wire \blk00000003/sig0000013b ;
  wire \blk00000003/sig0000013a ;
  wire \blk00000003/sig00000139 ;
  wire \blk00000003/sig00000138 ;
  wire \blk00000003/sig00000137 ;
  wire \blk00000003/sig00000136 ;
  wire \blk00000003/sig00000135 ;
  wire \blk00000003/sig00000134 ;
  wire \blk00000003/sig00000133 ;
  wire \blk00000003/sig00000132 ;
  wire \blk00000003/sig00000131 ;
  wire \blk00000003/sig00000130 ;
  wire \blk00000003/sig0000012f ;
  wire \blk00000003/sig0000012e ;
  wire \blk00000003/sig0000012d ;
  wire \blk00000003/sig0000012c ;
  wire \blk00000003/sig0000012b ;
  wire \blk00000003/sig0000012a ;
  wire \blk00000003/sig00000129 ;
  wire \blk00000003/sig00000128 ;
  wire \blk00000003/sig00000127 ;
  wire \blk00000003/sig00000126 ;
  wire \blk00000003/sig00000125 ;
  wire \blk00000003/sig00000124 ;
  wire \blk00000003/sig00000123 ;
  wire \blk00000003/sig00000122 ;
  wire \blk00000003/sig00000121 ;
  wire \blk00000003/sig00000120 ;
  wire \blk00000003/sig0000011f ;
  wire \blk00000003/sig0000011e ;
  wire \blk00000003/sig0000011d ;
  wire \blk00000003/sig0000011c ;
  wire \blk00000003/sig0000011b ;
  wire \blk00000003/sig0000011a ;
  wire \blk00000003/sig00000119 ;
  wire \blk00000003/sig00000118 ;
  wire \blk00000003/sig00000117 ;
  wire \blk00000003/sig00000116 ;
  wire \blk00000003/sig00000115 ;
  wire \blk00000003/sig00000114 ;
  wire \blk00000003/sig00000113 ;
  wire \blk00000003/sig00000112 ;
  wire \blk00000003/sig00000111 ;
  wire \blk00000003/sig00000110 ;
  wire \blk00000003/sig0000010f ;
  wire \blk00000003/sig0000010e ;
  wire \blk00000003/sig0000010d ;
  wire \blk00000003/sig0000010c ;
  wire \blk00000003/sig0000010b ;
  wire \blk00000003/sig0000010a ;
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
  wire \blk00000003/sig000000d7 ;
  wire \blk00000003/sig000000d6 ;
  wire \blk00000003/sig000000d5 ;
  wire \blk00000003/sig000000d4 ;
  wire \blk00000003/sig000000d3 ;
  wire \blk00000003/sig000000d2 ;
  wire \blk00000003/sig000000d1 ;
  wire \blk00000003/sig000000d0 ;
  wire \blk00000003/sig000000cf ;
  wire \blk00000003/sig000000ce ;
  wire \blk00000003/sig000000cd ;
  wire \blk00000003/sig000000cc ;
  wire \blk00000003/sig000000cb ;
  wire \blk00000003/sig000000ca ;
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
  wire \blk00000003/sig000000ad ;
  wire \blk00000003/sig000000ac ;
  wire \blk00000003/sig000000ab ;
  wire \blk00000003/sig000000aa ;
  wire \blk00000003/sig000000a9 ;
  wire \blk00000003/sig000000a8 ;
  wire \blk00000003/sig000000a7 ;
  wire \blk00000003/sig000000a6 ;
  wire \blk00000003/sig000000a5 ;
  wire \blk00000003/sig000000a4 ;
  wire \blk00000003/sig000000a3 ;
  wire \blk00000003/sig000000a2 ;
  wire \blk00000003/sig000000a1 ;
  wire \blk00000003/sig000000a0 ;
  wire \blk00000003/sig0000009f ;
  wire \blk00000003/sig0000009e ;
  wire \blk00000003/sig0000009d ;
  wire \blk00000003/sig0000009c ;
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
  wire \blk00000003/sig00000047 ;
  wire \blk00000003/sig00000046 ;
  wire \blk00000003/sig00000045 ;
  wire \blk00000003/sig00000044 ;
  wire \blk00000003/sig00000043 ;
  wire \blk00000003/sig00000042 ;
  wire \blk00000003/sig00000041 ;
  wire \blk00000003/sig00000040 ;
  wire \blk00000003/sig0000003f ;
  wire \blk00000003/sig0000003e ;
  wire \blk00000003/sig0000003d ;
  wire \blk00000003/sig0000003c ;
  wire \blk00000003/sig0000003b ;
  wire \blk00000003/sig0000003a ;
  wire \blk00000003/sig00000039 ;
  wire \blk00000003/sig00000038 ;
  wire \blk00000003/sig00000037 ;
  wire \blk00000003/sig00000036 ;
  wire \blk00000003/sig00000035 ;
  wire \blk00000003/sig00000032 ;
  wire NLW_blk00000001_P_UNCONNECTED;
  wire NLW_blk00000002_G_UNCONNECTED;
  wire \NLW_blk00000003/blk00000068_O_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000066_O_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000064_O_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000062_O_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000061_O_UNCONNECTED ;
  wire \NLW_blk00000003/blk0000003e_O_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000020_O_UNCONNECTED ;
  wire [15 : 0] a_0;
  wire [15 : 0] b_1;
  wire [5 : 0] operation_2;
  wire [15 : 0] result_3;
  assign
    operation_2[5] = operation[5],
    operation_2[4] = operation[4],
    operation_2[3] = operation[3],
    operation_2[2] = operation[2],
    operation_2[1] = operation[1],
    operation_2[0] = operation[0],
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
    result[15] = result_3[15],
    result[14] = result_3[14],
    result[13] = result_3[13],
    result[12] = result_3[12],
    result[11] = result_3[11],
    result[10] = result_3[10],
    result[9] = result_3[9],
    result[8] = result_3[8],
    result[7] = result_3[7],
    result[6] = result_3[6],
    result[5] = result_3[5],
    result[4] = result_3[4],
    result[3] = result_3[3],
    result[2] = result_3[2],
    result[1] = result_3[1],
    result[0] = result_3[0];
  VCC   blk00000001 (
    .P(NLW_blk00000001_P_UNCONNECTED)
  );
  GND   blk00000002 (
    .G(NLW_blk00000002_G_UNCONNECTED)
  );
  MUXF7   \blk00000003/blk00000126  (
    .I0(\blk00000003/sig0000013d ),
    .I1(\blk00000003/sig0000013c ),
    .S(\blk00000003/sig000000a7 ),
    .O(\blk00000003/sig000000ec )
  );
  LUT6 #(
    .INIT ( 64'h0000000041000000 ))
  \blk00000003/blk00000125  (
    .I0(\blk00000003/sig0000005d ),
    .I1(\blk00000003/sig000000aa ),
    .I2(\blk00000003/sig00000065 ),
    .I3(\blk00000003/sig0000013a ),
    .I4(\blk00000003/sig000000fe ),
    .I5(\blk00000003/sig0000005a ),
    .O(\blk00000003/sig0000013d )
  );
  LUT6 #(
    .INIT ( 64'h0000000082000000 ))
  \blk00000003/blk00000124  (
    .I0(\blk00000003/sig000000fe ),
    .I1(\blk00000003/sig00000065 ),
    .I2(\blk00000003/sig000000aa ),
    .I3(\blk00000003/sig0000013a ),
    .I4(\blk00000003/sig0000005d ),
    .I5(\blk00000003/sig0000005a ),
    .O(\blk00000003/sig0000013c )
  );
  LUT6 #(
    .INIT ( 64'h0000000090090000 ))
  \blk00000003/blk00000123  (
    .I0(a_0[10]),
    .I1(b_1[10]),
    .I2(a_0[11]),
    .I3(b_1[11]),
    .I4(\blk00000003/sig00000101 ),
    .I5(\blk00000003/sig000000f8 ),
    .O(\blk00000003/sig00000125 )
  );
  LUT6 #(
    .INIT ( 64'h5965996969665965 ))
  \blk00000003/blk00000122  (
    .I0(\blk00000003/sig00000101 ),
    .I1(\blk00000003/sig000000f8 ),
    .I2(b_1[11]),
    .I3(a_0[11]),
    .I4(b_1[10]),
    .I5(a_0[10]),
    .O(\blk00000003/sig0000012a )
  );
  LUT5 #(
    .INIT ( 32'h66699666 ))
  \blk00000003/blk00000121  (
    .I0(b_1[11]),
    .I1(a_0[11]),
    .I2(a_0[10]),
    .I3(\blk00000003/sig000000f8 ),
    .I4(b_1[10]),
    .O(\blk00000003/sig00000106 )
  );
  LUT4 #(
    .INIT ( 16'h9FF9 ))
  \blk00000003/blk00000120  (
    .I0(b_1[11]),
    .I1(a_0[11]),
    .I2(b_1[10]),
    .I3(a_0[10]),
    .O(\blk00000003/sig0000012d )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFF08808888 ))
  \blk00000003/blk0000011f  (
    .I0(\blk00000003/sig0000012a ),
    .I1(\blk00000003/sig00000126 ),
    .I2(b_1[10]),
    .I3(a_0[10]),
    .I4(\blk00000003/sig00000102 ),
    .I5(\blk00000003/sig00000128 ),
    .O(\blk00000003/sig00000107 )
  );
  LUT6 #(
    .INIT ( 64'h9AA9AAAAAAAAAAAA ))
  \blk00000003/blk0000011e  (
    .I0(\blk00000003/sig00000126 ),
    .I1(\blk00000003/sig000000f8 ),
    .I2(b_1[10]),
    .I3(a_0[10]),
    .I4(\blk00000003/sig0000013b ),
    .I5(\blk00000003/sig00000102 ),
    .O(\blk00000003/sig00000129 )
  );
  LUT5 #(
    .INIT ( 32'hB2BB22B2 ))
  \blk00000003/blk0000011d  (
    .I0(b_1[14]),
    .I1(a_0[14]),
    .I2(b_1[13]),
    .I3(a_0[13]),
    .I4(\blk00000003/sig00000138 ),
    .O(\blk00000003/sig000000f8 )
  );
  LUT4 #(
    .INIT ( 16'hEFA2 ))
  \blk00000003/blk0000011c  (
    .I0(a_0[13]),
    .I1(b_1[14]),
    .I2(a_0[14]),
    .I3(b_1[13]),
    .O(\blk00000003/sig0000005c )
  );
  LUT4 #(
    .INIT ( 16'hEB7D ))
  \blk00000003/blk0000011b  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig000000ad ),
    .I3(\blk00000003/sig00000065 ),
    .O(\blk00000003/sig00000133 )
  );
  LUT4 #(
    .INIT ( 16'h6966 ))
  \blk00000003/blk0000011a  (
    .I0(\blk00000003/sig00000063 ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig00000065 ),
    .I3(\blk00000003/sig000000aa ),
    .O(\blk00000003/sig00000122 )
  );
  LUT6 #(
    .INIT ( 64'hB2BB22B2B2BBB2BB ))
  \blk00000003/blk00000119  (
    .I0(b_1[12]),
    .I1(a_0[12]),
    .I2(b_1[11]),
    .I3(a_0[11]),
    .I4(b_1[10]),
    .I5(a_0[10]),
    .O(\blk00000003/sig00000138 )
  );
  LUT6 #(
    .INIT ( 64'hB2BB22B2B2BBB2BB ))
  \blk00000003/blk00000118  (
    .I0(\blk00000003/sig00000060 ),
    .I1(\blk00000003/sig00000114 ),
    .I2(\blk00000003/sig00000063 ),
    .I3(\blk00000003/sig000000ad ),
    .I4(\blk00000003/sig00000065 ),
    .I5(\blk00000003/sig000000aa ),
    .O(\blk00000003/sig00000137 )
  );
  LUT5 #(
    .INIT ( 32'h422DB442 ))
  \blk00000003/blk00000117  (
    .I0(b_1[14]),
    .I1(a_0[14]),
    .I2(\blk00000003/sig00000138 ),
    .I3(b_1[13]),
    .I4(a_0[13]),
    .O(\blk00000003/sig00000126 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFFFFFF45 ))
  \blk00000003/blk00000116  (
    .I0(\blk00000003/sig00000086 ),
    .I1(\blk00000003/sig000000aa ),
    .I2(\blk00000003/sig00000084 ),
    .I3(\blk00000003/sig000000af ),
    .I4(\blk00000003/sig000000a7 ),
    .I5(\blk00000003/sig000000ad ),
    .O(\blk00000003/sig000000c9 )
  );
  LUT4 #(
    .INIT ( 16'h0777 ))
  \blk00000003/blk00000115  (
    .I0(\blk00000003/sig000000fd ),
    .I1(\blk00000003/sig00000089 ),
    .I2(\blk00000003/sig000000b4 ),
    .I3(\blk00000003/sig000000a7 ),
    .O(\blk00000003/sig00000134 )
  );
  LUT5 #(
    .INIT ( 32'h09000009 ))
  \blk00000003/blk00000114  (
    .I0(b_1[10]),
    .I1(a_0[10]),
    .I2(\blk00000003/sig0000012a ),
    .I3(\blk00000003/sig00000126 ),
    .I4(\blk00000003/sig00000125 ),
    .O(\blk00000003/sig00000111 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFFFFFFEF ))
  \blk00000003/blk00000113  (
    .I0(b_1[12]),
    .I1(b_1[13]),
    .I2(\blk00000003/sig000000fb ),
    .I3(b_1[11]),
    .I4(b_1[10]),
    .I5(b_1[14]),
    .O(\blk00000003/sig0000008d )
  );
  LUT6 #(
    .INIT ( 64'h9990090009009990 ))
  \blk00000003/blk00000112  (
    .I0(\blk00000003/sig00000126 ),
    .I1(\blk00000003/sig00000125 ),
    .I2(\blk00000003/sig0000012a ),
    .I3(\blk00000003/sig000000eb ),
    .I4(a_0[10]),
    .I5(b_1[10]),
    .O(\blk00000003/sig0000010d )
  );
  LUT4 #(
    .INIT ( 16'h9A95 ))
  \blk00000003/blk00000111  (
    .I0(\blk00000003/sig00000060 ),
    .I1(\blk00000003/sig000000b2 ),
    .I2(\blk00000003/sig000000a7 ),
    .I3(\blk00000003/sig000000af ),
    .O(\blk00000003/sig0000013a )
  );
  LUT5 #(
    .INIT ( 32'hBFBFBFAA ))
  \blk00000003/blk00000110  (
    .I0(\blk00000003/sig000000f1 ),
    .I1(\blk00000003/sig000000fc ),
    .I2(\blk00000003/sig000000fb ),
    .I3(\blk00000003/sig000000fa ),
    .I4(\blk00000003/sig000000f5 ),
    .O(\blk00000003/sig00000135 )
  );
  LUT6 #(
    .INIT ( 64'h0000000100000000 ))
  \blk00000003/blk0000010f  (
    .I0(b_1[14]),
    .I1(b_1[13]),
    .I2(b_1[12]),
    .I3(b_1[11]),
    .I4(b_1[10]),
    .I5(\blk00000003/sig000000fb ),
    .O(\blk00000003/sig000000f6 )
  );
  LUT6 #(
    .INIT ( 64'h6966996969666966 ))
  \blk00000003/blk0000010e  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(\blk00000003/sig00000101 ),
    .I2(b_1[11]),
    .I3(a_0[11]),
    .I4(b_1[10]),
    .I5(a_0[10]),
    .O(\blk00000003/sig0000013b )
  );
  LUT5 #(
    .INIT ( 32'h6A665655 ))
  \blk00000003/blk0000010d  (
    .I0(\blk00000003/sig0000013a ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000065 ),
    .I3(\blk00000003/sig000000aa ),
    .I4(\blk00000003/sig000000ad ),
    .O(\blk00000003/sig00000123 )
  );
  LUT6 #(
    .INIT ( 64'h5555555514114414 ))
  \blk00000003/blk0000010c  (
    .I0(\blk00000003/sig00000121 ),
    .I1(\blk00000003/sig00000136 ),
    .I2(\blk00000003/sig00000137 ),
    .I3(\blk00000003/sig000000a7 ),
    .I4(\blk00000003/sig0000005d ),
    .I5(\blk00000003/sig000000f7 ),
    .O(result_3[14])
  );
  LUT6 #(
    .INIT ( 64'h4554454545455445 ))
  \blk00000003/blk0000010b  (
    .I0(\blk00000003/sig00000121 ),
    .I1(\blk00000003/sig000000f7 ),
    .I2(\blk00000003/sig000000fe ),
    .I3(\blk00000003/sig00000065 ),
    .I4(\blk00000003/sig000000aa ),
    .I5(\blk00000003/sig000000c6 ),
    .O(result_3[11])
  );
  LUT2 #(
    .INIT ( 4'hE ))
  \blk00000003/blk0000010a  (
    .I0(b_1[14]),
    .I1(a_0[14]),
    .O(\blk00000003/sig00000059 )
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \blk00000003/blk00000109  (
    .I0(a_0[15]),
    .I1(b_1[15]),
    .I2(operation_2[0]),
    .O(\blk00000003/sig00000088 )
  );
  LUT4 #(
    .INIT ( 16'hA2AA ))
  \blk00000003/blk00000108  (
    .I0(\blk00000003/sig00000139 ),
    .I1(\blk00000003/sig000000a7 ),
    .I2(\blk00000003/sig00000135 ),
    .I3(\blk00000003/sig000000b4 ),
    .O(result_3[15])
  );
  LUT6 #(
    .INIT ( 64'h8F0707078F000000 ))
  \blk00000003/blk00000107  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig000000f3 ),
    .I3(\blk00000003/sig000000f9 ),
    .I4(a_0[15]),
    .I5(\blk00000003/sig00000124 ),
    .O(\blk00000003/sig00000139 )
  );
  LUT6 #(
    .INIT ( 64'h0100000001010101 ))
  \blk00000003/blk00000106  (
    .I0(\blk00000003/sig000000f1 ),
    .I1(\blk00000003/sig000000f0 ),
    .I2(\blk00000003/sig000000ef ),
    .I3(\blk00000003/sig000000c6 ),
    .I4(\blk00000003/sig000000ec ),
    .I5(\blk00000003/sig000000ee ),
    .O(underflow)
  );
  LUT5 #(
    .INIT ( 32'h45545445 ))
  \blk00000003/blk00000105  (
    .I0(\blk00000003/sig00000121 ),
    .I1(\blk00000003/sig000000f7 ),
    .I2(\blk00000003/sig00000065 ),
    .I3(\blk00000003/sig000000aa ),
    .I4(\blk00000003/sig000000c6 ),
    .O(result_3[10])
  );
  LUT6 #(
    .INIT ( 64'hC03FC03F956AC03F ))
  \blk00000003/blk00000104  (
    .I0(\blk00000003/sig00000106 ),
    .I1(\blk00000003/sig000000fc ),
    .I2(\blk00000003/sig000000fb ),
    .I3(\blk00000003/sig00000070 ),
    .I4(\blk00000003/sig00000111 ),
    .I5(\blk00000003/sig00000107 ),
    .O(\blk00000003/sig0000008b )
  );
  LUT6 #(
    .INIT ( 64'h8000000000000000 ))
  \blk00000003/blk00000103  (
    .I0(a_0[14]),
    .I1(a_0[13]),
    .I2(a_0[12]),
    .I3(a_0[11]),
    .I4(a_0[10]),
    .I5(\blk00000003/sig00000039 ),
    .O(\blk00000003/sig000000f4 )
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \blk00000003/blk00000102  (
    .I0(a_0[15]),
    .I1(b_1[15]),
    .I2(operation_2[0]),
    .O(\blk00000003/sig00000070 )
  );
  LUT4 #(
    .INIT ( 16'h4004 ))
  \blk00000003/blk00000101  (
    .I0(\blk00000003/sig0000012a ),
    .I1(\blk00000003/sig000000e6 ),
    .I2(\blk00000003/sig00000125 ),
    .I3(\blk00000003/sig00000126 ),
    .O(\blk00000003/sig00000110 )
  );
  LUT4 #(
    .INIT ( 16'h4004 ))
  \blk00000003/blk00000100  (
    .I0(\blk00000003/sig0000012a ),
    .I1(\blk00000003/sig00000103 ),
    .I2(\blk00000003/sig00000125 ),
    .I3(\blk00000003/sig00000126 ),
    .O(\blk00000003/sig00000105 )
  );
  LUT4 #(
    .INIT ( 16'h4004 ))
  \blk00000003/blk000000ff  (
    .I0(\blk00000003/sig0000012a ),
    .I1(\blk00000003/sig000000e5 ),
    .I2(\blk00000003/sig00000125 ),
    .I3(\blk00000003/sig00000126 ),
    .O(\blk00000003/sig0000010f )
  );
  LUT3 #(
    .INIT ( 8'h69 ))
  \blk00000003/blk000000fe  (
    .I0(\blk00000003/sig0000005d ),
    .I1(\blk00000003/sig000000a7 ),
    .I2(\blk00000003/sig00000137 ),
    .O(\blk00000003/sig00000132 )
  );
  LUT5 #(
    .INIT ( 32'h99900900 ))
  \blk00000003/blk000000fd  (
    .I0(\blk00000003/sig00000126 ),
    .I1(\blk00000003/sig00000125 ),
    .I2(\blk00000003/sig0000012a ),
    .I3(\blk00000003/sig000000e8 ),
    .I4(\blk00000003/sig00000103 ),
    .O(\blk00000003/sig0000010c )
  );
  LUT5 #(
    .INIT ( 32'h99900900 ))
  \blk00000003/blk000000fc  (
    .I0(\blk00000003/sig00000126 ),
    .I1(\blk00000003/sig00000125 ),
    .I2(\blk00000003/sig0000012a ),
    .I3(\blk00000003/sig000000e7 ),
    .I4(\blk00000003/sig000000e5 ),
    .O(\blk00000003/sig0000010e )
  );
  LUT5 #(
    .INIT ( 32'h99900900 ))
  \blk00000003/blk000000fb  (
    .I0(\blk00000003/sig00000126 ),
    .I1(\blk00000003/sig00000125 ),
    .I2(\blk00000003/sig0000012a ),
    .I3(\blk00000003/sig000000e9 ),
    .I4(\blk00000003/sig000000e6 ),
    .O(\blk00000003/sig0000010a )
  );
  LUT6 #(
    .INIT ( 64'hC382D79641005514 ))
  \blk00000003/blk000000fa  (
    .I0(\blk00000003/sig0000012a ),
    .I1(\blk00000003/sig00000126 ),
    .I2(\blk00000003/sig00000125 ),
    .I3(\blk00000003/sig000000ea ),
    .I4(\blk00000003/sig0000006c ),
    .I5(\blk00000003/sig000000eb ),
    .O(\blk00000003/sig00000108 )
  );
  LUT6 #(
    .INIT ( 64'h9F0F960699099000 ))
  \blk00000003/blk000000f9  (
    .I0(\blk00000003/sig00000126 ),
    .I1(\blk00000003/sig00000125 ),
    .I2(\blk00000003/sig0000012a ),
    .I3(\blk00000003/sig000000e8 ),
    .I4(\blk00000003/sig000000e4 ),
    .I5(\blk00000003/sig00000103 ),
    .O(\blk00000003/sig0000010b )
  );
  LUT6 #(
    .INIT ( 64'h9F0F960699099000 ))
  \blk00000003/blk000000f8  (
    .I0(\blk00000003/sig00000126 ),
    .I1(\blk00000003/sig00000125 ),
    .I2(\blk00000003/sig0000012a ),
    .I3(\blk00000003/sig000000e7 ),
    .I4(\blk00000003/sig000000e3 ),
    .I5(\blk00000003/sig000000e5 ),
    .O(\blk00000003/sig00000109 )
  );
  LUT6 #(
    .INIT ( 64'h9F0F960699099000 ))
  \blk00000003/blk000000f7  (
    .I0(\blk00000003/sig00000126 ),
    .I1(\blk00000003/sig00000125 ),
    .I2(\blk00000003/sig0000012a ),
    .I3(\blk00000003/sig000000e9 ),
    .I4(\blk00000003/sig00000104 ),
    .I5(\blk00000003/sig000000e6 ),
    .O(\blk00000003/sig00000112 )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000f6  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[9]),
    .I4(b_1[9]),
    .O(\blk00000003/sig00000091 )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000f5  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[8]),
    .I4(b_1[8]),
    .O(\blk00000003/sig00000095 )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000f4  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[7]),
    .I4(b_1[7]),
    .O(\blk00000003/sig00000099 )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000f3  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[6]),
    .I4(b_1[6]),
    .O(\blk00000003/sig0000009d )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000f2  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[5]),
    .I4(b_1[5]),
    .O(\blk00000003/sig000000a1 )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000f1  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[4]),
    .I4(b_1[4]),
    .O(\blk00000003/sig000000a4 )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000f0  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[3]),
    .I4(b_1[3]),
    .O(\blk00000003/sig00000074 )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000ef  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[2]),
    .I4(b_1[2]),
    .O(\blk00000003/sig00000079 )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000ee  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[1]),
    .I4(b_1[1]),
    .O(\blk00000003/sig0000007d )
  );
  LUT5 #(
    .INIT ( 32'h77700700 ))
  \blk00000003/blk000000ed  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig00000041 ),
    .I3(a_0[0]),
    .I4(b_1[0]),
    .O(\blk00000003/sig00000081 )
  );
  LUT4 #(
    .INIT ( 16'h7770 ))
  \blk00000003/blk000000ec  (
    .I0(\blk00000003/sig000000fc ),
    .I1(\blk00000003/sig000000fb ),
    .I2(\blk00000003/sig000000fa ),
    .I3(\blk00000003/sig000000f5 ),
    .O(\blk00000003/sig000000f0 )
  );
  LUT6 #(
    .INIT ( 64'h5555555555454545 ))
  \blk00000003/blk000000eb  (
    .I0(\blk00000003/sig000000f0 ),
    .I1(\blk00000003/sig000000f1 ),
    .I2(\blk00000003/sig000000ee ),
    .I3(\blk00000003/sig000000a7 ),
    .I4(\blk00000003/sig000000b4 ),
    .I5(\blk00000003/sig000000ec ),
    .O(\blk00000003/sig00000121 )
  );
  LUT6 #(
    .INIT ( 64'h9614BE3C8200AA28 ))
  \blk00000003/blk000000ea  (
    .I0(\blk00000003/sig0000012a ),
    .I1(\blk00000003/sig00000126 ),
    .I2(\blk00000003/sig00000125 ),
    .I3(\blk00000003/sig000000ea ),
    .I4(\blk00000003/sig0000006c ),
    .I5(\blk00000003/sig000000eb ),
    .O(\blk00000003/sig00000113 )
  );
  LUT5 #(
    .INIT ( 32'h66600600 ))
  \blk00000003/blk000000e9  (
    .I0(a_0[10]),
    .I1(b_1[10]),
    .I2(\blk00000003/sig00000041 ),
    .I3(b_1[0]),
    .I4(a_0[0]),
    .O(\blk00000003/sig00000104 )
  );
  LUT5 #(
    .INIT ( 32'hDFFD8FF8 ))
  \blk00000003/blk000000e8  (
    .I0(\blk00000003/sig00000041 ),
    .I1(a_0[9]),
    .I2(a_0[10]),
    .I3(b_1[10]),
    .I4(b_1[9]),
    .O(\blk00000003/sig00000103 )
  );
  LUT6 #(
    .INIT ( 64'h5410FEBA54105410 ))
  \blk00000003/blk000000e7  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig00000090 ),
    .I3(\blk00000003/sig000000a0 ),
    .I4(\blk00000003/sig000000b2 ),
    .I5(\blk00000003/sig0000007c ),
    .O(\blk00000003/sig00000118 )
  );
  LUT6 #(
    .INIT ( 64'h5410FEBA54105410 ))
  \blk00000003/blk000000e6  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig00000094 ),
    .I3(\blk00000003/sig000000a3 ),
    .I4(\blk00000003/sig000000b2 ),
    .I5(\blk00000003/sig00000080 ),
    .O(\blk00000003/sig00000115 )
  );
  LUT6 #(
    .INIT ( 64'h5410FEBA54105410 ))
  \blk00000003/blk000000e5  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig00000098 ),
    .I3(\blk00000003/sig00000073 ),
    .I4(\blk00000003/sig000000b2 ),
    .I5(\blk00000003/sig00000084 ),
    .O(\blk00000003/sig00000117 )
  );
  LUT6 #(
    .INIT ( 64'h5410FEBA54105410 ))
  \blk00000003/blk000000e4  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig0000009c ),
    .I3(\blk00000003/sig00000078 ),
    .I4(\blk00000003/sig000000b2 ),
    .I5(\blk00000003/sig00000086 ),
    .O(\blk00000003/sig00000116 )
  );
  LUT4 #(
    .INIT ( 16'h95A9 ))
  \blk00000003/blk000000e3  (
    .I0(b_1[14]),
    .I1(\blk00000003/sig00000138 ),
    .I2(b_1[13]),
    .I3(a_0[13]),
    .O(\blk00000003/sig00000127 )
  );
  LUT4 #(
    .INIT ( 16'hFF8E ))
  \blk00000003/blk000000e2  (
    .I0(\blk00000003/sig00000137 ),
    .I1(\blk00000003/sig0000005d ),
    .I2(\blk00000003/sig000000a7 ),
    .I3(\blk00000003/sig0000005a ),
    .O(\blk00000003/sig000000ee )
  );
  LUT3 #(
    .INIT ( 8'h10 ))
  \blk00000003/blk000000e1  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig0000007c ),
    .O(\blk00000003/sig0000011d )
  );
  LUT3 #(
    .INIT ( 8'h10 ))
  \blk00000003/blk000000e0  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig00000080 ),
    .O(\blk00000003/sig0000011e )
  );
  LUT3 #(
    .INIT ( 8'h10 ))
  \blk00000003/blk000000df  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig00000084 ),
    .O(\blk00000003/sig0000011f )
  );
  LUT3 #(
    .INIT ( 8'h10 ))
  \blk00000003/blk000000de  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig00000086 ),
    .O(\blk00000003/sig00000120 )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \blk00000003/blk000000dd  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig000000a0 ),
    .I3(\blk00000003/sig0000007c ),
    .O(\blk00000003/sig00000119 )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \blk00000003/blk000000dc  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig000000a3 ),
    .I3(\blk00000003/sig00000080 ),
    .O(\blk00000003/sig0000011a )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \blk00000003/blk000000db  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig00000078 ),
    .I3(\blk00000003/sig00000086 ),
    .O(\blk00000003/sig0000011c )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \blk00000003/blk000000da  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig00000073 ),
    .I3(\blk00000003/sig00000084 ),
    .O(\blk00000003/sig0000011b )
  );
  LUT6 #(
    .INIT ( 64'h5555555559555555 ))
  \blk00000003/blk000000d9  (
    .I0(\blk00000003/sig0000005a ),
    .I1(\blk00000003/sig00000132 ),
    .I2(\blk00000003/sig000000ff ),
    .I3(\blk00000003/sig00000122 ),
    .I4(\blk00000003/sig00000123 ),
    .I5(\blk00000003/sig000000c6 ),
    .O(\blk00000003/sig00000136 )
  );
  LUT6 #(
    .INIT ( 64'h0200020202000200 ))
  \blk00000003/blk000000d8  (
    .I0(\blk00000003/sig000000fd ),
    .I1(\blk00000003/sig00000135 ),
    .I2(\blk00000003/sig000000ef ),
    .I3(\blk00000003/sig00000089 ),
    .I4(\blk00000003/sig000000c6 ),
    .I5(\blk00000003/sig0000008c ),
    .O(overflow)
  );
  LUT6 #(
    .INIT ( 64'hFEBABABABABABABA ))
  \blk00000003/blk000000d7  (
    .I0(\blk00000003/sig0000012b ),
    .I1(\blk00000003/sig0000012a ),
    .I2(\blk00000003/sig0000012c ),
    .I3(\blk00000003/sig00000129 ),
    .I4(\blk00000003/sig0000012d ),
    .I5(\blk00000003/sig0000006b ),
    .O(\blk00000003/sig000000cb )
  );
  LUT6 #(
    .INIT ( 64'h5555555500400000 ))
  \blk00000003/blk000000d6  (
    .I0(\blk00000003/sig000000f1 ),
    .I1(\blk00000003/sig000000ee ),
    .I2(\blk00000003/sig000000c4 ),
    .I3(\blk00000003/sig000000ec ),
    .I4(\blk00000003/sig00000134 ),
    .I5(\blk00000003/sig000000f0 ),
    .O(result_3[9])
  );
  LUT6 #(
    .INIT ( 64'h5544554455444554 ))
  \blk00000003/blk000000d5  (
    .I0(\blk00000003/sig00000121 ),
    .I1(\blk00000003/sig000000f7 ),
    .I2(\blk00000003/sig00000123 ),
    .I3(\blk00000003/sig00000132 ),
    .I4(\blk00000003/sig000000c6 ),
    .I5(\blk00000003/sig00000133 ),
    .O(result_3[13])
  );
  LUT6 #(
    .INIT ( 64'hF858A808FD5DAD0D ))
  \blk00000003/blk000000d4  (
    .I0(\blk00000003/sig000000ad ),
    .I1(\blk00000003/sig00000115 ),
    .I2(\blk00000003/sig000000aa ),
    .I3(\blk00000003/sig00000117 ),
    .I4(\blk00000003/sig00000118 ),
    .I5(\blk00000003/sig00000131 ),
    .O(\blk00000003/sig000000c2 )
  );
  LUT6 #(
    .INIT ( 64'h028A139B46CE57DF ))
  \blk00000003/blk000000d3  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig00000114 ),
    .I2(\blk00000003/sig00000078 ),
    .I3(\blk00000003/sig00000086 ),
    .I4(\blk00000003/sig0000008c ),
    .I5(\blk00000003/sig0000009c ),
    .O(\blk00000003/sig00000131 )
  );
  LUT6 #(
    .INIT ( 64'h11110100BBBBABAA ))
  \blk00000003/blk000000d2  (
    .I0(\blk00000003/sig000000b2 ),
    .I1(\blk00000003/sig00000073 ),
    .I2(\blk00000003/sig0000007c ),
    .I3(\blk00000003/sig00000080 ),
    .I4(\blk00000003/sig00000078 ),
    .I5(\blk00000003/sig00000130 ),
    .O(\blk00000003/sig000000a9 )
  );
  LUT2 #(
    .INIT ( 4'hD ))
  \blk00000003/blk000000d1  (
    .I0(\blk00000003/sig00000086 ),
    .I1(\blk00000003/sig00000084 ),
    .O(\blk00000003/sig00000130 )
  );
  LUT6 #(
    .INIT ( 64'h01010100ABABABAA ))
  \blk00000003/blk000000d0  (
    .I0(\blk00000003/sig000000af ),
    .I1(\blk00000003/sig0000008c ),
    .I2(\blk00000003/sig00000089 ),
    .I3(\blk00000003/sig00000094 ),
    .I4(\blk00000003/sig00000090 ),
    .I5(\blk00000003/sig0000012f ),
    .O(\blk00000003/sig000000ab )
  );
  LUT4 #(
    .INIT ( 16'hFFAB ))
  \blk00000003/blk000000cf  (
    .I0(\blk00000003/sig00000098 ),
    .I1(\blk00000003/sig000000a0 ),
    .I2(\blk00000003/sig000000a3 ),
    .I3(\blk00000003/sig0000009c ),
    .O(\blk00000003/sig0000012f )
  );
  LUT6 #(
    .INIT ( 64'h11110100BBBBABAA ))
  \blk00000003/blk000000ce  (
    .I0(\blk00000003/sig000000af ),
    .I1(\blk00000003/sig00000089 ),
    .I2(\blk00000003/sig00000090 ),
    .I3(\blk00000003/sig00000094 ),
    .I4(\blk00000003/sig0000008c ),
    .I5(\blk00000003/sig0000012e ),
    .O(\blk00000003/sig000000a8 )
  );
  LUT4 #(
    .INIT ( 16'hFF45 ))
  \blk00000003/blk000000cd  (
    .I0(\blk00000003/sig0000009c ),
    .I1(\blk00000003/sig000000a0 ),
    .I2(\blk00000003/sig000000a3 ),
    .I3(\blk00000003/sig00000098 ),
    .O(\blk00000003/sig0000012e )
  );
  LUT6 #(
    .INIT ( 64'hFEBABABABABABABA ))
  \blk00000003/blk000000cc  (
    .I0(\blk00000003/sig0000012b ),
    .I1(\blk00000003/sig0000012a ),
    .I2(\blk00000003/sig0000012c ),
    .I3(\blk00000003/sig00000129 ),
    .I4(\blk00000003/sig0000012d ),
    .I5(\blk00000003/sig0000006b ),
    .O(\blk00000003/sig0000006e )
  );
  LUT6 #(
    .INIT ( 64'h232323A32F2F2FAF ))
  \blk00000003/blk000000cb  (
    .I0(\blk00000003/sig00000069 ),
    .I1(\blk00000003/sig00000106 ),
    .I2(\blk00000003/sig00000129 ),
    .I3(\blk00000003/sig000000e6 ),
    .I4(\blk00000003/sig000000eb ),
    .I5(\blk00000003/sig00000104 ),
    .O(\blk00000003/sig0000012c )
  );
  LUT6 #(
    .INIT ( 64'h0202020202022202 ))
  \blk00000003/blk000000ca  (
    .I0(\blk00000003/sig00000067 ),
    .I1(\blk00000003/sig00000129 ),
    .I2(\blk00000003/sig00000106 ),
    .I3(\blk00000003/sig0000012a ),
    .I4(\blk00000003/sig000000ea ),
    .I5(\blk00000003/sig000000e9 ),
    .O(\blk00000003/sig0000012b )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFFFF8788 ))
  \blk00000003/blk000000c9  (
    .I0(\blk00000003/sig00000125 ),
    .I1(\blk00000003/sig00000126 ),
    .I2(\blk00000003/sig00000100 ),
    .I3(\blk00000003/sig00000127 ),
    .I4(\blk00000003/sig000000fb ),
    .I5(\blk00000003/sig000000fc ),
    .O(\blk00000003/sig00000128 )
  );
  LUT6 #(
    .INIT ( 64'h55F4F4F400B0B0B0 ))
  \blk00000003/blk000000c8  (
    .I0(\blk00000003/sig000000f4 ),
    .I1(\blk00000003/sig00000041 ),
    .I2(a_0[15]),
    .I3(\blk00000003/sig0000003d ),
    .I4(\blk00000003/sig000000f5 ),
    .I5(\blk00000003/sig000000f9 ),
    .O(\blk00000003/sig00000124 )
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000c7  (
    .I0(\blk00000003/sig000000c1 ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[8])
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000c6  (
    .I0(\blk00000003/sig000000be ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[7])
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000c5  (
    .I0(\blk00000003/sig000000bb ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[6])
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000c4  (
    .I0(\blk00000003/sig000000d6 ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[3])
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000c3  (
    .I0(\blk00000003/sig000000b8 ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[5])
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000c2  (
    .I0(\blk00000003/sig000000d3 ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[4])
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000c1  (
    .I0(\blk00000003/sig000000d9 ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[2])
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000c0  (
    .I0(\blk00000003/sig000000dc ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[1])
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk000000bf  (
    .I0(\blk00000003/sig000000de ),
    .I1(\blk00000003/sig000000f2 ),
    .O(result_3[0])
  );
  LUT6 #(
    .INIT ( 64'h5544554455444554 ))
  \blk00000003/blk000000be  (
    .I0(\blk00000003/sig00000121 ),
    .I1(\blk00000003/sig000000f7 ),
    .I2(\blk00000003/sig00000122 ),
    .I3(\blk00000003/sig00000123 ),
    .I4(\blk00000003/sig000000ff ),
    .I5(\blk00000003/sig000000c6 ),
    .O(result_3[12])
  );
  LUT5 #(
    .INIT ( 32'h73625140 ))
  \blk00000003/blk000000bd  (
    .I0(\blk00000003/sig000000ad ),
    .I1(\blk00000003/sig000000aa ),
    .I2(\blk00000003/sig0000011f ),
    .I3(\blk00000003/sig0000011e ),
    .I4(\blk00000003/sig00000120 ),
    .O(\blk00000003/sig000000cd )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000bc  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig0000011e ),
    .I3(\blk00000003/sig00000120 ),
    .I4(\blk00000003/sig0000011f ),
    .I5(\blk00000003/sig0000011d ),
    .O(\blk00000003/sig000000c7 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000bb  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig0000011e ),
    .I3(\blk00000003/sig00000120 ),
    .I4(\blk00000003/sig0000011f ),
    .I5(\blk00000003/sig0000011d ),
    .O(\blk00000003/sig000000dd )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000ba  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig0000011d ),
    .I3(\blk00000003/sig0000011f ),
    .I4(\blk00000003/sig0000011e ),
    .I5(\blk00000003/sig0000011c ),
    .O(\blk00000003/sig000000db )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000b9  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig0000011c ),
    .I3(\blk00000003/sig0000011e ),
    .I4(\blk00000003/sig0000011d ),
    .I5(\blk00000003/sig0000011b ),
    .O(\blk00000003/sig000000d8 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000b8  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig0000011b ),
    .I3(\blk00000003/sig0000011d ),
    .I4(\blk00000003/sig0000011c ),
    .I5(\blk00000003/sig0000011a ),
    .O(\blk00000003/sig000000d5 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000b7  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig0000011a ),
    .I3(\blk00000003/sig0000011c ),
    .I4(\blk00000003/sig0000011b ),
    .I5(\blk00000003/sig00000119 ),
    .O(\blk00000003/sig000000d2 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000b6  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig00000119 ),
    .I3(\blk00000003/sig0000011b ),
    .I4(\blk00000003/sig0000011a ),
    .I5(\blk00000003/sig00000116 ),
    .O(\blk00000003/sig000000b6 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000b5  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig00000116 ),
    .I3(\blk00000003/sig0000011a ),
    .I4(\blk00000003/sig00000119 ),
    .I5(\blk00000003/sig00000117 ),
    .O(\blk00000003/sig000000b9 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000b4  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig00000117 ),
    .I3(\blk00000003/sig00000119 ),
    .I4(\blk00000003/sig00000116 ),
    .I5(\blk00000003/sig00000115 ),
    .O(\blk00000003/sig000000bc )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk000000b3  (
    .I0(\blk00000003/sig000000aa ),
    .I1(\blk00000003/sig000000ad ),
    .I2(\blk00000003/sig00000115 ),
    .I3(\blk00000003/sig00000116 ),
    .I4(\blk00000003/sig00000117 ),
    .I5(\blk00000003/sig00000118 ),
    .O(\blk00000003/sig000000bf )
  );
  LUT2 #(
    .INIT ( 4'h1 ))
  \blk00000003/blk000000b2  (
    .I0(\blk00000003/sig00000084 ),
    .I1(\blk00000003/sig00000086 ),
    .O(\blk00000003/sig000000b3 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk000000b1  (
    .I0(\blk00000003/sig0000007c ),
    .I1(\blk00000003/sig00000080 ),
    .I2(\blk00000003/sig00000073 ),
    .I3(\blk00000003/sig00000078 ),
    .O(\blk00000003/sig000000b1 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk000000b0  (
    .I0(\blk00000003/sig00000098 ),
    .I1(\blk00000003/sig0000009c ),
    .I2(\blk00000003/sig000000a0 ),
    .I3(\blk00000003/sig000000a3 ),
    .O(\blk00000003/sig000000b0 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk000000af  (
    .I0(\blk00000003/sig00000089 ),
    .I1(\blk00000003/sig0000008c ),
    .I2(\blk00000003/sig00000090 ),
    .I3(\blk00000003/sig00000094 ),
    .O(\blk00000003/sig000000ae )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \blk00000003/blk000000ae  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000b4 ),
    .O(\blk00000003/sig000000ef )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \blk00000003/blk000000ad  (
    .I0(\blk00000003/sig000000b4 ),
    .I1(\blk00000003/sig000000b2 ),
    .O(\blk00000003/sig000000a6 )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \blk00000003/blk000000ac  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .O(\blk00000003/sig000000a5 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \blk00000003/blk000000ab  (
    .I0(\blk00000003/sig000000a7 ),
    .I1(\blk00000003/sig000000af ),
    .I2(\blk00000003/sig000000b2 ),
    .O(\blk00000003/sig00000114 )
  );
  LUT5 #(
    .INIT ( 32'h01010100 ))
  \blk00000003/blk000000aa  (
    .I0(\blk00000003/sig000000b2 ),
    .I1(\blk00000003/sig00000078 ),
    .I2(\blk00000003/sig00000073 ),
    .I3(\blk00000003/sig00000080 ),
    .I4(\blk00000003/sig0000007c ),
    .O(\blk00000003/sig000000ac )
  );
  LUT5 #(
    .INIT ( 32'hAAAA596A ))
  \blk00000003/blk000000a9  (
    .I0(\blk00000003/sig00000070 ),
    .I1(\blk00000003/sig00000106 ),
    .I2(\blk00000003/sig00000109 ),
    .I3(\blk00000003/sig00000113 ),
    .I4(\blk00000003/sig00000107 ),
    .O(\blk00000003/sig00000085 )
  );
  LUT5 #(
    .INIT ( 32'hAAAA596A ))
  \blk00000003/blk000000a8  (
    .I0(\blk00000003/sig00000070 ),
    .I1(\blk00000003/sig00000106 ),
    .I2(\blk00000003/sig0000010b ),
    .I3(\blk00000003/sig00000112 ),
    .I4(\blk00000003/sig00000107 ),
    .O(\blk00000003/sig00000083 )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk000000a7  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig00000070 ),
    .I2(\blk00000003/sig00000095 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig00000111 ),
    .I5(\blk00000003/sig0000010f ),
    .O(\blk00000003/sig00000093 )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk000000a6  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig000000a1 ),
    .I2(\blk00000003/sig00000070 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig00000110 ),
    .I5(\blk00000003/sig0000010c ),
    .O(\blk00000003/sig0000009f )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk000000a5  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig00000070 ),
    .I2(\blk00000003/sig00000099 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig00000105 ),
    .I5(\blk00000003/sig00000110 ),
    .O(\blk00000003/sig00000097 )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk000000a4  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig0000009d ),
    .I2(\blk00000003/sig00000070 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig0000010f ),
    .I5(\blk00000003/sig0000010d ),
    .O(\blk00000003/sig0000009b )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk000000a3  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig00000079 ),
    .I2(\blk00000003/sig00000070 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig0000010e ),
    .I5(\blk00000003/sig00000108 ),
    .O(\blk00000003/sig00000077 )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk000000a2  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig000000a4 ),
    .I2(\blk00000003/sig00000070 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig0000010d ),
    .I5(\blk00000003/sig0000010e ),
    .O(\blk00000003/sig000000a2 )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk000000a1  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig00000074 ),
    .I2(\blk00000003/sig00000070 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig0000010c ),
    .I5(\blk00000003/sig0000010a ),
    .O(\blk00000003/sig00000072 )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk000000a0  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig0000007d ),
    .I2(\blk00000003/sig00000070 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig0000010a ),
    .I5(\blk00000003/sig0000010b ),
    .O(\blk00000003/sig0000007b )
  );
  LUT6 #(
    .INIT ( 64'h69693C69693C3C3C ))
  \blk00000003/blk0000009f  (
    .I0(\blk00000003/sig00000107 ),
    .I1(\blk00000003/sig00000081 ),
    .I2(\blk00000003/sig00000070 ),
    .I3(\blk00000003/sig00000106 ),
    .I4(\blk00000003/sig00000108 ),
    .I5(\blk00000003/sig00000109 ),
    .O(\blk00000003/sig0000007f )
  );
  LUT5 #(
    .INIT ( 32'h0FF02DD2 ))
  \blk00000003/blk0000009e  (
    .I0(\blk00000003/sig00000105 ),
    .I1(\blk00000003/sig00000106 ),
    .I2(\blk00000003/sig00000070 ),
    .I3(\blk00000003/sig00000091 ),
    .I4(\blk00000003/sig00000107 ),
    .O(\blk00000003/sig0000008f )
  );
  LUT3 #(
    .INIT ( 8'h01 ))
  \blk00000003/blk0000009d  (
    .I0(\blk00000003/sig00000104 ),
    .I1(\blk00000003/sig000000e3 ),
    .I2(\blk00000003/sig000000e4 ),
    .O(\blk00000003/sig00000066 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk0000009c  (
    .I0(\blk00000003/sig000000ea ),
    .I1(\blk00000003/sig000000e9 ),
    .I2(\blk00000003/sig000000e7 ),
    .I3(\blk00000003/sig000000e8 ),
    .O(\blk00000003/sig00000068 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk0000009b  (
    .I0(\blk00000003/sig000000eb ),
    .I1(\blk00000003/sig000000e6 ),
    .I2(\blk00000003/sig000000e5 ),
    .I3(\blk00000003/sig00000103 ),
    .O(\blk00000003/sig0000006a )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \blk00000003/blk0000009a  (
    .I0(a_0[14]),
    .I1(b_1[14]),
    .O(\blk00000003/sig00000040 )
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \blk00000003/blk00000099  (
    .I0(b_1[14]),
    .I1(a_0[14]),
    .O(\blk00000003/sig0000003f )
  );
  LUT4 #(
    .INIT ( 16'h22B2 ))
  \blk00000003/blk00000098  (
    .I0(b_1[1]),
    .I1(a_0[1]),
    .I2(b_1[0]),
    .I3(a_0[0]),
    .O(\blk00000003/sig00000054 )
  );
  LUT4 #(
    .INIT ( 16'h22B2 ))
  \blk00000003/blk00000097  (
    .I0(b_1[3]),
    .I1(a_0[3]),
    .I2(b_1[2]),
    .I3(a_0[2]),
    .O(\blk00000003/sig00000052 )
  );
  LUT4 #(
    .INIT ( 16'h22B2 ))
  \blk00000003/blk00000096  (
    .I0(b_1[5]),
    .I1(a_0[5]),
    .I2(b_1[4]),
    .I3(a_0[4]),
    .O(\blk00000003/sig0000004f )
  );
  LUT4 #(
    .INIT ( 16'h22B2 ))
  \blk00000003/blk00000095  (
    .I0(b_1[7]),
    .I1(a_0[7]),
    .I2(b_1[6]),
    .I3(a_0[6]),
    .O(\blk00000003/sig0000004c )
  );
  LUT4 #(
    .INIT ( 16'h22B2 ))
  \blk00000003/blk00000094  (
    .I0(b_1[9]),
    .I1(a_0[9]),
    .I2(b_1[8]),
    .I3(a_0[8]),
    .O(\blk00000003/sig00000049 )
  );
  LUT4 #(
    .INIT ( 16'h22B2 ))
  \blk00000003/blk00000093  (
    .I0(b_1[11]),
    .I1(a_0[11]),
    .I2(b_1[10]),
    .I3(a_0[10]),
    .O(\blk00000003/sig00000046 )
  );
  LUT4 #(
    .INIT ( 16'h22B2 ))
  \blk00000003/blk00000092  (
    .I0(b_1[13]),
    .I1(a_0[13]),
    .I2(b_1[12]),
    .I3(a_0[12]),
    .O(\blk00000003/sig00000043 )
  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \blk00000003/blk00000091  (
    .I0(b_1[1]),
    .I1(a_0[1]),
    .I2(b_1[0]),
    .I3(a_0[0]),
    .O(\blk00000003/sig00000055 )
  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \blk00000003/blk00000090  (
    .I0(b_1[3]),
    .I1(a_0[3]),
    .I2(b_1[2]),
    .I3(a_0[2]),
    .O(\blk00000003/sig00000053 )
  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \blk00000003/blk0000008f  (
    .I0(b_1[5]),
    .I1(a_0[5]),
    .I2(b_1[4]),
    .I3(a_0[4]),
    .O(\blk00000003/sig00000050 )
  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \blk00000003/blk0000008e  (
    .I0(b_1[7]),
    .I1(a_0[7]),
    .I2(b_1[6]),
    .I3(a_0[6]),
    .O(\blk00000003/sig0000004d )
  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \blk00000003/blk0000008d  (
    .I0(b_1[9]),
    .I1(a_0[9]),
    .I2(b_1[8]),
    .I3(a_0[8]),
    .O(\blk00000003/sig0000004a )
  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \blk00000003/blk0000008c  (
    .I0(b_1[11]),
    .I1(a_0[11]),
    .I2(b_1[10]),
    .I3(a_0[10]),
    .O(\blk00000003/sig00000047 )
  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \blk00000003/blk0000008b  (
    .I0(b_1[13]),
    .I1(a_0[13]),
    .I2(b_1[12]),
    .I3(a_0[12]),
    .O(\blk00000003/sig00000044 )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \blk00000003/blk0000008a  (
    .I0(b_1[11]),
    .I1(a_0[11]),
    .O(\blk00000003/sig00000102 )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \blk00000003/blk00000089  (
    .I0(b_1[12]),
    .I1(a_0[12]),
    .O(\blk00000003/sig00000101 )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \blk00000003/blk00000088  (
    .I0(b_1[14]),
    .I1(a_0[14]),
    .O(\blk00000003/sig00000100 )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \blk00000003/blk00000087  (
    .I0(\blk00000003/sig00000065 ),
    .I1(\blk00000003/sig000000aa ),
    .O(\blk00000003/sig000000ff )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \blk00000003/blk00000086  (
    .I0(\blk00000003/sig00000063 ),
    .I1(\blk00000003/sig000000ad ),
    .O(\blk00000003/sig000000fe )
  );
  LUT6 #(
    .INIT ( 64'h4000000000000000 ))
  \blk00000003/blk00000085  (
    .I0(\blk00000003/sig00000057 ),
    .I1(\blk00000003/sig0000005a ),
    .I2(\blk00000003/sig0000005d ),
    .I3(\blk00000003/sig00000060 ),
    .I4(\blk00000003/sig00000063 ),
    .I5(\blk00000003/sig00000065 ),
    .O(\blk00000003/sig000000fd )
  );
  LUT4 #(
    .INIT ( 16'h22F2 ))
  \blk00000003/blk00000084  (
    .I0(\blk00000003/sig000000fa ),
    .I1(\blk00000003/sig00000039 ),
    .I2(\blk00000003/sig000000f5 ),
    .I3(\blk00000003/sig0000003d ),
    .O(\blk00000003/sig000000f3 )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \blk00000003/blk00000083  (
    .I0(\blk00000003/sig000000fd ),
    .I1(\blk00000003/sig00000089 ),
    .O(\blk00000003/sig000000ed )
  );
  LUT5 #(
    .INIT ( 32'h00000001 ))
  \blk00000003/blk00000082  (
    .I0(b_1[14]),
    .I1(b_1[13]),
    .I2(b_1[12]),
    .I3(b_1[11]),
    .I4(b_1[10]),
    .O(\blk00000003/sig000000fc )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \blk00000003/blk00000081  (
    .I0(b_1[14]),
    .I1(b_1[13]),
    .I2(b_1[12]),
    .I3(b_1[11]),
    .I4(b_1[10]),
    .O(\blk00000003/sig000000f5 )
  );
  LUT5 #(
    .INIT ( 32'h00000001 ))
  \blk00000003/blk00000080  (
    .I0(a_0[14]),
    .I1(a_0[13]),
    .I2(a_0[12]),
    .I3(a_0[11]),
    .I4(a_0[10]),
    .O(\blk00000003/sig000000fb )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \blk00000003/blk0000007f  (
    .I0(a_0[14]),
    .I1(a_0[13]),
    .I2(a_0[12]),
    .I3(a_0[11]),
    .I4(a_0[10]),
    .O(\blk00000003/sig000000fa )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \blk00000003/blk0000007e  (
    .I0(a_0[0]),
    .I1(a_0[1]),
    .I2(a_0[2]),
    .I3(a_0[3]),
    .I4(a_0[4]),
    .I5(a_0[5]),
    .O(\blk00000003/sig00000036 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk0000007d  (
    .I0(a_0[6]),
    .I1(a_0[7]),
    .I2(a_0[8]),
    .I3(a_0[9]),
    .O(\blk00000003/sig00000038 )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \blk00000003/blk0000007c  (
    .I0(b_1[0]),
    .I1(b_1[1]),
    .I2(b_1[2]),
    .I3(b_1[3]),
    .I4(b_1[4]),
    .I5(b_1[5]),
    .O(\blk00000003/sig0000003a )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk0000007b  (
    .I0(b_1[6]),
    .I1(b_1[7]),
    .I2(b_1[8]),
    .I3(b_1[9]),
    .O(\blk00000003/sig0000003c )
  );
  LUT3 #(
    .INIT ( 8'h27 ))
  \blk00000003/blk0000007a  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(b_1[10]),
    .I2(a_0[10]),
    .O(\blk00000003/sig00000064 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000079  (
    .I0(b_1[15]),
    .I1(operation_2[0]),
    .O(\blk00000003/sig000000f9 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000078  (
    .I0(a_0[10]),
    .I1(b_1[10]),
    .O(\blk00000003/sig0000006c )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \blk00000003/blk00000077  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(a_0[12]),
    .I2(b_1[12]),
    .O(\blk00000003/sig0000005f )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \blk00000003/blk00000076  (
    .I0(\blk00000003/sig000000f8 ),
    .I1(a_0[11]),
    .I2(b_1[11]),
    .O(\blk00000003/sig00000062 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFF00000400 ))
  \blk00000003/blk00000075  (
    .I0(\blk00000003/sig000000ef ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig000000f1 ),
    .I3(\blk00000003/sig000000ee ),
    .I4(\blk00000003/sig000000ec ),
    .I5(\blk00000003/sig000000f0 ),
    .O(\blk00000003/sig000000f7 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFF14445444 ))
  \blk00000003/blk00000074  (
    .I0(\blk00000003/sig000000f3 ),
    .I1(\blk00000003/sig000000f4 ),
    .I2(\blk00000003/sig0000003d ),
    .I3(\blk00000003/sig000000f5 ),
    .I4(\blk00000003/sig00000070 ),
    .I5(\blk00000003/sig000000f6 ),
    .O(\blk00000003/sig000000f1 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFFFFFFEF ))
  \blk00000003/blk00000073  (
    .I0(\blk00000003/sig000000ec ),
    .I1(\blk00000003/sig000000ed ),
    .I2(\blk00000003/sig000000ee ),
    .I3(\blk00000003/sig000000ef ),
    .I4(\blk00000003/sig000000f0 ),
    .I5(\blk00000003/sig000000f1 ),
    .O(\blk00000003/sig000000f2 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk00000072  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[7]),
    .I3(a_0[7]),
    .I4(a_0[6]),
    .I5(b_1[6]),
    .O(\blk00000003/sig000000eb )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk00000071  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[3]),
    .I3(a_0[3]),
    .I4(a_0[2]),
    .I5(b_1[2]),
    .O(\blk00000003/sig000000ea )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk00000070  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[4]),
    .I3(a_0[4]),
    .I4(a_0[3]),
    .I5(b_1[3]),
    .O(\blk00000003/sig000000e9 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk0000006f  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[6]),
    .I3(a_0[6]),
    .I4(a_0[5]),
    .I5(b_1[5]),
    .O(\blk00000003/sig000000e8 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk0000006e  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[5]),
    .I3(a_0[5]),
    .I4(a_0[4]),
    .I5(b_1[4]),
    .O(\blk00000003/sig000000e7 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk0000006d  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[8]),
    .I3(a_0[8]),
    .I4(a_0[7]),
    .I5(b_1[7]),
    .O(\blk00000003/sig000000e6 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk0000006c  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[9]),
    .I3(a_0[9]),
    .I4(a_0[8]),
    .I5(b_1[8]),
    .O(\blk00000003/sig000000e5 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk0000006b  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[2]),
    .I3(a_0[2]),
    .I4(a_0[1]),
    .I5(b_1[1]),
    .O(\blk00000003/sig000000e4 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk0000006a  (
    .I0(\blk00000003/sig0000006c ),
    .I1(\blk00000003/sig00000041 ),
    .I2(b_1[1]),
    .I3(a_0[1]),
    .I4(a_0[0]),
    .I5(b_1[0]),
    .O(\blk00000003/sig000000e3 )
  );
  MUXCY   \blk00000003/blk00000069  (
    .CI(\blk00000003/sig000000c5 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig000000e2 )
  );
  XORCY   \blk00000003/blk00000068  (
    .CI(\blk00000003/sig000000c5 ),
    .LI(\blk00000003/sig00000032 ),
    .O(\NLW_blk00000003/blk00000068_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk00000067  (
    .CI(\blk00000003/sig000000e2 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig000000e1 )
  );
  XORCY   \blk00000003/blk00000066  (
    .CI(\blk00000003/sig000000e2 ),
    .LI(\blk00000003/sig00000032 ),
    .O(\NLW_blk00000003/blk00000066_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk00000065  (
    .CI(\blk00000003/sig000000e1 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig000000e0 )
  );
  XORCY   \blk00000003/blk00000064  (
    .CI(\blk00000003/sig000000e1 ),
    .LI(\blk00000003/sig00000032 ),
    .O(\NLW_blk00000003/blk00000064_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk00000063  (
    .CI(\blk00000003/sig000000e0 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig000000df )
  );
  XORCY   \blk00000003/blk00000062  (
    .CI(\blk00000003/sig000000e0 ),
    .LI(\blk00000003/sig00000032 ),
    .O(\NLW_blk00000003/blk00000062_O_UNCONNECTED )
  );
  XORCY   \blk00000003/blk00000061  (
    .CI(\blk00000003/sig000000df ),
    .LI(\blk00000003/sig00000032 ),
    .O(\NLW_blk00000003/blk00000061_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk00000060  (
    .CI(\blk00000003/sig000000d0 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000dd ),
    .O(\blk00000003/sig000000da )
  );
  XORCY   \blk00000003/blk0000005f  (
    .CI(\blk00000003/sig000000d0 ),
    .LI(\blk00000003/sig000000dd ),
    .O(\blk00000003/sig000000de )
  );
  MUXCY   \blk00000003/blk0000005e  (
    .CI(\blk00000003/sig000000da ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000db ),
    .O(\blk00000003/sig000000d7 )
  );
  XORCY   \blk00000003/blk0000005d  (
    .CI(\blk00000003/sig000000da ),
    .LI(\blk00000003/sig000000db ),
    .O(\blk00000003/sig000000dc )
  );
  MUXCY   \blk00000003/blk0000005c  (
    .CI(\blk00000003/sig000000d7 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000d8 ),
    .O(\blk00000003/sig000000d4 )
  );
  XORCY   \blk00000003/blk0000005b  (
    .CI(\blk00000003/sig000000d7 ),
    .LI(\blk00000003/sig000000d8 ),
    .O(\blk00000003/sig000000d9 )
  );
  MUXCY   \blk00000003/blk0000005a  (
    .CI(\blk00000003/sig000000d4 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000d5 ),
    .O(\blk00000003/sig000000d1 )
  );
  XORCY   \blk00000003/blk00000059  (
    .CI(\blk00000003/sig000000d4 ),
    .LI(\blk00000003/sig000000d5 ),
    .O(\blk00000003/sig000000d6 )
  );
  MUXCY   \blk00000003/blk00000058  (
    .CI(\blk00000003/sig000000d1 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000d2 ),
    .O(\blk00000003/sig000000b5 )
  );
  XORCY   \blk00000003/blk00000057  (
    .CI(\blk00000003/sig000000d1 ),
    .LI(\blk00000003/sig000000d2 ),
    .O(\blk00000003/sig000000d3 )
  );
  MUXCY   \blk00000003/blk00000056  (
    .CI(\blk00000003/sig000000cf ),
    .DI(\blk00000003/sig00000035 ),
    .S(\blk00000003/sig00000035 ),
    .O(\blk00000003/sig000000d0 )
  );
  MUXCY   \blk00000003/blk00000055  (
    .CI(\blk00000003/sig000000ce ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000035 ),
    .O(\blk00000003/sig000000cf )
  );
  MUXCY   \blk00000003/blk00000054  (
    .CI(\blk00000003/sig000000cc ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000cd ),
    .O(\blk00000003/sig000000ce )
  );
  MUXCY   \blk00000003/blk00000053  (
    .CI(\blk00000003/sig000000ca ),
    .DI(\blk00000003/sig00000035 ),
    .S(\blk00000003/sig000000cb ),
    .O(\blk00000003/sig000000cc )
  );
  MUXCY   \blk00000003/blk00000052  (
    .CI(\blk00000003/sig000000c8 ),
    .DI(\blk00000003/sig00000035 ),
    .S(\blk00000003/sig000000c9 ),
    .O(\blk00000003/sig000000ca )
  );
  MUXCY   \blk00000003/blk00000051  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000c7 ),
    .O(\blk00000003/sig000000c8 )
  );
  XORCY   \blk00000003/blk00000050  (
    .CI(\blk00000003/sig000000c3 ),
    .LI(\blk00000003/sig00000035 ),
    .O(\blk00000003/sig000000c6 )
  );
  MUXCY   \blk00000003/blk0000004f  (
    .CI(\blk00000003/sig000000c3 ),
    .DI(\blk00000003/sig00000035 ),
    .S(\blk00000003/sig00000035 ),
    .O(\blk00000003/sig000000c5 )
  );
  XORCY   \blk00000003/blk0000004e  (
    .CI(\blk00000003/sig000000c0 ),
    .LI(\blk00000003/sig000000c2 ),
    .O(\blk00000003/sig000000c4 )
  );
  MUXCY   \blk00000003/blk0000004d  (
    .CI(\blk00000003/sig000000c0 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000c2 ),
    .O(\blk00000003/sig000000c3 )
  );
  XORCY   \blk00000003/blk0000004c  (
    .CI(\blk00000003/sig000000bd ),
    .LI(\blk00000003/sig000000bf ),
    .O(\blk00000003/sig000000c1 )
  );
  MUXCY   \blk00000003/blk0000004b  (
    .CI(\blk00000003/sig000000bd ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000bf ),
    .O(\blk00000003/sig000000c0 )
  );
  XORCY   \blk00000003/blk0000004a  (
    .CI(\blk00000003/sig000000ba ),
    .LI(\blk00000003/sig000000bc ),
    .O(\blk00000003/sig000000be )
  );
  MUXCY   \blk00000003/blk00000049  (
    .CI(\blk00000003/sig000000ba ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000bc ),
    .O(\blk00000003/sig000000bd )
  );
  XORCY   \blk00000003/blk00000048  (
    .CI(\blk00000003/sig000000b7 ),
    .LI(\blk00000003/sig000000b9 ),
    .O(\blk00000003/sig000000bb )
  );
  MUXCY   \blk00000003/blk00000047  (
    .CI(\blk00000003/sig000000b7 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b9 ),
    .O(\blk00000003/sig000000ba )
  );
  XORCY   \blk00000003/blk00000046  (
    .CI(\blk00000003/sig000000b5 ),
    .LI(\blk00000003/sig000000b6 ),
    .O(\blk00000003/sig000000b8 )
  );
  MUXCY   \blk00000003/blk00000045  (
    .CI(\blk00000003/sig000000b5 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b6 ),
    .O(\blk00000003/sig000000b7 )
  );
  MUXCY   \blk00000003/blk00000044  (
    .CI(\blk00000003/sig000000b2 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b3 ),
    .O(\blk00000003/sig000000b4 )
  );
  MUXCY   \blk00000003/blk00000043  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b1 ),
    .O(\blk00000003/sig000000b2 )
  );
  MUXCY   \blk00000003/blk00000042  (
    .CI(\blk00000003/sig000000af ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000b0 ),
    .O(\blk00000003/sig000000a7 )
  );
  MUXCY   \blk00000003/blk00000041  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig000000ae ),
    .O(\blk00000003/sig000000af )
  );
  MUXF7   \blk00000003/blk00000040  (
    .I0(\blk00000003/sig000000ab ),
    .I1(\blk00000003/sig000000ac ),
    .S(\blk00000003/sig000000a7 ),
    .O(\blk00000003/sig000000ad )
  );
  MUXF7   \blk00000003/blk0000003f  (
    .I0(\blk00000003/sig000000a8 ),
    .I1(\blk00000003/sig000000a9 ),
    .S(\blk00000003/sig000000a7 ),
    .O(\blk00000003/sig000000aa )
  );
  MUXF7   \blk00000003/blk0000003e  (
    .I0(\blk00000003/sig000000a5 ),
    .I1(\blk00000003/sig000000a6 ),
    .S(\blk00000003/sig000000a7 ),
    .O(\NLW_blk00000003/blk0000003e_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk0000003d  (
    .CI(\blk00000003/sig00000075 ),
    .DI(\blk00000003/sig000000a4 ),
    .S(\blk00000003/sig000000a2 ),
    .O(\blk00000003/sig0000009e )
  );
  XORCY   \blk00000003/blk0000003c  (
    .CI(\blk00000003/sig00000075 ),
    .LI(\blk00000003/sig000000a2 ),
    .O(\blk00000003/sig000000a3 )
  );
  MUXCY   \blk00000003/blk0000003b  (
    .CI(\blk00000003/sig0000009e ),
    .DI(\blk00000003/sig000000a1 ),
    .S(\blk00000003/sig0000009f ),
    .O(\blk00000003/sig0000009a )
  );
  XORCY   \blk00000003/blk0000003a  (
    .CI(\blk00000003/sig0000009e ),
    .LI(\blk00000003/sig0000009f ),
    .O(\blk00000003/sig000000a0 )
  );
  MUXCY   \blk00000003/blk00000039  (
    .CI(\blk00000003/sig0000009a ),
    .DI(\blk00000003/sig0000009d ),
    .S(\blk00000003/sig0000009b ),
    .O(\blk00000003/sig00000096 )
  );
  XORCY   \blk00000003/blk00000038  (
    .CI(\blk00000003/sig0000009a ),
    .LI(\blk00000003/sig0000009b ),
    .O(\blk00000003/sig0000009c )
  );
  MUXCY   \blk00000003/blk00000037  (
    .CI(\blk00000003/sig00000096 ),
    .DI(\blk00000003/sig00000099 ),
    .S(\blk00000003/sig00000097 ),
    .O(\blk00000003/sig00000092 )
  );
  XORCY   \blk00000003/blk00000036  (
    .CI(\blk00000003/sig00000096 ),
    .LI(\blk00000003/sig00000097 ),
    .O(\blk00000003/sig00000098 )
  );
  MUXCY   \blk00000003/blk00000035  (
    .CI(\blk00000003/sig00000092 ),
    .DI(\blk00000003/sig00000095 ),
    .S(\blk00000003/sig00000093 ),
    .O(\blk00000003/sig0000008e )
  );
  XORCY   \blk00000003/blk00000034  (
    .CI(\blk00000003/sig00000092 ),
    .LI(\blk00000003/sig00000093 ),
    .O(\blk00000003/sig00000094 )
  );
  MUXCY   \blk00000003/blk00000033  (
    .CI(\blk00000003/sig0000008e ),
    .DI(\blk00000003/sig00000091 ),
    .S(\blk00000003/sig0000008f ),
    .O(\blk00000003/sig0000008a )
  );
  XORCY   \blk00000003/blk00000032  (
    .CI(\blk00000003/sig0000008e ),
    .LI(\blk00000003/sig0000008f ),
    .O(\blk00000003/sig00000090 )
  );
  MUXCY   \blk00000003/blk00000031  (
    .CI(\blk00000003/sig0000008a ),
    .DI(\blk00000003/sig0000008d ),
    .S(\blk00000003/sig0000008b ),
    .O(\blk00000003/sig00000087 )
  );
  XORCY   \blk00000003/blk00000030  (
    .CI(\blk00000003/sig0000008a ),
    .LI(\blk00000003/sig0000008b ),
    .O(\blk00000003/sig0000008c )
  );
  XORCY   \blk00000003/blk0000002f  (
    .CI(\blk00000003/sig00000087 ),
    .LI(\blk00000003/sig00000088 ),
    .O(\blk00000003/sig00000089 )
  );
  MUXCY   \blk00000003/blk0000002e  (
    .CI(\blk00000003/sig0000006f ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000085 ),
    .O(\blk00000003/sig00000082 )
  );
  XORCY   \blk00000003/blk0000002d  (
    .CI(\blk00000003/sig0000006f ),
    .LI(\blk00000003/sig00000085 ),
    .O(\blk00000003/sig00000086 )
  );
  MUXCY   \blk00000003/blk0000002c  (
    .CI(\blk00000003/sig00000082 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000083 ),
    .O(\blk00000003/sig0000007e )
  );
  XORCY   \blk00000003/blk0000002b  (
    .CI(\blk00000003/sig00000082 ),
    .LI(\blk00000003/sig00000083 ),
    .O(\blk00000003/sig00000084 )
  );
  MUXCY   \blk00000003/blk0000002a  (
    .CI(\blk00000003/sig0000007e ),
    .DI(\blk00000003/sig00000081 ),
    .S(\blk00000003/sig0000007f ),
    .O(\blk00000003/sig0000007a )
  );
  XORCY   \blk00000003/blk00000029  (
    .CI(\blk00000003/sig0000007e ),
    .LI(\blk00000003/sig0000007f ),
    .O(\blk00000003/sig00000080 )
  );
  MUXCY   \blk00000003/blk00000028  (
    .CI(\blk00000003/sig0000007a ),
    .DI(\blk00000003/sig0000007d ),
    .S(\blk00000003/sig0000007b ),
    .O(\blk00000003/sig00000076 )
  );
  XORCY   \blk00000003/blk00000027  (
    .CI(\blk00000003/sig0000007a ),
    .LI(\blk00000003/sig0000007b ),
    .O(\blk00000003/sig0000007c )
  );
  MUXCY   \blk00000003/blk00000026  (
    .CI(\blk00000003/sig00000076 ),
    .DI(\blk00000003/sig00000079 ),
    .S(\blk00000003/sig00000077 ),
    .O(\blk00000003/sig00000071 )
  );
  XORCY   \blk00000003/blk00000025  (
    .CI(\blk00000003/sig00000076 ),
    .LI(\blk00000003/sig00000077 ),
    .O(\blk00000003/sig00000078 )
  );
  MUXCY   \blk00000003/blk00000024  (
    .CI(\blk00000003/sig00000071 ),
    .DI(\blk00000003/sig00000074 ),
    .S(\blk00000003/sig00000072 ),
    .O(\blk00000003/sig00000075 )
  );
  XORCY   \blk00000003/blk00000023  (
    .CI(\blk00000003/sig00000071 ),
    .LI(\blk00000003/sig00000072 ),
    .O(\blk00000003/sig00000073 )
  );
  MUXCY   \blk00000003/blk00000022  (
    .CI(\blk00000003/sig00000070 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000035 ),
    .O(\blk00000003/sig0000006d )
  );
  MUXCY   \blk00000003/blk00000021  (
    .CI(\blk00000003/sig0000006d ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig0000006e ),
    .O(\blk00000003/sig0000006f )
  );
  MUXCY   \blk00000003/blk00000020  (
    .CI(\blk00000003/sig0000006b ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig0000006c ),
    .O(\NLW_blk00000003/blk00000020_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk0000001f  (
    .CI(\blk00000003/sig00000069 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig0000006a ),
    .O(\blk00000003/sig0000006b )
  );
  MUXCY   \blk00000003/blk0000001e  (
    .CI(\blk00000003/sig00000067 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000068 ),
    .O(\blk00000003/sig00000069 )
  );
  MUXCY   \blk00000003/blk0000001d  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000066 ),
    .O(\blk00000003/sig00000067 )
  );
  MUXCY   \blk00000003/blk0000001c  (
    .CI(\blk00000003/sig00000032 ),
    .DI(\blk00000003/sig00000035 ),
    .S(\blk00000003/sig00000064 ),
    .O(\blk00000003/sig00000061 )
  );
  XORCY   \blk00000003/blk0000001b  (
    .CI(\blk00000003/sig00000032 ),
    .LI(\blk00000003/sig00000064 ),
    .O(\blk00000003/sig00000065 )
  );
  MUXCY   \blk00000003/blk0000001a  (
    .CI(\blk00000003/sig00000061 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000062 ),
    .O(\blk00000003/sig0000005e )
  );
  XORCY   \blk00000003/blk00000019  (
    .CI(\blk00000003/sig00000061 ),
    .LI(\blk00000003/sig00000062 ),
    .O(\blk00000003/sig00000063 )
  );
  MUXCY   \blk00000003/blk00000018  (
    .CI(\blk00000003/sig0000005e ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig0000005f ),
    .O(\blk00000003/sig0000005b )
  );
  XORCY   \blk00000003/blk00000017  (
    .CI(\blk00000003/sig0000005e ),
    .LI(\blk00000003/sig0000005f ),
    .O(\blk00000003/sig00000060 )
  );
  MUXCY   \blk00000003/blk00000016  (
    .CI(\blk00000003/sig0000005b ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig0000005c ),
    .O(\blk00000003/sig00000058 )
  );
  XORCY   \blk00000003/blk00000015  (
    .CI(\blk00000003/sig0000005b ),
    .LI(\blk00000003/sig0000005c ),
    .O(\blk00000003/sig0000005d )
  );
  MUXCY   \blk00000003/blk00000014  (
    .CI(\blk00000003/sig00000058 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000059 ),
    .O(\blk00000003/sig00000056 )
  );
  XORCY   \blk00000003/blk00000013  (
    .CI(\blk00000003/sig00000058 ),
    .LI(\blk00000003/sig00000059 ),
    .O(\blk00000003/sig0000005a )
  );
  XORCY   \blk00000003/blk00000012  (
    .CI(\blk00000003/sig00000056 ),
    .LI(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig00000057 )
  );
  MUXCY   \blk00000003/blk00000011  (
    .CI(\blk00000003/sig00000032 ),
    .DI(\blk00000003/sig00000054 ),
    .S(\blk00000003/sig00000055 ),
    .O(\blk00000003/sig00000051 )
  );
  MUXCY   \blk00000003/blk00000010  (
    .CI(\blk00000003/sig00000051 ),
    .DI(\blk00000003/sig00000052 ),
    .S(\blk00000003/sig00000053 ),
    .O(\blk00000003/sig0000004e )
  );
  MUXCY   \blk00000003/blk0000000f  (
    .CI(\blk00000003/sig0000004e ),
    .DI(\blk00000003/sig0000004f ),
    .S(\blk00000003/sig00000050 ),
    .O(\blk00000003/sig0000004b )
  );
  MUXCY   \blk00000003/blk0000000e  (
    .CI(\blk00000003/sig0000004b ),
    .DI(\blk00000003/sig0000004c ),
    .S(\blk00000003/sig0000004d ),
    .O(\blk00000003/sig00000048 )
  );
  MUXCY   \blk00000003/blk0000000d  (
    .CI(\blk00000003/sig00000048 ),
    .DI(\blk00000003/sig00000049 ),
    .S(\blk00000003/sig0000004a ),
    .O(\blk00000003/sig00000045 )
  );
  MUXCY   \blk00000003/blk0000000c  (
    .CI(\blk00000003/sig00000045 ),
    .DI(\blk00000003/sig00000046 ),
    .S(\blk00000003/sig00000047 ),
    .O(\blk00000003/sig00000042 )
  );
  MUXCY   \blk00000003/blk0000000b  (
    .CI(\blk00000003/sig00000042 ),
    .DI(\blk00000003/sig00000043 ),
    .S(\blk00000003/sig00000044 ),
    .O(\blk00000003/sig0000003e )
  );
  MUXCY   \blk00000003/blk0000000a  (
    .CI(\blk00000003/sig0000003e ),
    .DI(\blk00000003/sig0000003f ),
    .S(\blk00000003/sig00000040 ),
    .O(\blk00000003/sig00000041 )
  );
  MUXCY   \blk00000003/blk00000009  (
    .CI(\blk00000003/sig0000003b ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig0000003c ),
    .O(\blk00000003/sig0000003d )
  );
  MUXCY   \blk00000003/blk00000008  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig0000003a ),
    .O(\blk00000003/sig0000003b )
  );
  MUXCY   \blk00000003/blk00000007  (
    .CI(\blk00000003/sig00000037 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000038 ),
    .O(\blk00000003/sig00000039 )
  );
  MUXCY   \blk00000003/blk00000006  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig00000032 ),
    .S(\blk00000003/sig00000036 ),
    .O(\blk00000003/sig00000037 )
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
