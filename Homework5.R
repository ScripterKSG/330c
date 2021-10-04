
# Homework #5 Answers -----------------------------------------------------

# This script answers the following research question: What were the most salient topics discussed for each of the 2015 GOP primary debates? 


# Pre-Flight --------------------------------------------------------------

# Load libraries 
library(tidyverse)
library(tidytext)

# Load data
data <- read_csv("datasets/gop_debates.csv")

# TF-IDF Analysis  --------------------------------------------------------

#Save word data for each debate
data_word_n <- data %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(date, word, sort = TRUE)

# Get word count by debate compared to total count of each word
total_words <- data_word_n %>% 
  group_by(date) %>% 
  summarize(total = sum(n))

# Create a new dataframe combining information on total number of words per tweet word frequency counts
data_word_n <- left_join(data_word_n, total_words)

# Get term frequency (TF),  inverse document frequency (IDF), and TF-IDF 
data_word_n <- data_word_n %>%
  # Calculates TF, IDF, and TF-IDF from word totals and TFs
  bind_tf_idf(word, date, n)

#Visualize frequency of most common words occurring more frequently than 10 times by debate
data_word_n %>%
  arrange(desc(tf_idf)) %>%
  group_by(date) %>% 
  slice(1:10) %>%
  ungroup() %>%
  #mutate(word = factor(word, levels = rev(unique(word)))) %>% This is replaced with the below to fix. 
  mutate(date= as.factor(date),
         word = reorder_within(word, tf_idf, date)) %>%
  ggplot(aes(word, tf_idf, fill = date)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()+
  scale_x_reordered()+ # This must be added to fix issues with the labels created above. 
  facet_wrap(~date, ncol = 2, scales = "free_y")

