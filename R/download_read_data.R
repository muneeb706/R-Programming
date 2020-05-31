# download and read csv files

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

if (!file.exists("./data/cameras.csv")) {
    download.file(fileUrl, destfile = "./data/cameras.csv", method = "curl")
    dateDownloadedCSV <- date()
}

list.files("./data")

# reading flat files

# read.table reads data into RAM
# this function might not be suitable for large datasets

cameraData <- read.table('./data/cameras.csv', sep = ",", header = TRUE)
#head(cameraData)

# or 

cameraData <- read.csv('./data/cameras.csv')
#head(cameraData)

# download and read xlsx file

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

if (!file.exists("./data/ngap.xlsx")) {
    download.file(fileUrl, destfile = "./data/ngap.xlsx", mode = "wb")
    dateDownloadedXLSX <- date()
}

list.files("./data")

if (!"openxlsx" %in% rownames(installed.packages())) {
    install.packages("openxlsx")
}

library('openxlsx')

ngapData <- readWorkbook('./data/ngap.xlsx')
head(ngapData)

ngapDataSubset <- readWorkbook('./data/ngap.xlsx', rows = c(1, 3, 5), cols = 1:3)
head(ngapDataSubset)

## read xml file

if (!"XML" %in% rownames(installed.packages())) {
    install.packages("XML")
}

## RCurl for https
library("RCurl")
library(XML)

xmlFileUrl <- "https://www.w3schools.com/xml/simple.xml"
data.unparsed <- getURL(xmlFileUrl)
doc <- xmlTreeParse(data.unparsed, useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)

# names of nodes inside root nodes
names(rootNode)

# accessing nested components of root nodes
rootNode[[1]]
rootNode[[1]][[1]]

# extracts parts of the xml document
# following extracts all of the xml values inside root node recursively
xmlSApply(rootNode, xmlValue)

# Gets the items with given tag
xpathSApply(rootNode, "//name", xmlValue)
xpathSApply(rootNode, "//price", xmlValue)

# parsing xml from html file

htmlFileUrl <- "https://www.espn.com/nfl/team/_/name/bal/baltimore-ravens"
data.unparsed <- getURL(htmlFileUrl)
doc <- htmlTreeParse(data.unparsed, useInternalNodes = TRUE)
teams <- xpathSApply(doc, "//div[@class='game-info']", xmlValue)
teams


# reading JSON files

library(jsonlite)
jsonData <- fromJSON('https://api.github.com/users/jtleek/repos')
names(jsonData)
jsonData$owner$login

# writing dataframes to Json
# iris dataset already exists in rstudio

myjson <- toJSON(iris, pretty = TRUE)
cat(myjson)
iris2 <- fromJSON(myjson)
head(iris2)