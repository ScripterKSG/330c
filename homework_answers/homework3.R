
# Homework #3 -------------------------------------------------------------

# This script 1) Imports the appropriate data from the shared data sets. 2) Analyzes the speaking complexity of each speaking turn using an appropriate complexity metric. And 3) Aggregates the data by candidate and returns a two column data frame: speaker | ave_complexity in descending order of complexity. 


# Pre-flight --------------------------------------------------------------

#load libraries 
library(tidyverse)
library(quanteda)
library(quanteda.textstats)

#load data
data <- read_csv("datasets/gop_debates.csv")


# Analyze Speaking Complexity ---------------------------------------------
data <- data %>% 
  bind_cols(textstat_readability(.$text,measure = "ELF")) # bind ELF score to each row


# Aggregate & Arrange Data ------------------------------------------------
data %>% 
  select(speaker=who,ELF) %>% # select columns of interest and rename who as speaker 
  group_by(speaker) %>%  
  summarise(ave_complexity = mean(ELF)) %>% # get average speaking complexity  
  arrange(desc(ave_complexity)) #arrange descending by ave_complexity


