library(dplyr)
library(ggplot2)
library(tidyr)
library(tidytext)
library(tm)
library(topicmodels)
library(wordcloud)
library(wordcloud2)

set.seed(1)

reviews.df <- read.csv("reviews.csv")
reviews.df <- reviews.df[sample(61594,1000),-6]
reviews.df$Time_submitted <- as.POSIXct(reviews.df$Time_submitted, format='%Y-%m-%d %H:%M:%S')
reviews.df$id <- seq(1:1000)
colnames(reviews.df)[2] <- "text" 

lexicon <- get_sentiments("bing")

corpus <- Corpus(VectorSource(paste(reviews.df$text, collapse = " ")))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

# Convert the corpus to a tidy data frame
corpus_text <- as.character(corpus)
tidy_corpus <- corpus_text %>%
  as_tibble() %>%
  unnest_tokens(word, value) %>%
  filter(!word %in% stop_words$word)

sentiment_scores <- inner_join(tidy_corpus, lexicon, by = "word")

sentiment_scores <- sentiment_scores %>%
  mutate(sentiment = ifelse(sentiment == "positive", 1, -1))

sentiment_scores_unique <- sentiment_scores[!duplicated(sentiment_scores), ]

# Sentiment for words from the corpus for each tweet
review_words <- reviews.df %>%
  unnest_tokens(word, text) %>%
  inner_join(sentiment_scores_unique, by = "word")

# calculate the total score for each tweet
review_scores <- aggregate(sentiment ~ id, data = review_words, FUN = sum)

review_scores <- merge(review_scores, reviews.df, by = "id", all.x = TRUE)

x<-table(review_scores$Rating,review_scores$sentiment)

ggplot(review_scores) +
  geom_boxplot(aes(y=sentiment))+
  facet_grid(~Rating)+
  theme_bw()

# Weighted Sentiments
review_words$weights <- review_words$sentiment*(review_words$Total_thumbsup+1)

# calculate the weighted score for each tweet
review_scores <- aggregate(weights ~ id, data = review_words, FUN = sum)

review_scores <- merge(review_scores, reviews.df, by = "id", all.x = TRUE)

ggplot(review_scores) +
  geom_boxplot(aes(y=weights))+
  facet_grid(~Rating)+
  theme_bw()

ggplot(review_scores) +
  geom_boxplot(aes(y=weights), outlier.color = NA)+
  facet_grid(~Rating)+
  theme_bw()+
  ylim(c(-10,10))

# Positive Reviews

positive_review <- review_scores %>% 
  arrange(desc(weights)) %>% 
  head(15)

corpus_positive <- Corpus(VectorSource(positive_review$text))

# Clean the text by removing stopwords and converting to lowercase
corpus_positive <- tm_map(corpus_positive, removeWords, stopwords("english"))
corpus_positive <- tm_map(corpus_positive, content_transformer(tolower))

# Create a document-term matrix
dtm_positive <- DocumentTermMatrix(corpus_positive)

lda_pos <- LDA(dtm_positive, k = 2)
terms(lda_pos, 10)

freq_pos <- colSums(as.matrix(dtm_positive))
freq_pos <- sort(freq_pos, decreasing = TRUE)

freq_df <- data.frame(word = names(freq_pos), freq = freq_pos)

wordcloud(words = freq_df$word, freq = freq_df$freq)

# Negative Reviews

negative_review <- review_scores %>% 
  arrange(weights) %>% 
  head(15)

corpus_negative <- Corpus(VectorSource(positive_review$text))

# Clean the text by removing stopwords and converting to lowercase
corpus_negative <- tm_map(corpus_negative, removeWords, stopwords("english"))
corpus_negative <- tm_map(corpus_negative, content_transformer(tolower))

# Create a document-term matrix
dtm_negative <- DocumentTermMatrix(corpus_negative)

freq_neg <- colSums(as.matrix(dtm_negative))
freq_neg <- sort(freq_neg, decreasing = TRUE)

freq_df <- data.frame(word = names(freq_neg), freq = freq_neg)

wordcloud(words = freq_df$word, freq = freq_df$freq)

lda_neg <- LDA(dtm_negative, k = 2)
terms(lda_neg, 10)

