
class Assembler():

    opcode_decoder = {
        'ADD':	'0000',
        'ADDI': '0001',
        'SUB':	'0010',
        'SUBI': '0011',
        'MOVM': '0100',
        'MOVR': '0101',
        'LEA':	'0110',
        'CMP':	'0111',
        'JE':	'1000',
        'JNE':	'1001',
        'JMP':	'1010',
        'OR':	'1011',
        'AND':	'1100'
    }

    def __init__(self, file: str, output: str) -> None:
        self.commands = self.__read_file(file)
        self.instructions = []
        self.decode()
        self.__save_file(self.instructions, output)

    def decode(self) -> str:
        for command in self.commands:
            structure = command[:-1].split()
            try:
                opcode = self.opcode_decoder[structure[0].upper()]
            except KeyError:
                raise KeyError('Invalid operation.')
            if opcode in ['1000', '1001', '1010']:
                reg = '000'
                address = self.__decode_address(structure[1])
            elif opcode != '0101':
                reg = self.__decode_reg_address(structure[1][:-1])
                address = self.__decode_address(structure[2])
            else:
                reg = self.__decode_reg_address(structure[2])
                address = self.__decode_address(structure[1][:-1])
            self.instructions.append(opcode + reg + address)

    @staticmethod
    def __decode_address(address: str) -> str:
        value = int(address, 16)
        if value > 4095:
            raise ValueError('Invalid Imediat Value.')
        binary = bin(value)[2:]
        return binary.zfill(12)[:12]

    @staticmethod
    def __decode_reg_address(address: str) -> str:
        value = int(address[1:], 16)
        if value > 8:
            raise ValueError('Invalid Register Number. Valid Number are 1-8')
        binary = bin(value - 1)[2:]
        return binary.zfill(3)

    @staticmethod
    def __read_file(file: str) -> list():
        with open(file, 'r') as f:
            commands = f.read()
            commands = commands.split('\n')
        return commands
    
    @staticmethod
    def __save_file(instructions: list, output: str) -> None:
        with open(output, 'w') as f:
            for line, instruction in enumerate(instructions):
                f.write(f'\t\ttmp({line}) := \"{instruction}\";\n')
