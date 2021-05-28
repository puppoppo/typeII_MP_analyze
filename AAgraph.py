import numpy as np

f=open('aaindex1.dat', 'r')
er=open('er.fas','r')
gol=open('gol.fas','r')
pm=open('pm.fas','r')
fragI=0
raw=''
ID=''
AAall=[[]]

while True:
    data = f.readline()
    data = data.rstrip()
    if data.startswith('I'):
        fragI = 1
    elif data.startswith('H'):
        ID=data
    elif fragI==1 and not data.startswith('//'):
        raw+=data
    elif data.startswith('//'):
        para = raw.split()
        AAall.append(para)
        raw=''
        fragI=0
    elif data == '':
        break

i=0
j=0
fas=[[]]

while True:
    reading = er.readline()
    reading = reading.rstrip()
    if not reading.startswith('>'):
        if reading == '':
            break
        fas=np.append(list(reading))

print([len(v) for v in fas])
