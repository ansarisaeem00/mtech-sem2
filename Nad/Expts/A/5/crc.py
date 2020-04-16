import crc16 
crc = crc16.crc16xmodem(b'1234')
crc = crc16.crc16xmodem(b'56789', crc)
print(crc) 
