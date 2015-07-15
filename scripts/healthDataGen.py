# Licensed Materials - Property of IBM
# © Copyright IBM Corporation 2014, 2015. All Rights Reserved.

'''
This file generates fake Heart Rate, Body Weight, Steps, and Calories Burned data that can be used 
by HealthKit and GoogleFit.  This file will generate a number of data points (determined by NUM_DATA_POINTS
and output a JSON file at the paths specified by PATH_TO_XCODE_JSON and PATH_TO_ANDROID_JSON.
'''

import random
import json
import os

PATH_TO_XCODE_JSON = './../iOS/ReadyAppPT/Resources/'
PATH_TO_ANDROID_JSON = './../Android/Physio/app/src/main/assets/'

NUM_DATA_POINTS = 24*30 #24 hours for 30 days

#############################################
# Metrics Min/Max/Step values
#############################################
HEART_RATE_MIN = 50
HEART_RATE_MAX = 120
HEART_RATE_STEP = 1

BODY_WEIGHT_MIN = 170
BODY_WEIGHT_MAX = 190
BODY_WEIGHT_STEP = 1

CALORIES_MIN = 100
CALORIES_MAX = 500
CALORIES_STEP = 1

STEPS_MIN = 0
STEPS_MAX = 400
STEPS_STEP = 1

#############################################
# Setup of the JSON Dictionary
#############################################
metricsDict = {}
metricsDict['Metrics'] = {}
metricsDict['Metrics']['HeartRate'] = []
metricsDict['Metrics']['BodyWeight'] = []
metricsDict['Metrics']['Calories'] = []
metricsDict['Metrics']['Steps'] = []

bodyWeight = random.randrange(BODY_WEIGHT_MIN, BODY_WEIGHT_MAX, BODY_WEIGHT_STEP)
for i in range(NUM_DATA_POINTS):
    timeDiff = i*60*60*1000 # Converted to milliseconds
    heartRate = random.randrange(HEART_RATE_MIN, HEART_RATE_MAX, HEART_RATE_STEP)
    calories = random.randrange(CALORIES_MIN, CALORIES_MAX, CALORIES_STEP)
    steps = random.randrange(STEPS_MIN, STEPS_MAX, STEPS_STEP)
    
    #We only want to update the bodyWeight every 24 data points (body weight measurement changes once per day)
    if (i % 24) == 0:
        bodyWeight = random.randrange(BODY_WEIGHT_MIN, BODY_WEIGHT_MAX, BODY_WEIGHT_STEP)
    
    hrDataSample = {}
    hrDataSample['value'] = str(heartRate)
    hrDataSample['timeDiff'] = str(timeDiff)
    metricsDict['Metrics']['HeartRate'].append(hrDataSample)

    bwDataSample = {}
    bwDataSample['value'] = str(bodyWeight)
    bwDataSample['timeDiff'] = str(timeDiff)
    metricsDict['Metrics']['BodyWeight'].append(bwDataSample)

    calDataSample = {}
    calDataSample['value'] = str(calories)
    calDataSample['timeDiff'] = str(timeDiff)
    metricsDict['Metrics']['Calories'].append(calDataSample)

    stepsDataSample = {}
    stepsDataSample['value'] = str(steps)
    stepsDataSample['timeDiff'] = str(timeDiff)
    metricsDict['Metrics']['Steps'].append(stepsDataSample)

#############################################
# Writing the JSON Dictionary to the appropriate JSON files
#############################################
if (os.path.exists(PATH_TO_XCODE_JSON)):
    file = open(PATH_TO_XCODE_JSON+'healthData.json', 'w')
    file.write(json.dumps(metricsDict, indent=2))
    file.close()
    print("Updated the XCode JSON file at path = " + PATH_TO_XCODE_JSON)
else:
    print("Error: Path to \'" + PATH_TO_XCODE_JSON + "\' does not exist...")

if (os.path.exists(PATH_TO_ANDROID_JSON)):
    file = open(PATH_TO_ANDROID_JSON+'healthData.json', 'w')
    file.write(json.dumps(metricsDict, indent=2))
    file.close()
    print("Updated the Android JSON file at path = " + PATH_TO_ANDROID_JSON)
else:
    print("Error: Path to \'" + PATH_TO_ANDROID_JSON  + "\' does not exist...")


