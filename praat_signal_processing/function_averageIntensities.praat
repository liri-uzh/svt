# This script applies the mean intensity (in dB) of a number of selected Sound objets
# to each of the selected Sound objects. 
#
# Written by Volker Dellwo, University of Zurich (FEB 22. 2018)

nSel = numberOfSelected("Sound")

# Read sound IDs into array: 
for iSel to nSel
	sound[iSel]=selected("Sound", iSel)
endfor

# Read average intensity of each Sound into vector:
intensities# = zero#(nSel)
for iSel to nSel
	select sound[iSel]
	intensities#[iSel] = Get intensity (dB)
endfor

# Apply mean intensity to selected Sound objects: 
meanIntensity = mean(intensities#)
for iSel to nSel
	select sound[iSel]
	Scale intensity: meanIntensity
endfor

# Provide feedback (delete if not wanted): 
writeInfoLine: "I obtained the following intensities:"
appendInfoLine: intensities#
appendInfoLine: "I applied the mean intensity of: ", meanIntensity




