////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: M.81d
//  \   \         Application: netgen
//  /   /         Filename: float_to_fix.v
// /___/   /\     Timestamp: Thu Nov 14 10:36:07 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog ./tmp/_cg\float_to_fix.ngc ./tmp/_cg\float_to_fix.v 
// Device	: 6slx45csg324-2
// Input file	: ./tmp/_cg/float_to_fix.ngc
// Output file	: ./tmp/_cg/float_to_fix.v
// # of Modules	: 1
// Design Name	: float_to_fix
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

module float_to_fix (
a, result
)/* synthesis syn_black_box syn_noprune=1 */;
  input [15 : 0] a;
  output [12 : 0] result;
  
  // synthesis translate_off
  
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
  wire \blk00000003/sig00000034 ;
  wire \blk00000003/sig00000033 ;
  wire \blk00000003/sig00000032 ;
  wire \blk00000003/sig00000031 ;
  wire \blk00000003/sig00000030 ;
  wire \blk00000003/sig0000002f ;
  wire \blk00000003/sig0000002e ;
  wire \blk00000003/sig0000002d ;
  wire \blk00000003/sig0000002c ;
  wire \blk00000003/sig0000002b ;
  wire \blk00000003/sig0000002a ;
  wire \blk00000003/sig00000029 ;
  wire \blk00000003/sig00000028 ;
  wire \blk00000003/sig00000027 ;
  wire \blk00000003/sig00000026 ;
  wire \blk00000003/sig00000025 ;
  wire \blk00000003/sig00000024 ;
  wire \blk00000003/sig00000023 ;
  wire \blk00000003/sig00000022 ;
  wire \blk00000003/sig00000021 ;
  wire \blk00000003/sig00000020 ;
  wire \blk00000003/sig0000001f ;
  wire \blk00000003/sig0000001e ;
  wire NLW_blk00000001_P_UNCONNECTED;
  wire NLW_blk00000002_G_UNCONNECTED;
  wire \NLW_blk00000003/blk0000002b_O_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000010_O_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_O_UNCONNECTED ;
  wire [15 : 0] a_0;
  wire [12 : 0] result_1;
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
    result[12] = result_1[12],
    result[11] = result_1[11],
    result[10] = result_1[10],
    result[9] = result_1[9],
    result[8] = result_1[8],
    result[7] = result_1[7],
    result[6] = result_1[6],
    result[5] = result_1[5],
    result[4] = result_1[4],
    result[3] = result_1[3],
    result[2] = result_1[2],
    result[1] = result_1[1],
    result[0] = result_1[0];
  VCC   blk00000001 (
    .P(NLW_blk00000001_P_UNCONNECTED)
  );
  GND   blk00000002 (
    .G(NLW_blk00000002_G_UNCONNECTED)
  );
  MUXF7   \blk00000003/blk00000072  (
    .I0(\blk00000003/sig0000007c ),
    .I1(\blk00000003/sig0000007b ),
    .S(a_0[13]),
    .O(\blk00000003/sig00000070 )
  );
  LUT6 #(
    .INIT ( 64'h022A82AA466EC6EE ))
  \blk00000003/blk00000071  (
    .I0(a_0[10]),
    .I1(a_0[12]),
    .I2(a_0[11]),
    .I3(a_0[7]),
    .I4(a_0[3]),
    .I5(a_0[6]),
    .O(\blk00000003/sig0000007c )
  );
  LUT5 #(
    .INIT ( 32'hFFFFA2F7 ))
  \blk00000003/blk00000070  (
    .I0(a_0[10]),
    .I1(a_0[3]),
    .I2(a_0[11]),
    .I3(a_0[2]),
    .I4(a_0[12]),
    .O(\blk00000003/sig0000007b )
  );
  MUXF7   \blk00000003/blk0000006f  (
    .I0(\blk00000003/sig0000007a ),
    .I1(\blk00000003/sig00000079 ),
    .S(a_0[11]),
    .O(\blk00000003/sig0000005f )
  );
  LUT3 #(
    .INIT ( 8'h1B ))
  \blk00000003/blk0000006e  (
    .I0(a_0[10]),
    .I1(\blk00000003/sig0000005e ),
    .I2(\blk00000003/sig00000074 ),
    .O(\blk00000003/sig0000007a )
  );
  LUT6 #(
    .INIT ( 64'h45414440EFEBEEEA ))
  \blk00000003/blk0000006d  (
    .I0(a_0[10]),
    .I1(a_0[12]),
    .I2(a_0[13]),
    .I3(a_0[2]),
    .I4(a_0[6]),
    .I5(\blk00000003/sig0000005d ),
    .O(\blk00000003/sig00000079 )
  );
  INV   \blk00000003/blk0000006c  (
    .I(a_0[14]),
    .O(\blk00000003/sig0000002a )
  );
  LUT6 #(
    .INIT ( 64'h0800080000220822 ))
  \blk00000003/blk0000006b  (
    .I0(\blk00000003/sig0000002c ),
    .I1(a_0[12]),
    .I2(a_0[8]),
    .I3(a_0[11]),
    .I4(a_0[9]),
    .I5(a_0[10]),
    .O(\blk00000003/sig00000078 )
  );
  LUT6 #(
    .INIT ( 64'h2005220520052225 ))
  \blk00000003/blk0000006a  (
    .I0(a_0[12]),
    .I1(a_0[0]),
    .I2(a_0[10]),
    .I3(a_0[11]),
    .I4(a_0[1]),
    .I5(a_0[2]),
    .O(\blk00000003/sig00000077 )
  );
  MUXF7   \blk00000003/blk00000069  (
    .I0(\blk00000003/sig00000077 ),
    .I1(\blk00000003/sig00000078 ),
    .S(\blk00000003/sig0000005a ),
    .O(\blk00000003/sig00000068 )
  );
  LUT6 #(
    .INIT ( 64'hDDD0D0D0D0D0D0D0 ))
  \blk00000003/blk00000068  (
    .I0(\blk00000003/sig0000002b ),
    .I1(\blk00000003/sig00000066 ),
    .I2(a_0[14]),
    .I3(a_0[13]),
    .I4(a_0[11]),
    .I5(a_0[12]),
    .O(\blk00000003/sig00000076 )
  );
  LUT6 #(
    .INIT ( 64'h8A0000008A008A00 ))
  \blk00000003/blk00000067  (
    .I0(a_0[13]),
    .I1(\blk00000003/sig00000066 ),
    .I2(\blk00000003/sig0000002b ),
    .I3(a_0[14]),
    .I4(a_0[12]),
    .I5(\blk00000003/sig0000005c ),
    .O(\blk00000003/sig00000075 )
  );
  MUXF7   \blk00000003/blk00000066  (
    .I0(\blk00000003/sig00000075 ),
    .I1(\blk00000003/sig00000076 ),
    .S(\blk00000003/sig00000026 ),
    .O(\blk00000003/sig00000063 )
  );
  LUT6 #(
    .INIT ( 64'hAAAA96A6AAAAAAAA ))
  \blk00000003/blk00000065  (
    .I0(a_0[15]),
    .I1(a_0[10]),
    .I2(a_0[11]),
    .I3(a_0[9]),
    .I4(a_0[12]),
    .I5(a_0[13]),
    .O(\blk00000003/sig00000039 )
  );
  LUT6 #(
    .INIT ( 64'h1101110100FF01FF ))
  \blk00000003/blk00000064  (
    .I0(a_0[12]),
    .I1(a_0[4]),
    .I2(a_0[5]),
    .I3(a_0[10]),
    .I4(a_0[6]),
    .I5(a_0[11]),
    .O(\blk00000003/sig00000069 )
  );
  LUT6 #(
    .INIT ( 64'hEEBFFFBF44155515 ))
  \blk00000003/blk00000063  (
    .I0(a_0[10]),
    .I1(a_0[12]),
    .I2(a_0[7]),
    .I3(a_0[13]),
    .I4(a_0[3]),
    .I5(\blk00000003/sig00000071 ),
    .O(\blk00000003/sig00000072 )
  );
  LUT6 #(
    .INIT ( 64'h7F7F80F8FFFF87FF ))
  \blk00000003/blk00000062  (
    .I0(a_0[11]),
    .I1(a_0[10]),
    .I2(a_0[12]),
    .I3(a_0[3]),
    .I4(a_0[13]),
    .I5(a_0[7]),
    .O(\blk00000003/sig00000074 )
  );
  LUT6 #(
    .INIT ( 64'h1AAAA2221FFFF222 ))
  \blk00000003/blk00000061  (
    .I0(a_0[13]),
    .I1(a_0[2]),
    .I2(a_0[11]),
    .I3(a_0[10]),
    .I4(a_0[12]),
    .I5(a_0[6]),
    .O(\blk00000003/sig00000073 )
  );
  LUT5 #(
    .INIT ( 32'hAA966955 ))
  \blk00000003/blk00000060  (
    .I0(a_0[15]),
    .I1(a_0[11]),
    .I2(a_0[10]),
    .I3(\blk00000003/sig0000006c ),
    .I4(\blk00000003/sig0000006e ),
    .O(\blk00000003/sig00000045 )
  );
  LUT5 #(
    .INIT ( 32'hAA966955 ))
  \blk00000003/blk0000005f  (
    .I0(a_0[15]),
    .I1(a_0[11]),
    .I2(a_0[10]),
    .I3(\blk00000003/sig00000072 ),
    .I4(\blk00000003/sig0000006c ),
    .O(\blk00000003/sig0000004b )
  );
  LUT5 #(
    .INIT ( 32'hAA966955 ))
  \blk00000003/blk0000005e  (
    .I0(a_0[15]),
    .I1(a_0[11]),
    .I2(a_0[10]),
    .I3(\blk00000003/sig0000006a ),
    .I4(\blk00000003/sig0000006d ),
    .O(\blk00000003/sig00000042 )
  );
  LUT5 #(
    .INIT ( 32'hAA966955 ))
  \blk00000003/blk0000005d  (
    .I0(a_0[15]),
    .I1(a_0[11]),
    .I2(a_0[10]),
    .I3(\blk00000003/sig0000006e ),
    .I4(\blk00000003/sig0000006f ),
    .O(\blk00000003/sig0000003f )
  );
  LUT6 #(
    .INIT ( 64'hEAEA157FFFFF95FF ))
  \blk00000003/blk0000005c  (
    .I0(a_0[12]),
    .I1(a_0[11]),
    .I2(a_0[10]),
    .I3(a_0[8]),
    .I4(a_0[13]),
    .I5(a_0[4]),
    .O(\blk00000003/sig00000071 )
  );
  LUT6 #(
    .INIT ( 64'hEAEA157FFFFF95FF ))
  \blk00000003/blk0000005b  (
    .I0(a_0[12]),
    .I1(a_0[11]),
    .I2(a_0[10]),
    .I3(a_0[9]),
    .I4(a_0[13]),
    .I5(a_0[5]),
    .O(\blk00000003/sig0000006b )
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk0000005a  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig0000003d ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[9])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000059  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000040 ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[8])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000058  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000043 ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[7])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000057  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000046 ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[6])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000056  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000049 ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[5])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000055  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig0000004c ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[4])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000054  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig0000004f ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[3])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000053  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000052 ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[2])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000052  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000055 ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[1])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000051  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000037 ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[11])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk00000050  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig0000003a ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[10])
  );
  LUT5 #(
    .INIT ( 32'h54555454 ))
  \blk00000003/blk0000004f  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000058 ),
    .I3(a_0[15]),
    .I4(\blk00000003/sig00000034 ),
    .O(result_1[0])
  );
  LUT5 #(
    .INIT ( 32'hAAAA9AAA ))
  \blk00000003/blk0000004e  (
    .I0(a_0[15]),
    .I1(a_0[12]),
    .I2(a_0[13]),
    .I3(a_0[11]),
    .I4(a_0[10]),
    .O(\blk00000003/sig00000036 )
  );
  LUT6 #(
    .INIT ( 64'hF069D24BB42D960F ))
  \blk00000003/blk0000004d  (
    .I0(a_0[10]),
    .I1(a_0[11]),
    .I2(a_0[15]),
    .I3(\blk00000003/sig00000070 ),
    .I4(\blk00000003/sig0000005d ),
    .I5(\blk00000003/sig0000005e ),
    .O(\blk00000003/sig00000054 )
  );
  LUT6 #(
    .INIT ( 64'h028A46CE139B57DF ))
  \blk00000003/blk0000004c  (
    .I0(a_0[10]),
    .I1(a_0[11]),
    .I2(\blk00000003/sig0000005e ),
    .I3(\blk00000003/sig00000073 ),
    .I4(\blk00000003/sig00000074 ),
    .I5(\blk00000003/sig0000005d ),
    .O(\blk00000003/sig00000060 )
  );
  LUT6 #(
    .INIT ( 64'hF069D24BB42D960F ))
  \blk00000003/blk0000004b  (
    .I0(a_0[10]),
    .I1(a_0[11]),
    .I2(a_0[15]),
    .I3(\blk00000003/sig00000072 ),
    .I4(\blk00000003/sig00000073 ),
    .I5(\blk00000003/sig0000005d ),
    .O(\blk00000003/sig00000051 )
  );
  LUT6 #(
    .INIT ( 64'hF069D24BB42D960F ))
  \blk00000003/blk0000004a  (
    .I0(a_0[10]),
    .I1(a_0[11]),
    .I2(a_0[15]),
    .I3(\blk00000003/sig0000006a ),
    .I4(\blk00000003/sig0000006b ),
    .I5(\blk00000003/sig00000071 ),
    .O(\blk00000003/sig00000048 )
  );
  LUT6 #(
    .INIT ( 64'hF078961EE169870F ))
  \blk00000003/blk00000049  (
    .I0(a_0[11]),
    .I1(a_0[10]),
    .I2(a_0[15]),
    .I3(\blk00000003/sig0000006b ),
    .I4(\blk00000003/sig00000070 ),
    .I5(\blk00000003/sig00000071 ),
    .O(\blk00000003/sig0000004e )
  );
  LUT6 #(
    .INIT ( 64'hA9A6A995A9A6A9A6 ))
  \blk00000003/blk00000048  (
    .I0(a_0[15]),
    .I1(a_0[11]),
    .I2(\blk00000003/sig0000006d ),
    .I3(a_0[10]),
    .I4(a_0[12]),
    .I5(a_0[13]),
    .O(\blk00000003/sig0000003c )
  );
  LUT5 #(
    .INIT ( 32'hEF77CDFF ))
  \blk00000003/blk00000047  (
    .I0(a_0[10]),
    .I1(a_0[12]),
    .I2(a_0[9]),
    .I3(a_0[13]),
    .I4(a_0[11]),
    .O(\blk00000003/sig0000006f )
  );
  LUT6 #(
    .INIT ( 64'hFAF2FFF77FFF7FFF ))
  \blk00000003/blk00000046  (
    .I0(a_0[10]),
    .I1(a_0[8]),
    .I2(a_0[12]),
    .I3(a_0[11]),
    .I4(a_0[7]),
    .I5(a_0[13]),
    .O(\blk00000003/sig0000006e )
  );
  LUT6 #(
    .INIT ( 64'hFAF2FFF77FFF7FFF ))
  \blk00000003/blk00000045  (
    .I0(a_0[10]),
    .I1(a_0[9]),
    .I2(a_0[12]),
    .I3(a_0[11]),
    .I4(a_0[8]),
    .I5(a_0[13]),
    .O(\blk00000003/sig0000006d )
  );
  LUT6 #(
    .INIT ( 64'hDDD7FDDF8882A88A ))
  \blk00000003/blk00000044  (
    .I0(a_0[10]),
    .I1(a_0[13]),
    .I2(a_0[11]),
    .I3(a_0[12]),
    .I4(a_0[6]),
    .I5(\blk00000003/sig0000006b ),
    .O(\blk00000003/sig0000006c )
  );
  LUT6 #(
    .INIT ( 64'hF8FAFDFF2FAF2FAF ))
  \blk00000003/blk00000043  (
    .I0(a_0[10]),
    .I1(a_0[11]),
    .I2(a_0[12]),
    .I3(a_0[7]),
    .I4(a_0[6]),
    .I5(a_0[13]),
    .O(\blk00000003/sig0000006a )
  );
  LUT6 #(
    .INIT ( 64'hFEEEBAAABAAABAAA ))
  \blk00000003/blk00000042  (
    .I0(\blk00000003/sig00000068 ),
    .I1(\blk00000003/sig0000005a ),
    .I2(\blk00000003/sig0000002e ),
    .I3(\blk00000003/sig00000069 ),
    .I4(\blk00000003/sig0000005b ),
    .I5(\blk00000003/sig0000002d ),
    .O(\blk00000003/sig00000061 )
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \blk00000003/blk00000041  (
    .I0(a_0[15]),
    .O(\blk00000003/sig00000033 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFFFFFFFE ))
  \blk00000003/blk00000040  (
    .I0(a_0[9]),
    .I1(a_0[8]),
    .I2(a_0[7]),
    .I3(a_0[6]),
    .I4(a_0[5]),
    .I5(\blk00000003/sig00000067 ),
    .O(\blk00000003/sig00000066 )
  );
  LUT5 #(
    .INIT ( 32'hFFFFFFFE ))
  \blk00000003/blk0000003f  (
    .I0(a_0[4]),
    .I1(a_0[3]),
    .I2(a_0[2]),
    .I3(a_0[1]),
    .I4(a_0[0]),
    .O(\blk00000003/sig00000067 )
  );
  LUT6 #(
    .INIT ( 64'hFFF8FFF8FFFFFFA8 ))
  \blk00000003/blk0000003e  (
    .I0(a_0[15]),
    .I1(\blk00000003/sig00000065 ),
    .I2(\blk00000003/sig00000026 ),
    .I3(\blk00000003/sig00000064 ),
    .I4(\blk00000003/sig0000002b ),
    .I5(\blk00000003/sig00000066 ),
    .O(\blk00000003/sig00000062 )
  );
  LUT5 #(
    .INIT ( 32'h88888000 ))
  \blk00000003/blk0000003d  (
    .I0(a_0[14]),
    .I1(a_0[13]),
    .I2(a_0[10]),
    .I3(a_0[11]),
    .I4(a_0[12]),
    .O(\blk00000003/sig00000065 )
  );
  LUT4 #(
    .INIT ( 16'h1555 ))
  \blk00000003/blk0000003c  (
    .I0(a_0[14]),
    .I1(a_0[13]),
    .I2(a_0[11]),
    .I3(a_0[12]),
    .O(\blk00000003/sig00000064 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk0000003b  (
    .I0(a_0[4]),
    .I1(a_0[5]),
    .I2(a_0[6]),
    .I3(a_0[7]),
    .O(\blk00000003/sig0000002f )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk0000003a  (
    .I0(a_0[0]),
    .I1(a_0[1]),
    .I2(a_0[2]),
    .I3(a_0[3]),
    .O(\blk00000003/sig00000030 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk00000039  (
    .I0(a_0[10]),
    .I1(a_0[11]),
    .I2(a_0[12]),
    .I3(a_0[13]),
    .O(\blk00000003/sig00000028 )
  );
  LUT2 #(
    .INIT ( 4'h7 ))
  \blk00000003/blk00000038  (
    .I0(a_0[11]),
    .I1(a_0[10]),
    .O(\blk00000003/sig0000005c )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000037  (
    .I0(\blk00000003/sig00000060 ),
    .I1(a_0[15]),
    .O(\blk00000003/sig00000057 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk00000036  (
    .I0(a_0[4]),
    .I1(a_0[5]),
    .I2(a_0[6]),
    .I3(a_0[7]),
    .O(\blk00000003/sig00000023 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk00000035  (
    .I0(a_0[0]),
    .I1(a_0[1]),
    .I2(a_0[2]),
    .I3(a_0[3]),
    .O(\blk00000003/sig00000024 )
  );
  LUT2 #(
    .INIT ( 4'h1 ))
  \blk00000003/blk00000034  (
    .I0(a_0[8]),
    .I1(a_0[9]),
    .O(\blk00000003/sig00000021 )
  );
  LUT4 #(
    .INIT ( 16'h9888 ))
  \blk00000003/blk00000033  (
    .I0(\blk00000003/sig00000062 ),
    .I1(\blk00000003/sig00000063 ),
    .I2(\blk00000003/sig00000034 ),
    .I3(a_0[15]),
    .O(result_1[12])
  );
  LUT4 #(
    .INIT ( 16'h8000 ))
  \blk00000003/blk00000032  (
    .I0(a_0[12]),
    .I1(a_0[10]),
    .I2(a_0[13]),
    .I3(a_0[11]),
    .O(\blk00000003/sig00000027 )
  );
  LUT4 #(
    .INIT ( 16'h6A66 ))
  \blk00000003/blk00000031  (
    .I0(a_0[15]),
    .I1(\blk00000003/sig0000005f ),
    .I2(\blk00000003/sig00000060 ),
    .I3(\blk00000003/sig00000061 ),
    .O(\blk00000003/sig00000059 )
  );
  LUT6 #(
    .INIT ( 64'h849CA5BDC6DEE7FF ))
  \blk00000003/blk00000030  (
    .I0(\blk00000003/sig0000005c ),
    .I1(a_0[13]),
    .I2(a_0[12]),
    .I3(a_0[0]),
    .I4(a_0[4]),
    .I5(a_0[8]),
    .O(\blk00000003/sig0000005e )
  );
  LUT6 #(
    .INIT ( 64'h849CA5BDC6DEE7FF ))
  \blk00000003/blk0000002f  (
    .I0(\blk00000003/sig0000005c ),
    .I1(a_0[13]),
    .I2(a_0[12]),
    .I3(a_0[1]),
    .I4(a_0[5]),
    .I5(a_0[9]),
    .O(\blk00000003/sig0000005d )
  );
  LUT3 #(
    .INIT ( 8'h56 ))
  \blk00000003/blk0000002e  (
    .I0(a_0[12]),
    .I1(a_0[11]),
    .I2(a_0[10]),
    .O(\blk00000003/sig0000005b )
  );
  LUT4 #(
    .INIT ( 16'hAAA9 ))
  \blk00000003/blk0000002d  (
    .I0(a_0[13]),
    .I1(a_0[10]),
    .I2(a_0[11]),
    .I3(a_0[12]),
    .O(\blk00000003/sig0000005a )
  );
  MUXCY   \blk00000003/blk0000002c  (
    .CI(\blk00000003/sig0000001f ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000059 ),
    .O(\blk00000003/sig00000056 )
  );
  XORCY   \blk00000003/blk0000002b  (
    .CI(\blk00000003/sig0000001f ),
    .LI(\blk00000003/sig00000059 ),
    .O(\NLW_blk00000003/blk0000002b_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk0000002a  (
    .CI(\blk00000003/sig00000056 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000057 ),
    .O(\blk00000003/sig00000053 )
  );
  XORCY   \blk00000003/blk00000029  (
    .CI(\blk00000003/sig00000056 ),
    .LI(\blk00000003/sig00000057 ),
    .O(\blk00000003/sig00000058 )
  );
  MUXCY   \blk00000003/blk00000028  (
    .CI(\blk00000003/sig00000053 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000054 ),
    .O(\blk00000003/sig00000050 )
  );
  XORCY   \blk00000003/blk00000027  (
    .CI(\blk00000003/sig00000053 ),
    .LI(\blk00000003/sig00000054 ),
    .O(\blk00000003/sig00000055 )
  );
  MUXCY   \blk00000003/blk00000026  (
    .CI(\blk00000003/sig00000050 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000051 ),
    .O(\blk00000003/sig0000004d )
  );
  XORCY   \blk00000003/blk00000025  (
    .CI(\blk00000003/sig00000050 ),
    .LI(\blk00000003/sig00000051 ),
    .O(\blk00000003/sig00000052 )
  );
  MUXCY   \blk00000003/blk00000024  (
    .CI(\blk00000003/sig0000004d ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig0000004e ),
    .O(\blk00000003/sig0000004a )
  );
  XORCY   \blk00000003/blk00000023  (
    .CI(\blk00000003/sig0000004d ),
    .LI(\blk00000003/sig0000004e ),
    .O(\blk00000003/sig0000004f )
  );
  MUXCY   \blk00000003/blk00000022  (
    .CI(\blk00000003/sig0000004a ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig0000004b ),
    .O(\blk00000003/sig00000047 )
  );
  XORCY   \blk00000003/blk00000021  (
    .CI(\blk00000003/sig0000004a ),
    .LI(\blk00000003/sig0000004b ),
    .O(\blk00000003/sig0000004c )
  );
  MUXCY   \blk00000003/blk00000020  (
    .CI(\blk00000003/sig00000047 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000048 ),
    .O(\blk00000003/sig00000044 )
  );
  XORCY   \blk00000003/blk0000001f  (
    .CI(\blk00000003/sig00000047 ),
    .LI(\blk00000003/sig00000048 ),
    .O(\blk00000003/sig00000049 )
  );
  MUXCY   \blk00000003/blk0000001e  (
    .CI(\blk00000003/sig00000044 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000045 ),
    .O(\blk00000003/sig00000041 )
  );
  XORCY   \blk00000003/blk0000001d  (
    .CI(\blk00000003/sig00000044 ),
    .LI(\blk00000003/sig00000045 ),
    .O(\blk00000003/sig00000046 )
  );
  MUXCY   \blk00000003/blk0000001c  (
    .CI(\blk00000003/sig00000041 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000042 ),
    .O(\blk00000003/sig0000003e )
  );
  XORCY   \blk00000003/blk0000001b  (
    .CI(\blk00000003/sig00000041 ),
    .LI(\blk00000003/sig00000042 ),
    .O(\blk00000003/sig00000043 )
  );
  MUXCY   \blk00000003/blk0000001a  (
    .CI(\blk00000003/sig0000003e ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig0000003f ),
    .O(\blk00000003/sig0000003b )
  );
  XORCY   \blk00000003/blk00000019  (
    .CI(\blk00000003/sig0000003e ),
    .LI(\blk00000003/sig0000003f ),
    .O(\blk00000003/sig00000040 )
  );
  MUXCY   \blk00000003/blk00000018  (
    .CI(\blk00000003/sig0000003b ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig0000003c ),
    .O(\blk00000003/sig00000038 )
  );
  XORCY   \blk00000003/blk00000017  (
    .CI(\blk00000003/sig0000003b ),
    .LI(\blk00000003/sig0000003c ),
    .O(\blk00000003/sig0000003d )
  );
  MUXCY   \blk00000003/blk00000016  (
    .CI(\blk00000003/sig00000038 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000039 ),
    .O(\blk00000003/sig00000035 )
  );
  XORCY   \blk00000003/blk00000015  (
    .CI(\blk00000003/sig00000038 ),
    .LI(\blk00000003/sig00000039 ),
    .O(\blk00000003/sig0000003a )
  );
  MUXCY   \blk00000003/blk00000014  (
    .CI(\blk00000003/sig00000035 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000036 ),
    .O(\blk00000003/sig00000032 )
  );
  XORCY   \blk00000003/blk00000013  (
    .CI(\blk00000003/sig00000035 ),
    .LI(\blk00000003/sig00000036 ),
    .O(\blk00000003/sig00000037 )
  );
  MUXCY   \blk00000003/blk00000012  (
    .CI(\blk00000003/sig00000032 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000033 ),
    .O(\blk00000003/sig00000031 )
  );
  XORCY   \blk00000003/blk00000011  (
    .CI(\blk00000003/sig00000032 ),
    .LI(\blk00000003/sig00000033 ),
    .O(\blk00000003/sig00000034 )
  );
  XORCY   \blk00000003/blk00000010  (
    .CI(\blk00000003/sig00000031 ),
    .LI(\blk00000003/sig0000001e ),
    .O(\NLW_blk00000003/blk00000010_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk0000000f  (
    .CI(\blk00000003/sig0000001f ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000030 ),
    .O(\blk00000003/sig0000002e )
  );
  MUXCY   \blk00000003/blk0000000e  (
    .CI(\blk00000003/sig0000002e ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig0000002f ),
    .O(\blk00000003/sig0000002c )
  );
  MUXCY   \blk00000003/blk0000000d  (
    .CI(\blk00000003/sig0000002c ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig0000001e ),
    .O(\blk00000003/sig0000002d )
  );
  MUXCY   \blk00000003/blk0000000c  (
    .CI(\blk00000003/sig00000029 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig0000002a ),
    .O(\blk00000003/sig0000002b )
  );
  MUXCY   \blk00000003/blk0000000b  (
    .CI(\blk00000003/sig0000001f ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000028 ),
    .O(\blk00000003/sig00000029 )
  );
  MUXCY   \blk00000003/blk0000000a  (
    .CI(\blk00000003/sig0000001f ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000027 ),
    .O(\blk00000003/sig00000025 )
  );
  MUXCY   \blk00000003/blk00000009  (
    .CI(\blk00000003/sig00000025 ),
    .DI(\blk00000003/sig0000001e ),
    .S(a_0[14]),
    .O(\blk00000003/sig00000026 )
  );
  MUXCY   \blk00000003/blk00000008  (
    .CI(\blk00000003/sig0000001f ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000024 ),
    .O(\blk00000003/sig00000022 )
  );
  MUXCY   \blk00000003/blk00000007  (
    .CI(\blk00000003/sig00000022 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000023 ),
    .O(\blk00000003/sig00000020 )
  );
  MUXCY   \blk00000003/blk00000006  (
    .CI(\blk00000003/sig00000020 ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000021 ),
    .O(\NLW_blk00000003/blk00000006_O_UNCONNECTED )
  );
  VCC   \blk00000003/blk00000005  (
    .P(\blk00000003/sig0000001f )
  );
  GND   \blk00000003/blk00000004  (
    .G(\blk00000003/sig0000001e )
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
