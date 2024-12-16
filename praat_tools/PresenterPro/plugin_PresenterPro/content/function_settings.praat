# load the settings from the settings file: 
include settings.txt

# ask user to modify settings 

	beginPause ("PresenterPro settings...")
		positive ("line_width", line_width)
		positive ("font_size", font_size)
		positive ("line_spacing", line_spacing)
		optionMenu ("font", font)
			option ("Helvetica")
			option ("Times")
			option ("Arial")
		word ("font_colour", font_colour$)
		boolean ("display_sentence_number", display_sentence_number)
		boolean ("randomize_list", 0)
		real ("Countdown_duration", countdown_duration)
	clicked = endPause ("Reset", "Next", 2)

pause 'font$'

	if clicked=1
		line_width = 45
		font_size = 35
		line_spacing = 8
		font = 1
		font$ = "Helvetica"
		font_colour$="Black"
		display_sentence_number=1
		randomize_list=0
		countdown_duration = 1
	endif

# remember modified settings: 
filedelete settings.txt
fileappend settings.txt line_width = 'line_width''newline$'
fileappend settings.txt font_size = 'font_size''newline$'
fileappend settings.txt line_spacing = 'line_spacing''newline$'
fileappend settings.txt font = 'font''newline$'
fileappend settings.txt font$ = "'font$'"'newline$'
fileappend settings.txt font_colour$ = "'font_colour$'"'newline$'
fileappend settings.txt display_sentence_number = 'display_sentence_number''newline$'
fileappend settings.txt randomize_list = 'randomize_list''newline$'
fileappend settings.txt countdown_duration = 'countdown_duration''newline$'




