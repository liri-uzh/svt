form Spectral shifter...
   positive bandwidth 1000
   positive filter_slope 40
   positive number_of_bands 10
   boolean normalize_intensity yes
   positive intensity 70
endform

sound = selected("Sound")
name$ = selected$("Sound")

lowerCut = 0
upperCut = lowerCut+bandwidth
rotationFrequency = bandwidth
for iBand to number_of_bands

   # first step - filter band:
   select sound
   filtered = Filter (pass Hann band)... lowerCut upperCut filter_slope
   Rename... filtered_'iBand'

   # second step - rotate band:
   Formula... self * sin(2 * pi * x* rotationFrequency)

   # third step: 
   if iBand>1
      Formula... self * sin(2*pi*x*(rotationFrequency-bandwidth))
   endif

   # third step - filter band second time: 
   final[iBand] = Filter (pass Hann band)... lowerCut upperCut filter_slope
   Rename... final_'iBand'

   # count up counters: 
   lowerCut+=bandwidth
   upperCut+= bandwidth
   rotationFrequency+=bandwidth

   # clean up:
   select filtered
   Remove

endfor

# add up the different bands: 
select final[1]
rotated = Copy... rotated_'number_of_bands'_times_'bandwidth'_Hz
for iBand to number_of_bands
   select rotated
   Formula... self+Sound_final_'iBand'()
endfor

# normalize intensity: 
if normalize_intensity = 1
   select rotated
   Scale intensity... intensity
endif

# clean up: 
select final[1]
for iBand to number_of_bands
   plus final[iBand]
   Remove
endfor
