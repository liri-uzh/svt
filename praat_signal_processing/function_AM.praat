### START SCRIPT
#
# Name:
# function_amplitudeModulation.praat: carrier_frequency
# 
# Praat Script for Praat software (www.praat.org, version 6.0.17)
# Written by Volker Dellwo (volker.dellwo@uzh.ch) 
#
# History: 
#    V_0.1: 29.4.2016: created
#
# DESCRIPTION: 
#    This script turns a sound into a amplitude modulated (AM) sound
#    with a carrier frequency specified by the user.
# 
# INPUT:
#    Select sound object in Praat list of objects
#
# OUTPUT:
#    A new sound object containing the amplitude modulated input sound.  
#

form Amplitude modulation...
	real carrier_frequency 10000
endform

# Variables: 
sound$ = selected$("Sound")
td = Get total duration
sf = Get sampling frequency
cf = carrier_frequency

# Sampling rate must at least be twice the carrier frequency: 
if cf>sf/2
	exit Your sampling frequency must be at least twice the carrier frequency!
endif

# modulation: 
noprogress Filter (pass Hann band): 50, cf, 100
am = Create Sound from formula: "'sound$'_am'cf'", 1, 0, td, sf, "sin(2*pi*cf*x)*(Sound_'sound$'_band[])"

# clean up: 
select Sound 'sound$'_band
Remove

# leave AM signal selected: 
select am

### END SCRIPT
