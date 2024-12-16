form Rate modulation...
	optionmenu Carrier_signal: 1
		option sinusoid
		option selected
	real Carrier_frequency 440
	real Duration_in_sec 3
	positive Start_modulation_frequency 2
	positive End_modulation_frequency 10
	boolean Delete_carrier 1
endform

# create carrier:
if carrier_signal == 1
	carrier = Create Sound from formula: "carrier", 1, 0, duration_in_sec, 44100, ~1/2*sin(2*pi*carrier_frequency*x)
elsif carrier_signal = 2
	sf = Get sampling frequency
	if sf = 44100
		carrier = Copy: "carrier"
		total_duration = Get total duration
	else 
		carrier = Resample: 44100, 50
		Rename: "carrier"
		total_duration = Get total duration
	endif
endif

# create simple modulation: 
for i from start_modulation_frequency to end_modulation_frequency
	modulation[i] = Create Sound from formula: "modulation'i'", 1, 0, total_duration, 44100, ~1/2*sin(2*pi*(i/2)*x)
	Formula: ~self*Sound_carrier[]
endfor

# create complex modulation: 
for i from start_modulation_frequency to end_modulation_frequency
	modulation = Create Sound from formula... modulation 1 0 total_duration 44100 1/2*sin(2*pi*(i/2)*x)

	# full wave rectify:
	fwr = Copy... fwr
	Formula... sqrt(self^2)

	# half wave rectify:
	hwr = Copy... hwr
	Formula... (self+Sound_modulation[])/2

	# complex carrier:
	select fwr
	complex_modulation = Copy... complexModulation'i'
	Formula... (self+Sound_hwr[])/2

	# modulate: 
	Formula... self*Sound_carrier[]
	
	# clean up: 
	select modulation
	plus fwr
	plus hwr
	Remove

endfor





if delete_carrier
	select carrier
	Remove
endif