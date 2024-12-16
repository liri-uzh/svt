### START SCRIPT
#
# Name:
# normalizeIntensity.praat
# 
# Praat Script for Praat software (www.praat.org, version 6.1.50)
# Written by Volker Dellwo (volker.dellwo@uzh.ch) 
#
# History: 
#    V_0.1: 30.7.2021: created
#
# DESCRIPTION: 
#    This script sets the intensity of specified time
#    interval of a sound file to a constant value.  
# 
# INPUT:
#    - directory with WAV and corresponding TextGrids
#    - Text Grids must have three intervals in the first tier 
#      specifying pre-speech, speech and post-speech intervals
#
# OUTPUT:
#    - a directory with files in which only the speech interval 
#      is normalized to the wanted intensity
#

# Variable settings: 
rDir$ = "in/"; read directory
wDir$ = "out/"; write directory
dB = 70; mean intensity that speech will be changed to

# start measuring runtime: 
stopwatch

# loop through files in read directory (rDir$):
fileList = Create Strings as file list: "fileList", rDir$+"*.wav"
nFile = Get number of strings
for iFile to nFile

	selectObject: fileList
	file$ = Get string: iFile
	name$ = file$-".wav"
	
	sound.o = Read from file: rDir$+name$+".wav"
	tg.o = Read from file: rDir$+name$+".TextGrid"
	
	selectObject: tg.o

		# Get relevant time points from TextGrid: 
		start = Get start point: 1, 2
		end = Get end point: 1, 2
		
		# Save a version to out directory: 
		Save as text file: wDir$+name$+".TextGrid"		

	selectObject: sound.o

		# Move cut points to zero crossing: 
		start = Get nearest zero crossing: 1, start
		end = Get nearest zero crossing: 1, end

		# Get rms from speech:
		rms = Get root-mean-square: start, end

		# rms target for speech in pascals and factor to multiply speech signal with:
		rms_target = 0.00002*(10^(dB/20))

		factor = rms_target/rms
		
		# Apply target to speech signal
		Multiply: factor

		# Save: 
		Save as WAV file: wDir$+name$+".wav"

	# clean up: 
	removeObject: sound.o, tg.o

endfor

# final clean up: 
removeObject: fileList

# get runtime and report finish and runtime: 
runtime=stopwatch
writeInfoLine: "Script finished! This took me ", fixed$(runtime,2), " sec."

###### END SCRIPT ######


