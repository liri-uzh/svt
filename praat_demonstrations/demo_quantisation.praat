### demo_quantisation.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# DESCRIPTION: 
#    This script demonstrates the effects of quantisation at different numbers 
#    of quantisation levels on a variety of waveforms (sinusoid, noise, vowel, 
#    synthesised speech).  
#
# History: 
#    V_0.1: 28.3.2020: created (created at home during Corona lockdown)
#    V_0.2: 30.3.2020: bug-fixes (corrected a bug that would apply quantisation
#                      levels between peak and min amplitude instead of max and min 
#												system amplitude).
#    V_0.3: 31.3.2020: Added horizontal dotted lines for each quantisation level between
#                      1 and 6 bit quantisation. With higher quantisations there are too
#                      many lines which makes the display illegible.  
#
##################

# Start screen: 

	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "QS"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Quantisation Simulator"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "written by Volker Dellwo (University of Zurich)"
	demoShow()
	sleep(1)

# Initial settings

	wave$ = "sine"
	maximum_time = 0.05
	maximum_frequency = 10000
	peak_amplitude = 0.99
	quantisation = 16

# Create base sounds:

	# create sine: 
	sine = Create Sound from formula: "sine", 1, 0, 1, maximum_frequency*2+1, ~peak_amplitude*sin(2*pi*100*x)

	# create noise: 
	noise = Create Sound from formula: "noise", 1, 0, 1, maximum_frequency*2+1, ~randomGauss(0,0.1)
	Scale peak: peak_amplitude

	# create vowel: 
	klatt = Create KlattGrid from vowel: "a", 1, 125, 800, 50, 1200, 50, 2300, 100, 2800, 0.05, 1000
	temp_vowel = To Sound
	noprogress Resample: maximum_frequency*2, 50
	vowel = selected("Sound")
	Rename: "vowel"
	Scale peak: peak_amplitude

	# create speech:
	synth = Create SpeechSynthesizer: "English (Great Britain)", "Michael"
	temp_speech = To Sound: "There are many flowers in the garden.", 0
	noprogress Resample: maximum_frequency*2, 50
	speech = selected("Sound")
	Rename: "speech"
	Set part to zero: 1.745, 3, "at nearest zero crossing"
	Scale peak: peak_amplitude

	# clean up:
	removeObject: klatt, temp_vowel, temp_speech, synth

