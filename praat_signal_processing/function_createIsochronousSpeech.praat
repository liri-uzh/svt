### function_createIsochronousSpeech.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# Description: 
# This script creates speech with isochronous intervals
# based on any labelled tier (e.g. segments, syllables, CV-intervals, etc.)
#
# INPUT:
#    - A Sound with a corresponding TextGrid that contains sensible intervals (like sgements, syllables, etc.)
# 
# OUTPUT:
#		 - A new Sound with a corresponding TextGrid in which the intervals are 
#      isochronous, apart from intervals labelled as speech pauses. New
#      interal duration is the mean duration of all non pause intervals. This 
#      mean can be adjusted by the duration ratio. 
# 
# INSTRUCTIONS: 
#    - Select a Sound object with the corresponding TextGrid Object in the list of objects. 
#    - Execute the script. 
#
# PARAMETER SETTINGS: 
#    - tier: chose which you tier you want to turn into an isochronous tier (must be interval tier)
#    - silence label: write the label for speech pauses - these intervals will be disregarded
#       Note: if left empty, all empty intervals will be disregarded. 
#      If no pause label is chosen, pauses will be incldued in mean calculation which can obscure mean values strongly in case of very short or long pause intervals. 
#    - output file siffix: a suffix that will be added to your output Sound and TextGrid names
#    - duration ratio: Will change the overall duration ratio of your intervals compared to the input signal
#         (duration will be multiplied by duration ratio,
#         i.e. duration ratio>1 will make signal longer [slower]; <1 will make them shorter [faster])
#
# TRICKS:
#    - if you want to see the intermediate objects that are being created then silence the second last line (removeObject: [...]) 
#
# HISTORY 
#    6.12.2012: created
#    22.4.2020: 
#      - adapted new Praat syntax
#      - added funcion to adjust the overall ratio of change
#
###

form Make me isochronous...
	comment Which tier do you want to set isochronous?
	positive tier 1
	word Silence_label <p:>
	word Output_file_suffix syl
	real Duration_ratio 1
endform

sound = selected("Sound")
name$ = selected$("Sound")
tg = selected("TextGrid")

# Create table of chosen tier and calculate factor for interval duration change: 

	# Create tabel and add missing columns: 
	selectObject: tg
	tierObject = Extract one tier: tier
	table = Down to Table: 0, 10, 1, 0
	Append column: "type"
	Append column: "duration"
	Append column: "factor"
	Append column: "finalDuration"

	# Distinguish between silence (sil) and speech (sp)
	Formula: "type", ~if self$["text"]=silence_label$ then "sil" else "sp" fi

	# Calculated durations:
	Formula: "duration", ~self["tmax"]-self["tmin"]

	# Get mean duration of non-silence intervals:
	meanIntervalDuration = Get group mean: "duration", "type", "sp"

	# Calculate factor by which interval duration is changed and make sure you do not change silence intervals:
	Formula: "factor", ~if self$["type"]="sil" then 1 else meanIntervalDuration/self["duration"] fi

	# Adjust overall duration for duration ratio: 
	Formula: "factor", ~self*duration_ratio

	# Apply final durations of intervals:
	Formula: "finalDuration", ~if self$["type"]="sil" then self["duration"]*duration_ratio else meanIntervalDuration*duration_ratio fi

# Create durationTier and add duration points for isochronous interval durations:

	durationTier = Create DurationTier: "newDurations", 0, object[sound].xmax
	for iSI to object[table].nrow
		Add point: object[table, iSI, "tmin"]+0.01, object[table, iSI, "factor"]
		Add point: object[table, iSI, "tmax"]-0.01, object[table, iSI, "factor"]
	endfor

# Create new sound object based on isochronous durations: 

	selectObject: sound
	noprogress To Manipulation: 0.01, 75, 600
	manipulation = selected("Manipulation")
	selectObject: manipulation, durationTier
	Replace duration tier
	selectObject: manipulation
	outSound = Get resynthesis (overlap-add)
	Rename: name$+"_"+output_file_suffix$

# Create TextGrid with adjusted isochronous durations: 

	# Create output TextGrid: 
	selectObject: outSound
	totalDuration = Get total duration
	outTG = Create TextGrid: 0, totalDuration, output_file_suffix$, "none"
	Rename: name$+"_"+output_file_suffix$

	# Apply boundaries:
	selectObject: outTG
	boundary=0
	for iInt to object[table].nrow
		boundary+= object[table, iInt, "finalDuration"]
		if iInt<object[table].nrow
			Insert boundary: 1, boundary
		endif
		Set interval text: 1, iInt, object$[table, iInt, "text"]
	endfor

# Clean up: 

	removeObject: tierObject, table, manipulation, durationTier

# Leave output selected for other applications to find it: 

	selectObject: outSound, outTG
