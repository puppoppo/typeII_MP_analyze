f=open('aaindex1.dat', 'r')
g=open('index.csv','w')
fragI=0
raw=''
ID=''
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
		raw=''
		fragI=0
	elif data == '':
		break
