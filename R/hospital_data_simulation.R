# Plots the 30-day mortality rates for heart attack
plot_mortality_rate <- function() {
    outcome <- read.csv(paste(getwd(),"/data/hospital/outcome-of-care-measures.csv",sep=""), colClasses = "character")
    ## death rate column
    outcome[,11] <- as.numeric(outcome[,11])
    hist(outcome[,11])
}


# Finds the best hospital based on given outcome in a given state
find_best_hospital <- function(state_abb, outcome_name) {
    ## Read outcome data
    
    outcome <- read.csv(paste(getwd(),"/data/hospital/outcome-of-care-measures.csv",sep=""), colClasses = "character")
    
    possible_outcomes = c("heart attack", "heart failure", "pneumonia")
    states <- unique(outcome[,7])
    
    ## Check that state and outcome are valid
    
    if (state_abb %in% states && outcome_name %in% possible_outcomes) {
        outcome_col_number = 0
        if (outcome_name == "heart attack") {
            outcome_col_number = 11
        } else if (outcome_name == "heart failure") {
            outcome_col_number = 17
        } else if (outcome_name == "pneumonia") {
            outcome_col_number = 23
        }
        state_data <- subset(outcome, State == state_abb)
        min_outcome <- min(as.numeric(state_data[,outcome_col_number]), na.rm = TRUE)
        sort(state_data$Hospital.Name[state_data[,outcome_col_number] == toString(min_outcome)])[1]
        
    } else if (state_abb %in% states == FALSE){
        stop("invalid state")   
    } else if (outcome_name %in% possible_outcomes == FALSE) {
        stop("invalid outcome")   
    }
    
}


# Ranks hospitals by outcome in a state
find_hospital_with_rank <- function(state_abb, outcome_name, rank="best") {
    
    ## Read outcome data
    
    outcome <- read.csv(paste(getwd(),"/data/hospital/outcome-of-care-measures.csv",sep=""), colClasses = "character")
    
    possible_outcomes = c("heart attack", "heart failure", "pneumonia")
    states <- unique(outcome[,7])
    
    ## Check that state and outcome are valid
    
    if (state_abb %in% states && outcome_name %in% possible_outcomes) {
        outcome_col_number = 0
        if (outcome_name == "heart attack") {
            outcome_col_number = 11
        } else if (outcome_name == "heart failure") {
            outcome_col_number = 17
        } else if (outcome_name == "pneumonia") {
            outcome_col_number = 23
        }
      
        state_data <- subset(outcome, State == state_abb)
        state_data[,outcome_col_number] <- as.numeric(state_data[,outcome_col_number])
        ordered_state_data <- state_data[order(state_data[, outcome_col_number], state_data$Hospital.Name),]

        rank_no = 0
        if (rank == "best") {
            rank_no = 1
        } else if (rank == "worst") {
            rank_no = length(ordered_state_data[,outcome_col_number][!is.na(ordered_state_data[,outcome_col_number])])
        } else {
            # should be integer
            rank_no = rank
        }

        
        rank_outcome <- ordered_state_data[rank_no,]
        rank_outcome$Hospital.Name
        
    } else if (state_abb %in% states == FALSE){
        stop("invalid state")   
    } else if (outcome_name %in% possible_outcomes == FALSE) {
        stop("invalid outcome")   
    }
}

# Ranks hospitals by outcome for each state
find_hospital_with_rank_in_all_states <- function(outcome_name, rank="best") {
    
    ## Read outcome data
    
    outcome <- read.csv(paste(getwd(),"/data/hospital/outcome-of-care-measures.csv",sep=""), colClasses = "character")
    
    possible_outcomes = c("heart attack", "heart failure", "pneumonia")
    
    ## Check outcome is valid
    
    if (outcome_name %in% possible_outcomes) {
        outcome_col_number = 0
        if (outcome_name == "heart attack") {
            outcome_col_number = 11
        } else if (outcome_name == "heart failure") {
            outcome_col_number = 17
        } else if (outcome_name == "pneumonia") {
            outcome_col_number = 23
        }
        
        state <- sort(unique(outcome[,7]))
        
        state_no = 1
        hospital <- c()
        for (state_abb in state) {
            state_data <- subset(outcome, State == state_abb)
            state_data[,outcome_col_number] <- as.numeric(state_data[,outcome_col_number])
            ordered_state_data <- state_data[order(state_data[, outcome_col_number], state_data$Hospital.Name),]
            
            rank_no = 0
            if (rank == "best") {
                rank_no = 1
            } else if (rank == "worst") {
                rank_no = length(ordered_state_data[,outcome_col_number][!is.na(ordered_state_data[,outcome_col_number])])
            } else {
                # should be integer
                rank_no = rank
            }
            
            
            rank_outcome <- ordered_state_data[rank_no,]
            hospital[state_no] = rank_outcome$Hospital.Name
            
            state_no = state_no + 1
        }
        
        data.frame(hospital,state)
        
    } else if (outcome_name %in% possible_outcomes == FALSE) {
        stop("invalid outcome")   
    }
    
}