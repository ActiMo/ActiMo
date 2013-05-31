import sys, time, msvcrt
import serial
from serial.tools import list_ports
import math
from numpy import matrix
from numpy import array
import numpy

#output from hardware:
#pitch,roll,yaw,ax,ay,az

angleThreshold = 4 #pitch, roll, yaw
refractoryTime = .65 #seconds 
 
prevOrientation = [0,0,0]
currOrientation = [0,0,0]
diffOrientation = [0,0,0]
accSmoothData = [0,0,0]
forceMagnitude = 0 
offset = [0]*6 #SETS TO LENGH OF 6

def getAngle(y,x):
	return math.degrees(math.atan2(math.radians(y), math.radians(x)))
 
def init():
	bool = 0
	while 1:
		temp = list(serial.tools.list_ports.comports())
		if(len(temp) > 0):
			bool = 2 #found something to analyze
		if(bool == 0):
			print("Error, Nothing Connected")
			bool = 1 #have printed error, don't print again
		if(bool == 2)
			ports = []
			for i in range(0,len(temp))
				ports.append(temp[i][0])
			for i in ports
		
 
 
def getData ():
	global diffOrientation
	global prevOrientation
	global currOrientation
	global accSmoothData
	global forceMagnitude
	global offset
	#get Data and setup for use
	words = [0,0]
	while(len(words) < 6):
		temp = ser.readline().decode('utf-8')[:-2] #read in line
		temp = temp.rstrip() #cut off \n at end of line
		words = [0,0] #dummy so check if valid line works
		if temp != "": #if a valid line was read
			words = [float(x) for x in temp.split(',')]
	for i in range(0,3): #for each orientation data, calibrate
		words[i] = words[i] - offset[i] #subtract calibrated offset
		if (words[i] < 0) and (i != 0): #change ranges to appropriate
			words[i] = words[i] + 360
		if i == 0:
			words[i] = -words[i] #flips pitch so up is positive
	#split and process data into meaningful arrays
	for i in range(0,3):
		prevOrientation[i] = currOrientation[i]
		currOrientation[i] = words[i]
		diffOrientation[i] = currOrientation[i] - prevOrientation[i]
		if(diffOrientation[i] < -100):
			diffOrientation[i] = diffOrientation[i] + 360
		elif(diffOrientation[i] > 100):
			diffOrientation[i] = diffOrientation[i] - 360
		accSmoothData[i] = words[i+3]
	accSmoothData = toInertialRef(accSmoothData, currOrientation[0], currOrientation[1], currOrientation[2])
	if(math.fabs(diffOrientation[0]) < 1 and math.fabs(diffOrientation[1]) < 1 and math.fabs(diffOrientation[2]) < 1):
		for i in range(0,3):
			offset[i+3] = .7*offset[i+3] + .3*accSmoothData[i]
	for i in range(0,3):
		accSmoothData[i] = accSmoothData[i] - offset[i+3]
	forceMagnitude = math.sqrt(accSmoothData[0]*accSmoothData[0] + accSmoothData[1]*accSmoothData[1] + accSmoothData[2]*accSmoothData[2])
 
def round( array , N):
	if(isinstance( array, ( int, long, float ) )):
		if(N <= 0):
			return int(math.floor(array*math.pow(10,N) + .5)/math.pow(10,N))
		else:
			return math.floor(array*math.pow(10,N) + .5)/math.pow(10,N)
	else:
		ret = [0] * len(array)
		for i in range(0,len(array)):
			ret[i] = math.floor(array[i]*math.pow(10,N) + .5)/math.pow(10,N)
		if(N <= 0):
			return int(ret)
		else:
			return ret

def RotMatYaw( yawDeg ):
	yaw = math.radians(yawDeg)
	return matrix([[math.cos(yaw), math.sin(yaw), 0], [-math.sin(yaw), math.cos(yaw), 0], [0,0,1]])

def RotMatPitch( pitchDeg ):
	pitch = math.radians(pitchDeg)
	return matrix([[math.cos(pitch), 0, -math.sin(pitch)],[0, 1, 0],[math.sin(pitch), 0, math.cos(pitch)]])
						  
