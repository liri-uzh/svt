### function_createPTPTier.praat (version 0.02)
# 
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo and Ingrid Hove 
# (volker.dellwo@uzh.ch)
#
# Description: 
# This script measures speech rate by calculating the number of 
# amplitude envelope peak points per second
# The script is based on function_createPTPtier.praat
#
# History: 
# 19.12.2013: created (version 0.01)
 
# Define variables: 
from_time = 0
to_time = 0
start_interval_count_with = 1
min_duration_of_interval_in_sec = 0.05
first_and_last_is_silence = 1
show_peak_points_in_sound = 0
apply_warping = 0 

# Get sound information
sound = selected("Sound")
name$ = selected$("Sound")
samplingFrequency = Get sampling frequency
id = sound

# Extract sound-part as specified by user: 
select sound
totalDuration = Get total duration
if to_time<>0
   select sound
   soundPart=Extract part... from_time to_time rectangular 1 0
   originalSound=sound
   sound=soundPart
elsif from_time>to_time
   exit ERROR: Your start time must not be higher than your end time.
endif

# Band-pass filter signal:
select sound
bpfiltered = Filter (pass Hann band)... 80 4000 50
Rename... 'id'_bpfiltered

# Create rectified version: 
rectified = Copy... rectified
Rename... 'id'_rectified
Formula... sqrt(self^2)

# Create half-rectified version: 
halfRectified = Copy... 'id'_halfRectified
Formula... self+Sound_'id'_bpfiltered[]

# Create envelope of half-rectified version:
envelope = Filter (pass Hann band)... 0 10 1
Rename... 'id'_envelope

# Create warped version
if apply_warping = 1
   warped = Copy... 'id'_warped
   min = Get minimum... 0 0 sinc70
   min = sqrt(min^2)
   Formula... self+min+0.01
   Formula... self+log2(self)
   min = Get minimum... 0 0 sinc70
   Formula... self-min
   Scale peak... 0.99
   Formula... if self<0.3 then 0 else self fi
endif

# extract peaks: 
peakFilter = Copy... 'id'_peakFilter
Formula... if self[col+100]>self then 0 else self fi
Reverse
Formula... if self[col+100]>self then 0 else self fi
Reverse
max = Get maximum... 0 0 None
Formula... if self<max*0.1 then 0 else self fi
Scale peak... 0.99

# fill array with peak times
select peakFilter
duration = Get total duration
durationMS = duration*1000 
window = 100
peakCounter=0
for iMS to durationMS-window
   maximum = Get maximum... iMS/1000 iMS/1000+window/1000 Sinc70
   if maximum>0
      peakCounter+=1
      time[peakCounter]=Get time of maximum... iMS/1000 iMS/1000+window/1000 Sinc70
   endif
   iMS+=window   
endfor

# Create TextGrid with peak information:
textGrid = To TextGrid... peaks none
for iPeak to peakCounter
   peakTime = time[iPeak]
   nocheck Insert boundary... 1 peakTime
endfor

# Remove intervals below threshold duration specified by user. 
# Replace these intervals with a single boundary at the mid point of the interval. 
select textGrid
nIntervals = Get number of intervals... 1
for iInterval to nIntervals
   start = Get start point... 1 iInterval
   end = Get end point... 1 iInterval
   duration = end-start
   if duration <= min_duration_of_interval_in_sec
      mid = start+(duration/2)
      nocheck Remove boundary at time... 1 start
      nocheck Remove boundary at time... 1 end
      nocheck Insert boundary... 1 mid
      nIntervals-=1
   endif
endfor

# Label peak intervals:
select textGrid
nIntervals = Get number of intervals... 1
counter = start_interval_count_with 

	# deal with first interval:
	if first_and_last_is_silence = 0
		Set interval text... 1 1 'counter'
		counter+=1
	else
		Set interval text... 1 1 sil
	endif

	# loop through interval from 2nd to 2nd last:
	for iInterval from 2 to nIntervals-1
		Set interval text... 1 iInterval 'counter'
		counter+=1
	endfor

	# deal with last interval: 
	if first_and_last_is_silence = 0
		Set interval text... 1 nIntervals 'counter'
	else 
		Set interval text... 1 nIntervals sil
	endif

# Create stereo sound including peaks and original signal:
select sound
plus peakFilter
stereo1 = Combine to stereo
Rename... 'id'_original_peakFilter

# clean up: 
select bpfiltered
plus rectified
plus halfRectified
plus envelope
plus peakFilter
if show_peak_points_in_sound=0
   plus stereo1
endif
if apply_warping=1
   plus warped
endif
if to_time<>0
   plus sound
endif
Remove

select textGrid
nInt = Get number of intervals... 1
nPTP = nInt-3
start1 = Get start point... 1 2
end1 = Get end point... 1 2
duration1 = end1-start1
start2 = Get start point... 1 nInt-1
end2 = Get end point... 1 nInt-1
duration2 = end2-start2
totalDuration = (end2-(duration2/2)) - (start1+(duration1/2))
sylPerSec = nPTP/totalDuration
#Remove

echo 'sylPerSec'