### function_hilbertTransform.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Lei He (lei.he@uzh.ch) and Volker Dellwo (volker.dellwo@uzh.ch) 
# based on essential help from Stuart Rosen and a Matlab script by Christian Lorenzi.
#
# History: 
#    V_0.1: 09.5.2015: created
#    V_0.2: 30.5.2015: minor modifications (VD)
#    V_0.3: 26.6.2016: leaves the hilbert signal in the list of objects
#    V_0.4: 23.1.2020: adapted script to new Praat syntax (VD)
#    V_0.5: 26.4.2020: error correction (VD; thanks to Xueying Liu for pointing this out!)
#
# DESCRIPTION: 
#    This script produces the Hilbert shifted signal (HILBERT), the amplitude envelop (ENV) and the temporal 
#    fine structure (TFS) of a signal based on the Hilbert transformation.
# 
# INPUT:
#    A Sound object must be selected in the Praat list (note that longer sound objects may take a long processing time).
#
# PROCEDURE:
#    Execute the script on the selected Sound object in the Praat list
#
# OUTPUT:
#    (a) a new Sound object containing the ENV of the sound ([soundname]_ENV)
#    (b) a new Sound object containing the TFS of the sound ([soundname]_TFS)
#
###

# Get ID and name of object: 

	sound = selected("Sound")
	sound$ = selected$("Sound")

# Remove zero samples in sound: 

	selectObject: sound
	Formula: ~if self=0 then (self[col-1]+self)/2 else self fi

# Produce a spectrum by FFT:

	selectObject: sound
	spectrum = To Spectrum: 0
	Rename: "original"

# Shift imaginary parts by 90 degrees in Hilbert spectrum:  

	spectrumHilbert = Copy: "hilbert"
	Formula: ~if row=1 then Spectrum_original[2,col] else -Spectrum_original[1,col] fi

# Get the Hilbert sound

	soundHilbert = To Sound
	Rename: sound$+"_HILBERT"

# Remove zero samples in sound

	selectObject: soundHilbert
	Formula: ~if self=0 then (self[col-1]+self)/2 else self fi

# Get the ENV : 

	selectObject: soundHilbert
	env = Copy: sound$+"_ENV"
	Formula: ~sqrt(self^2+Sound_'sound$'[]^2)

# Produce inverse ENV: 

	selectObject: env
	inverse = Copy: "inverse_ENV"
	Formula: ~1/self

# Multiply inverse ENV with sound to get TFS:

	selectObject: sound
	tfs = Copy: sound$+"_TFS"
	Formula: ~self*Sound_inverse_ENV[]

# Scale overall intensity of TFS to that of original sound

	selectObject: sound
	intensity = Get intensity (dB)
	selectObject: tfs
	Scale intensity: intensity

# Clean up:

	removeObject: spectrum, spectrumHilbert, inverse

# Leave new objects selected: 

	selectObject: tfs, env, soundHilbert

### SCRIPT END ###
