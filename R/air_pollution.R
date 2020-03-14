
# Calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors.
# The function 'pollutant_mean' takes two arguments:'pollutant', and 'id'. 
# Given a vector monitor ID numbers, 'pollutant_mean' reads that monitors' 
# particulate matter data from the directory and returns the mean of the pollutant across all of the monitors, 
# ignoring any missing values coded as NA.

pollutant_mean <- function(pollutant, id=1:332){
  
  if (pollutant == "sulfate" | pollutant == "nitrate") {
    pollutant_values <- c()
    for (monitor in id){
      data <- read.csv(file=paste(getwd(),"/data/air_pollution/",sprintf("%03d", monitor),".csv",sep=""))
      pollutant_data <- data[[pollutant]]
      pollutant_values <- append(pollutant_values, pollutant_data[!is.na(pollutant_data)])
    }
    mean(pollutant_values)      
  } else {
    "Given pollutant name is invalid it should either be 'sulfate' or 'nitrate'"
  }
  
}

# reads a directory with given file ids and reports the number of completely observed cases in each data file.

nobs_in_monitors <- function(id=1:332){
  
  # Get a list of dataframes for all csv files in the directory
  list.df <- lapply(id, function(monitor){read.csv(paste(getwd(),"/data/air_pollution/",sprintf("%03d", monitor),".csv",sep=""), 
                                                   header = TRUE)})
  
  # Get a list of complete rows for each dataframe in the list
  nobs <- lapply(list.df, function(x) sum(complete.cases(x)))
  
  # Create a dataframe with the filename, number of complete rows, and number of incomplete rows
  df <- data.frame(cbind(id, nobs), stringsAsFactors = FALSE)
  
  # Return the dataframe
  df
}


# takes a threshold for complete cases and calculates the correlation between sulfate 
# and nitrate for monitor locations where the number of completely observed cases (on all variables) 
# is greater than the threshold. The function returns a vector of correlations for the monitors 
# that meet the threshold requirement. If no monitors meet the threshold requirement, 
# then the function returns a numeric vector of length 0. 

correlation <- function(threshold = 0) {
  df <- nobs_in_monitors()
  files_nobs_grtr_than_thres <- df[df$nobs > threshold,][["id"]]
  if (length(files_nobs_grtr_than_thres) > 0){
    correlations <- c()
    for (monitor in files_nobs_grtr_than_thres){
      data <- read.csv(file=paste(getwd(),"/data/air_pollution/",sprintf("%03d", monitor),".csv",sep=""))
      sulfate_data <- data[["sulfate"]]
      nitrate_data <- data[["nitrate"]]
      correlations <- append(correlations, cor(sulfate_data, nitrate_data, use='complete.obs'))
    }
    correlations
  } else {
    c()
  }
}