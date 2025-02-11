### demo_damping.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# History: 
#    V_0.1: 21.4.2020: created (created at home during Corona lockdown)
#
# DESCRIPTION: 
#    This script demonstrates the effects of filter bandwidth on a wave harmonic component. 
#
##################

# Start screen: 

	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 0, 100, 0, 100
	demo Colour: "{0.8,0.1,0.2}"
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "DD"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Damping Demonstration"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "written by Volker Dellwo (University of Zurich)"
	demoShow()
	sleep(1)

# Initial settings

	maximum_frequency=2000
	minimum_time = 0
	maximum_time = 1
	cFreq = 1000
	bw = 100
	sf = 16000
	pulse = 	Create Sound from formula: "pulse", 1, 0, 1, sf, ~0
	Set value at sample number: 1, floor(sf/2), 0.95

# Base screen:

	label BASE_SCREEN
	demo Erase all
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0, 100, 0, 100
	demo Paint rectangle: 0.8, 5, 20, 0, 100
	demo Maroon
	demo Text special: 60, "Centre", 94, "Half", "Helvetica", 30, "0", "Damping Demonstration"
	demo Text special: 13, "Centre", 90, "Half", "Helvetica", 20, "0", "BW = 'bw'"
	demo Black
	demo Text special: 60, "Centre", 90, "Half", "Helvetica", 15, "0", "use left and right arrows (<- ->) to decrease and increase filter bandwidth"
	@createButton: "b4", "Freq", "maroon", "0.8", "07 18 25 35", 20, 2
	@createButton: "b5", "EXIT (e)", "green", "0.8", "07 18 05 15", 20, 2
	@createButton: "b6.1", "Play (p)", "maroon", "0.8", "89 97 15 25", 20, 2
	@plotGraphs: minimum_time, maximum_time, maximum_frequency

	demoShow()
	while demoWaitForInput ()
		demo Axes: 0, 100, 0, 100

		if demoClickedIn 'b4$'
			beginPause ("Frequency range")
				positive ("maximum_frequency", maximum_frequency)
				comment ("       Values larger than 8000 will be reduced to 8000 (Nyquist Frequency)")
			endPause ("Done", 1)
			if maximum_frequency>8000
				maximum_frequency=8000
			endif
			removeObject: impResp, freqResp
			goto BASE_SCREEN

		elsif demoClickedIn 'b5$' or demoKey$() = "e"
			removeObject: impResp, freqResp
			goto EXIT

		elsif demoClickedIn 'b6.1$' or demoKey$() = "p"
			selectObject: impResp
			Play

		elsif demoKeyPressed ()

			if bw<=1
				increment=0.1
			elsif bw>1 and bw<=20
				increment=1
			else
				increment=5
			endif

			if demoKey$ () = "←"
				bw-=increment
				bw=round(bw*100)/100
				if bw<=0.1
					bw=0.1
				endif
				removeObject: impResp, freqResp
				goto BASE_SCREEN
			elsif demoKey$() = "→"
				bw+=increment
				bw=round(bw*100)/100
				removeObject: impResp, freqResp
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
	demo Text special: 50, "centre", 63, "half", "Helvetica", 150, "0", "DD"
	demo Text special: 50, "centre", 50, "half", "Helvetica", 23, "0", "Damping Demonstration"
	demo Black
	demo Text special: 50, "centre", 45, "half", "Helvetica", 12, "0", "You can close this window now"
	demoShow()

#### PROCEDURES #####

procedure plotGraphs: minTime, maxTime, maxFreq

	# Get impulse response and frequency response: 
	selectObject: pulse
	impResp = Filter (one formant): cFreq, bw
	freqResp = To Spectrum: 1; yes this is cheated but it seems the only way to get the shape of the frequency response in Praat. I'll work on it...

	# Plot pulse: 
	selectObject: pulse
	start=0.45
	end=0.55
	demo Axes: 0, 100, 0, 100
	demo Select outer viewport: 25, 45, 50, 90
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


	# Plot filter: 
	selectObject: freqResp
	demo Select outer viewport: 50, 90, 50, 90
	demo Draw: 0, maxFreq, 0, 100, 0
	demo Draw inner box
	demo Text left: 1, "Gain (dB)"
	demo Text bottom: 1, "Frequency (Hz)"
	demo Marks left every: 1, 20, 1, 1, 0
	freq_step = maxFreq/5
	demo Marks bottom every: 1, freq_step, 1, 1, 0 	

	# Plot impulse response: 
	selectObject: impResp
	demo Select outer viewport: 25, 90, 5, 50
	start=0.45
	end=1
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

