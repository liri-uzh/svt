form Apply durations
	positive Tier 1
	optionmenu Morphing_direction 2
		option One is donor
		option Interpolate
		option Two is donor
endform

tg1 = selected("TextGrid", 1)
sound1 = selected("Sound", 1)
name1$ = selected$("Sound", 1)
tg2 = selected("TextGrid", 2)
sound2 = selected("Sound", 2)
name2$ = selected$("Sound", 2)

if morphing_direction = 1

	select tg1
	textGrid_donor = Copy... donor

elsif morphing_direction = 2

	call create_interpolated_tg
	textGrid_donor = newTg

elsif morphing_direction = 3

	select tg2
	textGrid_donor = Copy... donor

endif

sound_receiver = sound1
textGrid_receiver = tg1
name$ = name1$
call applyTemporalManipulation

sound_receiver = sound2
textGrid_receiver = tg2
name$ = name2$
call applyTemporalManipulation

select textGrid_donor
Remove

# leave output selected:
select newSound_'name1$'
plus newTG_'name1$'
plus newSound_'name2$'
plus newTG_'name2$'


##### PROCEDURES ######

procedure create_interpolated_tg

	select tg1
	duration1 = Get total duration
	select tg2
	duration2 = Get total duration
	meanDuration = (duration1+duration2)/2
	newTg = Create TextGrid... 0 meanDuration segment none
	Rename... interpolated

	select tg1
	nIntervals = Get number of intervals... 1
	durationMemory = 0
	for iInterval to nIntervals

		select tg1
		start1 = Get start point... 1 iInterval
		end1 = Get end point... 1 iInterval
		duration1 = end1-start1 
		label1$ = Get label of interval... 1 iInterval

		select tg2
		start2 = Get start point... 1 iInterval
		end2 = Get end point... 1 iInterval
		duration2 = end2-start2 
		label2$ = Get label of interval... 1 iInterval

		newDuration = (duration1+duration2)/2
		durationMemory+=newDuration
		if label1$ = label2$

			select newTg
			if iInterval<>nIntervals
				Insert boundary... 1 durationMemory
			endif
			Set interval text... 1 iInterval 'label1$'

		else
	
			echo TextGrids 'tg1' and 'tg2' have different label 'iInterval' 
			exit

		endif

	endfor

endproc


procedure applyTemporalManipulation

	select sound_receiver
	noprogress To Manipulation... 0.01 75 400
	manipulation = selected("Manipulation")
	durationTier = Extract duration tier

	select textGrid_donor
	nIntervals = Get number of intervals... tier

	for iInterval to nIntervals

		select textGrid_donor
		start_don = Get start point... tier iInterval
		end_don = Get end point... tier iInterval
		duration_don = end_don-start_don
		label$ = Get label of interval... tier iInterval

		select textGrid_receiver
		start_rec = Get start point... tier iInterval
		end_rec = Get end point... tier iInterval
		duration_rec = end_rec-start_rec

		factor = duration_don/duration_rec

		select durationTier
		Add point... start_rec+0.001 factor
		Add point... end_rec-0.001 factor

	endfor

	select manipulation
	plus durationTier
	Replace duration tier

	select manipulation
	newSound_'name$' = Get resynthesis (overlap-add)
	Rename... 'name$'

	select textGrid_donor
	newTG_'name$' = Copy... 'name$'

	# clean up: 
	select manipulation
	plus durationTier
	Remove

endproc



