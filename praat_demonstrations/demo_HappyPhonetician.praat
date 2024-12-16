###########################################################
#
#       Praat Script: THE HAPPY PHONETICIAN
#
# Let's admit it: as Phoneticians we are typically very proud about 
# the fancy looking analysis graphs we are producing in our daily 
# work. With this script you can get a nice selection of typical 
# speech analysis graphs (spectrogram, pitch curve, formant tracks, 
# etc.) of a short section of speech, e.g. your name.  Printed on a 
# t-shirt this can be the ideal birthday or Xmas gift which, as 
# experience shows, makes everybody freeze in awe in front of the 
# amazingly complicated analysis we are able to perform.
#
#	This script prints waveform, spectrogram, formants, pitch, and intensity of 
#	a sound file into the 'Praat picture' window. It will print the name of the 
#	file as a headline. I use it with students at christmas so they can get an 
#	acoustic analysis of their names on one printout which is usually something 
#	that phoneticians like to hang up at home or print on their t-shirts - the 
#	more complicated the graphs look the better ;-) 
#
#                                     written by Volki (volker.dellwo@uzh.ch)
#
############################################################


### Create user interface window #############################################################
form waveform & spectrogram printer
   comment Record your name first select it in the Praat objects list.
   comment Now write down your name:
      text name Volker
   comment What's your gender? (This is relevant for measuring your formants)
      optionmenu gender
      option male
      option female
endform


### Read file and remove '.wav' extension for variable #######################################
sound = selected("Sound")
Rename... 'name$'
if gender = 1
  maxFormant = 5000
  maxPitch = 300
elsif gender = 2
  maxFormant = 5500
  maxPitch = 400
endif


### Graphical output of the waveform #########################################################
Erase all
Line width... 1

# Print headline:
Font size... 28
Maroon
Viewport... 0.3 7.5 0.5 1
Palatino
Viewport text... Centre Half 0 Phonetische Analyse von "'name$'"

# Print names:
Font size... 18
Helvetica
Viewport... 7 7.5 1.5 3
Viewport text... Centre Half 270 Oszillogramm
Viewport... 7 7.5 4 7
Viewport text... Centre Half 270 Spektrogramm & Formanten
Viewport... 0.3 4 7.5 8
Viewport text... Centre Half 0 Grundfrequenz
Viewport... 4 7.5 7.5 8
Viewport text... Centre Half 0 Intensitaet
Grey
Viewport... 3.6 3.8 10.5 10.55
Text special... 0 centre 0 bottom Times 17 0 Phonetisches Laboratorium der Universitaet Zuerich
Text special... 0 centre 0 top Times 13 0 - www.pholab.uzh.ch -

# Waveform:
minAmp = Get minimum... 0 0 Sinc70
maxAmp = Get maximum... 0 0 Sinc70
Viewport... 0.3 7.5 1 3.5
Font size... 12
Red
Draw... 0 0 'minAmp' 'maxAmp' 1

# Spetrogram:
spectrogram = To Spectrogram... 0.005 maxFormant 0.002 20 Gaussian
Viewport... 0.3 7.5 3.5 7.5
Paint... 0 0 0 0 100 yes 50 6 0 yes

# Formants:
select sound
formants = To Formant (burg)... 0.0 5 maxFormant 0.025 50
Viewport... 0.3 7.5 3.5 7.5
Speckle... 0 0 5000 30 no

# Pitch:
select sound
pitch = To Pitch... 0.0 75 600
Viewport... 0.3 4 7.5 10
Speckle... 0 0 0 maxPitch yes

# Intensity:
select sound
intensity = To Intensity... 100 0
Viewport... 4 7.5 7.5 10
Draw... 0 0 0 0 yes

# clean up:
select spectrogram
plus formants
plus pitch
plus intensity
Remove


### Display graphical output in file ############################################################
Viewport... 0 7.8 0 11
