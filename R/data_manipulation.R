# data manipulation is different from data transformation in a sense that it is more concerned with modification
# of data values while tranformation is concerned with changing overall structure or schema of the dataset.

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

if (!file.exists("./data/cameras.csv")) {
    download.file(fileUrl, destfile = "./data/cameras.csv", method = "curl")
    dateDownloadedCSV <- date()
}
cameraData <- read.csv("./data/cameras.csv")
names(cameraData)
# converting to lowercase letters
tolower(names(cameraData))

# separating values
# separting values by '.'
# slashes \\ are used because '.' is a reserved character
splitNames = strsplit(names(cameraData), "\\.")
splitNames[[5]]
splitNames[[6]]

# creating list of data structures
mylist <- list(letters = c("A", "b", "c"), numbers = 1:3, matrix(1:25, ncol=5))
head(mylist)
mylist[1]
mylist$letters

# applying a function to each element in a vecotr or a list
# get first element of every elemnent in a list
firstElement <- function(x){x[1]}
sapply(splitNames, firstElement)

# peer reviews datasets
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

# substituting characters
# it will substitute only first occurrences
sub("\\.", "", names(reviews))

# for substituting multiple occurrences
testName <- "this_is_a_test"
gsub("_", "", testName)

# finding values
# returns indices where given string is found
grep("Alameda", cameraData$intersection)
# counts number of entries where given word is found and not found aswell
table(grepl("Alameda", cameraData$intersection))

# get all the entries where given word is not found in the given column
cameraData2 <- cameraData[!grepl("Alameda", cameraData$intersection), ]

# setting value = true in grep will return values instead of indices
grep("Alameda", cameraData$intersection, value=TRUE)
# for values that dont exist in any of the entry 0 will be returned
grep("JeffStreet", cameraData$intersection)
length(grep("JeffStreet", cameraData$intersection))

# useful string functions
library(stringr)
nchar("Muneeb Shahid")

substr("Muneeb Shahid", 1, 7)
# merge two stirngs teogether with space as a spearator
paste("Muneeb", "Shahid")
# with no space
paste0("Muneeb", "Shahid")
# trim leading and trailing spaces
str_trim("Muneeb    ")

# Regular Expressions for grep function
# metacharacters are used to find substring with condition
# '^' is used to find following substring / word that comes in a start of a given string e-g ^I think
# '$'is used to find following substring / word that comes at the end of a given string e-g morning$

# to find a word with different variations of letters (lower and upper case)
# following will look for all variations of word bush e-g bUsh Bush
# [Bb][Uu][Ss][Hh]

# metacharacter can be combined
#^[Ii] am

# to specify range of letters
# [a-z] all lowercase letters
# [a-zA-Z] both lower and uppercase letters
#^[0-9][a-zA-Z] starts with digit followed by anycase letter

#[^?.]$ will select strings that does not end with ? or.

# metcharacter '.' means any character
# 9.11 will look for strings that contains 9 and 11 with any character between them.

# or metacharacter is '|'
# e-g flood|fire find strings with flood or fire word
# ^[Gg]ood|[Bb]ad starting with Good/good or has Bad/bad anywhere
# ^([Gg]ood|[Bb]ad) starting with Good/good or Bad/bad

# '?' metacharacter indicates optional expression (comese before question mark enclosed in circle brackets)
# in the following expression . has been escaped to tell that it is not a metcharacter
# [Gg]eorge ( [Ww]\.)? [Bb]ush

# '*' and '+' metacharacters are used for repitition, * means any number of times including none,
# and '+' means atleast one of the item
# e-g [0-9]+ (.*) [0-9]+ 

# { and } are for specifying minimum and maximum number of matches of an expression.
# {m,n} means at least m but not more than n matches
# {m} means exactly m matches
# {m,} means at least m matches
# following regex specifies there should be atleast one word and not more than 5 words between Bush/bush and debate
# [Bb]ush( +[^ ]+ +){1,5} debate
# [^ ] means not space
# '\1','\2' etc is for showing which regular expression in a group to imitate
# +([a-zA-z]+) +\1 +, there is only one regular expression enclosed in circle bracket so \1 will imitate that one.



