# before scraping always read whether it is legal to scrap the data from the desired website

con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

library("RCurl")
library(XML)

url <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
data.unparsed <- getURL(url)
html <- htmlTreeParse(data.unparsed, useInternalNodes = T)
xpathSApply(html, "//title", xmlValue)
citations <- xpathSApply(html, "//td[@class='gsc_a_c']", xmlValue)
citations

# with httr package

library(httr)
html2 = GET(url)
content2 = content(html2, as="text")
parsedHtml = htmlParse(content2, asText = TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)


# accessing websites with passwords (httr pacakge cont)
pg1 = GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user", "passwd"))
pg1

# with handles 
# use of handles will save authentication for multiple pages within websites
# cookies stays with the handle
google = handle("http://google.com")
pg1 = GET(handle=google, path="/")
pg2 = GET(handle=google, path="search")
