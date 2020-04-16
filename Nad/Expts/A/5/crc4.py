m=int(input("enter the no of bits in the divisor: "))
divisor=""

for i in range(m):
    f=input("enter the bit 0 or 1: ")
    divisor=divisor+f
    
n=int(input("enter the no of digits in initial data: "))
data=""
for i in range(n):
    c=input("enter the bit 0 or 1: ")
    data=data+c

zero=""
for i in range(m-1):
    zero+="0"

new_data=data+zero

print("initializing division process")

def xor(dividend,divisor):
    res=""
    for i in range(0,len(divisor)):
        if divisor[i]!=dividend[i]:
            res+="1"
        else:
            res+="0"
    return(res)
    

x=len(new_data)-m
q=""
temp=new_data[:m]
count=0
i=0

while(count<=x+1 and i<len(new_data)):
    if count<1:
        if temp[0]=="0":
            q+="0"
            temp=xor(temp,zero+"0")
        elif temp[0]=="1":
            q+="1"
            temp=xor(temp,divisor)
        i+=4
    else:
        temp=temp[1:]+new_data[i]
        if temp[0]=="0":
            q+="0"
            temp=xor(temp,zero+"0")
        elif temp[0]=="1":
            q+="1"
            temp=xor(temp,divisor)
        i+=1
    
    count+=1    
    
rem=temp[1:]

print(rem, "reminder")
print(temp, "temp")
print(q, "quotient")

rec_data=data+rem

new_temp=""
count=0

while(count<=x+1 and i<len(rec_data)):
    if count<1:
        if new_temp[0]=="0":
            q+="0"
            new_temp=xor(new_temp,zero+"0")
        elif new_temp[0]=="1":
            q+="1"
            new_temp=xor(new_temp,divisor)
        i+=4
    else:
        new_temp=new_temp[1:]+new_data[i]
        if new_temp[0]=="0":
            q+="0"
            new_temp=xor(new_temp,zero+"0")
        elif new_temp[0]=="1":
            q+="1"
            new_temp=xor(new_temp,divisor)
        i+=1
    
    count+=1    
    
check=new_temp[1:]

if check==zero :
    print("transferred data with no noise/change")
else:
    print("there's been a disturbance")
