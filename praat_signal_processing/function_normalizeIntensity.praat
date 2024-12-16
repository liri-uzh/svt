### START SCRIPT ################
#
# Name:
# function_normalizeIntensity.praat
# 
# Praat Script for Praat software (www.praat.org, version 6.1.50)
# Written by Volker Dellwo (volker.dellwo@uzh.ch) 
#
# History: 
#   V_0.1: 30.7.2021: created
#		V_0.2: 10.10.2021: script can now normalize speech with 
#					multiple pauses
#   V_0.3: 2.11.2021: bug fixes
#
# DESCRIPTION: 
#    This script normalizes the intensity of a speech sound
#    disregarding silences. Silences must be indicated in a TextGrid.  
# 
# INPUT:
#    - selected Sound containing speech
#    - selected TextGrid containing silences 
#
# OUTPUT:
#    - a Sound object in which the concatenated speech intervals 
#      are normalized to the specified intensity.
#
#################################

form Normalize intensity...
	integer Mean_intensity_(dB) 70
	positive Tier 1
	sentence Pause_label sil
endform

# Variable settings: 

	dB = mean_intensity
	pl$ = pause_label$
	sound.o=selected("Sound")
	tg.o=selected("TextGrid")
	name$ = selected$("Sound")
	
# Set counting variables to zero:

	nRms=0
	sumRms=0

# loop through intervals of specified tier in TextGrid: 

	selectObject: tg.o
	nInt = Get number of intervals: tier
	for iInt to nInt

		# process pause intervals: 
		selectObject: tg.o
		label$ = Get label of interval: tier, iInt
		if label$ != pl$
		
			# get relevant time points from TextGrid: 
			start = Get start point: tier, iInt
			end = Get end point: tier, iInt
		
			# move cut points to zero crossing: 
			selectObject: sound.o
			start = Get nearest zero crossing: 1, start
			end = Get nearest zero crossing: 1, end

			# get rms from speech section:
			nRms+=1
			localRms = Get root-mean-square: start, end
			sumRms+=localRms
			
		endif

	endfor

# rms target for speech in pascals and factor to multiply speech signal with:

	rms = sumRms/nRms; average rms
	rms_target = 0.00002*(10^(dB/20))
	factor = rms_target/rms
		
# Apply target to speech signal

	selectObject: sound.o	
	newSound.o = Copy: name$+"_'dB'dB"
	Multiply: factor

# Leave output sound selected: 

	selectObject: newSound.o

###### END SCRIPT ######


