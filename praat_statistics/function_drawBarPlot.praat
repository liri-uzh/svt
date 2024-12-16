form Bar plot...
	word factor famCond
	word dependent aPrime
	real min 0
	real max 0
	choice whiskers 1
		button none
		button sd
		button se
	boolean Garnish 1
	boolean Plot_N 1
	boolean Edit_sequence 0
endform

table = selected("Table")

# analyze factor 

	select table
	coll = Collapse rows: "'factor$'", "", "", "", "", ""
	Set column label (index)... 1 factor
	Save as tab-separated file... temp.txt
	strings = Read Strings from raw text file... temp.txt

	if edit_sequence
		Edit
		nocheck pause Edit sequence - if required - and continue
	endif

	Save as raw text file... temp.txt
	factor = Read Table from tab-separated file... temp.txt
	Rename... factor
	filedelete temp.txt
	select coll
	plus strings
	Remove
	
# Get data for each factor level:

	select factor
	nLevels = Get number of rows
	for i to nLevels
	
		select factor
		level$ = Get value... i factor
		
		select table
		temp = Extract rows where column (text)... 'factor$' "is equal to" 'level$'

		# calculate variables:
		n = Get number of rows
		mean = Get mean... 'dependent$'
		sd = Get standard deviation... 'dependent$'
		se = sd/sqrt(n)
		
		# save variables for printing
		n[i]=n
		level$[i] = level$
		mean[i] = mean
		sd[i] = sd
		se[i] = se

		# clean up:
		select temp
		Remove

	endfor

# Get highest and lowest value of dependent:

	if min=0 and max=0
		select table
		min = Get minimum... 'dependent$'
		max = Get maximum... 'dependent$'
	endif

# Plot data: 

	Axes... 0.3 nLevels+0.7 min max

	for i to nLevels
		
		n=n[i]
		label$ = level$[i]
		mean = mean[i]
		sd = sd[i]
		se = se[i]

		Paint rectangle... 0.8 i-0.3 i+0.3 min mean 

		if garnish
			One mark bottom... i 0 1 0 'label$'
		endif

		if plot_N
			Text... i Centre min Bottom N='n'
		endif

		if whiskers=2
			Draw line... i mean+sd i mean-sd
			Draw line... i-0.1 mean+sd i+0.1 mean+sd
			Draw line... i-0.1 mean-sd i+0.1 mean-sd
		elsif whiskers=3
			Draw line... i mean+se i mean-se
			Draw line... i-0.1 mean+se i+0.1 mean+se
			Draw line... i-0.1 mean-se i+0.1 mean-se
		endif

	endfor

	if garnish
		Draw inner box
	endif

# clean up: 
select factor
Remove
	
# leave table selected: 
select table

