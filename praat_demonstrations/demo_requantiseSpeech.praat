#
# Praat Script: RE-QUANTISATION
#
# Praat version: 5.2.11
#
# This program simulates a change of the number of quantisation levels.
# It changes a sound waveform to what it would look like if it was quantized 
# with varying numbers of bit levels. The actual number of quantization
# levels of the sound, howver, is not affected (this is necessary 
# because Praat (version 5.2.11) cannot process files lower than 8 bit). 
#
#                                               written by Volki
#

### Create user interface window ################################################

form waveform re-quantisation
   comment Finding the file you want to re-quantise
   comment Please specify the path:
      text Path sound/
   comment Please specify the filename:
      text Filename example.wav
   comment ----------------------------------------------------------------------------------------------------------------------   
   comment Please specify the quantisation simulation:
      choice quantisation_(bit) 1
         option 1
         option 2
         option 4
         option 6
         option 8
         option 10
         option 12
         option 14
         option 16
endform

### Read file and change its quantisation level #################################

# Prepare input sound:
quantisation = 'quantisation$'
sound = Read from file... 'path$''filename$'
name$ = selected$("Sound")
Rename... 'name$'_'quantisation'bit

# Requantise: 
number_of_quantisation_levels = 2^quantisation
Formula... floor(self*(number_of_quantisation_levels/2))
Scale peak... 0.99
Play
