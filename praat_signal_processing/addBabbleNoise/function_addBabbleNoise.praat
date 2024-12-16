form Add noise...
	integer Base_intensity 70
	integer SNR 0
endform

# Adjust intensity in input sound: 

	sound = selected("Sound")
	sound$ = selected$("Sound")
	newSound = Copy: sound$+"_SNR'sNR'"
	fs = Get sampling frequency
	Scale intensity: base_intensity
	dur = Get total duration

# Create noise and adjust intensity: 

	babble1 = Read from file: "babble.wav"
	babble2 = Resample: fs, 50
	noise = Extract part: 0, dur, "Rectangular", 1, 0
	Rename: "noise"
	Scale intensity: base_intensity-sNR

# Add signal and noise: 

	selectObject: newSound
	Formula: ~self+Sound_noise[]

# Clean up: 

	removeObject: noise, babble1, babble2
	selectObject: newSound