# Base screen:

	label BASE_SCREEN
	nQuantisationLevels = 2^quantisation
	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 5, 20, 0, 100
	demo Maroon
	demo Text special: 60, "Centre", 94, "Half", "Helvetica", 30, "0", "Quantisation Simulator"
	demo Black
	demo Text special: 60, "Centre", 90, "Half", "Helvetica", 15, "0", "use left and right arrows (<- ->) to decrease and increase quantisation"
	demo Maroon
	demo Text special: 60, "Centre", 44, "Half", "Helvetica", 20, "0", "'quantisation' bit quantisation = 'nQuantisationLevels' quantisation levels"
	demo Black
	demo Text special: 60, "Centre", 40, "Half", "Helvetica", 10, "0", "For space reasons the number of quantisation levels (horizontal dotted lines) are displayed between 1 and 6 bit only."
	@createButton: "b1.1", "Sine (s)", "navy", "0.8", "07 18 88 96", 18, 2
	@createButton: "b1.2", "Vowel (v)", "navy", "0.8", "07 18 78 86", 18, 2
	@createButton: "b1.3", "Noise (n)", "navy", "0.8", "07 18 68 76", 18, 2 
	@createButton: "b1.4", "Speech (h)", "navy", "0.8", "07 18 58 66", 18, 2
	@createButton: "b2.1", "Peak amplitude", "maroon", "0.8", "07 18 42 48", 12, 2	
	@createButton: "b2.2", "Max frequency", "maroon", "0.8", "07 18 34 40", 12, 2
	@createButton: "b2.3", "Max time", "maroon", "0.8", "07 18 26 32", 12, 2
	@createButton: "b3", "EXIT (e)", "green", "0.8", "07 18 05 15", 20, 2
	@createButton: "b4.1", "Play (p)", "maroon", "0.8", "89 98 45 55", 20, 2
	@createButton: "b4.2", "Open wave (w)", "grey", "0.8", "88 99 80 85", 14, 2
	@createButton: "b4.3", "Open spec (c)", "grey", "0.8", "88 99 10 15", 14, 2
	@plotGraphs: quantisation, peak_amplitude, wave$, maximum_time, maximum_frequency

	demoShow()
	while demoWaitForInput ()
		demo Axes: 0, 100, 0, 100

		if demoClickedIn 'b1.1$' or demoKey$()="s"
			wave$="sine"
			quantisation=16
			removeObject: wave, spectrum
			maximum_time = 0.05
			maximum_frequency = 10000
			peak_amplitude = 0.99
			goto BASE_SCREEN

		elsif demoClickedIn 'b1.2$' or demoKey$()="v"
			wave$="vowel"
			quantisation=16
			removeObject: wave, spectrum
			maximum_time = 0.05
			maximum_frequency = 10000
			peak_amplitude = 0.99
			goto BASE_SCREEN

		elsif demoClickedIn 'b1.3$' or demoKey$()="n"
			wave$="noise"
			quantisation=16
			removeObject: wave, spectrum
			maximum_time = 0.05
			maximum_frequency = 10000
			peak_amplitude = 0.99
			goto BASE_SCREEN

		elsif demoClickedIn 'b1.4$' or demoKey$()="h"
			wave$="speech"
			quantisation=16
			removeObject: wave, spectrum
			maximum_time = 1
			maximum_frequency = 10000
			peak_amplitude = 0.99
			goto BASE_SCREEN

		elsif demoClickedIn 'b2.3$'
			beginPause ("Time range")
				positive ("maximum_time", maximum_time)
				comment ("       Values larger than 1 will be reduced to 1")
			endPause ("Done", 1)
			if maximum_time>1
				maximum_time=1
			endif
			goto BASE_SCREEN

		elsif demoClickedIn 'b2.2$'
			beginPause ("Frequency range")
				positive ("maximum_frequency", maximum_frequency)
			endPause ("Done", 1)
			goto BASE_SCREEN

		elsif demoClickedIn 'b2.1$'
			beginPause ("Peak amplitude")
				positive ("peak_amplitude", peak_amplitude)
			endPause ("Done", 1)
			goto BASE_SCREEN

		elsif demoClickedIn 'b3$' or demoKey$() = "e"
			removeObject: wave, spectrum, sine, noise, vowel, speech
			goto EXIT

		elsif demoClickedIn 'b4.1$' or demoKey$() = "p"
			selectObject: wave
			Play

		elsif demoClickedIn 'b4.2$' or demoKey$() = "w"
			selectObject: wave
			Edit

		elsif demoClickedIn 'b4.3$' or demoKey$() = "c"
			selectObject: spectrum
			Edit

		elsif demoKeyPressed ()
			if demoKey$ () = "←"
				quantisation-=1
				if quantisation<1
					quantisation=1
				endif
				removeObject: wave, spectrum
				goto BASE_SCREEN

			elsif demoKey$() = "→"
				quantisation+=1
				if quantisation>16
					quantisation=16
				endif
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
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "QS"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Quantisation Simulator"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "You can close this window now"
	demoShow()

#### PROCEDURES #####

procedure plotGraphs: quantisation, amplitude, sound$, maxTime, maxFreq

	# Get copy of waveform:
	selectObject: "Sound "+sound$
	wave = Copy: "temp"

	# Adjust amplitude: 
	Scale peak: amplitude

	# clip peak in case amplitude exceeds 1: 
	Formula: ~if self>=1 then 0.9999999999 else self fi
	Formula: ~if self<=-1 then -0.9999999999 else self fi

	# Apply quantisation simulation:
	nQuantisationLevels=2^quantisation
	Formula: ~floor(self*(nQuantisationLevels/2))/(nQuantisationLevels/2)

	# Create spectrum of waveform: 
	selectObject: wave
	spectrum = To Spectrum: 1

	# Plot wave:
	selectObject: wave
	start=0
	end=maxTime
	demo Axes: 0, 100, 0, 100
	demo Select outer viewport: 25, 90, 48, 90
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
	if quantisation<=6
		for i to nQuantisationLevels 
			value = -1+(1.9999/nQuantisationLevels)*i
			qLevel = floor(value*(nQuantisationLevels/2))/(nQuantisationLevels/2)
			demo One mark right: qLevel, 0, 1, 1, "'i'"
		endfor
		demo Text right: 1, "Quantisation levels"
	endif
	time_step = maxTime/5
	demo Marks bottom every: 1, time_step, 1, 1, 0

	# Plot spectrum:
	selectObject: spectrum
	demo Select outer viewport: 25, 90, 0, 40
	demo Draw: 0, maxFreq, 0, 100, 0
	demo Draw inner box
	demo Text left: 1, "Amplitude (dB)"
	demo Text bottom: 1, "Frequency (Hz)"
	demo Marks left every: 1, 20, 1, 1, 0
	freq_step = maxFreq/5
	demo Marks bottom every: 1, freq_step, 1, 1, 0 		

	# Release content to screen:
	demoShow()

	# Reset Axes: 
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

