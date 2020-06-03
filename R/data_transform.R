fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"

if (!file.exists("./data/restaurants.csv")) {
    download.file(fileUrl, destfile = "./data/restaurants.csv", method = "curl")
}

restData <- read.csv("./data/restaurants.csv")

# creating sequences
# they are used for indexing datasets

# values ranging from 1 to 10 with difference 2
s1 <- seq(1,10, by=2)
s1

# 3 values ranging from 1 to 10
s2 <- seq(1,10, length=3)
s2

x <- c(1,3,8,25,100)
# returns consecutive indices in x
seq(along = x)

# subsetting variable
# return true for the rows where neighborhood is in the given list
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)

# creating binary variables
restData$zipWrong = ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode < 0)

# creating categorical variables
# cut, breaks the data according to given condition
restData$zipGroups = cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups, restData$zipCode)

# easier cutting with Hmisc library
# cutting produces factor variable
library(Hmisc)
# g is for number of groups
restData$zipGroups = cut2(restData$zipCode, g=4)
table(restData$zipGroups)

# creating factor variable
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)

# levels of factor variable
yesno <- sample(c("yes", "no"), size=10, replace=TRUE)
yesnofac = factor(yesno, levels=c("yes", "no"))
relevel(yesnofac, ref="yes")
# changes factor into numeric variables
as.numeric(yesnofc)

library(plyr)
# using mutate function for creating new version of the variable and add variable in new version
restData2 = mutate(restData, zipGroupsNew=cut2(zipCode,g=4))
table(restData2$zipGroupsNew)

# common transformation functions

# abs(x) //absolute values
# sqrt(x) // square root
# ceiling(x)
# floor (x)
# round(x, digits=n) // round(3.475,digits = 2) is 3.48
# signif(x, digits=n) // round(3.475,digits = 2) is 3.5
# cos(x), sin(x) etc
# log(x)
# log2(x), log10(x) etc
# exp(x)

# reshaping data

library(reshape)
head(mtcars)

mtcars$carname <- rownames(mtcars)
# dividing variables into groups (id, measures)
# it will melt the measure variables into one dimension hence reducing width of data set
carMelt <- melt(mtcars, id.vars=c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))
head(carMelt, n = 3)
tail(carMelt, n = 3)

# casting dataset
# it summarizes the dataset with given variables
# following example will tell how many instances of each distinct value in variable column are there for each
# distinct value of cylinder
cylData <- cast(carMelt, cyl ~ variable)
cylData

# following example will tell mean of distinct values in variable column for each
# distinct value of cylinder
cylData <- cast(carMelt, cyl ~ variable, mean)
cylData

head(InsectSprays)
# aggregating values against each distinct value of given column
# following example will sum the count values for each distinct value in spray column
tapply(InsectSprays$count, InsectSprays$spray, sum)

# following splits the dataset according to distinct values in spray column
spIns = split(InsectSprays$count, InsectSprays$spray)
spIns

# aggregating results for each distinct value in variable
sprCount = lapply(spIns, sum)
sprCount

# following are the methods to combine all the values in lists in one list (1D)
unlist(sprCount)
sapply(spIns, sum)

# group the values according to spray column and apply sum aggregate to count variable 
ddply(InsectSprays, .(spray), summarise,sum=sum(count))

# to keep the size of the dataset same after grouping and aggregating
spraySums <- ddply(InsectSprays, .(spray), summarise,sum=ave(count, FUN=sum))
dim(spraySums)
head(spraySums)


# use dplyr package for data.frames as
# it is an optimized(faster and readable) version of plyr package
# this is specific to data frames

library(dplyr)
chicago <- readRDS("./data/chicago.rds")
dim(chicago)
str(chicago)
names(chicago)
# select all columns between city and dptp columns 
head(select(chicago, city:dptp))
# select all columns that are not in between city and dptp columns
head(select(chicago, -(city:dptp)))

# above functionality in regular r
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[,-(i:j)])

# filter
chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f, 10)
chic.f <- filter(chicago, (pm25tmean2 > 30 & tmpd > 80))
head(chic.f)

# order rows of the dataframe according to given column
chicago <- arrange(chicago, date)
head(chicago)
tail(chicago)
chicago <- arrange(chicago, desc(date))
head(chicago)
tail(chicago)

# renaming variables
chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
head(chicago)

# adding variables based on existing variables
chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(select(chicago, pm25, pm25detrend))

chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c("cold", "hot")))
hotcold <- group_by(chicago, tempcat)
hotcold
# summarise based on given criterias
summarise(hotcold, pm25 = mean(pm25, na.rm=TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago, year)
summarise(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# perform series of operations in existing dataset
# with the help of pipeline operator (%>%)
# when you use pipeline operator you do not need to supply data frame for each function in pipeline
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% 
    summarise(pm25 = mean(pm25, na.rm=TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# merging data of related datasets
# similar to join in SQL
fileUrl1 <- "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/reviews.csv"
fileUrl2 <- "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/solutions.csv"

if (!file.exists("./data/reviews.csv")) {
    download.file(fileUrl1, destfile = "./data/reviews.csv", method = "curl")
}

if (!file.exists("./data/solutions.csv")) {
    download.file(fileUrl2, destfile = "./data/solutions.csv", method = "curl")
}

reviews = read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews, 2)
head(solutions, 2)

names(reviews)
names(solutions)

mergedData <- merge(reviews, solutions, by.x="solution_id", by.y="id", all=TRUE)
head(mergedData)

# default - merge all common column names

intersect(names(solutions), names(reviews))
mergedData2 = merge(reviews, solutions, all = TRUE)
head(mergedData2)

# using join in the plyr package
# bit faster than merge
df1 = data.frame(id=sample(1:10), x=rnorm(10))
df2 = data.frame(id=sample(1:10), y=rnorm(10))
df3 = data.frame(id=sample(1:10), z=rnorm(10))
dfList = list(df1, df2, df3)
# joins on the basis of common columns in this example we have id as common colum
join_all(dfList)

