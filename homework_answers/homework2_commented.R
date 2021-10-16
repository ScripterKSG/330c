
# Homework #2 -------------------------------------------------------------
# This script imports data from data from individual .CSVs and creates one large dataframe

# Load library 
library(tidyverse)

# Set working directory to datasets/gop_frags/
setwd("datasets/gop_frags/")

# List all of the files in the working directory and save as list: files
files <- list.files()

# Map read_CSV to each item in the files list and save as list: data
data <- map(files,function(x) read_csv(x))

# Map cbind() to files and data lists to create a list of dataframes where each .csv is connected to its file name.
gop_data <- map2(files,data, function(x,y) cbind(x,y))

# Apply rbind() to each element in the gop_data list of dataframes to create a single dataframe of all values. 
gop_df <- do.call(rbind,gop_data)

# Change the name of column 1 in gop_df to "date"
names(gop_df)[1] <- "date"

# Create a dataframe with the columns: date, text, speaker, text_length 
df1 <- gop_df %>% #pipe gop_df into the operation 
  
  #remove the .csv from file names in date to create a column with only date data. 
  separate(date,"date",sep = "\\.") %>% 
  
  # remove the speaker name from each talking turn. 
  separate(text, "speaker", sep = ":", remove = FALSE) %>% 
  
  # create a new column text_lenth that is the number of characters in each row of text. 
  mutate(text_length = nchar(text))

# Create a dataframe that aggregates the length of each talking turn by speaker 
df2 <- df1 %>% #pipe df1 into the operation 
  
  # group data by speaker 
  group_by(speaker) %>% 
  
  # summarize the data
  summarise(talking_turns = n(), # count number of talking turns per candidate
            total_length = sum(text_length), #get the total number of characters per speaker 
            ave_length = mean(text_length)) %>%  # get the average number of characters per speaker
  
  # Transform data from wide to long creating a variable column and a value column indexed by speaker 
  pivot_longer(-speaker,names_to = "variable", values_to = "value")
