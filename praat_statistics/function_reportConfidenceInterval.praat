### START SCRIPT ###
#
# function_reportConfidenceInterval
#
# Praat Script for Praat software (www.praat.org)
# Written by Volker Dellwo (volker.dellwo@uzh.ch)
#
# DESCRIPTION:
# This function returns the confidence interval of a data column in a Table
# based on the t-distribution (i.e. when the population mean is unknown). 
# The table includes:
# 	N: number of observations
# 	df: degrees of freedom (N-1)
# 	m: sample mean
#	sd: sample standard deviation 
#	CI: absolute confidence interval 
#	lowerLimit: m-CI
#	upperLimit: m+CI  
# 
# INPUT: Table containing a column with numeric data (variable). Specific variable can be chosen. 
# OUTPUT: New Table containing the above values
# REQUIREMENTS: The Table containing the variable to be analysed must be selected. 
#
# METHOD: 
# CI is calculated by the formula: ci = |t*(sd/sqrt(N))|
#
# HISTORY:  
# 10.11.2023: created (in a Hotel in Chiang Mai)
#
# LICENSE: 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation (see <http://www.gnu.org/licenses/>). This 
# program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY.
#

form Get CI...
	word Variable f1
	real Range_in_percent 95
endform

# define some variables to start with: 

	t_in = selected("Table")
	v$ = variable$
	r = range_in_percent

# Calculate mean and deviations for subset:
	# n: number of observations
	# df: degrees of freedom (n-1)
	# q: quantile to obtain t (e.g.: 0.025 or 0.975 for 95% CI) 
	# t: t-value for 95%CI with N-1 df (here: df=19)
	# m: sample mean
	# sd: sample standard deviation

	selectObject: t_in
	n = object[t_in].nrow
	df = n-1
	q = (1-r/100)/2
	t = invStudentQ(q, df)
	m = Get mean: v$
	sd = Get standard deviation: v$
	ci = t*(sd/sqrt(n))

# Create output table and fill in results: 
	
	t_out = Create Table with column names: "CI"+string$(r), 1, 
		..."N df mean sd CI lowerLimit upperLimit"
	Set numeric value: 1, "N", object[t_in].nrow
	Set numeric value: 1, "df", df
	Set numeric value: 1, "mean", m
	Set numeric value: 1, "sd", sd
	Set numeric value: 1, "CI", ci
	Set numeric value: 1, "lowerLimit", m-ci
	Set numeric value: 1, "upperLimit", m+ci

### END SCRIPT ###
