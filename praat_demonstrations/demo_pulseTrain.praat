### demo_pulseTrain.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# History: 
#    V_0.1: 21.4.2020: created (created at home during Corona lockdown)
#    V_0.2: 28.8.2021: added an option to change the pulse duration; added fade-in and fade-out
#    V_0.3: 29.8.2021: added a smooth onset and offset to pulse trains to make them more pleasant to listen to. 
#
# DESCRIPTION: 
#    This script demonstrates the effects of increasing and decreasing fundamental frequency 
#    in a pulse trian on its spectrum. You should learn that the frequency spectrum gets denser 
#    as the frequency of the pulse train increases until there is only one pulse left and maximum
#    density is reached (all frequencies are present at the same amplitude. 
#
##################

# Start screen: 

	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "PTD"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Pulse Train Demonstration"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "written by Volker Dellwo (University of Zurich)"
	demoShow()
	sleep(1)

# Initial settings

	maximum_frequency=1000
	minimum_time = 0
	maximum_time = 1
	pulse_duration = 0.001; (ms)
	sf = 100000
	f0 = 100

# Base screen:

	label BASE_SCREEN
	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 5, 20, 0, 100
	demo Maroon
	demo Text special: 60, "Centre", 94, "Half", "Helvetica", 30, "0", "Pulse Train Demonstration"
	demo Text special: 13, "Centre", 90, "Half", "Helvetica", 15, "0", "f0 = 'f0'"
	demo Text special: 13, "Centre", 85, "Half", "Helvetica", 15, "0", "duration = 'pulse_duration'ms"
	demo Black
	demo Text special: 60, "Centre", 90, "Half", "Helvetica", 15, "0", "use left and right arrows (<- ->) to decrease and increase fundamental frequency of pulse train"
	@createButton: "b2", "Pulse", "maroon", "0.8", "07 18 51 61", 20, 2
	@createButton: "b3", "Time", "maroon", "0.8", "07 18 32 37", 20, 2
	@createButton: "b4", "Freq", "maroon", "0.8", "07 18 25 30", 20, 2
	@createButton: "b5", "EXIT (e)", "green", "0.8", "07 18 05 15", 20, 2
	@createButton: "b6.1", "Play (p)", "maroon", "0.8", "89 97 45 55", 20, 2
	@createButton: "b6.2", "Open wave (w)", "grey", "0.8", "88 99 80 85", 14, 2
	@createButton: "b6.3", "Open spec (c)", "grey", "0.8", "88 99 10 15", 14, 2
	@createButton: "f_down", "<", "grey", "0.8", "80 82 03 05", 14, 2
	@createButton: "f_up", ">", "grey", "0.8", "83 85 03 05", 14, 2
	@createButton: "t_down", "<", "grey", "0.8", "80 82 49 51", 14, 2
	@createButton: "t_up", ">", "grey", "0.8", "83 85 49 51", 14, 2
	@plotGraphs: minimum_time, maximum_time, maximum_frequency

	demoShow()
	while demoWaitForInput ()
		demo Axes: 0, 100, 0, 100

		if demoClickedIn 'b2$'
			beginPause ("Duration of pulse (in ms)")
				real ("pulse_duration", pulse_duration)
				comment ("       Note that pulses can be not less than 0.001 ms (one sample)")
				comment ("       Note that long pulse durations may fill your entire period duration and result in DC signals.")
			endPause ("Done", 1)
			if pulse_duration<0.001
				pulse_duration=0.001
			endif
			goto BASE_SCREEN

		elsif demoClickedIn 'b3$'
			beginPause ("Visible time range")
				real ("minimum_time", minimum_time)
				positive ("maximum_time", maximum_time)
				comment ("       Values larger than 1 will be reduced to 1")
			endPause ("Done", 1)
			if maximum_time>1
				maximum_time=1
			endif
			if minimum_time>0
				mimimum_time=0
			elsif minimum_time>=maximum_time
				minimum_time=maximum_time-0.1
			endif
			goto BASE_SCREEN

		elsif demoClickedIn 'b4$'
			beginPause ("Visible frequency range")
				positive ("maximum_frequency", maximum_frequency)
				comment ("       Values larger than 8000 will be reduced to 8000 (Nyquist Frequency)")
			endPause ("Done", 1)
			if maximum_frequency>8000
				maximum_frequency=8000
			endif
			removeObject: pt, spectrum
			goto BASE_SCREEN

		elsif demoClickedIn 'f_down$'
			maximum_frequency-=100
			if maximum_frequency<100
				maximum_frequency=100
			endif
			goto BASE_SCREEN

		elsif demoClickedIn 'f_up$'
			maximum_frequency+=100
			if maximum_frequency>10000
				maximum_frequency=10000
			endif
			goto BASE_SCREEN

		elsif demoClickedIn 't_down$'
			minimum_time-=0.1
			maximum_time+=0.1
			if minimum_time<=0
				minimum_time=0
				maximum_time=1
			endif
			goto BASE_SCREEN

		elsif demoClickedIn 't_up$'
			minimum_time+=0.1
			maximum_time-=0.1
			if minimum_time>0.4
				minimum_time=0.45
				maximum_time=0.55
			endif
			goto BASE_SCREEN

		elsif demoClickedIn 'b5$' or demoKey$() = "e"
			removeObject: pt, spectrum
			goto EXIT

		elsif demoClickedIn 'b6.1$' or demoKey$() = "p"
			selectObject: pt
			Play

		elsif demoClickedIn 'b6.2$' or demoKey$() = "w"
			selectObject: pt
			Edit

		elsif demoClickedIn 'b6.3$' or demoKey$() = "c"
			selectObject: spectrum
			Edit

		elsif demoKeyPressed ()

			if f0<=20
				increment=1
			elsif f0>300
				increment= 20
			else
				increment=5
			endif

			if demoKey$ () = "←"
				f0-=increment
				if f0<=1
					f0=1
				endif
				removeObject: pt, spectrum
				goto BASE_SCREEN
			elsif demoKey$() = "→"
				f0+=increment
				removeObject: pt, spectrum
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
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "PTD"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Pulse Train Demonstration"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "You can close this window now"
	demoShow()

#### PROCEDURES #####

procedure plotGraphs: minTime, maxTime, maxFreq

	# create pulse train and spectrum
	pt = Create Sound from formula: "pulseTrain", 1, 0, 1, sf, ~0
	nS = Get number of samples
	periodDuration = floor(sf/f0)
	sample = periodDuration
	pulseDurationInSamples = floor(pulse_duration*100)
	if pulseDurationInSamples < 1
		pulseDurationInSamples =1
	endif
	repeat
		Set value at sample number: 1, sample, 0.9
		for iSample to pulseDurationInSamples-1
			nocheck Set value at sample number: 1, sample+iSample, 0.9
		endfor
		sample+=periodDuration 
	until sample>=nS
	Fade in: 1, 0, 0.1, 1
	Fade out: 1, 1, -0.1, 1

	spectrum = To Spectrum: 1

	# Plot wave: 
	selectObject: pt
	start=minTime
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
	demo Draw: 0, maxFreq, 0, 50, 0
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

