
# Homework #4 Answers -----------------------------------------------------

# This script answers the research question: Is there a meaningful mean difference in speaking complexity for Bush, Cruz, and Walker when compared to Trump. To answer this question, write an R script that accomplishes the following:


# Pre-Flight --------------------------------------------------------------

#load libraries 
library(tidyverse)
library(quanteda)
library(quanteda.textstats)
library(dabestr)

# load data
data <- read_csv("datasets/gop_debates.csv")




# Complexity Analysis  ----------------------------------------------------

# Determine speaking complexity using ELF

data <- data %>% 
  bind_cols(textstat_readability(.$text,measure = "ELF"))


# Mean Difference Analysis ------------------------------------------------

# Set up dabest 
data_shared_control <- data %>% dabest(x=who,
                              y=ELF,
                              idx = c("TRUMP","BUSH","CRUZ","WALKER"),
                              paired = FALSE)

# Get mean difference 
data_shared_control %>% mean_diff()

# Plot mean difference 
data_shared_control %>% mean_diff() %>% plot()


# Interpretation  ---------------------------------------------------------

# There is a meaningful difference in the average ELF score for Bush, Cruz, and Walker when compared to Trump. 
# The spoken language of each candidate is easier to understand than Trump's. 
# The average ELF score for Bush is 0.994 higher than Trump (95% CI: 0.687 to 1.31)
# The average ELF score for Cruz is 1.96 higher than Trump (95% CI: 1.64 to 2.32)
# The average ELF score for Walker is 1.89 higher than Trump (95% CI: 1.13 to 2.68)

