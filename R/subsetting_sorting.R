set.seed(13435)
X <- data.frame("var1"=sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15))
# shuffling rows
X <- X[sample(1:5), ]
X$var2[c(1,3)] = NA
X
# first column of all rows
X[,1]
X[,"var1"]
# second column of first two rows
X[1:2, "var2"]

# subsetting using logical ands and ors

# get all the rows with given condition
X[(X$var1 <= 3 & X$var3 > 11), ]
X[(X$var1 <= 3 | X$var3 > 15), ]

# dealing with missing values
# you can not avoid NA with simple condition
# you have to use which function
X[which(X$var2 > 8),]

# sorting
sort(X$var1)
sort(X$var1, decreasing = TRUE)
# put NA in last
sort(X$var2, na.last = TRUE)

# order by variable
X[order(X$var1),]
# in case of similar values it will order by var3
X[order(X$var1, X$var3),]

# ordering with plyr command
library(plyr)
arrange(X, var1)
arrange(X, desc(var1))

# adding rows and columns
X$var4 <- rnorm(5)
X

# column binding existing columns of X in Y and adds specified column to Y
Y <- cbind(X, rnorm(5))
Y

# for row binding
Y <- rbind(Y, rnorm(5))
Y
