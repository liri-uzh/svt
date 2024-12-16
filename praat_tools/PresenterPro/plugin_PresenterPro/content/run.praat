label STARTOVER
deleteFile: "settings/temp_list.txt"
deleteFile: "settings/temp_speaker.txt"
start_from=1

label SCREEN
include settings.txt

# Demo window design:
 
	demo Erase all
	demo Select inner viewport: 0, 100, 0, 100
	demo Axes: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Black
	demo Arrow size: 5
	demo Line width: 5
	demo Draw arrow: 50, 90, 50, 25
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 93, "half", "Helvetica", 40, "0", "PresenterPro"

# BUTTONS: 

	# Code: Name, button color, text color, coordinates, text size, line width:
	@createButton: "button1", "Choose list", "navy", "0.8", "35 65 75 85", 20, 2
	@createButton: "button2", "Name speaker", "navy", "0.8", "35 65 62 72", 20, 2
	@createButton: "button3a", "Rec mono", "navy", "0.8", "35 49 49 59", 20, 2
	@createButton: "button3b", "Rec stereo", "navy", "0.8", "51 65 49 59", 20, 2
	@createButton: "button3c", "Start from: 'start_from'", "navy", "0.8", "38 62 36 46", 20, 2
	@createButton: "button4", "Start", "navy", "0.8", "38 62 15 23", 20, 2
	@createButton: "button5", "HELP", "grey", "{0.8,0.1,0.2}", "05 15 05 10", 10, 2
	@createButton: "button6", "SETTINGS", "grey", "{0.8,0.1,0.2}", "17 27 05 10", 10, 2
	@createButton: "button7", "Add list", "grey", "{0.8,0.1,0.2}", "29 39 05 10", 10, 2
	@createButton: "button8", "Remove list", "grey", "{0.8,0.1,0.2}", "41 51 05 10", 10, 2
	@createButton: "button11", "Extract intervals", "blue", "{0.8,0.1,0.2}", "55 65 05 10", 10, 2
	@createButton: "button9", "TextGrids", "blue", "{0.8,0.1,0.2}", "67 77 05 10", 10, 2
	@createButton: "button10", "EXIT", "grey", "{0.8,0.1,0.2}", "85 95 05 10", 10, 2

# Check if list and speaker have been chosen:

	listExist = fileReadable("settings/temp_list.txt")
	if listExist
		list$ = readFile$("settings/temp_list.txt")
		@createButton: "button1", list$, "navy", "0.8", "35 65 75 85", 20, 2
	endif
	speakerExist = fileReadable("settings/temp_speaker.txt")
	if speakerExist
		speaker$ = readFile$("settings/temp_speaker.txt")
		demo Black
		@createButton: "button2", speaker$, "navy", "0.8", "35 65 62 72", 20, 2
	endif

