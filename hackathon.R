library(foreign)
library(tidyverse)
library(mltools)
library(data.table)

data <- read.spss("C:/Users/Allen/Desktop/MSiA/hackathon/materials for public release/2017 Pew Research Center STEM survey.sav", to.data.frame=TRUE)

unique(data$EMPLOYED)

data_raw = data %>%
    select(PPGENDER, RACE_col, ppagecat, HH_INCOME_col,PPHHHEAD, PPREG4, EDUC4CAT, STEM_DEGREE, EMPLOYED,INDUSTRY_col, GENDJOB1)

colnames(data_raw) = c('Gender', 'Race', 'Age', 'Income','Household_info', 'Location','Education','STEM','Employment','Industry','Response')


data_raw$Gender = recode(data_raw$Gender, 'Male' = 0, 'Female' = 1)


data_raw = one_hot(as.data.table(data_raw), cols = c('Race', 'Location'))
data_raw$Age = recode(data_raw$Age, "Under 18" = 1, "18-24" = 2, "25-34" = 3, "35-44" = 4, "45-54" = 5, "55-64" = 6, "65-74" = 7, "75+" = 8)
data_raw$Age = (data_raw$Age - 1) / (8-1)
data_raw$Income = recode(data_raw$Income, 'Less than $30,000' = 1, '$30,000 to $49,999' = 2, '$50,000 to $74,999' = 3, '$75,000 to $99,999' = 4, '$100,000 or more' = 5) 
data_raw$Income = (data_raw$Income - 1) / (5-1)
data_raw$Household_info = recode(data_raw$Household_info, 'No' = 0, 'Yes' = 1)
data_raw$Education = recode(data_raw$Education,'High school graduate or less' = 1 ,'Some college, including Associate degree' = 2,'Bachelors degree' = 3, 'Masters, Professional or Doctorate Degree' = 4)
data_raw$Education = (data_raw$Education - 1)/ 3
data_raw$STEM = recode(data_raw$STEM, 'no STEM degrees' = 0, 'at least one STEM degree' = 1)
data_raw$Employment = recode(data_raw$Employment, 'Not employed' = 0, 'Employed' = 1)
data_raw$Response = recode(data_raw$Response,'My gender has made it harder for me to succeed in my job' = 1 ,'My gender has not made much difference in my job' = 2,'My gender has made it easier for me to succeed in my job' = 3)
data_raw = data_raw[!is.na(data_raw$Response), ]
data_raw = one_hot(data_raw, cols = 'Industry')


write.csv(data_raw, 'draft_data.csv')
