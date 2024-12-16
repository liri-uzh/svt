######################################
#
# Praat script: vocoder.praat
#
# Noise vocoder based on a script by 
# Micah Bregman, Aniruddh Patel, Timothy Gentner
# downloadable under
# www.pnas.org/content/suppl/2016/01/20/1515380113.../pnas.1515380113.sd01.docx
#
# 21. June 2017: The present version was adapted to the current Praat version (6.0.29)
# by Volker Dellwo (volker.dellwo@uzh.ch) with the following inovations: 
# - The object removal commands got changed so that the script does not 
#   remove previously existing objects in the list of objects in Praat. 
# - The stack processing procedure got removed. The script can now be carried out 
#   manually on a Sound Object in Praat and can easily be implemented in 
#   in a stack processing procedure by the following line: 
#   runScript: "[path/]vocoder.praat", [number of bands], [lower cutoff], [upper cutoff], [clean up list of objects]
# - A form got included to make it easier to change variables manually or when passed
#   on in through a stack processing procedure. 7
# 8. April 2020: (Volker Dellwo)
# - Code updated
# - Corrected a bug that would not allow the script to do single channel vocoding.
# 9. May 2023: (Volker Dellwo)
# - Bug fix: corrected line that would make script crash
# 
#######################################

form Vocoder...
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

	# get overall rms in band
	rms_SOURCE = Get root-mean-square: 0, 0

	# get intensity contour
	intObj = To Intensity: 100, 0, 1
	intTier = Down to IntensityTier

	# create a noise-band sound
	noiseBand = Create Sound: "noise", 0, t, sr, "randomGauss(0,0.1)"
	noiseFiltered = Filter (pass Hann band): temp1, temp2, 50

	# add intensity contour of source
	selectObject: noiseFiltered, intTier
	Multiply: 0

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
		removeObject: signalFiltered, intObj, intTier, noiseBand, noiseFiltered
	endif

endfor

if i>1
	for i to number_of_bands-1
		removeObject: band[i]
	endfor
endif
	
selectObject: band[number_of_bands]
Rename: s1$+"_voc'number_of_bands'"

