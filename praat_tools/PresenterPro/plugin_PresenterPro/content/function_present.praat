### START SCRIPT ###
form Present...
	positive Start_from 1
endform

# load the settings from the settings file: 
include settings.txt

# get details of sentence list

	sentenceList = selected("Strings")
	nSentences = Get number of strings

# play calibration sound: 

	tone = Create Sound from formula... sine 1 0 0.5 10000 1/2 * sin(2*pi*500*x)
	Play
	Remove

# start time:

	stopwatch

# prepare demo window

	demoWindowTitle ("PresenterPro")
	demo Select inner viewport: 0, 100, 0, 100
	demo Axes: 0, 100, 0, 100

# loop through sentences: 

	totalTime=0.3
	for iSentence from start_from to nSentences

	# Get sentence: 

		select sentenceList
		sentence$[iSentence] = Get string... iSentence
		
	# Present RED screen with text

		demo Erase all
		demo 'font_colour$'
		demo 'font$'
		demo Select inner viewport: 0, 100, 0, 100
		demo Paint rectangle: "Maroon", 0, 100, 0, 100
		runScript: "function_text2demo.praat", sentence$[iSentence], font_size, line_width, line_spacing, 65, 50, "centre", 0
		demoShow()

###### REPAIR HERE ###
	# This code stopped working with a Praat update sometime ago:
	# A temporary patch is to have users clicking into the screen to finish the red screen:
	demoWaitForInput()

	# desired code paused from here:

	# Delay the presentation of the speak window: 
	# sleep(countdown_duration)

	# desired code paused till here
###### REPAIR END ###

	# Present GREEN screen with text

		demo Erase all
		demo 'font_colour$'
		demo 'font$'
		demo Select inner viewport: 0, 100, 0, 100
		demo Paint rectangle: "Green", 0, 100, 0, 100
		runScript: "function_text2demo.praat", sentence$[iSentence], font_size, line_width, line_spacing, 65, 50, "centre", 0
		demoShow()

	# Add control buttons:

		demo Black
		demo Paint rounded rectangle... silver 20 25 5 10 3
		demo Paint rounded rectangle... silver 40 60 5 10 3
		demo Paint rounded rectangle... silver 75 80 5 10 3
		demo Paint rounded rectangle... silver 93 98 2 8 3
		demo Arrow size: 2
		demo Draw arrow... 24 7.5 21 7.5
		demo Draw arrow... 76 7.5 79 7.5
		demo Text special... 50 centre 7.5 half 'font$' 20 0 repeat
		demo Text special... 95.5 centre 4.5 half 'font$' 15 0 EXIT
		demoShow()

   # Get time of stopwatch

		delay = stopwatch
		totalTime+=delay
		start[iSentence] = totalTime

   # Display sentence number if asked for by user: 

		if display_sentence_number = 1
			demo Grey
			demo Text special... 50 centre 30 half 'font$' 30 0 'iSentence'/'nSentences'
			demoShow()
		endif

   # Wait for input if control is on screen

		label SCREEN
		demoPeekInput()
		while demoWaitForInput ()
            
			# Go back a sentence:
			if demoClickedIn (20, 25, 5, 10)
				if iSentence=1
					iSentence-=1
					goto END
				else
					iSentence -=2
					goto END
				endif

			# Repeat the sentence
			elsif demoClickedIn (40, 60, 5, 10)
				iSentence -=1
				goto END

			# Go to next sentence
			elsif demoClickedIn (75, 80, 5, 10)
				delay = stopwatch
				totalTime+=delay
				end[iSentence] = totalTime
	        goto END

			# Exit earlier
			elsif demoClickedIn (93, 98, 2, 8)
				delay = stopwatch
				totalTime+=delay
				end[iSentence] = totalTime
				nSentences=iSentence
				goto END
			endif

		endwhile
		label END

endfor

# Create Text Grid

	textGrid = Create TextGrid... 0 end[nSentences]+0.5 reading
	counter = 2
	for iSentence from start_from to nSentences
		start = start[iSentence]
		end = end[iSentence]
		sentence$ = sentence$[iSentence]
		Insert boundary... 1 start-0.15
		Insert boundary... 1 end+0.15
		Set interval text... 1 counter 'iSentence'_'sentence$'
		counter+=2
	endfor
	Rename... 'speaker_id$'

# clean-up:

	demo Erase all

# leave output selected: 

	select textGrid

### END ###


