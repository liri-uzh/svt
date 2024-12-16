### function_rotatePitch.praat (version 0.02)
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# Description: 
# This script rotates the pitch contour around 
# its average.
#
# Disclaimer: The pitch contour will be perfectly
# rotated, however, resynthesising a speech recording 
# with an rotated contour does not always lead 
# to the expected output. If you can, use the pitch 
# contours only. 
#
# Version history: 
# 0.01 (2012.03.18) created
# 0.02 (2020.01.23) adapted to new Praat code
#
###

form Invert pitch contour...
	positive Pitch_ceiling 600
	boolean Only_show_sound_resynthesis 0
endform

name$ = selected$("Sound")
sound = selected("Sound")
   
# Create and invert pitch
originalPitch = To Pitch: 0, 75, pitch_ceiling
Rename: "original"
rotatedPitch = Copy: "rotated"
average = Get mean: 0, 0, "Hertz"
Formula: ~average*exp(-1*ln(self/average))

# Resynthesis:
selectObject: sound, rotatedPitch
manipulation = To Manipulation
resynthesis = Get resynthesis (overlap-add)
Rename: name$+"_rotatedPitch"

# Clean up:
removeObject: manipulation

if only_show_sound_resynthesis
	removeObject: originalPitch, rotatedPitch
endif

# Leave output selected: 
selectObject: resynthesis
