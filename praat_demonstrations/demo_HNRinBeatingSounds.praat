clearinfo
for i to 101
   frequency_a = 200
   frequency_b = frequency_a-1+i
   noprogress Create Sound from formula... signal 1 0 1 44100 1/2 * sin(2*pi*frequency_a*x) + 1/2 * sin(2*pi*frequency_b*x)
   signal=selected("Sound")
   noprogress To Harmonicity (cc)... 0.01 75 0.1 1.0
   hnr=selected("Harmonicity")
   mean = Get mean... 0 0
   printline 'frequency_a' Hz + 'frequency_b' Hz: hnr = 'mean'
   select signal 
   Rename... 'frequency_a'_'frequency_b'
   select hnr 
   Remove
endfor
