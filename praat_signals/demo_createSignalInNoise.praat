form Create tone with noise
	integer Duration 1
	integer SNR_in_dB 16
	integer Tone_frequency 400
	integer Noise_lower_cut_off 200
	integer Noise_upper_cut_off 600
endform

tone = Create Sound from formula... tone 1 0 duration 44100 sin(2*pi*tone_frequency*x) 
Scale intensity... 70
whiteNoise = Create Sound from formula... whiteNoise 1 0 duration 44100 randomGauss(0,0.1)
filtered = Filter (formula)... if x<noise_lower_cut_off or x>noise_upper_cut_off then 0 else self fi
Scale intensity... 70+sNR_in_dB
Rename... whiteNoise_filt

select tone
Rename... toneAndNoise_'sNR_in_dB'
Formula... self+Sound_whiteNoise_filt[]
Scale intensity... 70
Play

select filtered
plus whiteNoise
Remove

select tone
spectrum = To Spectrum... 1
Edit