fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"

if (!file.exists("./data/restaurants.csv")) {
    download.file(fileUrl, destfile = "./data/restaurants.csv", method = "curl")
}

restData <- read.csv("./data/restaurants.csv")
# top 3 rows
# default is top 6 rows
head(restData, n=3)
#bottom 3
tail(restData, n = 3)
# gives information regarding every variable in the dataset
summary(restData)
# for more in depth information
str(restData)

quantile(restData$councilDistrict, na.rm=TRUE)
# quantile with given probabilities
quantile(restData$councilDistrict, probs=c(0.5,0.75,0.9))

# make table
# table will tell frequency of all the distinct values in the variable
# useNa if any means it will add extra column to tell number of missing values
table(restData$zipCode, useNA = "ifany")

# 2D table
table(restData$councilDistrict, restData$zipCode)

# check for missing values
# is.na returns boolean for every index that has NA value
# sum == 0 means there are no missing values
sum(is.na(restData$councilDistrict))
# returns boolean
any(is.na(restData$councilDistrict))
# returns boolean
# checks if all the zipCodes are greater than 0
all(restData$zipCode > 0)

# row and columns sums

# returns total no. of NAs for every column
colSums(is.na(restData))
# checks if all the columns have NA or not
all(colSums(is.na(restData))==0)

# values with specific characteristics
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212", "21213"))
restData[restData$zipCode %in% c("21212", "21213"),]

# cross tabs
# are used to identify relationships in the dataset
# loading data from R data repo
data("UCBAdmissions")
DF = as.data.frame(UCBAdmissions)
summary(DF)

# variable before ~ is a variable whose values that you want to display in the table
# variables after ~ are those according to which you want group the data
# in the following example
# result will contain values for frequency for each distinct value in gender and admit column.
xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt

# flat tables
# adding variable in existing warpbreaks dataset
warpbreaks$replicate <- rep(1:9, len=54)
# . after ~ means include all variables in the dataset
xt = xtabs(breaks ~., data=warpbreaks)
xt
# above results will be difficult to visualize
# to visualize such data we can use flat tables
ftable(xt)

# size of dataset
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units="Mb")
