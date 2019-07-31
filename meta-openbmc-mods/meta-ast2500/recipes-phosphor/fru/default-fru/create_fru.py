#!/usr/bin/python3

"""
This script generates a default baseboard fru file.
"""


def create_fru(name):
    if len(name) > 16:
        raise Exception('Product Name Too Large: {}'.format(name))

    fill_char = ord('.')
    eof = 0xC1

    filename = '{}.fru.bin'.format(name)
    name = name.encode('ascii')

    name_len = (0x3 << 6) | len(name)

    # internal area
    internal = [0x01] + ([0] * 6) + [0x01]

    # chassis area
    chassis = [0x01,  # Chassis Info Area Format Version Bit Fields
               0xFF,  # Chassis Info Area Length (in multiples of 8 bytes)
               0x17]  # Chassis Type (Main Server Chassis)

    fill_len = 18

    # Chassis Part Number
    chassis += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)

    # Chassis Serial Number
    chassis += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)

    fill_len = 31
    chassis += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)  # Info AM1
    chassis += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)  # Info AM2

    chassis.append(eof)

    chassis.append(0)  # need room for checksum

    while len(chassis) % 8:  # pad
        chassis.append(0)

    chassis[1] = int(len(chassis) / 8)  # populate length
    chassis[-1] = (256 - sum(chassis)) & 0xFF  # populate checksum

    # board area
    board = [0x1,  # Board Info Area Format Version Bit Fields
             0xFF,  # Board Info Area Length (in multiples of 8 bytes)
             0x0,  # Language Code
             0x0,  # Mfg. Date/Time
             0x0,  # Mfg. Date/Time
             0x0,  # Mfg. Date/Time
             0xD1]  # Product Manufacturer Name Len

    corp = b'Intel Corporation'
    board += bytearray(corp)  # Manufacturer Name

    board.append(name_len)
    board += bytearray(name)  # Board Product Name

    fill_len = 12
    board += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)  # board SN

    fill_len = 10
    board += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)  # board PN

    version = b'FRU Ver 0.01'

    board += [0x3 << 6 | len(version)]  # FRU File version ID string
    board += bytearray(version)

    board.append(eof)

    board.append(0)  # need room for checksum

    while len(board) % 8:
        board.append(0)

    board[1] = int(len(board) / 8)  # populate length
    board[-1] = (256 - sum(board)) & 0xFF  # populate checksum

    # product area
    product = [1,  # Product Info Area Format Version Bit Fields
               0xFF,  # Product Info Area Length (in multiples of 8 bytes)
               0x0,  # Language Code
               0xD1]  # Product Manufacturer Name Len

    product += bytearray(corp)  # Manufacturer Name

    product.append(name_len)  # Product Name Len
    product += bytearray(name)  # Product Name

    fill_len = 10

    # Product Part Number
    product += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)

    # Product Version
    fill_len = 20
    product += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)

    # Product Serial Number
    fill_len = 12
    product += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)

    # Asset Tag
    fill_len = 20
    product += [0x3 << 6 | fill_len] + ([fill_char] * fill_len)

    product.append(0xC0)  # FRU File ID (Not used)
    product.append(eof)

    product.append(0)  # need room for checksum

    while len(product) % 8:
        product.append(0)

    product[1] = int(len(product) / 8)
    product[-1] = (256 - sum(product)) & 0xFF

    header = [0x1]
    length = 1  # internal
    header.append(length)
    length += int(len(internal) / 8)
    header.append(length)
    length += int(len(chassis) / 8)
    header.append(length)
    length += int(len(board) / 8)
    header.append(length)
    header.append(0)
    header.append(0)
    header.append((256 - sum(header)) & 0xFF)

    result = header + internal + chassis + board + product

    while len(result) < 0x1FF:
        result.append(0)

    result = bytearray(result)

    # print(result)

    with open(filename, 'wb') as out:
        out.write(result)


if __name__ == '__main__':
    product_name = input('Enter Product Name: ')
    create_fru(product_name)

