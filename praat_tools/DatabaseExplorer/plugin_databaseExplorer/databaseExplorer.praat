### databaseExplorer.praat ###
#
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# DESCRIPTION:
# Databases typically have many files in one directory. In 
# Praat it can be a bit bulky to run through a file collection. 
# The fundamental idea of databaseExplorer is 
# that you can simply loop through a number of files in a 
# directory and can carry out simple edits. To change from 
# one file to the next or back, you can simply use the arrow 
# buttons. 
#  
# INPUT: Select a Sound object in the Praat list of objects
# OUTPUT (optional): a Sound with a TextGrid that is saved in a 
#				directory of your choice
# REQUIREMENTS: none 
#
# METHOD: 
# - starts from a Sound object in the list of objects  
# - obtains the information where the sound is located
# - lists all sounds in the directory in relation to the sound
# - allows basic editing
#
# HISTORY:  
# 23.01.2021 (01): created
# 05.01.2022 (02): 	- allowed to chose file extension (e.g. wav, mp3, etc.)
#										- included TextGrids
#
# LICENSE: 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation (see <http://www.gnu.org/licenses/>). This 
# program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY.
#
################################

original.sound = selected("Sound")

# Start settings

	windowLength = 0.005; duration of frame for spectral analysis
	fMax = 8000; maximum frequency for spectral display
	writeDirectory$ = "-choose with 'w'-"
	fileExtension$ = "mp3"
	include_TextGrid = 0
	fMax = 8000; Maximum frequency for spectrogram
	move_forward_with_blank = 1
	save_originals = 0

