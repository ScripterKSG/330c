
# Homework 6 --------------------------------------------------------------

# This code identifies the most salient differences in how Trump, Cruz, and Rubio discussed immigration during the GOP primary debates.


# Pre-Flight --------------------------------------------------------------

#load libraries 
library(tidyverse)
library(tidytext)
library(textstem)

# Load data, clean, and filter for records of interest 
data <- read_csv("datasets/gop_debates.csv") %>% 
  mutate(text=str_replace(text,"^.*?(?=:): ","")) %>% 
           filter(who %in% c("TRUMP","CRUZ","RUBIO")) 


# Create helper objects ---------------------------------------------------
# Stem and lemmatize (I borrowed these from Cody because he did such a good job. If you're doing framegrams, think big.)
stem_strings("immigration border deport refugee visa citizen alien undocumented naturalization mexico")
lemmatize_strings("immigration border deport refugee visa citizen alien undocumented naturalization mexico")

# Save terms for later
immigration_terms <- "migrat|border|deport|refuge|visa|citizen|alien|document|natural|mexic"

# Create a stopwords object.
stop_words_bounded <- paste0("\\b", stop_words$word, "\\b", collapse = "|")


# Conduct TF-IDF (salience) Analysis  -------------------------------------

# Get TF for trigrams 
trigrams_tf <- data %>%
  unnest_tokens(trigram, text, token = "ngrams", n=3) %>%
  filter(str_count(trigram,stop_words_bounded) < 1) %>%
  count(who, trigram)

# Get N of trigrams per speaker 
n_trigrams <- trigrams_tf %>%  
  group_by(who) %>% 
  summarize(total = sum(n))

# Complete TF-IDF 
trgrams_tf_idf <- left_join(trigrams_tf, n_trigrams) %>%
  bind_tf_idf(trigram, who, n)

#Filter and plot 
trgrams_tf_idf %>%
  filter(str_detect(trigram,immigration_terms)) %>% # Filter for immigration terms
  group_by(who) %>% 
  slice(1:10) %>% 
  mutate(trigram= as.factor(trigram),
         trigram = reorder_within(trigram, tf_idf, who)) %>%
  ggplot(aes(trigram, tf_idf, fill="red")) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  scale_x_reordered()+ 
  theme_minimal() + #some bonus aesthetics for fun
  theme(legend.position = "none") + #some bonus aesthetics for fun
  facet_wrap(~who, ncol = 1, scales = "free_y")