def RotMatRoll( rollDeg ):
	roll = math.radians(rollDeg)
	return matrix([[ 1, 0,0], [ 0, math.cos(roll), math.sin(roll) ], [ 0, -math.sin(roll), math.cos(roll) ]])

def toInertialRef( accData, pitchDeg, rollDeg, yawDeg):
	A = matrix(accData)
	B = RotMatYaw(-yawDeg)*RotMatPitch(-pitchDeg)*RotMatRoll(-rollDeg)*A.T
	ret = ((B.T).tolist())[0]
	for i in range(0,3): #rounds to two decimal places
		ret[i] = math.floor(ret[i]*100 + .5)/100
	return ret
	
def printOut( dir, force, range):
	po = "d" + repr(dir) + "f" + repr(force) + "r" + repr(range) + "end"
	print(po)
	
def readInput( default, timeout = .01):
    start_time = time.time()
    input = ''
    while True:
        if msvcrt.kbhit():
            chr = msvcrt.getche()
            if ord(chr) == 46: # \n
                break
            elif ord(chr) >= 32: #space_char
                input += chr
        if len(input) == 0 and (time.time() - start_time) > timeout:
            break
    if len(input) > 0:
        return input
    else:
        return default

		
ser = serial.Serial('COM12', 115200, timeout=1)
bool = 1
tempBool = 0
log = []
data = []
f = open('noiseGraph.csv','w')
while 1:
	ans = readInput('')
	if ans == '': #do stuff, no input so normal 
		if bool == 1:
			getData()
			#print(round2(accSmoothData))
			#print(forceMagnitude)
			#print(getAngle(diffOrientation[0], diffOrientation[2]))
			#print(round2(diffOrientation))
			#print(forceMagnitude)
			
			if(math.fabs(diffOrientation[0]) > angleThreshold or math.fabs(diffOrientation[2]) > angleThreshold): #if is swiping
				if(len(log)>0): #and if not first data taken while moving
					if(math.fabs(getAngle(diffOrientation[0], diffOrientation[2]) - (log[len(log)-1])[2]) < 60): #and if no reversal of direction then add to log						
						log.insert(0,[currOrientation[0],currOrientation[2], getAngle(diffOrientation[0], diffOrientation[2]), forceMagnitude])
				else: #if is first data then store in log
					log.insert(0,[currOrientation[0],currOrientation[2], getAngle(diffOrientation[0], diffOrientation[2]), forceMagnitude])
			elif (len(log) > 2): #there is three data points in the log
				tempBool = 1
			else:
				log = []
				
			#if tempBool == 1 at this point then they swiped for at least three data points
			if(tempBool == 1):
				log2 = array(log)
				data = [0,0,0,0] #direction, force, xrange, yrange
				data[0] = numpy.median(log2[:,2])
				data[1] = 4*numpy.median(log2[:,3])
				data[2] = (log[len(log)-1])[0] - (log[0])[0]
				data[3] = (log[len(log)-1])[1] - (log[0])[1]
				if(data[3]>180):
					data[3] -= 360
				elif(data[3]<-180):
					data[3] += 360
				data = [data[0], data[1], math.sqrt(data[2]*data[2] + data[3]*data[3])]
				printOut(round(data[0],0),round(data[1],0),round(data[2],0))
				tempBool = 0
				log = []
				temp_time1 = time.time()
				temp_time2 = time.time()
				while(temp_time2 - temp_time1 < refractoryTime):
					getData()
					temp_time2 = time.time()		
			
		else:	
			temp = ser.readline().decode('utf-8')[:-2]
		continue
	elif ans == 'p': #print out information
		bool = 1
	elif ans == 's': #stop printing out information
		bool = 0
	elif ans == 'c': #calibrate everything at once
		getData()
		offset[0] = 0
		for i in range(1,3): #sets roll and yaw but not pitch which is always zero, and resets accelerometer to zero
			offset[i] = (currOrientation[i] + offset[i]) % 360
	elif ans == 'r': #reset offsets
		offset = [0]*6
		angleThreshold = [10,10,10] #pitch, roll, yaw
		forceThreshold = 20
	elif ans == 'x': #quit the program
		exit()