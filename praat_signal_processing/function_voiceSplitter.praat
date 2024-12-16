form Voice splitter...
	real Window_length 0.04
	boolean Fill_noise 0
	real Noise_intensity 0.02
endform

sound$ = selected$("Sound")
channel_1 = Copy... channel_1
channel_2 = Copy... channel_2
duration = Get total duration

channel = 1
windowPosition=0
while windowPosition<duration

	# select correct channel:
	if channel=1
		select channel_1
		channel=2
	elsif channel=2
		select channel_2
		channel=1
	endif

	# process part:
	start = windowPosition
	end = windowPosition+window_length
	Set part to zero... start end at nearest zero crossing
	if fill_noise
		Formula (part)... start end 1 1 randomGauss(0,noise_intensity)
	endif
	windowPosition+=window_length

endwhile

select channel_1
plus channel_2
final = Combine to stereo
Rename... 'sound$'_ce_12

select channel_1
temp=Copy... temp
select channel_2
plus temp
final_21 = Combine to stereo
Rename... 'sound$'_ce_21
select temp
Remove

select channel_1
plus channel_2
#Remove
