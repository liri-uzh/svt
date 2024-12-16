form Plot regression line...
	word x vsRatio
	word y syllableChosen
	real from_x 0.5
	real to_x 1.1
	sentence formula self$["listenerLg"]="sw"
endform

table = selected("Table")
reduced = Extract rows where... 'formula$'

n = Get number of rows

sumX = 0
sumY = 0
sumXY = 0
sumXsq = 0
for i to n

	x = Get value... i 'x$'
	y = Get value... i 'y$'
	sumX+=x
	sumY+=y
	sumXY+=(x*y)
	sumXsq+=(x^2)

endfor


# Calculate regression coefficients: 
# y = m*x+b
# m = slope
# b = y-intercept

b = (sumY*sumXsq-sumX*sumXY)/(n*sumXsq-sumX^2)
m = (n*sumXY-sumX*sumY)/(n*sumXsq-sumX^2)

from_y = b+m*from_x
to_y = b+m*to_x

Draw line... from_x from_y to_x to_y

# Reconstruct original list of objects:
select reduced
Remove
select table

