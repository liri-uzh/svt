### demo_sourceFilterVowelSynthesiser.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# History: 
#    V_0.1: 1.4.2020: created (created at home during Corona lockdown)
#
# DESCRIPTION: 
#    This script visualises a Klatt formant synthesis and lets the user
#    change pitch and formant frequencies
#
# DEDICATION: 
#    To Professor Vowel (alias Dieter Maurer)
#
##################

########### Start screen: 

	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "VS"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Vowel Synthesiser"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "written by Volker Dellwo (University of Zurich)"
	demoShow()
	sleep(0.5)

### Initial settings

	label DEFAULT

	# Default vowel settings:
	variable$ = "f1"
	increment = 10
	lThresh = 150
	uThresh = 2000

	# Vowel settings: 
	duration = 0.4
	amplitude=0.8
	a_increment = 0.1
	a_min=0.00000001
	a_max=100
	fo = 125
	fo_increment = 3
	fo_min = 30
	fo_max = 1500
	f1 = 500
	f1_increment = 10
	f1_bw = 50
	f1_min = 100
	f1_max = 2000
	f2 = 1500
	f2_increment = 30
	f2_bw = 50
	f2_min = 300
	f2_max = 5000
	f3 = 2500
	f3_increment = 50
	f3_bw = 100
	f3_min = 500
	f3_max = 7000
	f4 = 3500
	f4_increment = 80
	f4_min = 3000
	f4_max = 10000
	bwFraction = 0.05
	interval = 1000

	# Plot settings: 
	minF = 0.1
	maxF = 4000
	minA = 0.1
	maxA = 100

########## Base screen:

	label BASE_SCREEN
	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 5, 20, 0, 100
	demo Maroon
	demo Text special: 60, "Centre", 94, "Half", "Helvetica", 30, "0", "Source-Filter Vowel Synthesiser"
	demo Black
	demo Text special: 60, "Centre", 87, "Half", "Helvetica", 18, "0", "Left and right arrow (<-/->) now changes: 'variable$'"

	# Variables: 
	demo Text special: 11, "Centre", 81, "Half", "Helvetica", 10, "0", "Choose variable:" 
	@createButton: "fo", "fo (o)", "navy", "0.8", "07 18 75 79 ", 18, 1
	@createButton: "f1", "f1 (1)", "navy", "0.8", "07 18 70 74", 18, 1
	@createButton: "f2", "f2 (2)", "navy", "0.8", "07 18 65 69", 18, 1 
	@createButton: "f3", "f3 (3)", "navy", "0.8", "07 18 60 64", 18, 1
	@createButton: "f4", "f4 (4)", "navy", "0.8", "07 18 55 59", 18, 1

	# Pre-defined settings: 
	demo Text special: 11, "Centre", 47, "Half", "Helvetica", 10, "0", "Pre-defined settings:"
	@createButton: "shwa", "shwa", "maroon", "0.8", "07 12 41 45", 18, 1
	@createButton: "a", "a", "maroon", "0.8", "13 18 41 45", 18, 1
	@createButton: "i", "i", "maroon", "0.8", "07 12 36 40", 18, 1	
	@createButton: "u", "u", "maroon", "0.8", "13 18 36 40", 18, 1	

	# Other buttons
	@createButton: "frequency", "Frequency", "maroon", "0.8", "05 20 10 14", 20, 0.1
	@createButton: "exit", "EXIT (e)", "green", "0.8", "05 20 00 7", 20, 0.1
	@createButton: "play", "Play (space)", "maroon", "0.8", "05 20 16 20", 20, 0.1
	@createButton: "edit", "Open spec (c)", "grey", "0.8", "88 99 10 15", 14, 0.1

########## Create vowel: 

	klatt = Create KlattGrid from vowel: "vowel",
		...duration, 
		...fo,
		...f1,
		...f1_bw,
		...f2, 
		...f2_bw, 
		...f3,
		...f3_bw, 
		...f4,
		...bwFraction,
		...interval
	wave = To Sound

	# Apply amplitude: 
	Scale peak: amplitude

	# Clip peaks at +-1:
	Formula: ~if self>1 then 1 else self fi
	Formula: ~if self<-1 then -1 else self fi

	# Create spectrum and spectral envelope: 
	spectrum = To Spectrum: 1
	env = Cepstral smoothing: 300

############ PLOT GRAPHS:

	# Draw spectrum:
	selectObject: spectrum
	demo Select outer viewport: 25, 90, 5, 85
	demo Draw: minF, maxF, minA, maxA, 0	
	demo Text special: minF+(maxF-minF)*0.07, "centre", 95, "half", "Helvetica", 12, "0", "fo = 'fo'"

	# Draw decoration: 
	demo Draw inner box
	demo Text left: 1, "Amplitude (dB)"
	demo Text bottom: 1, "Frequency (Hz)"
	demo Marks left every: 1, 20, 1, 1, 0
	freq_step = maxF/5
	demo Marks bottom every: 1, freq_step, 1, 1, 0	

	# Plot spectral envelope:
	selectObject: env
	demo Select outer viewport: 25, 90, 15, 75
	demo Red
	demo Draw: minF, maxF, 0, 0, 0	
	demo Black

	# Plot formant values: 
	for i to 4
		amp[i]=Get sound pressure level of nearest maximum: f'i'
	endfor
	demo Text special: f1, "centre", amp[1]+2, "half", "Helvetica", 8, "0", "f1 ('f1')"
	demo Text special: f2, "centre", amp[2]+2, "half", "Helvetica", 8, "0", "f2 ('f2')"
	demo Text special: f3, "centre", amp[3]+2, "half", "Helvetica", 8, "0", "f3 ('f3')"
	demo Text special: f4, "centre", amp[4]+2, "half", "Helvetica", 8, "0", "f4 ('f4')"

	# Plot f1/f2 space: 
	demo Select outer viewport: 65, 85, 50, 80
	demo Axes: 3000, 500, 1000, 100
	demo Draw arrow: 500, 100, 3300, 100
	demo Marks top every: 1000, 0.5, 1, 1, 0
	demo Draw arrow: 500, 100, 500, 1100
	demo Marks right every: 1000, 0.2, 1, 1, 0
	demo Text top: 1, "f2 (kHz)"
	demo Text right: 1, "f1 (kHz)"
	demo Paint circle (mm): 0.5, f2, f1, 3
	demo Text: 1100, "centre", 730, "Half", "/a:/"
	demo Text: 2300, "centre", 270, "Half", "/i:/"
	demo Text: 870, "centre", 300, "Half", "/u:/"

	# Set axis and viewport back (necessary after plotting spectrum):
	demo Select inner viewport: 0, 100, 0, 100
	demo Axes: 0, 100, 0, 100

