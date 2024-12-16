### function_chimerize.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch), Lei He (lei.he@uzh.ch) and Elias Pellegrino 
#
# History: 
#    - 01.05.2015: created (VD & EP)
#    - 17.05.2015: added Hilbert env and tfs methods (LH and VD)
#    - 30.05.2015: bug-fixes and protocoll added
#
# DESCRIPTION: 
#    This script exchanges the envelopes between two Sounds. You can choose the number of 
#    frequency bands from which the envelopes are taken. 
# 
# INPUT:
#    Two Sound objects (selected).
#
# OUTPUT:
#    (a) a new Sound object containing the ENV of the other sound
#    (b) a new Sound object containing the TFS of the sound ([soundname]_ENV_[soundname-other])
#
###

form Extract ENV and TFS...
	positive Minimum_frequency 80
	positive Maximum_frequency 8820
	positive Number_of_bands 1
	positive filter_slope 100
	optionmenu Fine_structure_method 1
		option Hilbert
		option Infinite peak clipping
	optionmenu Envelope_method 2
		option Hilbert
		option Low pass filtering
	comment When low-pass filtering: 
	positive ENV_frequency 30
	boolean Clean_up 1
	boolean Print_protocol 1
endform
clearinfo

# 0 # Report date:

	date$ = date$()
	fileappend log_chimerize.txt 'date$''newline$'

# 1 # Get object information: 

	sound1 = selected("Sound", 1)
	name1$ = selected$("Sound", 1)
	sound2 = selected("Sound", 2)
	name2$ = selected$("Sound", 2)
	fileappend log_chimerize.txt 'tab$'name1$' - 'name2$'

# 2 # Loop through bands and exchange ENV between speakers: 

	if print_protocol
		table = Create Table with column names... filters 1 band lowCutoff highCutoff bandwidth slope
	endif

	# Get stepsize of frequency bands on log scale: 
	maxLogFrequency = ln(maximum_frequency/minimum_frequency)
	stepSize = maxLogFrequency/number_of_bands
	euler = e

	for iBand to number_of_bands
			
		# calculate filter characteristics: 

			lowCutoff = minimum_frequency*(euler^(stepSize*iBand-stepSize))
			highCutoff = minimum_frequency*(euler^(stepSize*iBand))
			bandwidth = highCutoff-lowCutoff
			slope_in_Hz = (bandwidth/2)*(filter_slope/100)

		# Band-pass filter sounds:

			# sound1:
			select sound1
			sound1_band = Filter (pass Hann band)... lowCutoff highCutoff slope_in_Hz
			Rename... sound1_'iBand'

			# Band-pass filter sound2:
			select sound2
			sound2_band = Filter (pass Hann band)... lowCutoff highCutoff slope_in_Hz
			Rename... sound2_'iBand'

		#  Extract envelope and fine-structure for each sound: 

			# sound1:
			select sound1_band 
			call extractENVandTFS sound1_band
			env1 = selected("Sound", 1)
			tfs1 = selected("Sound", 2)
			select env1
			Rename... env1
			select tfs1
			Rename... tfs1

			# sound2:
			select sound2_band
			call extractENVandTFS sound2_band
			env2 = selected("Sound", 1)
			tfs2 = selected("Sound", 2)
			select env2
			Rename... env2
			select tfs2
			Rename... tfs2

		#  Exchange envelope and fine structure: 

			select tfs1
			Formula... self*Sound_env2[]
			select tfs2
			Formula... self*Sound_env1[]

		# Name bands 

			band1_'iBand' = tfs1
			band2_'iBand' = tfs2
			select tfs1
			Rename... band1_'iBand'
			select tfs2
			Rename... band2_'iBand'

		# Clean up 

			select env1
			plus env2
			plus sound1_band
			plus sound2_band
			Remove
		
	endfor

# 3 # Put bands back together for each sound:

	select band1_1
	sound1_new = Copy... 'name1$'_ENVof_'name2$'_nB'number_of_bands'
	for iBand from 2 to number_of_bands	
		Formula... self+Sound_band1_'iBand'[]
	endfor
	Scale intensity... 70

	select band2_1
	sound2_new = Copy... 'name2$'_ENVof_'name1$'_nB'number_of_bands'
	for iBand from 2 to number_of_bands
		Formula... self+Sound_band2_'iBand'[]
	endfor
	Scale intensity... 70
	
# 4 # Clean up: 

	select band1_1
	for iBand to number_of_bands
		plus band1_'iBand'
		plus band2_'iBand'
	endfor
	if clean_up=1
		Remove
	endif

# 5 # Leave output selected: 

	select sound1_new
	plus sound2_new


#### PROCEDURES ####

procedure extractENVandTFS sound

	# Create ENV:

		if envelope_method = 1

			# use Hilbert method:
			select sound
			sound$ = selected$("Sound")
			spectrum = To Spectrum... 0
			Rename... original
			spectrumHilbert = Copy... hilbert
			Formula... if row=1 then Spectrum_original[2,col] else -Spectrum_original[1,col] fi
			soundHilbert = To Sound (fft)
			env = Copy... ENV
			Formula... sqrt(self^2+Sound_'sound$'[]^2)
			Formula... if self<0.01 then 0.01 else self fi
			
			# clean up:
			select spectrum
			plus spectrumHilbert
			plus soundHilbert
			Remove

		elsif envelope_method = 2

			# use low-pass filtering of rectified signal:
			select sound
			rectified = Copy... rectified
			Formula... sqrt(self^2)
	
			# band-pass rectified signal: 			
			select rectified
			env = Filter (pass Hann band)... 0 eNV_frequency 1
			Scale peak... 0.99
			Formula... if self<=0.001 then 0 else self fi
			Rename... ENV
			select rectified
			Remove

		endif

	# Create TFS

		if fine_structure_method = 1

			# use Hilbert method: 
			select sound
			sound$ = selected$("Sound")
			spectrum = To Spectrum... 0
			Rename... original
			spectrumHilbert = Copy... hilbert
			Formula... if row=1 then Spectrum_original[2,col] else -Spectrum_original[1,col] fi
			soundHilbert = To Sound (fft)
			env_temp = Copy... 'sound$'_ENV
			Formula... sqrt(self^2+Sound_'sound$'[]^2)
			Formula... if self<0.01 then 0.01 else self fi
			inverse = Copy... inverse_ENV
			Formula... 1/self

			select sound
			tfs = Copy... 'sound$'_TFS
			Formula... self*Sound_inverse_ENV[]

			# Clean up:
			select spectrum
			plus spectrumHilbert
			plus soundHilbert
			plus env_temp
			plus inverse
			Remove

		elsif fine_structure_method = 2

			# use infinite peak clipping with prior de-emphasis:
			select sound
			tfs = Filter (de-emphasis)... 1000
			Rename... TFS
			silence_threshold = 0.01
			Formula... if self>silence_threshold then 0.9 else -0.9 fi	
		endif
	
	# Leave output selected

		select env
		plus tfs

endproc

