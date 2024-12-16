### demo_harmonicDistortion.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# History: 
#    V_0.1: 28.3.2020: created (created at home during Corona lockdown)
#
# DESCRIPTION: 
#    This script demonstrates the effects of harmonic distortion on a 
#    sinusoid of 100 Hz and a vowel /a/ with 100 Hz fundamental frequency. 
#
##################

# Start screen: 

	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "HDS"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Harmonic Distortion Simulator"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "written by Volker Dellwo (University of Zurich)"
	demoShow()
	sleep(1)

# Initial settings

	amplitude=0.5
	wave$ = "sine"
	maximum_time = 0.05
	maximum_frequency = 10000

# Create sounds: 

	# create sine: 
	sine = Create Sound from formula: "sine", 1, 0, 1, maximum_frequency*2+1, ~amplitude*sin(2*pi*100*x)

	# create noise:
	noise = Create Sound from formula: "noise", 1, 0, 1, maximum_frequency*2+1, ~randomGauss(0,0.1)
	Scale peak: amplitude

	# create vowel: 
	klatt = Create KlattGrid from vowel: "a", 1, 125, 800, 50, 1200, 50, 2300, 100, 2800, 0.05, 1000
	temp = To Sound
	noprogress Resample: maximum_frequency*2, 50
	vowel = selected("Sound")
	Rename: "vowel"
	Scale peak: amplitude
	removeObject: klatt, temp

# Base screen:

	label BASE_SCREEN
	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 5, 20, 0, 100
	demo Maroon
	demo Text special: 60, "Centre", 94, "Half", "Helvetica", 30, "0", "Harmonic Distortion Simulator"
	demo Black
	demo Text special: 60, "Centre", 90, "Half", "Helvetica", 15, "0", "use left and right arrows (<- ->) to decrease and increase amplitude"
	@createButton: "b1", "Sine (s)", "navy", "0.8", "07 18 85 95", 20, 2
	@createButton: "b2", "Vowel (v)", "navy", "0.8", "07 18 72 82", 20, 2
	@createButton: "b2.2", "Noise (n)", "navy", "0.8", "07 18 59 69", 20, 2 
	@createButton: "b3", "Time", "maroon", "0.8", "07 18 38 48", 20, 2	
	@createButton: "b4", "Freq", "maroon", "0.8", "07 18 25 35", 20, 2
	@createButton: "b5", "EXIT (e)", "green", "0.8", "07 18 05 15", 20, 2
	@createButton: "b6.1", "Play (p)", "maroon", "0.8", "89 97 45 55", 20, 2
	@createButton: "b6.2", "Open wave (w)", "grey", "0.8", "88 99 80 85", 14, 2
	@createButton: "b6.3", "Open spec (c)", "grey", "0.8", "88 99 10 15", 14, 2
	@plotGraphs: amplitude, wave$, maximum_time, maximum_frequency

	demoShow()
	while demoWaitForInput ()
		demo Axes: 0, 100, 0, 100

		if demoClickedIn 'b1$' or demoKey$()="s"
			wave$="sine"
			amplitude=0.5
			removeObject: wave, spectrum
			maximum_time = 0.05
			maximum_frequency = 10000
			goto BASE_SCREEN

		elsif demoClickedIn 'b2$' or demoKey$()="v"
			wave$="vowel"
			amplitude=0.5
			removeObject: wave, spectrum
			maximum_time = 0.05
			maximum_frequency = 10000
			goto BASE_SCREEN

		elsif demoClickedIn 'b2.2$' or demoKey$()="n"
			wave$="noise"
			amplitude=0.5
			removeObject: wave, spectrum
			maximum_time = 0.05
			maximum_frequency = 10000
			goto BASE_SCREEN

		elsif demoClickedIn 'b3$'
			beginPause ("Time range")
				positive ("maximum_time", maximum_time)
				comment ("       Values larger than 1 will be reduced to 1")
			endPause ("Done", 1)
			if maximum_time>1
				maximum_time=1
			endif
			goto BASE_SCREEN

		elsif demoClickedIn 'b4$'
			beginPause ("Frequency range")
				positive ("maximum_frequency", maximum_frequency)
			endPause ("Done", 1)
			goto BASE_SCREEN

		elsif demoClickedIn 'b5$' or demoKey$() = "e"
			removeObject: wave, spectrum, sine, noise, vowel
			goto EXIT

		elsif demoClickedIn 'b6.1$' or demoKey$() = "p"
			selectObject: wave
			Play

		elsif demoClickedIn 'b6.2$' or demoKey$() = "w"
			selectObject: wave
			Edit

		elsif demoClickedIn 'b6.3$' or demoKey$() = "c"
			selectObject: spectrum
			Edit

		elsif demoKeyPressed ()
			if demoKey$ () = "←"
				amplitude-=0.1
				if amplitude<=0
					amplitude=0.01
				endif
				removeObject: wave, spectrum
				goto BASE_SCREEN
			elsif demoKey$() = "→"
				amplitude+=0.1
				removeObject: wave, spectrum
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
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "HDS"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Harmonic Distortion Simulator"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "You can close this window now"
	demoShow()

#### PROCEDURES #####

procedure plotGraphs: amplitude, sound$, maxTime, maxFreq

	# Create waveform copy: 
	selectObject: "Sound "+sound$
	wave = Copy: "temp"

	# Get the right amplitude:
	Scale peak: amplitude

	# Peak clipping:
	Formula: ~if self>1 then 1 else self fi
	Formula: ~if self<-1 then -1 else self fi

	# Create spectrum of waveform: 
	spectrum = To Spectrum: 1

	# Plot wave: 
	selectObject: wave
	start=0
	end=maxTime
	demo Axes: 0, 100, 0, 100
	demo Select outer viewport: 25, 90, 50, 90
	demo Draw: start, end, -1.1, 1.1, 0, "Curve"
	demo Dotted line
		demo Draw line: start, 0, end, 0
			demo Red
				demo Draw line: start, 1, end, 1
				demo Draw line: start, -1, end, -1
			demo Black
	demo Solid line
	demo Draw inner box
	demo Text left: 1, "Amplitude (Pa)"
	demo Text bottom: 1, "Time (s)"
	demo Marks left every: 1, 0.5, 1, 1, 0
	time_step = maxTime/5
	demo Marks bottom every: 1, time_step, 1, 1, 0

	# Plot spectrum:
	selectObject: spectrum
	demo Select outer viewport: 25, 90, 5, 50
	demo Draw: 0, maxFreq, 0, 100, 0
	demo Draw inner box
	demo Text left: 1, "Amplitude (dB)"
	demo Text bottom: 1, "Frequency (Hz)"
	demo Marks left every: 1, 20, 1, 1, 0
	freq_step = maxFreq/5
	demo Marks bottom every: 1, freq_step, 1, 1, 0 		

	demoShow()

	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100

endproc

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
	demo Line width: 1
	demo Colour: 0

endproc

