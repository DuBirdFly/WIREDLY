# -*- coding: utf-8 -*-

'''
DDR CA Pins     : CA[9:0], 最大值为 0x3FF (1023) (11 1111 1111)

典型例子, 一条 ACTIVE 命令的第一段: 0x362 (110 11000 10) (BA, R, TYPE)
          一条 WRITE  命令的第一段: 0x301 (110 00xx 001) (BA, C, TYPE)
          一条 READ   命令的第一段: 0x305 (110 00xx 101) (BA, C, TYPE)
'''

import re

def check_hex(Hexadecimal: str) -> tuple[bool, str]:
    '''
    检查输入的十六进制值是否合法\n
    return (bool) -> 是否合法\n
    return (str)  -> 转换为二进制后的值, (左边是最高位, 右边是最低位)
    '''

    if not re.match(r'^[0-9a-fA-F]+$', Hexadecimal):
        print('ERROR: 输入的不是十六进制值')
        return False, ''

    Decimal : int = int(Hexadecimal, 16)
    Binary  : str = bin(Decimal)[2:]

    if Binary.__len__() > 10:
        print(f'ERROR: 输入的十六进制值超出范围 ({Binary = })')
        return False, Binary

    Binary = Binary.zfill(10)

    return True, Binary

########################################################################################
print('=' * 50)
CA_HEX : str = input("输入第一条命令 (0x0 ~ 0x3FF): 0x")
CA_CHECK, CA_FLIP = check_hex(CA_HEX)

if not CA_CHECK:
    raise ValueError('ERROR: 输入的十六进制值不合法')

CA = CA_FLIP[::-1] # 翻转二进制值, 使 CA[0] 对应 CA[0], 从而对应 JESD209-3B 的真值表
print(f'CA = {" ".join(CA)}')
print(f'     {" ".join(map(str, range(10)))}')

# 注: python的字符串切片是左闭右开区间
CMD_TYPE = f'{CA[0:3]}'  # CA[0:2]

BA  = f'{CA[7:10]}'  # BA[0:2]
ROW = f'{CA[2:7]}'   # ROW[8:12]
COL = f'{CA[5:7]}'   # COL[5:6]

BA_INT = int(BA[::-1], 2)

if CMD_TYPE[0:2] == '01':
    print('这是 ACTIVATE 命令')
elif CMD_TYPE[0:3] == '100':
    print('这是 WRITE 命令')
elif CMD_TYPE[0:3] == '101':
    print('这是 READ 命令')
else:
    raise ValueError('ERROR: 无法从 CA0~CA2 判断命令类型')

print(f"BA[2:0] = 3'b{BA[::-1]} ({BA_INT})")

if CMD_TYPE[0:2] == '01':
    print(f"ROW[12:8] = 5'b{ROW[::-1]}")
elif CMD_TYPE[0:3] == '100' or CMD_TYPE[0:3] == '101':
    print(f"COL[2:1] = 2'b{COL[::-1]}")

########################################################################################
print('=' * 50)
CA_HEX : str = input("输入第二条命令 (0x0 ~ 0x3FF): 0x")
CA_CHECK, CA = check_hex(CA_HEX)

if not CA_CHECK:
    raise ValueError('ERROR: 输入的十六进制值不合法')

CA = CA[::-1]
print(f'CA = {" ".join(CA)}')
print(f'     {" ".join(map(str, range(10)))}')

AP_BIN  = f'{CA[0]}'                # AP[0]
ROW = f'{CA[0:8]}{ROW}{CA[8:10]}'   # ROW[0:12]
COL = f'X{COL}{CA[1:10]}'           # COL[0:10]

ROW_INT = int(ROW[::-1], 2)

print(f"AP[0] = {AP_BIN}")

if CMD_TYPE[0:2] == '01':
    print(f"ROW[14:0] = 15'b{ROW[::-1]} ({ROW_INT}) ({hex(ROW_INT)})")
elif CMD_TYPE[0:3] == '100' or CMD_TYPE[0:3] == '101':
    print(f"COL[10:0] = 11'b{COL[::-1]}")
else:
    raise ValueError('ERROR: 无法从 CA0~CA2 判断命令类型')
