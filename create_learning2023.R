# Juho Vehviläinen
# Date 3 Nov 2023
# Input and output of data JYTOPKYS3-data.txt

library(tidyverse)

library(readr)
data_kys <- read_delim("data/JYTOPKYS3-data.txt", 
                             delim = "\t", escape_double = FALSE, 
                             trim_ws = TRUE)
View(data_kys)

# Check the column data types
data_kys_column_types <- spec(data_kys)
View(data_kys_column_types)

# Dimensions of the data
data_kys_dim <- dim(data_kys)
View(data_kys_dim)


# Creating an analyze data set with the variables above


data_attitude <- data_kys 

library(dplyr)

# Creating Deep that is mean of d_sm, d_ri, d_ue
data_analysis <- data_kys %>% rowwise() %>% mutate(d_sm = mean(c_across(c('D03','D11','D19','D27'))))
data_analysis <- data_analysis %>% rowwise() %>% mutate(d_ri = mean(c_across(c('D07','D14','D22','D30'))))
data_analysis <- data_analysis %>% rowwise() %>% mutate(d_ue = mean(c_across(c('D06','D15','D23','D31'))))
data_analysis <- data_analysis %>% rowwise() %>% mutate(Deep = mean(c_across(c('d_sm','d_ri','d_ue'))))

# Creating Surf that is mean of su_lp, su_um, su_sb
data_analysis <- data_analysis %>% rowwise() %>% mutate(su_lp = mean(c_across(c('SU02','SU10','SU18','SU26'))))
data_analysis <- data_analysis %>% rowwise() %>% mutate(su_um = mean(c_across(c('SU05','SU13','SU21','SU29'))))
data_analysis <- data_analysis %>% rowwise() %>% mutate(su_sb = mean(c_across(c('SU08','SU16','SU24','SU32'))))
data_analysis <- data_analysis %>% rowwise() %>% mutate(Surf = mean(c_across(c('su_lp','su_um','su_sb'))))

# Creating Stra that is mean of st_os, st_tm
data_analysis <- data_analysis %>% rowwise() %>% mutate(st_os = mean(c_across(c('ST01','ST09','ST17','ST25'))))
data_analysis <- data_analysis %>% rowwise() %>% mutate(st_tm = mean(c_across(c('ST04','ST12','ST20','ST28'))))
data_analysis <- data_analysis %>% rowwise() %>% mutate(Stra = mean(c_across(c('st_os','st_tm'))))

# Attitude seems not to be a mean. Converting to mean
data_analysis$Attitude <- data_analysis$Attitude/10

# Create a output table with Gender, Age, Attitude, Deep, Stra, Surf, Points
# Include only obs that have Points > 0
data_output <- data_analysis %>% select(gender, Age, Attitude, Deep, Stra, Surf, Points) %>% filter(Points > 0)

# Write data to CSV
write_csv(data_output, "learning2014.csv")

# Read data back
data_read_again <- read_csv("learning2014.csv")

# Check the beginning of the data
head(data_read_again)
str(data_read_again)
