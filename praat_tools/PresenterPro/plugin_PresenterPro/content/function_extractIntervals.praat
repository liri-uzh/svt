form Extract_intervals...
	optionmenu Sound_format 1
		option Sound
		option LongSound
	sentence Write_directory (insert full directory path)
	comment Make sure your Sound and TextGrid are selected before you proceed
endform

if sound_format = 1
	sound = selected("Sound")
else
	sound = selected("LongSound")
endif
tg = selected("TextGrid")
name$ = selected$("TextGrid")

select tg
nIntervals = Get number of intervals: 1
for iInterval to nIntervals
	
	select tg
	label$ = Get label of interval: 1, iInterval
	if label$<>""

		start = Get start point: 1, iInterval
		end = Get end point: 1, iInterval
		underscore = index(label$, "_")
		noc = length(label$)
		number$ = left$(label$, underscore-1)
		sentence$ = mid$(label$, underscore+1, noc)

		select sound
		soundPart = Extract part: start, end, "rectangular", 1, "no"
		Save as WAV file: "'write_directory$'/'name$'_'number$'.wav"

		tgPart = To TextGrid: "utterance", "none"
		Set interval text: 1, 1, sentence$
		Save as text file: "'write_directory$'/'name$'_'number$'.TextGrid"
		
		writeFileLine: write_directory$+"/"+name$+"_"+number$+".txt", sentence$

		select soundPart
		plus tgPart
		Remove

	endif
		
endfor

select sound
plus tg