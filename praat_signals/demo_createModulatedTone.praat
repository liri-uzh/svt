### START SCRIPT ###
#
# function_createSinusoidallyAmplitudeModulatedTone.praat 
#
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# DESCRIPTION:
# This script creates a sinusoidally amplitude modulated (SAM) tone 
# Users can chose the frequency of the tone (Carrier frequency (Hz)),
# the frequency of the modulation cycles (Modulation frequency (Hz); 
# f(Modulator)/2) and the number of modulation cycles. The script 
# calculates the total duration of the SAM tone from the number of 
# modulation cycles and rate of modulation cycles (number_of_cycles/
# modulation_frequency). 
#
# HISTORY:  
# 10.12.2015 (01): created
# 8.5.2016 (02): modified
# 
# LICENSE: 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation (see <http://www.gnu.org/licenses/>). This 
# program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY.

form Create Sound from sinusoidally amplitude modulated tone...
	real Modulation_frequency_(Hz) 5
	real Carrier_frequency_(Hz) 250
	positive Number_of_modulation_cycles 10
	real Intensity 70
	boolean Clean_up 1
endform

# Determine duration of SAM

	duration = (number_of_modulation_cycles/modulation_frequency)

# Create modulator and carrier: 

	modulator = Create Sound from formula... modulator 1 0 duration 44100 sin(2*pi*(modulation_frequency/2)*x)
	carrier = Create Sound from formula... carrier 1 0 duration 44100 sin(2*pi*carrier_frequency*x)

# Create modulated tone: 

	modulatedTone = Copy: "sine'carrier_frequency'_AM'modulation_frequency'"
	Formula... self*Sound_modulator[]

# Scale the output intensity: 

	Scale intensity... intensity

# Clean up modulator and carrier: 

	if clean_up
		select modulator
		plus carrier
		Remove
	endif

# Leave modulated tone selected: 

	select modulatedTone

