### demo_createSawtooth.praat ####################
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# History: 
#    V_0.1: 29.3.2020: created (created at home during Corona lockdown :-S )
#
# DESCRIPTION: 
#    This script creates a sawtooth wave. The user can choose 
#    fundamental frequency, duration of the sawtooth in seconds
#    peak amplitude and sampling frequency.  
#    The script samples a time function of the sawtooth.
#
# RECOMMENDATION:
#    Depending on sampling frequencies there can be rounding differences
#    between timedomain in seconds and time sampling domain leading to little 
#    discrepancies between wanted and actual fundamental frequency. I recommend
#    to stick with a sampling frequency of 44100 which seemed to work best
#    for whole number frequencies (I am working on the problem...). 
#
#	VARIABLES:
#    fo = fundamental frequency of oscillation
#    d = total duration of signal in seconds
#    sf = sampling frequency
#    a = peak amplitude of signal
#    dP = duration of a period (in sec)
#    nS = total number of samples in signal
#    iS = ith sample in a signal
#    deltaS = duration between samples (in sec)
#    slope = rise/run (rise = max amplitude difference, run = period duration)
#    timeX = the time of the ith sample
#
###################################################

form Create sawtooth...
	real Fundamental_frequency 120
	real Duration 1
	real Peak_amplitude 0.9
	positive Sampling_frequency 44100
endform

# variables: 
fo = fundamental_frequency
d = duration
sf = sampling_frequency
a = peak_amplitude
dP = 1/fo
nS = d*sf
deltaS = 1/sf
slope = (a*2)/dP

# procedure: 
signal# = zero#(nS)
for iS to nS	
	timeX = iS*deltaS
	run = dP*((timeX/dP)-floor(timeX/dP))
	rise = slope*run
	aS = a-rise
	signal#[iS] = aS
endfor
sawtooth = Create Sound from formula: "sawtooth_'fo'", 1, 0, d, sf, ~signal#[col]
