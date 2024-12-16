### function_createPTPtier.praat (version 0.02)
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# Description: 
# This script creates a TextGrid (based on a sound) 
# which contains peak-to-peak intervals.
#
# History: 
# 30.6.2012: created (version 0.01)
# 19.7.2022: 
# 	- updated to new Praat syntax (version 0.02)
# 	- changed envelope calculation from half to fully rectified wave
#		- tried to change moving frame for peak detection to amplitude detection by sample but runtime is too long
#		- added several menu commands
#		- several bug changes

form Create peak-to-peak interval tier...
	real From_time 0
	real To_time 0
	real From_frequency 70
	real To_frequency 3500
	optionmenu Envelope_method 1
		option low-pass filtering
		option harmonicity contour
	real Envelope_cut_off_frequency 8
	boolean apply_warping 1
	real Min_duration_of_interval_in_sec 0.05
	boolean Show_peak_points_in_sound 0
endform

# Get sound information
sound = selected("Sound")
name$ = selected$("Sound")
sf = Get sampling frequency
id = sound

# Extract sound-part as specified by user: 
selectObject: sound
td = Get total duration
if to_time<>0
   selectObject: sound
   soundPart = Extract part: from_time, to_time, "rectangular", 1, 0
   originalSound = sound
   sound = soundPart
elsif from_time>to_time
   exit ERROR: Your start time must not be higher than your end time.
endif

# Band-pass filter signal:
selectObject: sound
bp = Filter (pass Hann band): from_frequency, to_frequency, 50
Rename: "'id'_bpfiltered"

# Create envelope (ENV): 

	if envelope_method=1

		# Create low-pass filtered version of full-wave rectified wave
		temp0 = Copy: "rectified"
		Rename: "'id'_rectified"
		Formula: ~sqrt(self^2)
		envelope = Filter (pass Hann band): 0, envelope_cut_off_frequency, 1
		Rename: "'id'_envelope"
		removeObject: temp0

	elsif envelope_method=2

		# Create harmonicity object and turn into sound 
		temp0 = Copy: "harmonicity"
		sf = Get sampling frequency
		noprogress To Harmonicity (cc): 0.01, 75, 0.1, 1
		temp1 = selected()
		Formula: ~if self<0 then 0 else self fi
		temp2 = To Matrix
		temp3 = To Sound
		temp4 = Resample: sf, 50
		envelope = Filter (pass Hann band): 0, envelope_cut_off_frequency, 1
		Rename: "'id'_envelope"
		removeObject: temp0, temp1, temp2, temp3, temp4

	endif

# Create warped version
if apply_warping = 1
   warped = Copy: "'id'_warped"
   min = Get minimum: 0, 0, "sinc70"
   min = sqrt(min^2)
   Formula: ~self+min+0.01
   Formula: ~self+log2(self)
   min = Get minimum: 0, 0, "sinc70"
   Formula: ~self-min
   Scale peak: 0.99
   Formula: ~if self<0.3 then 0 else self fi
endif

# extract peaks: 
peakFilter = Copy: "'id'_peakFilter"
Formula: ~ if self[col+100]>self then 0 else self fi
Reverse
Formula: ~if self[col+100]>self then 0 else self fi
Reverse
max = Get maximum: 0, 0, "None"
Formula: ~if self<max*0.1 then 0 else self fi
Scale peak: 0.99

# fill array with peak times
selectObject: peakFilter
duration = Get total duration
durationMS = duration*1000 
window = 100
peakCounter=0
for iMS to durationMS-window
   maximum = Get maximum: iMS/1000, iMS/1000+window/1000, "sinc70"
   if maximum>0
      peakCounter+=1
      time[peakCounter]=Get time of maximum: iMS/1000, iMS/1000+window/1000, "sinc70"
   endif
   iMS+=window   
endfor

# Create TextGrid with peak information:
textGrid = To TextGrid: "peaks", "none"
for iPeak to peakCounter
   nocheck Insert boundary: 1, time[iPeak]
endfor

# Remove intervals below threshold duration specified by user. 
# Replace these intervals with a single boundary at the mid point of the interval. 
selectObject: textGrid
nIntervals = Get number of intervals: 1
for iInterval to nIntervals
   start = Get start point: 1, iInterval
   end = Get end point: 1, iInterval
   duration = end-start
   if duration <= min_duration_of_interval_in_sec
      mid = start+(duration/2)
      nocheck Remove boundary at time: 1, start
      nocheck Remove boundary at time: 1, end
      nocheck Insert boundary: 1, mid
      nIntervals-=1
   endif
endfor

# Label peak intervals:
selectObject: textGrid
nIntervals = Get number of intervals: 1
Set interval text: 1, 1, "sil"
Set interval text: 1, nIntervals, "sil"
for iInterval from 2 to nIntervals-1
	start = Get start point: 1, iInterval
	end = Get end point: 1, iInterval
	duration = end-start
	if duration<0.4
		Set interval text: 1, iInterval, "P2P"
	else
		Set interval text: 1, iInterval, "sil"
	endif
endfor

# Remove consequtive "sil":
selectObject: textGrid
nIntervals = Get number of intervals: 1
for iInterval to nIntervals-1
	label1$ = Get label of interval: 1, iInterval
	label2$ = Get label of interval: 1, iInterval+1
	if label1$ = "sil" and label2$ = "sil"
		time = Get end point: 1, iInterval
		Remove boundary at time: 1, time
		Set interval text: 1, iInterval, "sil"
		iInterval-=1
		nIntervals-=1
	endif
endfor

# Create stereo sound including peaks and original signal:
selectObject: sound, peakFilter
stereo1 = Combine to stereo
Rename: "'id'_original_peakFilter"

# clean up: 
removeObject: bp, envelope, peakFilter
if show_peak_points_in_sound=0
   removeObject: stereo1
endif
if apply_warping=1
   removeObject: warped
endif
if to_time<>0
   removeObject: sound
endif

# Leave output selected: 
selectObject: textGrid