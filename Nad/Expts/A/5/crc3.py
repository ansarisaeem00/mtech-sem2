def check_binary(word):
    ret = True
    for b in word:
        if b == '1' or b == '0':
            ret = True
        else:
            return False
    return ret

def Xor(a,b):
    xor = ''
    for i,j in zip(a,b):
        if i == j:
            xor = xor + '0'
        else:
            xor = xor + '1'
    return xor

def filter_bin(b):
    count = 0
    for i in b:
        if i == '0':
            count = count + 1
        else:
            break
    b = "" + b[count:]
    #print( 'bin =',b,'count =',count
    return b,count

def Crc(msg, g):
    rem = ''
    crc = ''
    count = 0
    msg_with_redundant_bits = msg + '0'*(len(g)-1)
    a = msg_with_redundant_bits[0:len(g)]
    crc = crc + '1'
    j = len(g)

    while len(crc)<=len(msg):
        print( a,'with',g,'gives')
        a = Xor(a,g)
        print( a,a,count = filter_bin(a))
        print('filtered a =',a)
        a = a + msg_with_redundant_bits[j:j+count]
        j = j + count
        crc = crc + '0'*(count-1)
        crc = crc + '1'
        print( 'crc = ',crc)
        print( '********************************************************')
        #break
    crc = "" + crc[:-1] + a
    return crc,a


def main():
    msg = input("Enter the binary msg: ")
    g = input("Enter the Generator function G(x): ")

    #msg,g = '11010011101100','1011'

    if check_binary(msg) and check_binary(g):
        crc, r = Crc(msg, g)
        print( 'Cyclic Encoded MESSAGE =', crc)
        print( 'Remainder =',r)

main()
