
# Homework #7 -------------------------------------------------------------

# RQ: Is there a meaningful difference in the frequency of fear words used per talking turn when comparing Bush, Cruz, and Fiorina to Trump? 


# Pre-Flight --------------------------------------------------------------

# load libraries 
library(tidyverse)
library(tidytext)
library(textdata)
library(textstem)
library(dabestr)

# load data
data <- read_csv("datasets/gop_debates.csv") %>% filter(who %in% c("BUSH","CRUZ","FIORINA","TRUMP")) %>% mutate(id=row.names(.))

# load sentiment dictionary & filter for fear words 
nrc_fear_lemma <- get_sentiments("nrc") %>% filter(sentiment=="fear") %>% mutate(word=lemmatize_words(word))


# Get Aggregate scores 
fear_anlysis <- data %>% 
  unnest_tokens(word, text, token = "words") %>% 
  mutate(word=lemmatize_words(word)) %>% 
  inner_join(nrc_fear) %>% 
  add_count(id) %>% 
  select(id,who,n) %>% 
  unique()

# Get averages
fear_anlysis %>% group_by(who) %>% 
  summarise(ave_fear = mean(n))

# Mean Difference Analysis ------------------------------------------------

# Set up dabest
fear_dabest <- fear_anlysis %>% 
  dabest(x = who,
         y= n,
         idx= c("TRUMP","BUSH","CRUZ","FIORINA"),
         paired = FALSE)

# Get mean diff
fear_dabest %>% mean_diff()

# Plot mean diff
fear_dabest %>% mean_diff() %>% plot()


# Write-Up ----------------------------------------------------------------

# There are measurable differences in the average number of fear words used per talking turn by candidate. 
# On average, Bush used 0.888 more fear words per talking turn than did Trump (95% CI: 0.243 to 1.53)
# Similarly, Cruz used 1.81 more fear words per talking turn than Trump (95% CI: 1.15 to 2.44)
# Finally, Fiorina also used 1.76 more fear words per turn on average when compared to Trump (95% CI: .595 to 3.11)
# On average, the number of fear words per turn was low (2.88 for Trump to 4.69 for Cruz).
# The difference between Trump and Cruz strikes me as meaningful, but the 95% CI for Fiorina is too wide for me to be comfortable saying that difference is also meaningful. 
