import argparse
import serial
import sys

BAUDRATE=115200
MEM_SIZE=(16*2)

def main():
		args = parse()
		run(args)

def parse():
		parser = argparse.ArgumentParser()
		
		parser.add_argument('-COM', '--port', metavar='p', type=int, help='set COMn as port')
		parser.add_argument('-p', '--pipeline', metavar='n', type=int, help='set pipeline number')
		parser.add_argument('-c', '--core', metavar='n', type=int, help='set core number')
		parser.add_argument('-m', '--memory', metavar='n', type=int, help='set memory number')

		parser.add_argument('-i', '--instruction', metavar='filename', help='write file to instruction memory')
		parser.add_argument('-d', '--data', metavar='filename', help='write file to data memory')
		parser.add_argument('-r', '--read', metavar='filename', help='read data memory to file')
		parser.add_argument('-e', '--execute', metavar='n', type=int, help='execute n cycles')
		
		return parser.parse_args()

def run(args):
		
		if args.instruction:
				write_instruction(args)
		elif args.data:
		    write_data(args)
		elif args.read:
				read_data(args)
		elif args.execute:
				execute(args)

def write_instruction(args):

		if args.pipeline is None:
				print 'Missing pipeline parameter'
				sys.exit(1)

		if args.core is None:
				print 'Missing core parameter'
				sys.exit(1)



		port = args.port
		command = 'wi' + `args.pipeline` + `args.core`
		data = read_file(args.instruction)
		
		write_to_bitless(port, command, data)



def write_data(args):

		if args.pipeline is None:
				print 'Missing pipeline parameter'
				sys.exit(1)

		if args.memory is None:
				print 'Missing memory parameter'
				sys.exit(1)

		port = args.port
		command = 'wd' + `args.pipeline` + `args.memory`
		data = read_file(args.data)

		write_to_bitless(port, command, data)

		print 'write data'


def read_data(args):

		if args.pipeline is None:
				print 'Missing pipeline parameter'
				sys.exit(1)

		if args.memory is None:
				print 'Missing memory parameter'
				sys.exit(1)

		port = args.port
		command = 'rd' + `args.pipeline` + `args.memory`

		data = read_from_bitless(port, command, MEM_SIZE)
		write_file(args.read, data)


def execute(args):
		print 'execute'

def write_to_bitless(port, command, data):
		print 'executing', command
		serial_port = serial_open(port)

		
		if serial_port.isOpen():
				print 'port opened'

				# Tell bitless what's comming
				serial_port.write(command)

				# Tell bitless all about it
				serial_port.write(data)

				# Reset the port
				serial_port.flush()

				# Check what bitless thinks about it
				response = serial_port.read()

				# Say good bye for now
				serial_port.close()

				print 'port closed'
		else:
				print 'error opening port'

def read_from_bitless(port, command, n):
		print 'executing', command
		serial_port = serial_open(port)

		if serial_port.isOpen():
				print 'port opened'
				
				# Tell bitless what to send
				serial_port.write(command)

				# Listen bitless
				data = serial_port.read(n)

				# Say goodbye 
				serial_port.close()

				print 'port closed'
		else:
				print 'error opening port'
				
		return data
				
def serial_open(port):
		try:
				ser = serial.Serial(port=port, baudrate=BAUDRATE, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE, timeout=1)
		except serial.SerialException:
				print 'COM Port', port, 'Unknown'
				sys.exit(1)
		return ser

def read_file(filename):

		f = None
		data = None
		try:
				f = open(filename, 'r')
		except:
				print 'File: "' + filename + '" not found'
				sys.exit(1)
		if f:
				data = f.read(MEM_SIZE);
				f.close()
		return data

def write_file(filename, data):
		
		f = None
		try:
				f = open(filename, 'w')
		except:
				print 'Could not open:', filename
				sys.exit(1)
		if f:
				f.write(data)
				f.close()



if __name__ == "__main__":
		main()
