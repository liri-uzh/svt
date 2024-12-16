form Write sentence with line breaks...
	sentence sentence Write me on the screen and see whether the line break works well
	integer font_size 40
	positive line_width 35
	positive line_spacing 20
	positive vertical_position 65
	positive horizontal_position 50
	optionmenu alignment 2
		option left
		option centre
		option right
	boolean erase_all 1
endform
include settings.txt

demo 'font_colour$'
if erase_all
	demo Erase all
endif
nChar = length(sentence$)
iChar = 1
repeat
	sentenceChunk$ = mid$(sentence$, iChar, line_width)
	lengthChunk = length(sentenceChunk$)
	if lengthChunk=line_width
		lastBlank = rindex(sentenceChunk$, " ")
		sentencePart$ = mid$(sentence$, iChar, lastBlank)
		demo Text special: horizontal_position, alignment$, vertical_position, "half",  font$, font_size, "0", sentencePart$
		iChar+=lastBlank
		vertical_position-=line_spacing
	else
		sentencePart$ = mid$(sentence$, iChar, nChar)
		demo Text special: horizontal_position, alignment$, vertical_position, "half",  font$, font_size, "0", sentencePart$
	endif
until lengthChunk<>line_width
