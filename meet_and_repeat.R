# Juho Vehviläinen
# Date 1 Dec 2023
# Assignment 6 data wrangling exercise 


# 1.

# Load libraries and data 

library(tidyverse)
library(dplyr)
library(readr)
bprs <- read_delim("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", 
                       delim = " ", escape_double = FALSE, 
                       trim_ws = TRUE)

names(bprs)

# Summaries of the variables
summary(bprs)

# Variable types
str(bprs)
# => real numbers

# For some reason the ID column is doubled in the data (14 variables, 13 headers)
# Reading the file
rats <- read.delim("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", 
                   sep = "\t", header = FALSE)
# Remove first column (doubled one)
rats <- rats[,-1]

# Remove headers
rats <- rats[-1,]

# Make all values as numeric
rats <- sapply(rats,as.numeric)
rats <- as.data.frame(rats)

# Read the column names from the file
rats_header <- read_delim("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", 
                   delim = "\t", col_names = FALSE)

# Read just the first line
rats_header <- head(rats_header, 1)

# Assign the column names
colnames(rats) <- c(rats_header[1,])

# Now rats should be correct
summary(bprs)
summary(rats)
# Summary from the wide form data shows us summaries of all rats on a designated point in time.
# What we'd want is probably how one of the rats change when time goes by (longitudinal data)
# Same applies to bprs = brief psychiatric rating scale


glimpse(rats)
# Looks like it

# Write data out 

write_csv(bprs, "data/bprs.csv")
write_csv(rats, "data/rats.csv")



# 2. Factor data convertation

# BPRS
# treatment and subject into factors
bprs$treatment <- as.factor(bprs$treatment)
bprs$subject <- as.factor(bprs$subject)
glimpse(bprs)
# First two columns as factors, rest as real numbers

# RATS
# ID and group into factors
rats$ID <- as.factor(rats$ID)
rats$Group <- as.factor(rats$Group)
glimpse(rats)
# First two columns as factors, rest as real numbers

# 3. Converting to long form

bprs_long <- pivot_longer(bprs, cols = -c(treatment, subject), names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks)

# Extract the week number to its own column
# String exctract from 5th charter to the end of the string
bprs_long <- bprs_long %>% mutate(week = as.integer(substr(weeks, 5, nchar(weeks))))

glimpse(bprs_long) # looks as it should

# Same for rats, names  (WD*) to time column

rats_long <- pivot_longer(rats, cols = -c(ID, Group), names_to = "time", values_to = "rats") 

rats_long <- rats_long %>% mutate(time = as.integer(substr(time, 3, nchar(time)))) %>% arrange(time)

write_csv(bprs_long, "data/bprs_long.csv")
write_csv(rats_long, "data/rats_long.csv")

# 4. Look at the data

# Names
names(bprs)
names(bprs_long)
summary(bprs) # Summary of bprs values on that week as weeks are each their own variable
summary(bprs_long) # Summary of all bprs values over all times

str(bprs_long) # Factor variables as constructed earlier, brps as real number, weeks as integers

names(rats)
names(rats_long)
summary(rats)
summary(rats_long)

str(rats_long) # Factor variables as constructed earlier, rats as real number, time as integer


# bprs and rats are missing the time variable as numeric, it would be hard to do time series
# bprs_long and rats_long do have time as numeric variable