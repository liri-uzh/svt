### START SCRIPT ###
#
# function_addWhiteNoise.praat
#
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# DESCRIPTION:
# This scripts adds white-noise to a signal (input) with a specified signal-to-noise ratio.
# The average intensity of the signal will be set to to a specified value by the user (set 
# to 0 to keep intensity of original).
# 
# INPUT: sound object (select in list of objects)
# OUTPUT: sound object 
# REQUIREMENTS: no specifc requirements 
#
# HISTORY:  
# 8.11.2024 (01): created
#
# LICENSE: 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation (see <http://www.gnu.org/licenses/>). This 
# program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY.

form: "Add noise..."
	integer: "SNR", "0"
	integer: "New_signal_intensity", "0 (= no change)"
	integer: "New_sampling_frequency", "0 (= no change)"
	boolean: "Write_protocol", "1"
endform

# Select sound:

	sound = selected("Sound")
	sound$ = selected$("Sound")

# Copy the sound to the signal:

	signal = Copy: sound$+"_SNR'sNR'"
	signal$ = selected$("Sound")

# Adjust intensity of signal (if asked for by user):

	selectObject: signal
	signal_intensity = Get intensity (dB)
	if new_signal_intensity>0
		Scale intensity: new_signal_intensity
	elsif new_signal_intensity=0
		new_signal_intensity = signal_intensity
	elsif new_signal_intensity<0
		exitScript: "The signal intensity must be 0 (no change) or larger than 0"
	endif

# Adjust sampling frequency (if asked for by user): 
	
	selectObject: signal
	fs = Get sampling frequency
	if new_sampling_frequency>0
		old_signal = signal
		signal = Resample: fs, 50
		removeObject: old_signal
	elsif new_sampling_frequency=0
		new_sampling_frequency=fs
	elsif new_sampling_frequency<0
		exitScript: "The sampling frequency cannot be lower than 0 (chose 0 for no change)"
	endif

# Create noise and scale intensity: 

	selectObject: signal
	dur = Get total duration
	noise = Create Sound from formula: "noise", 1, 0, dur, fs, ~randomGauss(0,0.1)
	Scale intensity: new_signal_intensity-sNR

# Combine signal and noise

	selectObject: signal
	Formula: ~self+Sound_noise[]
	signalWithNoise = signal

# Write protocol: 

	if write_protocol
		if folderExists(preferencesDirectory$+"/protocol")!=1
			createFolder: preferencesDirectory$+"/protocol"
		endif
		if fileReadable(preferencesDirectory$+"/protocol/function_addWhiteNoise.txt")!=1
			writeFileLine: preferencesDirectory$+"/protocol/function_addWhiteNoise.txt", 
			..."date", tab$, 
			..."fileName", tab$,
			..."SNR", tab$,
			..."signalIntensity", tab$,
			..."fs"

		appendFileLine: preferencesDirectory$+"/protocol/function_addWhiteNoise.txt", 
			...date$(), tab$, 
			...signal$, tab$,
			...sNR, tab$,
			...new_signal_intensity, tab$,
			...new_sampling_frequency

# Clean up and leave new object selected: 

	removeObject: noise
	selectObject: signalWithNoise




