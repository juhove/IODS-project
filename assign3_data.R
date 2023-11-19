# Juho Vehviläinen
# Date 16 Nov 2023
# Date wrangling excercise for course IODS2023 University of Helsinki
# Data from http://www.archive.ics.uci.edu/dataset/320/student+performance


library(tidyverse)

library(readr)

# 3.
# They have named the files as .csv even though the file is not csv as the delimiter is semicolon

data_mat <- read_delim("data/student-mat.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
data_por <- read_delim("data/student-por.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)

# Mat
# Check the column data types
data_mat_column_types <- spec(data_mat)
View(data_mat_column_types)

# Dimensions of the data
data_mat_dim <- dim(data_mat)
View(data_mat_dim)

# Por
# Check the column data types
data_por_column_types <- spec(data_por)
View(data_kys_column_types)

# Dimensions of the data
data_por_dim <- dim(data_por)
View(data_por_dim)

# Mat and Por matrices have same number of columns 33 => a good thing


# 4.

# joining the data using all other variables except the ones specific to the mathematics and portuguese classes (failures, paid, absences, G1, G2, and G3)
data_join <- inner_join(data_mat, data_por, by = c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "guardian", "traveltime", "studytime", "schoolsup", "famsup", "activities", "nursery", "higher", "internet", "romantic", "famrel", "freetime", "goout", "Dalc", "Walc", "health"))

ff_glimpse(data_join)
# Created a joined table with 370 students and 39 variables that has combined all other variables expect the ones excluded earlier, these non-joined variables are included but are marked as x and y subscripts(?)


# 5.

# Didn't really get to where the instruction  "copy the solution from the exercise "3.3 The if-else structure" to combine the 'duplicated' answers in the joined data " pointed to and I was too lazy to write any own solution
# UPDATE: Now I did find the Excercise Set 3, oh well, I'll leave this as is.

# 6.

# Calculating mean of every row's Dalc and Walc values and storing it to alc_use variable
data_join_mod <- mutate(data_join, alc_use = rowMeans(select(data_join, c(Dalc,Walc)), na.rm = TRUE))

# New logical variable high_use that will be TRUE if alc_use is >2, otherwise FALSE
data_join_mod <- data_join_mod %>% mutate(high_use = ifelse(alc_use>2, "TRUE", "FALSE"))

# 7.

# glimpse of the data
ff_glimpse(data_join_mod)

# 370 observations, 41 variables, high_use have two levels, alc_use median 1.5, mean 1.9, min 1 max 5 makes sense
# Still includes some *.x and *.y variables, don't know if these were supposed to get rid of in item 5, however, they are not duplicates

# Write out a csv file
write_csv(data_join_mod, "data/assign3_data.csv")
