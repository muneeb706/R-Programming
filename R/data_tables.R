
# data.table package
# data tables are much faster and efficient than data frames in terms of performance and memory
# this package is much faster at subsetting, grouping and updating

library(data.table)

DF = data.frame(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DF, 3)

DT = data.table(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DT, 3)

# see all the tables in memory
tables()

# subsetting rows
DT[2,]

# second and third rows
DT[c(2,3)]

# subset cols
DT[,c(2,3)]

# calculating values for variables with columns
# prints mean of column x and sum of column z
DT[, list(mean(x), sum(z))]

DT[, table(y)]

# Adding new columns
# it adds columns to same data table referenced in memory
# does not create copy
DT[,w:=z^2]

# adding column using multiple operations
# inside curly brackets you can write expressions
# last statement inside curly brackets gets assigned
DT[,m:={tmp <- (x+z); log2(tmp + 5)}]
DT[, a:=x>0]
# takes the mean of x + w columns according to value in the corresponding column a
# separates out the rows for calculating mean of x + w columns according to value in column a
# then sets the value in column b accordingly
# by parameters means group by
DT[, b:=mean(x+w), by=a]

# special variables for fast calculation
set.seed(123)
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
#.N counts the number of instances for each value in x
DT[,.N,by = x]

# data tables have keys
# values can be accessed much rapidly than data frame

DT <- data.table(x = rep(c("a", "b", "c"), each = 100), y=rnorm(300))
setkey(DT, x)
# prints all the rows with value a in x
DT['a']

# joining tables with keys
DT1 <- data.table(x=c('a', 'a', 'b', 'dt1'), y=1:4)
DT2 <- data.table(x=c('a', 'b', 'dt2'), z=5:7)
setkey(DT1, x)
setkey(DT2, x)
merge(DT1, DT2)

# fast reading from large data tables
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names = FALSE, col.names = TRUE, sep = "\t", quote = FALSE)

# faster
system.time(fread(file))
# slower
system.time(read.table(file, header=TRUE, sep="\t"))
