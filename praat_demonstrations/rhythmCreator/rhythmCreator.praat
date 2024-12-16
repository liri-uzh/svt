form createRhythm
   comment How long should the intervals be?
   integer duration 0.5
   comment How many patterns would you like?
   integer patterns 4
   comment How many clicks per pattern?
   integer clicks 4
   comment Slow down and speed up factor?
   integer factor 2
   comment How many rate versions? 
   integer rate 4
   comment Sampling rate for sound output?
   integer sr 12000
   comment Name TextGrid file:
   sentence name temp
endform

################ PROGRAM ########################
totalDuration = duration
duration = (totalDuration*0.9)
start = duration*0.05
interval = duration/(clicks-1)

call createTextGrid
call createSounds
#call createEditor

################## PROCEDURES ###################

procedure createTextGrid
   textGrid = Create TextGrid... 0 totalDuration 1 1
   Rename... 'name$'
   # add points:
   for iPoint to clicks
      Insert point... 1 start 'iPoint'
      start+=interval
   endfor
   # add tiers:
   for iTier from 2 to patterns
      Duplicate tier... 1 iTier 'iTier'
   endfor
   Edit
   pause Adjust the clicks and then click continue
   Write to text file... patterns.TextGrid
   editor TextGrid 'name$'
      Close
   endeditor
endproc

procedure createSounds
   # loop through all tiers
   for iTier to patterns
      # Load array with click times:
      select textGrid
      numberOfClicks = Get number of points... iTier
      for iClick to numberOfClicks
         click'iClick' = Get time of point... iTier iClick
      endfor
      # Create Sounds
      start = 1/factor
      range = factor-1/factor
      differences = range/rate
      for iRate to rate
         Create Sound from formula... 'iTier'_'iRate' Mono 0 totalDuration*start sr 0
         for iClick to numberOfClicks
            click = click'iClick'
            sample = Get sample number from time... click*start
            Set value at sample number... sample 0.9
         endfor
         start+=differences
      endfor
   endfor
endproc

procedure createEditor
   demo Select inner viewport... 10 90  10 90
   startRow = 10
   startColumn = 10
   column = 90/rate
   row = 90/patterns

   for iRow to patterns
      for iColumn to rate
         demo Draw rectangle... startColumn startColumn+column startRow startRow+row
         startColumn+=column
      endfor
      startRow+=row
   endfor

endproc
