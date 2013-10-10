op_trans 	= {
				'LDI' : '000000',
				'LDC' : '000000',
				'LDA' : '000000',
				'LDB' : '000000',
				'STB' : '000000',
				
				'ADI' : '000000',
				'ADF' : '000000',
				'SBI' : '000000',
				'ABF' : '000000',
				'AIM' : '000000',
				'SIM' : '000000',
				
				'MLI' : '000000',
				'MLF' : '000000',
				'MLA' : '000000',
				'MLS' : '000000',
				'SHL' : '000000',
				'SHR' : '000000',
				
				'CMP' : '000000',
				'NOT' : '000000',
				'AND' : '000000',
				'NND' : '000000',
				'ORR' : '000000',
				'XOR' : '000000',
				'NOR' : '000000',
				
				'MOV' : '000000',
				'MVN' : '000000',
				'I2F' : '000000',
				'F2I' : '000000',
				
				'BEQ' : '000000',
				'BNE' : '000000',
				'BLT' : '000000',
				'BGT' : '000000',
				'JMP' : '000000'}
				
reg_trans	= { 
				'$LC' : 0,
				'$LI' : 1,
				'$00' : 2,
				'$TT' : 3,
				
				'$?0' : 4,
				'$?1' : 5,
				'$?2' : 6,
				'$?3' : 7,
				
				'$?4' : 8,
				'$?5' : 9,
				'$?6' : 10,
				'$?7' : 11,
				
				'$A0' : 12,
				'$A1' : 13,
				'$A2' : 14,
				'$A3' : 15,
				
				'$B0' : 16,
				'$B1' : 17,
				'$B2' : 18,
				'$B3' : 19,
				
				'$C0' : 20,
				'$C1' : 21,
				'$C2' : 22,
				'$C3' : 23,
				
				'$S0' : 24,
				'$S1' : 25,
				'$S2' : 26,
				'$S3' : 27,
				
				'$R0' : 28,
				'$R1' : 29,
				'$R2' : 30,
				'$R3' : 31}

def translate(source_filename, exe_filename):
	source	= open(source_filename, r)
	exe		= open(exe_filename.split('.')[0]+'.awsm', rwb)
	
	for newline in source:
		line = newline.split('//')[0].split()
		instruction = opcode(line[0])
		if len(line) == 2:
			if line[1][0] == '$':
				instruction += '{0:005b}'.format(reg_trans(line[1]))	#is reg (NOT)
			else:
				instruction += '{0:010b}'.format(line[2])				#is value
		else:
			instruction += '{0:005b}'.format(reg_trans(line[1]))		#is reg
			if line[2][0] == '$':
				instruction += '{0:005b}'.format(reg_trans(line[2]))	#is reg
			else:
				instruction += '{0:005b}'.format(line[2])				#is value			
		exe.write(instruction)
	file.close()