# Put path, file and extension names into variables

	info$ = Info
	writeFileLine: "info.txt", info$
	info$# = readLinesFromFile$# ("info.txt")
	all$ = info$#[2]
	noc = length(all$)
	all$= right$(all$, noc-17)
	slash = rindex(all$, "\"); this works on windows
	if slash = 0
		slash = rindex(all$, "/"); and this works on Mac
	endif
	noc = length(all$)
	file$ = right$(all$, noc-slash)
	path$ = left$(all$, slash)
	extension$ = right$(all$, noc-rindex(all$, "."))

# Create array of file names: 

	fileName$# = fileNames$#(path$+"*."+extension$)
	nFile = size(fileName$#)

# Identify current file:
	
	row=0
	repeat
		row+=1
		compFile$ = fileName$#[row]
	until compFile$ = file$
	goto FILE


##############
### START ####
##############

	label START
	if row>nFile
		row=nFile
		goto SCREEN
	elsif row<1
		row=1
		goto SCREEN
	else 
		nocheck removeObject: sound
		nocheck removeObject: tg
	endif

	##################################
	########## READ FILES ############
	##################################

	label FILE
	file$ = fileName$#[row]
	name$ = file$-("."+extension$)
	sound = Read from file: path$+file$
	tg_exist = fileReadable(path$+name$+".TextGrid")
	if include_TextGrid
		if tg_exist 
			tg = Read from file: path$+name$+".TextGrid"
			nTier = Get number of tiers
		endif
	endif

	##################################
	########## DRAW SCREEN: ##########
	##################################

	label SCREEN
	demo Erase all
	demo Select inner viewport: 0, 100, 0, 100
	demo Axes: 0, 100, 0, 100
	demo Paint rectangle: 0.9, 0, 100, 0, 100

		##### RIGHT COLUMN #####

		demo Select inner viewport: 82, 95, 20, 80
		demo Axes: 0, 110, 0, 110

		### ADD LEGEND:

			demo Text special: 0, "left", 90, "half", "Helvetica", 12, "0", 
				..."#L#e#g#e#n#d#:"+newline$
				...+newline$
				...+"1st click = green cursor"+newline$
				...+"2nd click = red cursor"+newline$
				...+"3rd click = remove cursors"+newline$
				...+newline$
				...+"blank = move forward and save"+newline$
				...+"d = delete form write directory"+newline$
				...+newline$
				...+"\-> or blank = following file"+newline$
				...+"\<- = previous file"+newline$
				...+"\_| = fast forward"+newline$
				...+"\^| = fast backward"+newline$
				...+"g = Go to file"+newline$
				...+newline$
				...+"p = Play"+newline$
				...+newline$
				...+"+ = increase filter band-width"+newline$
				...+"- = decrease filter band-width"+newline$
				...+newline$
				...+"t = Include/exclude TextGrid"+newline$
				...+newline$
				...+"s = Settings"+newline$
				...+newline$
				...+"q = Quit"

		##### LEFT COLUMN #####

		demo Select inner viewport: 1, 14, 20, 80
		demo Axes: 0, 110, 0, 110

		# ADD FILE LIST: 

			vertPos=92
			for iFile from -10 to 10
				stringNumber = row+iFile

				# Get name: 
				if stringNumber<1
					name$ = " "
				elsif stringNumber>nFile
					name$ = " "
				else
					name$ = fileName$#[stringNumber]
				endif

				# Choose the colour for the central presentation
				if iFile=0
					demo Maroon
				endif
	
				# Print the file name in the list
				demo Text special: 110, "right", vertPos, "half", "Helvetica", 12*(1/(((0.3*iFile)^2)+1)), "0", replace$(name$-".wav", "_", "\_ ", 0)

				demo Black

				if left$(writeDirectory$,7)!="-choose"
					w.sound = fileReadable(writeDirectory$+"/"+name$)
					w.tg = fileReadable(writeDirectory$+"/"+name$-extension$+"TextGrid")

					if w.sound
						demo Green
						demo Text special: 111, "left", vertPos, "half", "Helvetica", 12*(1/(((0.3*iFile)^2)+1)), "0", "S"
						demo Black
					endif

					if w.tg
						demo Green
						demo Text special: 116, "left", vertPos, "half", "Helvetica", 12*(1/(((0.3*iFile)^2)+1)), "0", "TG"
						demo Black
					endif

				endif
				vertPos-=10*(1/(((0.3*iFile)^2)+1))

			endfor

		# Add info about number of files preceding and following: 

			nStringBefore = stringNumber-11
			nStringAfter = nFile-stringNumber+10
			demo Text: 110, "right", 100, "half", "Before: 'nStringBefore'/'nFile'"
			demo Text: 110, "right", 5, "half", "Following: 'nStringAfter'/'nFile'"

		##### CENTRAL COLUMN #####

			# Adjust windows: 

			left=20
			right=80
			bottom=10
			top=90
			y=top-bottom

			if include_TextGrid
				if tg_exist
					levels=nTier+4
				else
					levels=5
				endif
				sound_top=top
				sound_bottom=top-(y/levels)*2
				spec_top=sound_bottom
				spec_bottom=top-(y/levels)*4
				tg_top = top
				tg_bottom = bottom
			else
				sound_top=top
				sound_bottom=bottom+(y/2)
				spec_top=sound_bottom
				spec_bottom=bottom
			endif

			# Paint background white: 

			demo Select inner viewport: left, right, bottom, top 
			demo Axes: 0, 1, 0, 1
			demo Paint rectangle: 1, 0, 1, 0, 1
			demo Draw inner box

			# Add headline: 
			
			demo Maroon
			demo Text special: 0.05, "left", 1.05, "half", "Helvetica", 40, "0", "Database EXPLORER"
			demo Black

			# Add directory information: 

			pathname$ = replace$(path$, "_", "\_ ", 0)
			demo Text: 0, "left", -0.05, "half", "#R#e#a#d #d#i#r#e#c#t#o#r#y#: "+pathname$
			demo Text: 0, "left", -0.07, "half", "#W#r#i#t#e #d#i#r#e#c#t#o#r#y#: "+writeDirectory$

			# Add waveform: 

			demo Select inner viewport: left, right, sound_bottom, sound_top
			demo Axes: 0, 1, 0, 1	
	
			selectObject: sound
			demo Draw: 0, 0, 0, 0, 0, "curve"
			demo Draw inner box
			maxA = Get maximum: 0, 0, "sinc70"
			maxA$ = fixed$(maxA/4, 3)
			maxA = 'maxA$'
			demo nocheck Marks left every: 1, maxA, 1, 1, 0
			demo Text left: 1, "Amplitude"

			# Add spectrogram: 

			demo Select inner viewport: left, right, spec_bottom, spec_top
			demo Axes: 0, 1, 0, 1

			selectObject: sound
			noprogress To Spectrogram: windowLength, fMax, 0.002, 20, "Gaussian"
			spec = selected("Spectrogram")
			intT$ = fixed$(object[sound].xmax/10, 3)
			intT = 'intT$'
			demo Paint: 0, 0, 0, fMax, 100, 1, 50, 6, 0, 0
			demo Draw inner box
			demo Marks left every: 1, fMax/10, 1, 1, 0
			demo Text left: 1, "Frequency (Hz)"	
			if include_TextGrid = 0
				demo Marks bottom every: 1, intT, 1, 1, 0
				demo Text bottom: 1, "Time (s)"
			endif
			removeObject: spec

			# Add TextGrid:
			
			if include_TextGrid

				demo Select inner viewport: left, right, tg_bottom, tg_top 
				demo Axes: 0, 1, 0, 1

				if tg_exist
					selectObject: tg
					demo Draw: 0, 0, 1, 1, 0
					demo Marks bottom every: 1, intT, 1, 1, 0
					demo Text bottom: 1, "Time (s)"
				else
					demo Maroon
					demo Text special: 0.5, "centre", (1/levels)/2, "half", "Helvetica", 25, "0", "No TextGrid avaliable for this sound file"
					demo Black
				endif
			endif

	###############################	
	###### GET USER INPUT #########
	###############################

	colour$="Green"
	counter=0
	cursor[1]=0
	cursor[2]=0

	demo Select inner viewport: left, right, bottom, top
	left=0
	right=object[sound].xmax
	bottom=0
	top=1
	demo Axes: left, right, bottom, top
	
	while demoWaitForInput()

		if demoClickedIn(left, right, bottom, top)
			if counter=2
				goto START
				counter=0
			else
				demo 'colour$'
				demo Draw line: demoX(), bottom, demoX(), top
				demo Black
				colour$="Red"
				counter+=1
				cursor[counter]=demoX()
				if counter=2
					if cursor[1]>cursor[2]
						foo=cursor[1]
						cursor[1]=cursor[2]
						cursor[2]=foo
					endif
					demo Paint rectangle: 0.5, cursor[1], cursor[2], top, top+0.03
					duration = cursor[2]-cursor[1]
					demo White
					demo Text special: cursor[1]+duration/2, "centre", top+0.015, "half", "Helvetica", 10, "0", fixed$(duration,3)
					demo Black
				endif
			endif
		elsif demoClickedIn(cursor[1], cursor[2], top, top+0.03)
			selectObject: sound
			part = Extract part: cursor[1], cursor[2], "rectangular", 1, 0
			Play
			removeObject: part
		elsif demoKey$() = "+"
			windowLength-=0.0005
			if windowLength<=0.0001
				windowLength=0.001
			endif
			goto START
		elsif demoKey$() = "-"
			windowLength+=0.001
			if windowLength>=1
				windowLength=1
			endif
			goto START
		elsif demoKey$() = " "

			if left$(writeDirectory$,7)="-choose"
				pauseScript: "You need to choose a write directory first (press: w)"
				goto START
			endif

			# Create trimmed Sound
			selectObject: sound
			sound.trimmed = Extract part: cursor[1], cursor[2], "rectangular", 1, 0

			# Create TextGrid containing trimming informationt
			selectObject: sound
			tg.trimInfo = To TextGrid: "speech", "none"
			if cursor[1]!=cursor[2] and cursor[1]!=0 and cursor[2]!=0
				Insert boundary: 1, cursor[1]
				Insert boundary: 1, cursor[2]
				Set interval text: 1, 1, "sil"
				Set interval text: 1, 2, "speech"
				Set interval text: 1, 3, "sil"
			endif		

			# Create trimmed TextGrid
			if include_TextGrid and tg_exist
				selectObject: tg
				tg.trimmed = Extract part: cursor[1], cursor[2], 0
			endif

			# Add trimming information to existing TextGrid
			if include_TextGrid and tg_exist
				selectObject: tg
				Insert interval tier: nTier+1, "trim"
				if cursor[1]!=cursor[2] and cursor[1]!=0 and cursor[2]!=0
					Insert boundary: nTier+1, cursor[1]
					Insert boundary: nTier+1, cursor[2]
					Set interval text: nTier+1, 1, "sil"
					Set interval text: nTier+1, 2, "speech"
					Set interval text: nTier+1, 3, "sil"
				endif					
			endif

			# Save untrimmed versions:
			if save_originals
				selectObject: sound
				Save as WAV file: writeDirectory$+"/"+file$
				if include_TextGrid and tg_exist
					selectObject: tg
				else
					selectObject: tg.trimInfo
				endif
				Save as text file: writeDirectory$+"/"+file$-extension$+"TextGrid"

			# Save trimmed versions: 
			else
				selectObject: sound.trimmed
				Save as WAV file: writeDirectory$+"/"+file$
				if include_TextGrid and tg_exist
					selectObject: tg.trimmed
					Save as text file: writeDirectory$+"/"+file$-extension$+"TextGrid"
				endif
			endif

			removeObject: sound.trimmed, tg.trimInfo
			if include_TextGrid and tg_exist
				removeObject: tg.trimmed
			endif

			if move_forward_with_blank
				row+=1
			endif
			goto START

		elsif demoKey$() = "d"
			if left$(writeDirectory$,7)="-choose"
				pauseScript: "You need to choose a write directory first (press: w)"
				goto START
			endif
			deleteFile: writeDirectory$+"/"+file$
			deleteFile: writeDirectory$+"/"+file$-".wav"+".TextGrid"
			goto START
		elsif demoKey$() = "←"
			row-=1
			goto START
		elsif demoKey$() = "→"
			row+=1
			goto START
		elsif demoKey$() = "↑"
			row-=round(nFile/10)
			goto START
		elsif demoKey$() = "↓"
			row+=round(nFile/10)
			goto START
		elsif demoKey$() = "w"
			writeDirectory$ = chooseFolder$: "Choose a folder to save all new files in"
			goto START
		elsif demoKey$() = "p"
			selectObject: sound
			Play
		elsif demoKey$() = "t"
			if include_TextGrid=0
				include_TextGrid=1
			else
				include_TextGrid=0
			endif
			goto START
		elsif demoKey$() = "s"
			beginPause: "Settings"
				boolean: "Save originals", save_originals
				boolean: "Move forward with blank", move_forward_with_blank
				integer: "fMax", fMax
			endPause: "Continue", 1
			goto START
		elsif demoKey$() = "g"
			beginPause: "Go to file"
				comment: "Your largest file number is 'nFile'"
				positive: "Go_to_file", row
			endPause: "Continue", 1
			row=go_to_file
			goto START
		endif
		
		goto END demoKey$()="q"

	endwhile 

# END of script

	label END

# Final clean-up and message:

	demo Erase all
	removeObject: sound
	nocheck removeObject: tg
	selectObject: original.sound

	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "DE"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Database Explorer"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "You can close this window now"
	demo Text special: 50, "centre", 40, "half", "Helvetica", 12, "0", "Comments and bug reports: volker.dellwo@uzh.ch"
	demoShow()

##########################
###### END of SCRIPT #####
##########################



