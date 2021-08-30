
# tidyverse Workshop  ------------------------------------------------------

#Load libraries | You can also load all tidyverse libraries at once with library(tidyverse)
library(readr)
library(dplyr)




# Ingest & Explore  -------------------------------------------------------

# Read the gop_debates dataset into R with read_csv()
gop_data <- read_csv("datasets/gop_debates.csv") # note the use of quotes "" and the file structure datasets/ <- this tells R where to look. 


# To view your data directly, click on gop_data in the Global Environment. 

# PRO-TIP: the Global Environment tells you the shape of your data. This object has 3 columns (variables) and 2569 rows (observations).


# You can use head() and str() to learn more about rectangular data. 

# head() shows you the first few rows.  
head(gop_data)

# str() tells you about the structure of the data. You can also click on the blue carrot in the Global Environment to get this information. 
str(gop_data) # This tells you that gop_data is a dataframe with three columns (date, text, who).

# PRO-TIP: Get in the habit of checking out your data and it structure whenever you bring it into R. 




# Manipulate data with dplyr ----------------------------------------------

# Get the text column with dplyr::select
select(gop_data,text) # note the use of base R syntax. 

# Get the text column with dplyr::select
gop_data %>% select(text) # note the use of the pipe %>%

# Use group_by and summarize to figure out how many time each person speaks

# This line feeds gop_data into the first pipe. 
gop_data %>% 
  
  # This line groups all of the data by who is speaking and feeds the results into the next pipe. 
  group_by(who) %>% 
  
  # This line summarizes the data and creates a new column called n that uses n() to get the number of rows per group (Person)
  summarise(n=n())


# Do it again but shorter
gop_data %>% 
  group_by(who) %>% 
  tally() # tally() is a shortcut for summarise(n=n()). It's exactly the same. 


# Do it again but shorter still, and this time re-order
gop_data %>% 
  count(who) %>% # count() is a shortcut for group_by() %>% tally(). It's exactly the same. 
  
  # Arrange the data by column n in descending order. 
  arrange(desc(n))



# Comment the following ---------------------------------------------------
# To make sure you really undersatnd what each line is doing, write a clear explanitory comment for each. Run the code first to understand the process. 
# PRO-TIP: if you highlight small sections of the code and click run, you can see what those segments do by themselves. 

#
gop_data %>% 
  #
  filter(who %in% c("TRUMP","CARSON","WALKER")) %>% 
  #
  group_by(who) %>% 
  #
  summarise(ave_text_length = mean(nchar(text))) %>% 
  #
  arrange(desc(ave_text_length))




# Code the following ------------------------------------------------------
# Here are the comments for a piped data manipulation operation. You have a good understanding of today's lesson if you can write the code that does what the comments say. 

# load football_tweets.csv as football_tweets

# view the first few rows

# view the football_tweets structure 

# Create a new dataframe that summarizes which schools tweets are the most popular. 

#assign result to variable name "popularity" and feed dataframe into pipe

  # group by school
  
  #create the following columns n_RT for number of retweets, n_Fav for number of favoriates, ave_RT for average of retweets, and ave_Fav for the average number of favorites. 

  # Re-order the dataframe descending by n_Fav



# New verbs ---------------------------------------------------------------
?read_csv
?head
?select
?filter
?group_by
?summarise
?tally
?count


