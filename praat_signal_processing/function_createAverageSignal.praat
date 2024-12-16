# This script produces an average of a number of selected sounds.
#
# Written by Volker Dellwo, University of Zurich (FEB 22. 2018)

nSel = numberOfSelected("Sound")

# Read sound IDs into array: 
for iSel to nSel
	sound[iSel]=selected("Sound", iSel)
	sound$[iSel]=selected$("Sound", iSel)
endfor

select sound[1]
sounds$ = "'nSel'"
averageSum = Copy: "sum_of_"+sounds$

for iSel from 2 to nSel
	select averageSum
	sound$ = sound$[iSel]
	Formula: ~self+Sound_'sound$'[]
endfor

select averageSum
Formula: ~self/nSel