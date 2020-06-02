if (!"RMySQL" %in% rownames(installed.packages())) {
    install.packages("RMySQL")
}

library(RMySQL)


listGenomeDatabases <- function(){
    
    ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
    databases <- dbGetQuery(ucscDb, "show databases;")
    dbDisconnect(ucscDb)
    databases
    
}

listGenomeDatabases()

hg19Tables <- function(){
    
    hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
    allTables <- dbListTables(hg19)
    totalTables <- length(allTables)
    # get first five tables
    allTables[1:5]
    
    # list fields in the given table
    affyFields <- dbListFields(hg19, "affyU133Plus2")
    
    # get total number of records in the given table
    affyTotalRecords <- dbGetQuery(hg19, "select count(*) from affyU133Plus2")
    
    # read data from given table
    affyData <- dbReadTable(hg19, "affyU133Plus2")
    
    # read subset of data with filter condition
    # send query method just sends the query to the database it does not gets the result
    query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
    # gets the result back from the database
    affMis<- fetch(query)
    # to get only subset of the results from the query
    affyMisSmall <- fetch(query, n = 10)
    # clear the query, removes the query from the server that was sent by send query method
    dbClearResult(query)
    
    affyMisMatches <- quantile(affMis$misMatches)
    
    dbDisconnect(hg19)
    
    dim(affyMisSmall)
    
}

hg19Tables()