########### Get user input: 

	demoShow()
	while demoWaitForInput ()
		demo Axes: 0, 100, 0, 100

		if demoClickedIn 'shwa$'
			removeObject: klatt, wave, spectrum, env
			goto DEFAULT

		elsif demoClickedIn 'a$'
			f1=720
			f2=1100
			f3=2300
			f4=2800
			removeObject: klatt, wave, spectrum, env
			goto BASE_SCREEN

		elsif demoClickedIn 'i$'
			f1=280
			f2=2300
			f3=2400
			f4=2800
			removeObject: klatt, wave, spectrum, env
			goto BASE_SCREEN

		elsif demoClickedIn 'u$'
			f1=310
			f2=880
			f3=2300
			f4=2800
			removeObject: klatt, wave, spectrum, env
			goto BASE_SCREEN

		elsif demoClickedIn 'fo$' or demoKey$()="o"
			variable$="fo"
			increment=fo_increment
			lThresh=fo_min
			uThresh=fo_max
			removeObject: klatt, wave, spectrum, env
			goto BASE_SCREEN

		elsif demoClickedIn 'f1$' or demoKey$()="1"
			variable$="f1"
			increment=f1_increment
			lThresh=f1_min
			uThresh=f1_max
			removeObject: klatt, wave, spectrum, env
			goto BASE_SCREEN

		elsif demoClickedIn 'f2$' or demoKey$()="2"
			variable$="f2"
			increment=f2_increment
			lThresh=f2_min
			uThresh=f2_max
			removeObject: klatt, wave, spectrum, env
			goto BASE_SCREEN

		elsif demoClickedIn 'f3$' or demoKey$()="3"
			variable$="f3"
			increment=f3_increment
			lThresh=f3_min
			uThresh=f3_max
			removeObject: klatt, wave, spectrum, env
			goto BASE_SCREEN

		elsif demoClickedIn 'f4$' or demoKey$()="4"
			variable$="f4"
			increment=f4_increment
			lThresh=f4_min
			uThresh=f4_max
			removeObject: klatt, wave, spectrum, env
			goto BASE_SCREEN

		elsif demoClickedIn 'frequency$'
			beginPause ("Frequency range")
				positive ("minimum_frequency", minF)
				positive ("maximum_frequency", maxF)
			endPause ("Done", 1)
			minF=minimum_frequency
			maxF=maximum_frequency
			goto BASE_SCREEN

		elsif demoClickedIn 'play$' or demoKey$() = " "
			selectObject: wave
			Play

		elsif demoClickedIn 'edit$' or demoKey$() = "c"
			selectObject: spectrum
			Edit

		elsif demoClickedIn 'exit$' or demoKey$() = "e"
			removeObject: klatt, wave, spectrum, env
			goto EXIT

		elsif demoKeyPressed ()

			if demoKey$ () = "←"
				'variable$'-=increment
				if 'variable$'<=lThresh
					'variable$'=lThresh
				endif
				removeObject: klatt, wave, spectrum, env
				goto BASE_SCREEN

			elsif demoKey$() = "→"
				'variable$'+=increment
				if 'variable$'>=uThresh
					'variable$'=uThresh
				endif
				removeObject: klatt, wave, spectrum, env
				goto BASE_SCREEN

			endif

		endif

	endwhile

# Exit screen: 

	label EXIT
	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "VS"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Vowel Synthesiser"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "You can close this window now"
	demoShow()

#### PROCEDURES #####

procedure createButton: id$, name$, colorButton$, colorText$, coordinates$, textSize, lineWidth

	# LEGEND:
	# 
	# id$: choose a name that will contain the coordinates by which the button can be called in demoWaitForInput, e.g.: "f0"
	# name$: the name that appears on the button, e.g.: "Fundamental frequency"
	# colorButton$: the color of the button, e.g.: "navy"
	# colorText$: the colour of the button text, e.g.: "0.8" (or choose RGB)
	# coordinates$: the coordinates x1, x2, y1, y2 as string, e.g. "07 28 75 79"
	# textSize: size of text, e.g. 16
	# lineWidth: width of the button outline, e.g. 1 (0 for no line) 
	# 
	# FULL EXAMPLE: @createButton: "fo", "Fundamental frequency", "navy", "0.8", "07 28 75 79 ", 16, 1

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
	demo Line width: 1
	demo Colour: 0

endproc

