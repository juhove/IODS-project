# Assigment 4
# Data wrangling for the next week's data
# Juho Vehviläinen
# Date 23.11.2023

# 2.

# Import library for data download
library(readr)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# 3.

# hd data
# Data description
# Check the beginning of the data
head(hd) 
# Some more indepth information regarding the data (variable types)
spec(hd)
# Dimensions of the data as a vector
dim_hd <- dim(hd)
dim_hd

# 195x8 matrix

# Summary of the whole tibble, however
summary(hd)

# Missing data
# mean, sd, IQR, min/max values for appropriate variable types (numbers)
# number of categorical variables (leves_n) for charcter data
# Prints out the variable names as well. Data will be in two data frames: fisrt will have the information regarding the numeral value data and the second the variables that have character data.
ff_glimpse(hd)
# Some missing values in hd (HDI.Rank andGNI.per.Capita.Rank.Minus.HDI.Rank)

# ------------------------------------
# gii data
# Data description
# Check the beginning of the data
head(gii) 
# Some more indepth information regarding the data (variable types)
spec(gii)
# Dimensions of the data as a vector
dim_gii <- dim(gii)
dim_gii

#  matrix 195x10

# Summary of the whole tibble, however, below I use ff_glimpse
summary(gii)

# Missing data
# mean, sd, IQR, min/max values for appropriate variable types (numbers)
# number of categorical variables (leves_n) for charcter data
# Prints out the variable names as well. Data will be in two data frames: fisrt will have the information regarding the numeral value data and the second the variables that have character data.
ff_glimpse(gii)

# 4.

gii$`Maternal Mortality Ratio`
hd$`Gross National Income (GNI) per Capita`

# Renaming the gii and hd => new data objects
  
gii_new <- gii %>% rename("Parli.F" = "Percent Representation in Parliament",
                          "Edu2.F" = "Population with Secondary Education (Female)",
                          "Edu2.M" = "Population with Secondary Education (Male)",
                          "Labo.F" = "Labour Force Participation Rate (Female)", 
                          "Labo.M" = "Labour Force Participation Rate (Male)",
                          "Ado.Birth" = "Adolescent Birth Rate",
                          "Mat.Mor" = "Maternal Mortality Ratio",
                          )

hd_new <- hd %>% rename("Edu.Exp" = "Expected Years of Education",
                        "Life.Exp" = "Life Expectancy at Birth",
                        "GNI" = "Gross National Income (GNI) per Capita")

# New variable for ratio of female and male populations with secondary education in each country
gii_new$Edu2.FM = gii_new$Edu2.F / gii_new$Edu2.M


# # New variable for ratio of labor force participation of females and males in each country
gii_new$Labo.FM = gii_new$Labo.F / gii_new$Labo.M

# 6.


# Import library for inner_join
library(dplyr)

# Inner join two tables by Country
human <- inner_join(hd_new,gii_new,by="Country")

# Check dimensions
dim(human) # => 195x19 seems about right

# Write out csv file into data directory
write_csv(human,"data/human.csv")
