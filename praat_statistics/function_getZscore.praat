form Turn to zScore...
	word Group speaker
	word Variable fo
endform

table = selected("Table")

# Append z column to table: 
select table
nocheck Remove column: variable$+"_z"
Append column: variable$+"_z"

# Get a table with the values for the different groups:
group = Collapse rows: group$, "", "", "", "", ""
nGroup = Get number of rows

# Loop through groups: 
for iGroup to nGroup

	# Get string value for iGroup:
	iGroup$ = object$[group,iGroup,1]

	# Get group mean and sd:
	select table
	Extract rows where: ~self$["'group$'"]=iGroup$ and self["'variable$'"]<>undefined
	m = Get mean: variable$
	sd = Get standard deviation: variable$
	Remove

	# Apply z to column:
	select table
	Formula: variable$+"_z", ~if self$["'group$'"]=iGroup$ then (self["'variable$'"]-m)/sd else self fi

endfor

removeObject: group