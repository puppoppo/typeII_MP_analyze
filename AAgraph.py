import numpy as np
import pandas as pd

f=open('aaindex1.dat', 'r')
er=open('er.fas','r')

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

df_index=pd.DataFrame(AAall,index=ID_array,columns=columns)

##############################################################################################

er=open('er.fas','r')

fas = [[]]

while True:
    reading = er.readline()
    reading = reading.rstrip()

    if not reading.startswith('>'):
        if reading == '':
            break
        fas.append(list(reading))

fas.remove([])
columns=list(range(-15,16))
df_er=pd.DataFrame(fas,columns=columns)

##############################################################################################

ALLave=[[]]

k=0
while k<len(df_index.index):
    l=0
    value=[]
    while l<len(df_index.columns):
        if df_index.iat[k,l]=="NA":
            value.append(0)
        else:
            value.append(float(df_index.iat[k,l]))
        l=l+1


    j=0
    AAnum=[[]]
    while j<len(df_er.index):
        i=0
        AA=[]
        while i<=30:
            AA.append(df_er.iat[j,i])
            if AA[i]=="A":
                AA[i]=value[0]
            elif AA[i]=="R":
                AA[i]=value[1]
            elif AA[i]=="N":
                AA[i]=value[2]
            elif AA[i]=="D":
                AA[i]=value[3]
            elif AA[i]=="C":
                AA[i]=value[4]
            elif AA[i]=="Q":
                AA[i]=value[5]
            elif AA[i]=="E":
                AA[i]=value[6]
            elif AA[i]=="G":
                AA[i]=value[7]
            elif AA[i]=="H":
                AA[i]=value[8]
            elif AA[i]=="I":
                AA[i]=value[9]
            elif AA[i]=="L":
                AA[i]=value[10]
            elif AA[i]=="K":
                AA[i]=value[11]
            elif AA[i]=="M":
                AA[i]=value[12]
            elif AA[i]=="F":
                AA[i]=value[13]
            elif AA[i]=="P":
                AA[i]=value[14]
            elif AA[i]=="S":
                AA[i]=value[15]
            elif AA[i]=="T":
                AA[i]=value[16]
            elif AA[i]=="W":
                AA[i]=value[17]
            elif AA[i]=="Y":
                AA[i]=value[18]
            elif AA[i]=="V":
                AA[i]=value[19]
            elif AA[i]=="X":
                # valueリストを最初の20要素のみに制限
                initial20values = value[:20]

                # その合計値を取得
                sumAA = sum(initial20values)
                AA[i]=sumAA/20

            i=i+1
        AAnum.append(AA)
        j=j+1
    df_AAnum=pd.DataFrame(AAnum)
    #print (df_AAnum)

    ave=df_AAnum.mean()
    ALLave.append(ave)

    k=k+1
