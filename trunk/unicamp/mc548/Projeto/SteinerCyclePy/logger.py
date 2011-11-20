import sys, itertools, math
from datetime import datetime

#-- Configurations
enabledLog = False;
logFile = None;

# -- Open logger
def openLogger(enable, fileName):
	
	global enabledLog;
	global logFile;
	
	enabledLog = enable;
	if fileName == None or len(fileName) == 0:
		logFile = open('steinerCycle.log', 'a');
	else:
		logFile = open(fileName, 'a');
		

# -- Log info
def logInfo(value):
	
	global enabledLog;
	global logFile;

	if not enabledLog or logFile == None:
		return;
	now = datetime.now()
	logFile.write("\nINFO - " + str(now) + " - " + value);
	
	
# -- Log info
def logDebug(value):
	
	global enabledLog;
	global logFile;

	if not enabledLog or logFile == None:
		return;
	now = datetime.now()
	logFile.write("\nDEBUG - " + str(now) + " - " + value);

	
# -- Close logger
def closeLogger():
	
	global enabledLog;
	global logFile;
	
	if logFile != None and enabledLog:
		logFile.close();