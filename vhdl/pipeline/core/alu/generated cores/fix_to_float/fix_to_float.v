////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: M.81d
//  \   \         Application: netgen
//  /   /         Filename: fix_to_float.v
// /___/   /\     Timestamp: Wed Nov 13 15:38:14 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog ./tmp/_cg\fix_to_float.ngc ./tmp/_cg\fix_to_float.v 
// Device	: 6slx16csg324-2
// Input file	: ./tmp/_cg/fix_to_float.ngc
// Output file	: ./tmp/_cg/fix_to_float.v
// # of Modules	: 1
// Design Name	: fix_to_float
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

module fix_to_float (
a, result
)/* synthesis syn_black_box syn_noprune=1 */;
  input [12 : 0] a;
  output [15 : 0] result;
  
  // synthesis translate_off
  
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
  wire \blk00000003/sig0000001d ;
  wire NLW_blk00000001_P_UNCONNECTED;
  wire NLW_blk00000002_G_UNCONNECTED;
  wire \NLW_blk00000003/blk00000024_O_UNCONNECTED ;
  wire [12 : 12] NlwRenamedSignal_a;
  wire [11 : 0] a_0;
  wire [10 : 10] NlwRenamedSig_OI_result;
  assign
    NlwRenamedSignal_a[12] = a[12],
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
    result[15] = NlwRenamedSignal_a[12],
    result[10] = NlwRenamedSig_OI_result[10];
  VCC   blk00000001 (
    .P(NLW_blk00000001_P_UNCONNECTED)
  );
  GND   blk00000002 (
    .G(NLW_blk00000002_G_UNCONNECTED)
  );
  MUXF7   \blk00000003/blk00000089  (
    .I0(\blk00000003/sig00000092 ),
    .I1(\blk00000003/sig00000091 ),
    .S(\blk00000003/sig00000053 ),
    .O(\blk00000003/sig0000008b )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \blk00000003/blk00000088  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig0000007e ),
    .I2(\blk00000003/sig0000002d ),
    .I3(\blk00000003/sig00000039 ),
    .O(\blk00000003/sig00000092 )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \blk00000003/blk00000087  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig0000007e ),
    .I2(\blk00000003/sig00000033 ),
    .I3(\blk00000003/sig0000003f ),
    .O(\blk00000003/sig00000091 )
  );
  INV   \blk00000003/blk00000086  (
    .I(\blk00000003/sig0000004a ),
    .O(\blk00000003/sig00000059 )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \blk00000003/blk00000085  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig0000007e ),
    .I2(\blk00000003/sig00000039 ),
    .I3(\blk00000003/sig00000045 ),
    .O(\blk00000003/sig00000090 )
  );
  LUT6 #(
    .INIT ( 64'h5410FEBA54105410 ))
  \blk00000003/blk00000084  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000055 ),
    .I2(\blk00000003/sig00000033 ),
    .I3(\blk00000003/sig0000003f ),
    .I4(\blk00000003/sig00000058 ),
    .I5(\blk00000003/sig0000004a ),
    .O(\blk00000003/sig0000008f )
  );
  MUXF7   \blk00000003/blk00000083  (
    .I0(\blk00000003/sig0000008f ),
    .I1(\blk00000003/sig00000090 ),
    .S(\blk00000003/sig00000053 ),
    .O(\blk00000003/sig00000081 )
  );
  LUT6 #(
    .INIT ( 64'h00015555FFFFFFFF ))
  \blk00000003/blk00000082  (
    .I0(\blk00000003/sig0000005a ),
    .I1(\blk00000003/sig00000053 ),
    .I2(\blk00000003/sig00000050 ),
    .I3(\blk00000003/sig0000006b ),
    .I4(\blk00000003/sig00000058 ),
    .I5(\blk00000003/sig0000004d ),
    .O(result[14])
  );
  LUT5 #(
    .INIT ( 32'h00010101 ))
  \blk00000003/blk00000081  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig0000006b ),
    .I2(\blk00000003/sig00000053 ),
    .I3(\blk00000003/sig0000005a ),
    .I4(\blk00000003/sig0000004d ),
    .O(\blk00000003/sig0000008e )
  );
  LUT5 #(
    .INIT ( 32'h07070770 ))
  \blk00000003/blk00000080  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig0000005a ),
    .I2(\blk00000003/sig00000053 ),
    .I3(\blk00000003/sig00000050 ),
    .I4(\blk00000003/sig0000006b ),
    .O(result[11])
  );
  LUT6 #(
    .INIT ( 64'h7070707070707007 ))
  \blk00000003/blk0000007f  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig0000005a ),
    .I2(\blk00000003/sig0000007e ),
    .I3(\blk00000003/sig00000050 ),
    .I4(\blk00000003/sig0000006b ),
    .I5(\blk00000003/sig00000053 ),
    .O(result[12])
  );
  LUT4 #(
    .INIT ( 16'h0770 ))
  \blk00000003/blk0000007e  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig0000005a ),
    .I2(\blk00000003/sig00000050 ),
    .I3(\blk00000003/sig0000006b ),
    .O(NlwRenamedSig_OI_result[10])
  );
  LUT5 #(
    .INIT ( 32'h22200200 ))
  \blk00000003/blk0000007d  (
    .I0(\blk00000003/sig00000048 ),
    .I1(\blk00000003/sig00000053 ),
    .I2(\blk00000003/sig0000004d ),
    .I3(\blk00000003/sig00000055 ),
    .I4(\blk00000003/sig00000058 ),
    .O(\blk00000003/sig0000008c )
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk0000007c  (
    .I0(\blk00000003/sig00000067 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[1])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk0000007b  (
    .I0(\blk00000003/sig00000064 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[2])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk0000007a  (
    .I0(\blk00000003/sig00000069 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[0])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk00000079  (
    .I0(\blk00000003/sig0000005d ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[4])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk00000078  (
    .I0(\blk00000003/sig00000079 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[5])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk00000077  (
    .I0(\blk00000003/sig00000061 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[3])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk00000076  (
    .I0(\blk00000003/sig00000074 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[7])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk00000075  (
    .I0(\blk00000003/sig00000071 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[8])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk00000074  (
    .I0(\blk00000003/sig00000077 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[6])
  );
  LUT3 #(
    .INIT ( 8'h2A ))
  \blk00000003/blk00000073  (
    .I0(\blk00000003/sig0000006e ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig0000005a ),
    .O(result[9])
  );
  LUT6 #(
    .INIT ( 64'h7575557525250525 ))
  \blk00000003/blk00000072  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig0000005a ),
    .I2(\blk00000003/sig0000007e ),
    .I3(\blk00000003/sig00000087 ),
    .I4(NlwRenamedSig_OI_result[10]),
    .I5(\blk00000003/sig0000008e ),
    .O(result[13])
  );
  LUT6 #(
    .INIT ( 64'h4501EFAB45014501 ))
  \blk00000003/blk00000071  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000055 ),
    .I2(\blk00000003/sig0000008d ),
    .I3(\blk00000003/sig0000007b ),
    .I4(\blk00000003/sig00000058 ),
    .I5(\blk00000003/sig0000007a ),
    .O(\blk00000003/sig0000006d )
  );
  LUT6 #(
    .INIT ( 64'h028A139B46CE57DF ))
  \blk00000003/blk00000070  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig00000053 ),
    .I2(\blk00000003/sig0000002d ),
    .I3(\blk00000003/sig00000033 ),
    .I4(\blk00000003/sig0000002a ),
    .I5(\blk00000003/sig00000030 ),
    .O(\blk00000003/sig0000008d )
  );
  LUT5 #(
    .INIT ( 32'h01010100 ))
  \blk00000003/blk0000006f  (
    .I0(\blk00000003/sig00000053 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig00000055 ),
    .I3(\blk00000003/sig0000004a ),
    .I4(\blk00000003/sig00000088 ),
    .O(\blk00000003/sig00000023 )
  );
  LUT4 #(
    .INIT ( 16'hFFFE ))
  \blk00000003/blk0000006e  (
    .I0(\blk00000003/sig00000053 ),
    .I1(\blk00000003/sig0000004d ),
    .I2(\blk00000003/sig00000055 ),
    .I3(\blk00000003/sig00000086 ),
    .O(\blk00000003/sig00000020 )
  );
  LUT6 #(
    .INIT ( 64'h5555555511110010 ))
  \blk00000003/blk0000006d  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000050 ),
    .I2(\blk00000003/sig0000007d ),
    .I3(\blk00000003/sig00000055 ),
    .I4(\blk00000003/sig0000008c ),
    .I5(\blk00000003/sig00000085 ),
    .O(\blk00000003/sig00000060 )
  );
  LUT6 #(
    .INIT ( 64'h5444545510001011 ))
  \blk00000003/blk0000006c  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000055 ),
    .I2(\blk00000003/sig0000007d ),
    .I3(\blk00000003/sig00000050 ),
    .I4(\blk00000003/sig00000084 ),
    .I5(\blk00000003/sig0000007c ),
    .O(\blk00000003/sig0000005c )
  );
  LUT5 #(
    .INIT ( 32'h5454FE54 ))
  \blk00000003/blk0000006b  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000082 ),
    .I2(\blk00000003/sig0000008b ),
    .I3(\blk00000003/sig0000007c ),
    .I4(\blk00000003/sig00000058 ),
    .O(\blk00000003/sig00000070 )
  );
  LUT6 #(
    .INIT ( 64'h1111115100000040 ))
  \blk00000003/blk0000006a  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000055 ),
    .I2(\blk00000003/sig0000004a ),
    .I3(\blk00000003/sig00000050 ),
    .I4(\blk00000003/sig00000053 ),
    .I5(\blk00000003/sig0000007f ),
    .O(\blk00000003/sig00000063 )
  );
  LUT3 #(
    .INIT ( 8'h10 ))
  \blk00000003/blk00000069  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000055 ),
    .I2(\blk00000003/sig0000007a ),
    .O(\blk00000003/sig00000066 )
  );
  LUT3 #(
    .INIT ( 8'h10 ))
  \blk00000003/blk00000068  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000055 ),
    .I2(\blk00000003/sig0000007c ),
    .O(\blk00000003/sig00000068 )
  );
  LUT4 #(
    .INIT ( 16'h5410 ))
  \blk00000003/blk00000067  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000055 ),
    .I2(\blk00000003/sig0000007b ),
    .I3(\blk00000003/sig0000007a ),
    .O(\blk00000003/sig00000078 )
  );
  LUT6 #(
    .INIT ( 64'h01010100ABABABAA ))
  \blk00000003/blk00000066  (
    .I0(\blk00000003/sig00000055 ),
    .I1(\blk00000003/sig0000002a ),
    .I2(\blk00000003/sig00000027 ),
    .I3(\blk00000003/sig00000030 ),
    .I4(\blk00000003/sig0000002d ),
    .I5(\blk00000003/sig0000008a ),
    .O(\blk00000003/sig00000051 )
  );
  LUT4 #(
    .INIT ( 16'hFFAB ))
  \blk00000003/blk00000065  (
    .I0(\blk00000003/sig00000033 ),
    .I1(\blk00000003/sig00000039 ),
    .I2(\blk00000003/sig0000003c ),
    .I3(\blk00000003/sig00000036 ),
    .O(\blk00000003/sig0000008a )
  );
  LUT6 #(
    .INIT ( 64'h11110100BBBBABAA ))
  \blk00000003/blk00000064  (
    .I0(\blk00000003/sig00000055 ),
    .I1(\blk00000003/sig00000027 ),
    .I2(\blk00000003/sig0000002d ),
    .I3(\blk00000003/sig00000030 ),
    .I4(\blk00000003/sig0000002a ),
    .I5(\blk00000003/sig00000089 ),
    .O(\blk00000003/sig0000004e )
  );
  LUT4 #(
    .INIT ( 16'hFF45 ))
  \blk00000003/blk00000063  (
    .I0(\blk00000003/sig00000036 ),
    .I1(\blk00000003/sig00000039 ),
    .I2(\blk00000003/sig0000003c ),
    .I3(\blk00000003/sig00000033 ),
    .O(\blk00000003/sig00000089 )
  );
  LUT4 #(
    .INIT ( 16'h51FB ))
  \blk00000003/blk00000062  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig00000025 ),
    .I2(\blk00000003/sig00000048 ),
    .I3(\blk00000003/sig00000024 ),
    .O(\blk00000003/sig00000088 )
  );
  LUT2 #(
    .INIT ( 4'h1 ))
  \blk00000003/blk00000061  (
    .I0(\blk00000003/sig00000053 ),
    .I1(\blk00000003/sig00000050 ),
    .O(\blk00000003/sig00000087 )
  );
  LUT6 #(
    .INIT ( 64'h51DD51FF51DD51DD ))
  \blk00000003/blk00000060  (
    .I0(\blk00000003/sig00000048 ),
    .I1(\blk00000003/sig00000050 ),
    .I2(\blk00000003/sig00000024 ),
    .I3(\blk00000003/sig0000004a ),
    .I4(\blk00000003/sig00000045 ),
    .I5(\blk00000003/sig00000025 ),
    .O(\blk00000003/sig00000086 )
  );
  LUT6 #(
    .INIT ( 64'h22A800A822200020 ))
  \blk00000003/blk0000005f  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig0000007e ),
    .I2(\blk00000003/sig0000003f ),
    .I3(\blk00000003/sig00000053 ),
    .I4(\blk00000003/sig00000045 ),
    .I5(\blk00000003/sig0000004a ),
    .O(\blk00000003/sig00000085 )
  );
  LUT3 #(
    .INIT ( 8'h27 ))
  \blk00000003/blk0000005e  (
    .I0(\blk00000003/sig00000053 ),
    .I1(\blk00000003/sig0000003f ),
    .I2(\blk00000003/sig00000039 ),
    .O(\blk00000003/sig00000084 )
  );
  LUT6 #(
    .INIT ( 64'hAAEAAFEF00400545 ))
  \blk00000003/blk0000005d  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig0000007d ),
    .I2(\blk00000003/sig0000007e ),
    .I3(\blk00000003/sig0000004d ),
    .I4(\blk00000003/sig00000083 ),
    .I5(\blk00000003/sig00000081 ),
    .O(\blk00000003/sig00000073 )
  );
  LUT5 #(
    .INIT ( 32'hA2A7F2F7 ))
  \blk00000003/blk0000005c  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000048 ),
    .I2(\blk00000003/sig00000053 ),
    .I3(\blk00000003/sig00000030 ),
    .I4(\blk00000003/sig00000036 ),
    .O(\blk00000003/sig00000083 )
  );
  LUT6 #(
    .INIT ( 64'hA8AAA88820222000 ))
  \blk00000003/blk0000005b  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig0000007e ),
    .I2(\blk00000003/sig00000036 ),
    .I3(\blk00000003/sig00000053 ),
    .I4(\blk00000003/sig00000030 ),
    .I5(\blk00000003/sig0000007d ),
    .O(\blk00000003/sig00000082 )
  );
  LUT4 #(
    .INIT ( 16'h222E ))
  \blk00000003/blk0000005a  (
    .I0(\blk00000003/sig00000081 ),
    .I1(\blk00000003/sig00000050 ),
    .I2(\blk00000003/sig0000004d ),
    .I3(\blk00000003/sig00000080 ),
    .O(\blk00000003/sig00000076 )
  );
  LUT6 #(
    .INIT ( 64'h028A139B46CE57DF ))
  \blk00000003/blk00000059  (
    .I0(\blk00000003/sig00000053 ),
    .I1(\blk00000003/sig0000007e ),
    .I2(\blk00000003/sig0000003c ),
    .I3(\blk00000003/sig00000048 ),
    .I4(\blk00000003/sig00000036 ),
    .I5(\blk00000003/sig00000042 ),
    .O(\blk00000003/sig00000080 )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk00000058  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig00000053 ),
    .I2(\blk00000003/sig00000042 ),
    .I3(\blk00000003/sig00000048 ),
    .I4(\blk00000003/sig00000045 ),
    .I5(\blk00000003/sig0000003f ),
    .O(\blk00000003/sig0000007f )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk00000057  (
    .I0(\blk00000003/sig00000045 ),
    .I1(\blk00000003/sig00000048 ),
    .I2(\blk00000003/sig0000003f ),
    .I3(\blk00000003/sig00000042 ),
    .O(\blk00000003/sig00000057 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk00000056  (
    .I0(\blk00000003/sig00000033 ),
    .I1(\blk00000003/sig00000036 ),
    .I2(\blk00000003/sig00000039 ),
    .I3(\blk00000003/sig0000003c ),
    .O(\blk00000003/sig00000056 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \blk00000003/blk00000055  (
    .I0(\blk00000003/sig00000027 ),
    .I1(\blk00000003/sig0000002a ),
    .I2(\blk00000003/sig0000002d ),
    .I3(\blk00000003/sig00000030 ),
    .O(\blk00000003/sig00000054 )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \blk00000003/blk00000054  (
    .I0(\blk00000003/sig0000005a ),
    .I1(\blk00000003/sig00000058 ),
    .O(\blk00000003/sig0000004c )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \blk00000003/blk00000053  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000055 ),
    .O(\blk00000003/sig0000004b )
  );
  LUT3 #(
    .INIT ( 8'hD8 ))
  \blk00000003/blk00000052  (
    .I0(\blk00000003/sig0000004d ),
    .I1(\blk00000003/sig00000058 ),
    .I2(\blk00000003/sig00000055 ),
    .O(\blk00000003/sig0000007e )
  );
  LUT5 #(
    .INIT ( 32'h01010100 ))
  \blk00000003/blk00000051  (
    .I0(\blk00000003/sig00000058 ),
    .I1(\blk00000003/sig00000042 ),
    .I2(\blk00000003/sig0000003f ),
    .I3(\blk00000003/sig00000048 ),
    .I4(\blk00000003/sig00000045 ),
    .O(\blk00000003/sig00000052 )
  );
  LUT5 #(
    .INIT ( 32'h11110010 ))
  \blk00000003/blk00000050  (
    .I0(\blk00000003/sig00000058 ),
    .I1(\blk00000003/sig0000003f ),
    .I2(\blk00000003/sig00000048 ),
    .I3(\blk00000003/sig00000045 ),
    .I4(\blk00000003/sig00000042 ),
    .O(\blk00000003/sig0000004f )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000004f  (
    .I0(a_0[9]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig0000002f )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000004e  (
    .I0(a_0[8]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig00000032 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000004d  (
    .I0(a_0[7]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig00000035 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000004c  (
    .I0(a_0[6]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig00000038 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000004b  (
    .I0(a_0[5]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig0000003b )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk0000004a  (
    .I0(a_0[4]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig0000003e )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000049  (
    .I0(a_0[3]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig00000041 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000048  (
    .I0(a_0[2]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig00000044 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000047  (
    .I0(a_0[1]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig00000047 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000046  (
    .I0(a_0[11]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig00000029 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000045  (
    .I0(a_0[10]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig0000002c )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000003/blk00000044  (
    .I0(a_0[0]),
    .I1(NlwRenamedSignal_a[12]),
    .O(\blk00000003/sig00000049 )
  );
  LUT3 #(
    .INIT ( 8'hD8 ))
  \blk00000003/blk00000043  (
    .I0(\blk00000003/sig00000053 ),
    .I1(\blk00000003/sig00000042 ),
    .I2(\blk00000003/sig0000003c ),
    .O(\blk00000003/sig0000007d )
  );
  LUT5 #(
    .INIT ( 32'h73625140 ))
  \blk00000003/blk00000042  (
    .I0(\blk00000003/sig00000053 ),
    .I1(\blk00000003/sig00000050 ),
    .I2(\blk00000003/sig00000048 ),
    .I3(\blk00000003/sig00000045 ),
    .I4(\blk00000003/sig0000004a ),
    .O(\blk00000003/sig0000007c )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk00000041  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig00000053 ),
    .I2(\blk00000003/sig00000039 ),
    .I3(\blk00000003/sig0000003f ),
    .I4(\blk00000003/sig0000003c ),
    .I5(\blk00000003/sig00000036 ),
    .O(\blk00000003/sig0000007b )
  );
  LUT6 #(
    .INIT ( 64'hFD75B931EC64A820 ))
  \blk00000003/blk00000040  (
    .I0(\blk00000003/sig00000050 ),
    .I1(\blk00000003/sig00000053 ),
    .I2(\blk00000003/sig00000045 ),
    .I3(\blk00000003/sig0000004a ),
    .I4(\blk00000003/sig00000048 ),
    .I5(\blk00000003/sig00000042 ),
    .O(\blk00000003/sig0000007a )
  );
  MUXCY   \blk00000003/blk0000003f  (
    .CI(\blk00000003/sig0000005e ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000078 ),
    .O(\blk00000003/sig00000075 )
  );
  XORCY   \blk00000003/blk0000003e  (
    .CI(\blk00000003/sig0000005e ),
    .LI(\blk00000003/sig00000078 ),
    .O(\blk00000003/sig00000079 )
  );
  MUXCY   \blk00000003/blk0000003d  (
    .CI(\blk00000003/sig00000075 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000076 ),
    .O(\blk00000003/sig00000072 )
  );
  XORCY   \blk00000003/blk0000003c  (
    .CI(\blk00000003/sig00000075 ),
    .LI(\blk00000003/sig00000076 ),
    .O(\blk00000003/sig00000077 )
  );
  MUXCY   \blk00000003/blk0000003b  (
    .CI(\blk00000003/sig00000072 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000073 ),
    .O(\blk00000003/sig0000006f )
  );
  XORCY   \blk00000003/blk0000003a  (
    .CI(\blk00000003/sig00000072 ),
    .LI(\blk00000003/sig00000073 ),
    .O(\blk00000003/sig00000074 )
  );
  MUXCY   \blk00000003/blk00000039  (
    .CI(\blk00000003/sig0000006f ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000070 ),
    .O(\blk00000003/sig0000006c )
  );
  XORCY   \blk00000003/blk00000038  (
    .CI(\blk00000003/sig0000006f ),
    .LI(\blk00000003/sig00000070 ),
    .O(\blk00000003/sig00000071 )
  );
  MUXCY   \blk00000003/blk00000037  (
    .CI(\blk00000003/sig0000006c ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000006d ),
    .O(\blk00000003/sig0000006a )
  );
  XORCY   \blk00000003/blk00000036  (
    .CI(\blk00000003/sig0000006c ),
    .LI(\blk00000003/sig0000006d ),
    .O(\blk00000003/sig0000006e )
  );
  XORCY   \blk00000003/blk00000035  (
    .CI(\blk00000003/sig0000006a ),
    .LI(\blk00000003/sig0000001e ),
    .O(\blk00000003/sig0000006b )
  );
  MUXCY   \blk00000003/blk00000034  (
    .CI(\blk00000003/sig00000021 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000068 ),
    .O(\blk00000003/sig00000065 )
  );
  XORCY   \blk00000003/blk00000033  (
    .CI(\blk00000003/sig00000021 ),
    .LI(\blk00000003/sig00000068 ),
    .O(\blk00000003/sig00000069 )
  );
  MUXCY   \blk00000003/blk00000032  (
    .CI(\blk00000003/sig00000065 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000066 ),
    .O(\blk00000003/sig00000062 )
  );
  XORCY   \blk00000003/blk00000031  (
    .CI(\blk00000003/sig00000065 ),
    .LI(\blk00000003/sig00000066 ),
    .O(\blk00000003/sig00000067 )
  );
  MUXCY   \blk00000003/blk00000030  (
    .CI(\blk00000003/sig00000062 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000063 ),
    .O(\blk00000003/sig0000005f )
  );
  XORCY   \blk00000003/blk0000002f  (
    .CI(\blk00000003/sig00000062 ),
    .LI(\blk00000003/sig00000063 ),
    .O(\blk00000003/sig00000064 )
  );
  MUXCY   \blk00000003/blk0000002e  (
    .CI(\blk00000003/sig0000005f ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000060 ),
    .O(\blk00000003/sig0000005b )
  );
  XORCY   \blk00000003/blk0000002d  (
    .CI(\blk00000003/sig0000005f ),
    .LI(\blk00000003/sig00000060 ),
    .O(\blk00000003/sig00000061 )
  );
  MUXCY   \blk00000003/blk0000002c  (
    .CI(\blk00000003/sig0000005b ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000005c ),
    .O(\blk00000003/sig0000005e )
  );
  XORCY   \blk00000003/blk0000002b  (
    .CI(\blk00000003/sig0000005b ),
    .LI(\blk00000003/sig0000005c ),
    .O(\blk00000003/sig0000005d )
  );
  MUXCY   \blk00000003/blk0000002a  (
    .CI(\blk00000003/sig00000058 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000059 ),
    .O(\blk00000003/sig0000005a )
  );
  MUXCY   \blk00000003/blk00000029  (
    .CI(\blk00000003/sig0000001e ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000057 ),
    .O(\blk00000003/sig00000058 )
  );
  MUXCY   \blk00000003/blk00000028  (
    .CI(\blk00000003/sig00000055 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000056 ),
    .O(\blk00000003/sig0000004d )
  );
  MUXCY   \blk00000003/blk00000027  (
    .CI(\blk00000003/sig0000001e ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000054 ),
    .O(\blk00000003/sig00000055 )
  );
  MUXF7   \blk00000003/blk00000026  (
    .I0(\blk00000003/sig00000051 ),
    .I1(\blk00000003/sig00000052 ),
    .S(\blk00000003/sig0000004d ),
    .O(\blk00000003/sig00000053 )
  );
  MUXF7   \blk00000003/blk00000025  (
    .I0(\blk00000003/sig0000004e ),
    .I1(\blk00000003/sig0000004f ),
    .S(\blk00000003/sig0000004d ),
    .O(\blk00000003/sig00000050 )
  );
  MUXF7   \blk00000003/blk00000024  (
    .I0(\blk00000003/sig0000004b ),
    .I1(\blk00000003/sig0000004c ),
    .S(\blk00000003/sig0000004d ),
    .O(\NLW_blk00000003/blk00000024_O_UNCONNECTED )
  );
  MUXCY   \blk00000003/blk00000023  (
    .CI(NlwRenamedSignal_a[12]),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000049 ),
    .O(\blk00000003/sig00000046 )
  );
  XORCY   \blk00000003/blk00000022  (
    .CI(NlwRenamedSignal_a[12]),
    .LI(\blk00000003/sig00000049 ),
    .O(\blk00000003/sig0000004a )
  );
  MUXCY   \blk00000003/blk00000021  (
    .CI(\blk00000003/sig00000046 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000047 ),
    .O(\blk00000003/sig00000043 )
  );
  XORCY   \blk00000003/blk00000020  (
    .CI(\blk00000003/sig00000046 ),
    .LI(\blk00000003/sig00000047 ),
    .O(\blk00000003/sig00000048 )
  );
  MUXCY   \blk00000003/blk0000001f  (
    .CI(\blk00000003/sig00000043 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000044 ),
    .O(\blk00000003/sig00000040 )
  );
  XORCY   \blk00000003/blk0000001e  (
    .CI(\blk00000003/sig00000043 ),
    .LI(\blk00000003/sig00000044 ),
    .O(\blk00000003/sig00000045 )
  );
  MUXCY   \blk00000003/blk0000001d  (
    .CI(\blk00000003/sig00000040 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000041 ),
    .O(\blk00000003/sig0000003d )
  );
  XORCY   \blk00000003/blk0000001c  (
    .CI(\blk00000003/sig00000040 ),
    .LI(\blk00000003/sig00000041 ),
    .O(\blk00000003/sig00000042 )
  );
  MUXCY   \blk00000003/blk0000001b  (
    .CI(\blk00000003/sig0000003d ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000003e ),
    .O(\blk00000003/sig0000003a )
  );
  XORCY   \blk00000003/blk0000001a  (
    .CI(\blk00000003/sig0000003d ),
    .LI(\blk00000003/sig0000003e ),
    .O(\blk00000003/sig0000003f )
  );
  MUXCY   \blk00000003/blk00000019  (
    .CI(\blk00000003/sig0000003a ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000003b ),
    .O(\blk00000003/sig00000037 )
  );
  XORCY   \blk00000003/blk00000018  (
    .CI(\blk00000003/sig0000003a ),
    .LI(\blk00000003/sig0000003b ),
    .O(\blk00000003/sig0000003c )
  );
  MUXCY   \blk00000003/blk00000017  (
    .CI(\blk00000003/sig00000037 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000038 ),
    .O(\blk00000003/sig00000034 )
  );
  XORCY   \blk00000003/blk00000016  (
    .CI(\blk00000003/sig00000037 ),
    .LI(\blk00000003/sig00000038 ),
    .O(\blk00000003/sig00000039 )
  );
  MUXCY   \blk00000003/blk00000015  (
    .CI(\blk00000003/sig00000034 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000035 ),
    .O(\blk00000003/sig00000031 )
  );
  XORCY   \blk00000003/blk00000014  (
    .CI(\blk00000003/sig00000034 ),
    .LI(\blk00000003/sig00000035 ),
    .O(\blk00000003/sig00000036 )
  );
  MUXCY   \blk00000003/blk00000013  (
    .CI(\blk00000003/sig00000031 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig0000002e )
  );
  XORCY   \blk00000003/blk00000012  (
    .CI(\blk00000003/sig00000031 ),
    .LI(\blk00000003/sig00000032 ),
    .O(\blk00000003/sig00000033 )
  );
  MUXCY   \blk00000003/blk00000011  (
    .CI(\blk00000003/sig0000002e ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000002f ),
    .O(\blk00000003/sig0000002b )
  );
  XORCY   \blk00000003/blk00000010  (
    .CI(\blk00000003/sig0000002e ),
    .LI(\blk00000003/sig0000002f ),
    .O(\blk00000003/sig00000030 )
  );
  MUXCY   \blk00000003/blk0000000f  (
    .CI(\blk00000003/sig0000002b ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000002c ),
    .O(\blk00000003/sig00000028 )
  );
  XORCY   \blk00000003/blk0000000e  (
    .CI(\blk00000003/sig0000002b ),
    .LI(\blk00000003/sig0000002c ),
    .O(\blk00000003/sig0000002d )
  );
  MUXCY   \blk00000003/blk0000000d  (
    .CI(\blk00000003/sig00000028 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000029 ),
    .O(\blk00000003/sig00000026 )
  );
  XORCY   \blk00000003/blk0000000c  (
    .CI(\blk00000003/sig00000028 ),
    .LI(\blk00000003/sig00000029 ),
    .O(\blk00000003/sig0000002a )
  );
  XORCY   \blk00000003/blk0000000b  (
    .CI(\blk00000003/sig00000026 ),
    .LI(\blk00000003/sig0000001d ),
    .O(\blk00000003/sig00000027 )
  );
  MUXCY   \blk00000003/blk0000000a  (
    .CI(\blk00000003/sig00000024 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000001e ),
    .O(\blk00000003/sig00000025 )
  );
  MUXCY   \blk00000003/blk00000009  (
    .CI(\blk00000003/sig0000001e ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000001e ),
    .O(\blk00000003/sig00000024 )
  );
  MUXCY   \blk00000003/blk00000008  (
    .CI(\blk00000003/sig0000001e ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig00000023 ),
    .O(\blk00000003/sig00000022 )
  );
  MUXCY   \blk00000003/blk00000007  (
    .CI(\blk00000003/sig00000022 ),
    .DI(\blk00000003/sig0000001d ),
    .S(\blk00000003/sig0000001d ),
    .O(\blk00000003/sig0000001f )
  );
  MUXCY   \blk00000003/blk00000006  (
    .CI(\blk00000003/sig0000001f ),
    .DI(\blk00000003/sig0000001e ),
    .S(\blk00000003/sig00000020 ),
    .O(\blk00000003/sig00000021 )
  );
  VCC   \blk00000003/blk00000005  (
    .P(\blk00000003/sig0000001e )
  );
  GND   \blk00000003/blk00000004  (
    .G(\blk00000003/sig0000001d )
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
