### START SCRIPT
#
# Name:
# function_frequencyModulation.praat: carrier_frequency
# 
# Praat Script for Praat software (www.praat.org, version 6.0.17)
# Written by Thayabaran Kathiresan & Volker Dellwo (volker.dellwo@uzh.ch) 
#
# History: 
#    V_0.1: 29.4.2016: created
#
# DESCRIPTION: 
#    This script turns a sound into a frequency modulated (FM) sound
#    with a carrier frequency specified by the user.
# 
# INPUT:
#    Select sound object in Praat list of objects
#
# OUTPUT:
#    A new sound object containing the frequency modulated input sound.  
#

form Frequency modulation...
	real carrier_frequency 10000
endform

# Variables: 
modulator$ = selected$("Sound")
td = Get total duration
sf = Get sampling frequency
cf = carrier_frequency

# Exit if sampling rate is not at least twice the carrier frequency: 
if cf*2>sf
	exit Your sampling frequency must be at least twice the carrier frequency!
endif

# modulation: 
noprogress Filter (pass Hann band): 50, cf, 100
fm = Create Sound from formula: "'modulator$'_fm'cf'", 1, 0, td, sf, "sin((2*pi*cf*x)+Sound_'modulator$'[])"

# clean up: 
select Sound 'modulator$'_band
Remove

# leave fm signal selected:
select fm

### END SCRIPT 