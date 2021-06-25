import numpy as np
import pandas as pd
pd.get_option("display.max_columns")
pd.set_option('display.max_columns', 1000)
pd.get_option("display.max_rows")
pd.set_option('display.max_rows', 1000)

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
        def to_be_float(str):
            if (str == "NA"):
                return 0
            float(str)
        appended_value = to_be_float(df_index.iat[k,l])
        value.append(appended_value)
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

##############################################################################################

columns=list(range(-15,16))
ID_array.insert(0,'0')
erave=pd.DataFrame(ALLave,index=ID_array,columns=columns)

##############################################################################################

gol=open('gol.fas','r')

fas = [[]]

while True:
    reading = gol.readline()
    reading = reading.rstrip()

    if not reading.startswith('>'):
        if reading == '':
            break
        fas.append(list(reading))

fas.remove([])
columns=list(range(-15,16))
df_gol=pd.DataFrame(fas,columns=columns)

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
    while j<len(df_gol.index):
        i=0
        AA=[]
        while i<=30:
            AA.append(df_gol.iat[j,i])
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

columns=list(range(-15,16))
golave=pd.DataFrame(ALLave,index=ID_array,columns=columns)

golave

##############################################################################################

pm=open('pm.fas','r')

fas = [[]]

while True:
    reading = pm.readline()
    reading = reading.rstrip()

    if not reading.startswith('>'):
        if reading == '':
            break
        fas.append(list(reading))

fas.remove([])
columns=list(range(-15,16))
df_pm=pd.DataFrame(fas,columns=columns)

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
    while j<len(df_pm.index):
        i=0
        AA=[]
        while i<=30:
            AA.append(df_pm.iat[j,i])
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

columns=list(range(-15,16))
pmave=pd.DataFrame(ALLave,index=ID_array,columns=columns)

pmave

##############################################################################################

import matplotlib.pyplot as plt

for index_pm, row_pm in pmave.iterrows():
    for index_gol, row_gol in golave.iterrows():
        for index_er, row_er in erave.iterrows():
            if index_pm==index_gol and index_pm==index_er:
                print (index_pm)
                plt.plot(columns , row_pm , color = 'red', marker = 'o')
                plt.plot(columns , row_gol , color = 'blue', marker = 'v')
                plt.plot(columns , row_er , color = 'green', marker = 'x')
                plt.show()