# RESPONSES:

	demoShow()
	while demoWaitForInput ()
		
		# choose list:
		if demoClickedIn 'button1$'

			list = Create Strings as file list... list lists/*.txt
			nLists = Get number of strings
			if nLists = 0
				pause You don't have a list. Add list first.
				goto SCREEN
			endif
			beginPause: "Choose list..."
				choice: "Lists", 1
					for iList to nLists
						list$ = Get string... iList
						option: list$
					endfor
			clicked = endPause: "Continue", "Cancel", 1
			Remove
			if clicked = 1
				list = Read Strings from raw text file: "lists/'lists$'"
				if randomize_list=1
					Randomize
				endif
				writeFileLine: "settings/temp_list.txt", lists$
			endif
			goto SCREEN
	
		# Name speaker
		elsif demoClickedIn 'button2$'

			beginPause: "Name speaker..."
				sentence: "Speaker_ID", "name"
			clicked = endPause: "Continue", "Cancel", 1
			if clicked=1
				writeFileLine: "settings/temp_speaker.txt", speaker_ID$
			endif
			goto SCREEN

		# Start recording
		elsif demoClickedIn 'button3a$'

			Record mono Sound... 
			goto SCREEN

		elsif demoClickedIn 'button3b$'

			Record stereo Sound...
			goto SCREEN


		elsif demoClickedIn 'button3c$'

			beginPause: "Change start sentence..."
				positive: "start_from", 1
			clicked = endPause: "Continue", "Cancel", 1
			@createButton: "button3c", "Start from: 'start_from'", "navy", "0.8", "38 62 36 46", 20, 2

		# Start presentation
		elsif demoClickedIn 'button4$'
			
			# Check whether list has been chosen:
			listExist = fileReadable("settings/temp_list.txt")
			if listExist<>1
				pause You first need to chose a list from the button above.
				goto SCREEN
			endif

			# Check whether name has been chosen:
			listExist = fileReadable("settings/temp_speaker.txt")
			if listExist<>1
				pause You first need to give your speaker a name.
				goto SCREEN
			endif

			# Create an id for subjects from a date stamp
   			date$ = date$()
   			m$ = mid$(date$,5,3)
   			d$ = mid$(date$,9,2)
   			d$ = replace_regex$ (d$," ","0", 0) ; Dank Dieter Studer kann ich jetzt auch endlich regex verwenden!!
   			y$ = right$(date$,4)
   			h$ = mid$(date$,12,2)
   			min$ = mid$(date$,15,2)
   			s$ = mid$(date$,18,2)
   			date$ = m$+d$+y$+h$+min$+s$
			
			# I had to fill in the following as the demoWaitForInput() in this script caused problems with the same command at the same time in the other script.
			goto PRESENT

		# HELP:
		elsif demoClickedIn 'button5$'

			Read from file... help.man

		# SETTINGS:
		elsif demoClickedIn 'button6$'

			execute function_settings.praat 0
			goto SCREEN

		# ADD LIST: 
		elsif demoClickedIn 'button7$'

			beginPause: "Choose txt file..."
				comment: "Type in the full path to your list:"
				sentence: "New list", ""
			clicked = endPause: "Continue", "Cancel", 1
			if clicked = 1
				Read Strings from raw text file: new_list$
				list$ = selected$("Strings")
				Save as raw text file: "lists/'list$'.txt"
				Remove
			endif
			goto SCREEN

		# REMOVE LIST:
		elsif demoClickedIn 'button8$'

			list = Create Strings as file list... list lists/*.txt
			nLists = Get number of strings
			beginPause: "Choose list..."
				choice: "Lists", 1
					for iList to nLists
						list$ = Get string... iList
						option: list$
					endfor
			clicked = endPause: "Continue", "Cancel", 1
			Remove
			if clicked = 1
				deleteFile: "lists/'list$'"
			endif
			goto SCREEN

		# EXTRACT INTERVALS: 
		elsif demoClickedIn 'button11$'

			beginPause: "Extract intervals..."
				optionMenu: "Sound_format", 1
					option: "Sound"
					option: "LongSound"
				sentence: "Write_directory", "insert full directory path here"
				comment: "Make sure your Sound and TextGrid are selected before you proceed"
			clicked = endPause: "Continue", 1
					
			runScript: "function_extractIntervals.praat", sound_format$, write_directory$

		# Show TextGrids: 
		elsif demoClickedIn 'button9$'
			
			list = Create Strings as file list... list textGrids/*.TextGrid
			nLists = Get number of strings
			if nLists = 0
				pause You don't have any TextGrids. Record first.
				goto SCREEN
			endif
			beginPause: "Choose TextGrid..."
				choice: "Lists", 1
					for iList to nLists
						list$ = Get string... iList
						option: list$
					endfor
			clicked = endPause: "Continue", "Cancel", 1
			Remove
			if clicked = 1
				list = Read from file: "textGrids/'lists$'"
			endif
			goto SCREEN

		# EXIT:
		elsif demoClickedIn 'button10$'
			goto END

		# If user clicks outside the buttons go back to beginning
		else
			goto SCREEN
		endif

   endwhile

label PRESENT

# exectute presentation:
select list
runScript: "function_present.praat", start_from
textGrid = selected("TextGrid")
Rename: speaker_ID$

# Save TextGrid
Write to text file: "textGrids/'speaker_ID$'_'date$'.TextGrid"
select list
Remove

goto STARTOVER



label END

# Demo window design:   
	demo Erase all
	demo Select inner viewport: 0, 100, 0, 100
	demo Axes: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 60, "half", "Helvetica", 30, "0", "Thank you for using PresenterPro"
	demo Colour: "black"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 12, "0", "You can now close this window"
	demoShow()



###### PROCEDURES #######

	procedure createButton: id$, name$, colorButton$, colorText$, coordinates$, textSize, lineWidth
		x1 = number(mid$(coordinates$,1, 2))
		x2 = number(mid$(coordinates$,4, 2))
		y1 = number(mid$(coordinates$,7, 2))
		y2 = number(mid$(coordinates$,10, 2))
		'id$'$ = "('x1', 'x2', 'y1', 'y2')"
		demo Paint rounded rectangle: colorButton$, x1, x2, y1, y2, lineWidth
		demo Red
		demo Line width: lineWidth
		demo Draw rounded rectangle: x1, x2, y1, y2, lineWidth
		demo Colour: 0.8
		demo Text special: (x1+x2)/2, "centre", (y1+y2)/2, "half", "Helvetica", textSize, "0", name$
	endproc

### END SCRIPT ###