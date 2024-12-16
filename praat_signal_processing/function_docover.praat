######################################
#
# Praat script: docover.praat
# written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# A dovocver is a function that removes the amplitude envelope 
# of a singnal and maintans the signal temporal fine-structure only.
# The name has been derived from Vocoder by spelling 'vocod' backwards. 
# A vocoder is a function that somehow does the opposite. It maintains 
# the envelope of speech and fills it with a different temporal fine-
# structure. 
#
# CREDITS: 
# - This script is based on the the noise vocoder script by 
# Micah Bregman, Aniruddh Patel, Timothy Gentner downloadable under
# www.pnas.org/content/suppl/2016/01/20/1515380113.../pnas.1515380113.sd01.docx
# - The process to extract the Hilbert signal has been adopted from a script
# by Lei He and Volker Dellwo. 
#
# HISTORY:
# 7. June 2023: created
# 
#######################################

form Docover...
	positive Number_of_bands 4
	positive Lower_cutoff_(Hz) 50
	positive Upper_cutoff_(Hz) 10000
	boolean Clean_up 1
endform

s1 = selected("Sound",1)
s1$ = selected$("Sound",1)
t = Get total duration

# parameters: 
sr = 2 * upper_cutoff + 1000
blower_cutoff = hertzToBark(lower_cutoff)
bupper_cutoff = hertzToBark(upper_cutoff)
step = (bupper_cutoff - blower_cutoff)/number_of_bands

# loop through bands
for i to number_of_bands

	# for adding previous bands
	if i > 1
		selectObject: band[i-1]
		Rename: "previous"
	endif

	# get limits for band
	bandUpper = blower_cutoff + i * step
	bandLower = bandUpper - step
	temp1 = round(barkToHertz(bandLower))
	temp2 = round(barkToHertz(bandUpper))

	# account for filtersmoothing
	temp1 = temp1 + 25
	temp2 = temp2 - 25

	# generate estimate of ENERGY in band of SOURCE
	selectObject: s1
	signalFiltered = Filter (pass Hann band): temp1, temp2, 50
		# get name
		signalFiltered$ = selected$("Sound")
		# get overall rms in band
		rms_SOURCE = Get root-mean-square: 0, 0
		# Remove zero samples in sound: 
		Formula: ~if self=0 then (self[col-1]+self)/2 else self fi

	# Produce a spectrum by FFT:
	selectObject: signalFiltered
	spectrum = To Spectrum: 0
		Rename: "original"

	# Shift imaginary parts by 90 degrees in Hilbert spectrum:  
	selectObject: spectrum
	spectrumHilbert = Copy: "hilbert"
		Formula: ~if row=1 then Spectrum_original[2,col] else -Spectrum_original[1,col] fi

	# Get the Hilbert sound
	selectObject: spectrumHilbert
	soundHilbert = To Sound
		Rename: signalFiltered$ +"_HILBERT"
		# Remove zero samples in sound
		Formula: ~if self=0 then (self[col-1]+self)/2 else self fi

	# Get the ENV : 
	selectObject: soundHilbert
	env = Copy: signalFiltered$ +"_ENV"
		Formula: ~sqrt(self^2+Sound_'signalFiltered$'[]^2)

	# Produce inverse ENV: 
	inverse = Copy: "inverse_ENV"
		Formula: ~1/self

	# Multiply inverse ENV with sound to get TFS:
	selectObject: signalFiltered
		tfs = Copy: signalFiltered$ +"_TFS"
		Formula: ~self*Sound_inverse_ENV[]

		# adjust overall amplitude
		rms_IS = Get root-mean-square: 0, 0
		Multiply: rms_SOURCE/rms_IS
		Rename: "band_'i'"
		band[i] = selected("Sound")

	# add previous bands
	if i > 1
		Formula: ~self[col] + Sound_previous[col]
	endif

	if clean_up
		removeObject: signalFiltered, inverse, env, soundHilbert, spectrumHilbert, spectrum
	endif

endfor

if i>1
	for i to number_of_bands-1
		removeObject: band[i]
	endfor
endif
	
selectObject: band[number_of_bands]
Rename: s1$+"_doc'number_of_bands'"

