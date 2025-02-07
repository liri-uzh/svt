# create rectangular wave: 
rectangular = Create Sound from formula: "rectangular", 1, 0, 3, 48000, "if col>48000 and col<96000 then 1 else 0 fi"
sine = Create Sound from formula: "sine", 1, 0, 10, 48000, ~1/2 * sin(2*pi*377*x)

# create triangular wave: 
triangularGate = Create Sound from formula: "triangularGate", 1, 0, 3, 48000, "if col>48000 and col<96000 then 1 else 0 fi"
t=1
for i from 48001 to 96000
	Set value at sample number: 0, i, t
	t-=1/48000
endfor
triangularRamp = Copy: "triangularRamp"
Reverse

# convolution
selectObject: rectangular, triangularGate
	convolution = Convolve: "integral", "zero"
	Rename: "convolution_rect_gate"

# convolution
selectObject: triangularGate, triangularRamp
	convolution = Convolve: "integral", "zero"
	Rename: "convolution_gate_ramp"

# cross-correlation
selectObject: rectangular, triangularGate
	crosscorrelation = Cross-correlate: "integral", "zero"
	Rename: "crosscorrelation_rect_gate"

# cross-correlation
selectObject: triangularGate, triangularRamp
	crosscorrelation = Cross-correlate: "integral", "zero"
	Rename: "crosscorrelation_gate_ramp"

# auto-correlation
selectObject: rectangular
	autocorrelation = Autocorrelate: "peak 0.99", "zero"
	Rename: "autocorrelation"


