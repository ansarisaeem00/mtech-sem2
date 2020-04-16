def check(frame, p):
  n = len(p) - 1
  fcs = frame[0: n]
  for i in range(n, len(frame)):
    fcs += frame[i]
    fcs = bin(int(fcs, 2))[2:]
    if (len(fcs) < len(p)): 
      continue
    fcs = bin(int(fcs, 2) ^ int(p, 2))[2:]
  while len(fcs) < n:
    fcs = "0" + fcs
  return fcs

def crc(frame, p):
  n = len(p) - 1
  frameM = frame +  n * "0"
  return check(frameM, p)

import random

def test(p):
  for i in range(50):
    frame = random.choice("01") * random.randint(50, 100)
    assert check(frame + crc(frame, p), p) == (len(p) - 1) * "0", f"encountered error when tested {p}"


CRC_16 = "11000000000000101"                    # 16 bits
CRC_CCITT = "10001000000100001"                 # 16 bits
CRC_32 = "100000100110000010001110110110111"    # 32 bits

test(CRC_16)
#test(CRC_CCITT)
#test(CRC_32)
print("Accept")
