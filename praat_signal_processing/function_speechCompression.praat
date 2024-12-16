### function_speechCompression.praat
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# History: 
#    V_0.1: 18.4.2014: created (on a train from Neuchatel to Strasbourg)
#    V_0.2: 6.5.2021: ceated (on a ferry from Ancona to Igoumenitsa)
#           - updated to new Praat scripting syntax
#           - added an option that allows processing for multiple frequency bands
#
# DESCRIPTION: 
#    This script produces speech that is infinitely peaked clipped (ipc)
#    and reapplies the amplitude envelope (env) to the ipc signal. When 
#    executed on a Sound object the script produces three new files: 
#	   1: Sound ENV: The amplitude envelope of the signal
#	   2: Sound IPC: The infinitely peak clipped signal
#	   3: Sound IPC_ENV: The infinitely peak clipped signal with the 
#		   with the amplitude envelope reapplied
#
# SETTINGS: 
# Evelope frequency: 
#	Maximum frequency of the amplitude envelope (default: 30 Hz)
# 
# Silence threshold:
# 	Amplitudes smaller than this value will be set to 0. 
#
# ipc method I:
# 	* binary method scaling signal between 0 and 1 
# 	* silences are counted to 0 
#	* This method produces a positive waveform only
#
# ipc method II: 
# 	* binary method scaling signal between -1 and 0 
# 	* silences are counted to 0 
#	* This method produces a negative waveform only
#
# ipc method III
# 	* binary method scaling signal between -1 and 1
# 	* silences are attributed to -1
#	* this is the preferred method
# 
# ipc method IV:
# 	* tertiary method scaling signal between -1, 0 and 1 
# 	* low level noise is attributed to 0
#	* this method can be problematic because it produces intervals at 0
#
# Smoothing: 
# 	To smooth the sharp edges of the ipc signal this method can be applied.
# 	Not recommended to use together with De-emphasis as this results in 
# 	in a similar process. 
#
# Pre- and de-emphasis:
# 	Licklider and Pollack (1948, JASA[20,1], 42-51) suggest 
# 	to preced ipc with a pre-emphasis filter and de-emphasize 
# 	again post ipc processing for best intelligibility. The de-emphasis
# 	however, results in a non-flat envelope. It has been found that
# 	pre-emphasis alone enhances intelligibility. For this reason the
# 	follwoing settings are recommended: 
# 	pre-emphasis = 1
# 	de-emphasis = 0
#
##################

### SCRIPT START ###

form Infinite peak clipping compression...
	positive Envelope_frequency 30
	real Silence_threshold 0.01
	choice ipc_method 3
		option between_0_and_1
		option between_-1_and_0
		option between_-1_and_1
		option between_-1_0_and_1
	boolean Apply_smoothing 0
	boolean Apply_pre_emphasis 1
	boolean Apply_de_emphasis 0
endform

sound = selected("Sound")
duration = Get total duration

# Filter sound within speech range and scale peak to 0.99

	filtered = Filter (pass Hann band)... 80 8000 100
	Scale peak... 0.99

# Get amplitude envelope of original: 
	
	select filtered
	rectified = Copy... rectified
	Formula... sqrt(self^2)
	env = Filter (pass Hann band)... 0 envelope_frequency 1
	Scale peak... 0.99
	Formula... if self<=0.001 then 0 else self fi
	Rename... ENV

# Infinitely peak clip signal with 1-bit quantisation: 
	
	select filtered
	ipc = Copy... IPC
	
	# Perform pre-emphasis: 
	
		if apply_pre_emphasis = 1
			ipc_before_pre_emphasis = ipc
			ipc = Filter (pre-emphasis)... 1000
			Rename... IPC_pre_emphasis
		endif			

	# Perform ipc: 
		if ipc_method=1
			Formula... if self>silence_threshold then 0.9 else 0 fi
		elsif ipc_method=2
			Formula... if self<-silence_threshold then -0.9 else 0 fi
		elsif ipc_method=3
			Formula... if self>silence_threshold then 0.9 else -0.9 fi
		elsif ipc_method=4
			Formula... if self>silence_threshold then 0.9 else self fi
			Formula... if self<-silence_threshold then -0.9 else self fi
			Formula... if self<silence_threshold and self>-silence_threshold then 0 else self fi
		endif

	# Perform de-emphasise: 
		
		if apply_de_emphasis = 1
			ipc_before_de_emphasis = ipc
			Rename... IPC_before_de_emphasis
			ipc = Filter (de-emphasis)... 1000
			Rename... IPC
		endif	

# Smooth the edges of the peak clipped signal: 
	
	if apply_smoothing = 1
		Formula... (self[col-1]+self[col+1])/2
		Reverse
		Formula... (self[col-1]+self[col+1])/2
		Reverse
	endif

# Apply ENV to IPC

	select ipc
	ipcWithEnv = Copy... IPCwithENV
	Formula... self*Sound_ENV[]

# Clean up: 
	
	select filtered
	plus rectified
	if apply_pre_emphasis = 1
		plus ipc_before_pre_emphasis
	endif
	if apply_de_emphasis = 1
		plus ipc_before_de_emphasis
	endif
	Remove

# Scale intensities: 

	select ipc
	Scale intensity... 70
	select ipcWithEnv
	Scale intensity... 70

# Leave output selected: 

	select env
	plus ipc
	plus ipcWithEnv

### SCRIPT END ###ß®