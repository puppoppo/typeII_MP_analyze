import numpy as np
import pandas as pd

f=open('aaindex1.dat', 'r')
er=open('er.fas','r')
gol=open('gol.fas','r')
pm=open('pm.fas','r')
fragI=0
raw=''
ID=''
ID_array=[]
AAall=[[]]

while True:
    data = f.readline()
    data = data.rstrip()
    if data.startswith('I'):
        fragI = 1
    elif data.startswith('H'):
        ID=data[2:]
    elif fragI==1 and not data.startswith('//'):
        raw+=data
    elif data.startswith('//'):
        para = raw.split()
        AAall.append(para)
        ID_array.append(ID)
        raw=''
        fragI=0
    elif data == '':
        break

AAall.remove([])

columns=['A','R','N','D','C','Q','E','G','H','I','L','K','M','F','P','S','T','W','Y','V']

dataframe1=pd.DataFrame(AAall,index=ID_array,columns=columns)
dataframe1

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
